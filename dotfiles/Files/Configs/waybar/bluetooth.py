#!/usr/bin/env python3
import dbus
import dbus.service
import dbus.mainloop.glib
import threading
import gi

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GLib, Gdk, Pango

# ===== BlueZ constants =====
BLUEZ = "org.bluez"
ADAPTER_IFACE = "org.bluez.Adapter1"
DEVICE_IFACE = "org.bluez.Device1"
PROP_IFACE = "org.freedesktop.DBus.Properties"
OM_IFACE = "org.freedesktop.DBus.ObjectManager"
AGENT_IFACE = "org.bluez.Agent1"

ICON_CONNECTED = "󰂯"
ICON_DISCONNECTED = "󰂲"

STYLE_DATA = """
switch:checked slider { background-color: #5294e2; }
switch:checked { background-color: #215d9c; }
.battery-green { color: #43ad6b; }
.battery-orange { color: #f29c1f; }
.battery-red { color: #e74c3c; }
"""

def get_battery_class(p):
    try:
        p = int(p)
        if p > 60: return "battery-green"
        if p > 20: return "battery-orange"
        return "battery-red"
    except: return ""

class ConfirmationAgent(dbus.service.Object):
    def __init__(self, bus, path):
        super().__init__(bus, path)
        self.local_loop = None
        self.result = False

    @dbus.service.method(AGENT_IFACE, in_signature="ou", out_signature="")
    def RequestConfirmation(self, device, passkey):
        print(f"[Agent] Запрос подтверждения кода: {passkey}")
        self.result = False
        self.local_loop = GLib.MainLoop()

        # Показываем диалог в основном потоке
        GLib.idle_add(self._show_dialog, passkey)

        # Запускаем вложенный цикл (останавливает выполнение функции, но не вешает GUI)
        self.local_loop.run()

        if not self.result:
            print("[Agent] Отклонено пользователем")
            raise dbus.exceptions.DBusException("org.bluez.Error.Rejected")
        print("[Agent] Подтверждено")

    def _show_dialog(self, passkey):
        dlg = Gtk.MessageDialog(
            transient_for=None, modal=True,
            message_type=Gtk.MessageType.QUESTION,
            buttons=Gtk.ButtonsType.YES_NO,
            text="Подтвердить сопряжение?"
        )
        dlg.format_secondary_text(f"Код на устройстве совпадает: {passkey}?")
        res = dlg.run()
        self.result = (res == Gtk.ResponseType.YES)
        dlg.destroy()
        if self.local_loop:
            self.local_loop.quit()

    @dbus.service.method(AGENT_IFACE, in_signature="o", out_signature="s")
    def RequestPinCode(self, device): return "0000"
    @dbus.service.method(AGENT_IFACE, in_signature="", out_signature="")
    def Release(self): pass
    @dbus.service.method(AGENT_IFACE, in_signature="", out_signature="")
    def Cancel(self):
        if self.local_loop: self.local_loop.quit()

class BluetoothGUI(Gtk.Window):
    def __init__(self):
        super().__init__(title="Bluetooth Manager")
        self.set_default_size(400, 550)
        self.set_border_width(10)

        style_provider = Gtk.CssProvider()
        style_provider.load_from_data(STYLE_DATA.encode("utf-8"))
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(), style_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

        self.connecting = set()
        self.devices = {}
        self.discovering = False

        dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
        self.bus = dbus.SystemBus()
        self.om = dbus.Interface(self.bus.get_object(BLUEZ, "/"), OM_IFACE)

        self._setup_adapter()
        self._setup_agent()
        self._init_ui()

        self.bus.add_signal_receiver(self.refresh_devices, "InterfacesAdded", OM_IFACE)
        self.bus.add_signal_receiver(self.refresh_devices, "InterfacesRemoved", OM_IFACE)
        self.refresh_devices()

    def _setup_adapter(self):
        for path, ifaces in self.om.GetManagedObjects().items():
            if ADAPTER_IFACE in ifaces:
                self.adapter_path = path
                obj = self.bus.get_object(BLUEZ, path)
                self.adapter = dbus.Interface(obj, ADAPTER_IFACE)
                self.adapter_props = dbus.Interface(obj, PROP_IFACE)
                return
        raise RuntimeError("Адаптер не найден")

    def _setup_agent(self):
        path = "/test/agent"
        self.agent = ConfirmationAgent(self.bus, path)
        manager = dbus.Interface(self.bus.get_object(BLUEZ, "/org/bluez"), "org.bluez.AgentManager1")
        try: manager.UnregisterAgent(path)
        except: pass
        manager.RegisterAgent(path, "KeyboardDisplay")
        manager.RequestDefaultAgent(path)

    def _init_ui(self):
        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        self.add(vbox)

        # Header
        hbox = Gtk.Box(spacing=10)
        try:
            is_pwr = self.adapter_props.Get(ADAPTER_IFACE, "Powered")
        except: is_pwr = False
        self.bt_switch = Gtk.Switch(active=is_pwr)
        self.bt_switch.connect("state-set", self.toggle_bluetooth)
        hbox.pack_start(Gtk.Label(label="Bluetooth:", xalign=0), False, False, 0)
        hbox.pack_start(self.bt_switch, False, False, 0)

        clear_btn = Gtk.Button(label="🧹")
        clear_btn.connect("clicked", self.clear_all_devices)
        hbox.pack_end(clear_btn, False, False, 0)
        vbox.pack_start(hbox, False, False, 0)

        # Lists
        vbox.pack_start(Gtk.Label(label="Сохранённые", xalign=0), False, False, 0)
        self.saved_list = Gtk.ListBox()
        vbox.pack_start(self._scrolled(self.saved_list), True, True, 0)

        vbox.pack_start(Gtk.Label(label="Найдено", xalign=0), False, False, 0)
        self.found_list = Gtk.ListBox()
        vbox.pack_start(self._scrolled(self.found_list), True, True, 0)

        self.scan_btn = Gtk.Button(label="🔍 Сканировать")
        self.scan_btn.connect("clicked", self.toggle_scan)
        vbox.pack_start(self.scan_btn, False, False, 0)

    def _scrolled(self, widget):
        sw = Gtk.ScrolledWindow()
        sw.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        sw.add(widget)
        return sw

    def refresh_devices(self, *args):
        self.devices.clear()
        try:
            objects = self.om.GetManagedObjects()
            for path, ifaces in objects.items():
                if DEVICE_IFACE in ifaces:
                    self.devices[path] = ifaces[DEVICE_IFACE]
        except: pass
        GLib.idle_add(self.update_ui)

    def update_ui(self):
        # ВАЖНО: Весь этот метод должен выполняться ТОЛЬКО в основном потоке.
        # Если он вызывается из сигнала DBus, мы перенаправляем его через idle_add.
        for l in [self.saved_list, self.found_list]:
            l.foreach(l.remove)

        # Делаем локальную копию данных, чтобы избежать конфликтов при итерации
        current_devices = dict(self.devices)

        for path, dev in current_devices.items():
            try:
                paired = dev.get("Paired", False)
                connected = dev.get("Connected", False)

                row = Gtk.ListBoxRow()
                box = Gtk.Box(spacing=10, margin=5)

                # Статус
                status_icon = ICON_CONNECTED if connected else ICON_DISCONNECTED
                box.pack_start(Gtk.Label(label=status_icon), False, False, 0)

                # Имя и батарея
                label = Gtk.Label(xalign=0)
                label.set_ellipsize(Pango.EllipsizeMode.END)
                name = dev.get("Name", dev.get("Alias", "Unknown"))
                battery = dev.get("BatteryPercentage")

                display_text = f"{self.device_type_icon(dev)} {name}"
                if battery:
                    display_text += f" ({battery}%)"
                    label.get_style_context().add_class(get_battery_class(battery))

                label.set_text(display_text)
                box.pack_start(label, True, True, 0)

                # Переключатель
                if path in self.connecting:
                    box.pack_start(Gtk.Spinner(active=True), False, False, 0)
                else:
                    sw = Gtk.Switch(active=connected)
                    # Используем connect_after, чтобы сигнал не конфликтовал с системными прерываниями
                    sw.connect("state-set", self.toggle_device, path)
                    box.pack_start(sw, False, False, 0)

                if paired:
                    btn = Gtk.Button(label="❌")
                    btn.connect("clicked", lambda b, p=path: self.run_async(self.adapter.RemoveDevice, p))
                    box.pack_start(btn, False, False, 0)

                row.add(box)
                row.show_all()
                (self.saved_list if paired else self.found_list).add(row)
            except Exception as e:
                print(f"Ошибка отрисовки строки {path}: {e}")

        self.show_all()

    def device_type_icon(self, dev):
        icon = dev.get("Icon", "").lower()
        name = dev.get("Name", "").lower()
        if "audio" in icon or "head" in name: return "🎧"
        if "phone" in icon or "poco" in name: return "📱"
        if "gamepad" in icon or "xbox" in name: return "🎮"
        if "input-keyboard" in icon: return "⌨️"
        return "📦"

    def run_async(self, func, *args):
        def task():
            try: func(*args)
            except Exception as e: GLib.idle_add(self.show_error, str(e))
            finally: GLib.idle_add(self.refresh_devices)
        threading.Thread(target=task, daemon=True).start()

    def toggle_bluetooth(self, switch, state):
        def task():
            try:
                self.adapter_props.Set(ADAPTER_IFACE, "Powered", dbus.Boolean(state))
            except Exception as e:
                GLib.idle_add(self.show_error, str(e))
            finally:
                GLib.idle_add(self.refresh_devices)
        threading.Thread(target=task, daemon=True).start()
        return False

    def toggle_scan(self, btn):
        # Если мы в процессе подключения, лучше не трогать адаптер
        if self.connecting:
            print("[System] Адаптер занят подключением, сканирование отложено")
            return

        if self.discovering:
            btn.set_label("🔍 Сканировать")
            self.discovering = False
            # Выполняем строго в фоне
            threading.Thread(target=lambda: self.adapter.StopDiscovery(), daemon=True).start()
        else:
            btn.set_label("⏹ Стоп")
            self.discovering = True

            def start_task():
                try:
                    # Устанавливаем свойства асинхронно
                    self.adapter_props.Set(ADAPTER_IFACE, "Discoverable", dbus.Boolean(True),
                                         reply_handler=lambda *a: None, error_handler=lambda *a: None)
                    self.adapter.StartDiscovery(reply_handler=lambda *a: None, error_handler=self._on_scan_error)
                except Exception as e:
                    print(f"Scan error: {e}")

            threading.Thread(target=start_task, daemon=True).start()

    def _on_scan_error(self, err):
        # Если ошибка "Already Discovery", просто игнорим
        if "InProgress" not in str(err):
            GLib.idle_add(self.show_error, f"Ошибка сканирования: {err}")

    def toggle_device(self, switch, state, path):
        if path in self.connecting:
            return True

        self.connecting.add(path)
        GLib.idle_add(self.update_ui)

        def task():
            try:
                obj = self.bus.get_object(BLUEZ, path)
                dev = dbus.Interface(obj, DEVICE_IFACE)

                if state:
                    # Для включения оставляем как было (или тоже переводим в асинхрон)
                    props = dbus.Interface(obj, PROP_IFACE)
                    props.Set(DEVICE_IFACE, "Trusted", dbus.Boolean(True))
                    if not self.devices.get(path, {}).get("Paired"):
                        dev.Pair()
                    dev.Connect()
                    GLib.idle_add(self._finalize_connection, path)
                else:
                    # ОТКЛЮЧЕНИЕ: Асинхронный вызов, который не блокирует UI
                    print(f"Посылаем команду Disconnect для {path}...")
                    dev.Disconnect(
                        reply_handler=lambda: self._async_success(path),
                        error_handler=lambda e: self._async_error(path, e)
                    )
                    # Мы НЕ вызываем _finalize_connection здесь,
                    # его вызовут обработчики выше
            except Exception as e:
                print(f"Ошибка инициации потока: {e}")
                GLib.idle_add(self._finalize_connection, path)

        threading.Thread(target=task, daemon=True).start()
        return False

    # Вспомогательные методы для асинхронности
    def _async_success(self, path):
        print(f"Успешное отключение {path}")
        GLib.idle_add(self._finalize_connection, path)

    def _async_error(self, path, err):
        # Игнорируем ошибку, если устройство уже отключено
        if "NotConnected" not in str(err):
            print(f"Ошибка асинхронного вызова для {path}: {err}")
        GLib.idle_add(self._finalize_connection, path)

    def _finalize_connection(self, path):
        self.connecting.discard(path)
        self.refresh_devices()

    def clear_all_devices(self, btn):
        def task():
            for path, dev in list(self.devices.items()):
                if dev.get("Paired"): self.adapter.RemoveDevice(path)
        self.run_async(task)

    def show_error(self, text):
        if any(x in text.lower() for x in ["alreadyconnected", "canceled"]): return
        dlg = Gtk.MessageDialog(transient_for=self, modal=True, message_type=Gtk.MessageType.ERROR, buttons=Gtk.ButtonsType.OK, text="Ошибка Bluetooth")
        dlg.format_secondary_text(text)
        dlg.run()
        dlg.destroy()

if __name__ == "__main__":
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
    win = BluetoothGUI()
    win.connect("destroy", Gtk.main_quit)
    win.show_all()
    Gtk.main()