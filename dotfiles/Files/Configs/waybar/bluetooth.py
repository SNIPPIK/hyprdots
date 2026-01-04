#!/usr/bin/env python3

import re
import gi, os, subprocess, threading, json
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GLib, Gdk, Pango

STATE_FILE = os.path.expanduser("~/.config/bluetooth.json")

ICON_CONNECTED = "󰂯"
ICON_DISCONNECTED = "󰂲"

def battery_color(percent):
    try:
        p = int(percent)
        if p > 60:
            return "green"
        elif p > 20:
            return "orange"
        else:
            return "red"
    except:
        return "grey"

def load_state():
    if os.path.exists(STATE_FILE):
        try:
            with open(STATE_FILE, "r") as f:
                return json.load(f)
        except:
            return {}
    return {}

def save_state(state):
    os.makedirs(os.path.dirname(STATE_FILE), exist_ok=True)
    with open(STATE_FILE, "w") as f:
        json.dump(state, f)

class BluetoothGUI(Gtk.Window):
    def __init__(self):
        super().__init__(title="Bluetooth Manager")
        self.set_resizable(True)
        self.set_border_width(10)

        self.state = load_state()
        self.state.setdefault("tray_enabled", True)
        self.state.setdefault("obex_enabled", False)

        self.vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        self.add(self.vbox)

        # Галочка включения/выключения Bluetooth
        self.bt_switch = Gtk.Switch()
        self.bt_switch.set_active(self.is_bluetooth_on())
        self.bt_switch.connect("state-set", self.on_bluetooth_toggle)
        switch_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        switch_box.pack_start(Gtk.Label(label="Bluetooth:"), False, False, 0)
        switch_box.pack_start(self.bt_switch, False, False, 0)
        self.vbox.pack_start(switch_box, False, False, 0)

        # Список устройств
        self.listbox = Gtk.ListBox()
        self.vbox.pack_start(self.listbox, True, True, 0)

        # Обновление устройств каждые 3 секунды
        GLib.timeout_add_seconds(3, self.update_devices)
        self.update_devices()

    def run_command(self, cmd):
        try:
            return subprocess.check_output(cmd).decode().splitlines()
        except:
            return []

    def is_bluetooth_on(self):
        output = self.run_command(["rfkill", "list", "bluetooth"])
        for l in output:
            if "Soft blocked: yes" in l:
                return False
        return True

    def on_bluetooth_toggle(self, switch, state):
        switch.set_sensitive(False)

        spinner = Gtk.Spinner()
        spinner.start()
        parent_box = switch.get_parent()
        parent_box.pack_start(spinner, False, False, 5)
        parent_box.reorder_child(spinner, 2)
        self.show_all()

        def task():
            cmd = "unblock" if state else "block"
            subprocess.call(["rfkill", cmd, "bluetooth"])
            GLib.idle_add(lambda: self.finish_switch(switch, spinner))
        threading.Thread(target=task, daemon=True).start()
        return True

    def finish_switch(self, switch, spinner):
        spinner.stop()
        spinner.destroy()
        switch.set_active(self.is_bluetooth_on())
        switch.set_sensitive(True)
        self.update_devices()

    def update_devices(self):
        # Сбрасываем список
        self.listbox.foreach(lambda w: self.listbox.remove(w))

        devices = []
        output = self.run_command(["bluetoothctl", "devices"])
        for line in output:
            parts = line.split(" ", 2)
            if len(parts) < 3:
                continue
            mac, name = parts[1], parts[2]
            info = self.run_command(["bluetoothctl", "info", mac])
            connected = any("Connected: yes" in l for l in info)
            battery = None
            profile = ""
            for l in info:
                if "Battery Percentage:" in l:
                    m = re.search(r'(\d+)%', l)
                    if m:
                        battery = m.group(1)
            devices.append((connected, name, mac, battery, profile, True))

        # Сортировка — сначала подключенные
        devices.sort(key=lambda x: not x[0])

        for connected, name, mac, battery, profile, available in devices:
            row = Gtk.ListBoxRow()
            hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12)

            icon_label = Gtk.Label(label=ICON_CONNECTED if connected else ICON_DISCONNECTED)
            icon_label.set_markup(f"<b>{icon_label.get_text()}</b>")
            hbox.pack_start(icon_label, False, False, 0)

            label = Gtk.Label(xalign=0)
            text = f"{name} {profile}"
            if battery:
                text += f" ({battery}%)"
            if not available:
                text += " (Не доступно)"
            label.set_text(text)
            if battery:
                color_name = battery_color(battery.replace("%",""))
                color = Gdk.RGBA()
                color.parse(color_name)
                label.override_color(Gtk.StateFlags.NORMAL, color)
            label.set_ellipsize(Pango.EllipsizeMode.END)
            hbox.pack_start(label, True, True, 0)

            switch = Gtk.Switch()
            switch.set_active(connected)
            switch.set_sensitive(available)
            hbox.pack_start(switch, False, False, 0)
            if available:
                switch.connect("state-set", self.on_device_switch, mac)

            row.add(hbox)
            self.listbox.add(row)

        self.show_all()
        return True

    def on_device_switch(self, switch, state, mac):
        switch.set_sensitive(False)
        spinner = Gtk.Spinner()
        spinner.start()
        parent_box = switch.get_parent()
        parent_box.pack_start(spinner, False, False, 5)
        parent_box.reorder_child(spinner, 2)
        self.show_all()

        def task():
            available = True
            if state:
                subprocess.call(["bluetoothctl", "trust", mac])
                ret = subprocess.call(["bluetoothctl", "connect", mac])
                if ret != 0:
                    available = False
            else:
                subprocess.call(["bluetoothctl", "disconnect", mac])
            if not available:
                GLib.idle_add(lambda: self.mark_unavailable(switch, spinner))
            else:
                GLib.idle_add(lambda: self.finish_device_switch(switch, spinner))

        threading.Thread(target=task, daemon=True).start()
        return True


    def finish_device_switch(self, switch, spinner):
        spinner.stop()
        spinner.destroy()
        switch.set_sensitive(True)
        self.update_devices()

    def mark_unavailable(self, switch, spinner):
        spinner.stop()
        spinner.destroy()
        switch.set_active(False)
        switch.set_sensitive(False)
        self.update_devices()

if __name__ == "__main__":
    win = BluetoothGUI()
    win.connect("destroy", Gtk.main_quit)
    win.show_all()
    Gtk.main()
