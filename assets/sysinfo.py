import json
import subprocess
import shutil
import time
import sys

def get_sys_info():
    prev_idle = 0
    prev_total = 0

    while True:
        data = {}

        try:
            with open('/proc/stat', 'r') as f:
                parts = [int(x) for x in f.readline().split()[1:]]
            idle = parts[3] + parts[4]
            total = sum(parts)
            
            total_delta = total - prev_total
            idle_delta = idle - prev_idle
            
            if total_delta > 0:
                data['cpuPercent'] = round(100 * (1 - idle_delta / total_delta))
            else:
                data['cpuPercent'] = 0
                
            prev_idle = idle
            prev_total = total
        except Exception:
            data['cpuPercent'] = 0

        try:
            usage = shutil.disk_usage('/')
            data['diskUsedGb'] = round(usage.used / 1e9, 1)
            data['diskTotalGb'] = round(usage.total / 1e9, 1)
            data['diskPercent'] = round((usage.used / usage.total) * 100)
        except Exception:
            data['diskPercent'] = 0

        try:
            with open('/sys/class/power_supply/BAT0/capacity', 'r') as f:
                data['batteryPercent'] = int(f.read().strip())
            with open('/sys/class/power_supply/BAT0/status', 'r') as f:
                data['batteryState'] = f.read().strip()
        except Exception:
            data['batteryPercent'] = 0
            data['batteryState'] = "unknown"

        try:
            uptime = subprocess.check_output(['uptime', '-p'], text=True).strip()
            data['uptimeStr'] = uptime.replace("up ", "")
        except Exception:
            data['uptimeStr'] = "unknown"

        # ---- Universal Packages ----
        pkg_count = 0
        
        # Check native package managers
        if shutil.which("pacman"):
            try:
                out = subprocess.check_output("pacman -Qq | wc -l", shell=True, text=True).strip()
                pkg_count += int(out) if out else 0
            except Exception:
                pass
        elif shutil.which("dpkg"):
            try:
                out = subprocess.check_output("dpkg-query -f '.\\n' -W | wc -l", shell=True, text=True).strip()
                pkg_count += int(out) if out else 0
            except Exception:
                pass
        elif shutil.which("rpm"):
            try:
                out = subprocess.check_output("rpm -qa | wc -l", shell=True, text=True).strip()
                pkg_count += int(out) if out else 0
            except Exception:
                pass
        elif shutil.which("xbps-query"):
            try:
                out = subprocess.check_output("xbps-query -l | wc -l", shell=True, text=True).strip()
                pkg_count += int(out) if out else 0
            except Exception:
                pass
        elif shutil.which("apk"):
            try:
                out = subprocess.check_output("apk info | wc -l", shell=True, text=True).strip()
                pkg_count += int(out) if out else 0
            except Exception:
                pass
        
        # Add universal package managers
        if shutil.which("flatpak"):
            try:
                out = subprocess.check_output("flatpak list 2>/dev/null | wc -l", shell=True, text=True).strip()
                pkg_count += int(out) if out else 0
            except Exception:
                pass
                
        if shutil.which("snap"):
            try:
                out = subprocess.check_output("snap list 2>/dev/null | wc -l", shell=True, text=True).strip()
                snap_count = int(out) if out else 0
                if snap_count > 0:
                    pkg_count += (snap_count - 1) # Subtract header line
            except Exception:
                pass
                
        data['packagesCount'] = pkg_count

        print(json.dumps(data), flush=True)
        
        time.sleep(2)

if __name__ == '__main__':
    get_sys_info()
