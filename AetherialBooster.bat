import subprocess
import sys
import os
import shutil
import urllib.request
from PyQt5.QtWidgets import QApplication, QMainWindow, QWidget, QVBoxLayout, QTabWidget, QPushButton, QMessageBox, QFileDialog
from PyQt5.QtGui import QIcon
from PyQt5.QtCore import Qt

class PerformanceOptimizer(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle('Performance Optimizer')
        self.setGeometry(100, 100, 900, 600)  # Larger window for better layout
        self.setWindowIcon(QIcon('AT.ico'))  # Replace with the path to your icon file

        self.central_widget = QWidget()
        self.setCentralWidget(self.central_widget)
        self.tab_widget = QTabWidget()
        self.layout = QVBoxLayout(self.central_widget)
        self.layout.addWidget(self.tab_widget)

        self.search_indexing_enabled = True
        self.firewall_enabled = True
        self.network_discovery_enabled = True

        self.create_tabs()

        # Apply stylesheet
        self.apply_stylesheet()

    def apply_stylesheet(self):
        self.setStyleSheet("""
            QMainWindow {
                background-color: #1e1e1e; /* Dark gray background */
            }
            QWidget {
                background-color: #2e2e2e; /* Slightly lighter gray for widgets */
                border: 1px solid #444;
            }
            QTabWidget::pane {
                border: 1px solid #444;
                background-color: #2e2e2e;
            }
            QTabBar::tab {
                background: #3b0a45; /* Dark Purple */
                color: white;
                padding: 10px;
                border: 1px solid #2a0934; /* Slightly darker purple */
                border-bottom: none;
            }
            QTabBar::tab:selected {
                background: #4a1b6c; /* Lighter Dark Purple */
                border-bottom: 1px solid #2e2e2e;
            }
            QPushButton {
                background-color: #3b0a45; /* Dark Purple */
                color: white;
                border: 1px solid #2a0934; /* Slightly darker purple for border */
                padding: 10px;
                font-size: 14px;
                border-radius: 5px;
            }
            QPushButton:hover {
                background-color: #4a1b6c; /* Lighter Dark Purple */
            }
            QPushButton:pressed {
                background-color: #2a0934; /* Even darker purple when pressed */
            }
            QMessageBox {
                background-color: #2e2e2e;
                color: white;
            }
        """)

    def create_tabs(self):
        self.create_tab('Performance', self.setup_performance_tab)
        self.create_tab('Network', self.setup_network_tab)
        self.create_tab('Apps', self.setup_apps_tab)

    def create_tab(self, name, setup_function):
        tab = QWidget()
        layout = QVBoxLayout(tab)
        layout.setContentsMargins(10, 10, 10, 10)  # Add margins around the layout
        setup_function(layout)
        self.tab_widget.addTab(tab, name)

    def setup_performance_tab(self, layout):
        button_actions = {
            "Enable ULTIMATE PERFORMANCE MODE": self.enable_ultimate_performance_mode,
            "Toggle Transparency": self.toggle_transparency,
            "Clear Temp Files": self.clear_temporary_files,
            "Disable Startup Programs": self.disable_startup_programs,
            "Increase System Performance": self.increase_system_performance,
            "Toggle Firewall": self.toggle_firewall,
            "Optimize Disk Performance": self.optimize_disk_performance,
            "Clean Up System Files": self.clean_up_system_files,
            "Manage System Services": self.manage_system_services,
            "Adjust Visual Effects": self.adjust_visual_effects,
            "Disable Hibernation": self.disable_hibernation,
            "Disable Superfetch": self.disable_superfetch,
            "Clear DNS Cache": self.clear_dns_cache,
            "Increase Virtual Memory": self.increase_virtual_memory,
            "Set High Performance Mode": self.set_high_performance_mode,
            "Disable Windows Tips": self.disable_windows_tips,
            "Toggle Search Indexing": self.toggle_search_indexing,
            "Optimize Windows Defender": self.optimize_windows_defender,
            "Disable Cortana": self.disable_cortana,
            "Disable Error Reporting": self.disable_windows_error_reporting,
            "Disable Automatic Updates": self.disable_automatic_updates,
            "Disable Defender Realtime Protection": self.disable_defender_realtime_protection,
            "Disable Background Apps": self.disable_background_apps,
        }

        for button_text, action in button_actions.items():
            button = QPushButton(button_text)
            button.clicked.connect(action)
            layout.addWidget(button)

        layout.addStretch()  # Add stretch to push buttons to the top

    def setup_network_tab(self, layout):
        button_actions = {
            "Toggle Network Discovery": self.toggle_network_discovery,
            "Set DNS to Google": self.set_dns_google,
            "Set DNS to Cloudflare": self.set_dns_cloudflare,
            "Check Best DNS": self.check_best_dns,
            "Toggle QoS": self.toggle_qos,
            "Change MTU": self.change_mtu,
            "Reset TCP/IP Stack": self.reset_tcpip_stack,
        }

        for button_text, action in button_actions.items():
            button = QPushButton(button_text)
            button.clicked.connect(action)
            layout.addWidget(button)

        layout.addStretch()  # Add stretch to push buttons to the top

    def setup_apps_tab(self, layout):
        file_urls = [
            "https://github.com/spookyynate/AetherialServices/raw/main/AetherialBooster.bat",
            # Add more URLs here as needed
        ]
        file_names = [
            "AetherialBooster.bat",
            # Add more file names here as needed
        ]

        for url, name in zip(file_urls, file_names):
            button = QPushButton(f"Download {name}")
            button.clicked.connect(lambda checked, u=url, n=name: self.download_file(u, n))
            layout.addWidget(button)

        layout.addStretch()  # Add stretch to push buttons to the top

    def download_file(self, url, file_name):
        save_path, _ = QFileDialog.getSaveFileName(self, "Save File", file_name, "All Files (*)")
        if save_path:
            try:
                urllib.request.urlretrieve(url, save_path)
                QMessageBox.information(self, 'Download Complete', f'File saved to: {save_path}')
            except Exception as e:
                QMessageBox.warning(self, 'Error', f'Failed to download file: {e}')

    def save_file(self):
        # Get the directory of the script
        base_dir = os.path.dirname(os.path.abspath(__file__))
        # Path to the embedded batch file (ensure this file is added to your project)
        batch_file_path = os.path.join(base_dir, 'AetherialBooster.bat')
    
        # Ask the user where to save the file
        options = QFileDialog.Options()
        save_path, _ = QFileDialog.getSaveFileName(self, "Save Batch File", "", "Batch Files (*.bat);;All Files (*)", options=options)
    
        if save_path:
            shutil.copy(batch_file_path, save_path)
            QMessageBox.information(self, 'File Saved', f'Batch file saved to: {save_path}')

    def run_command(self, command):
        try:
            subprocess.run(command, shell=True, check=True)
        except subprocess.CalledProcessError as e:
            QMessageBox.warning(self, 'Error', f'An error occurred: {e}')

    def enable_ultimate_performance_mode(self):
        self.run_command("powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61")
        QMessageBox.information(self, 'ULTIMATE PERFORMANCE MODE', 'ULTIMATE PERFORMANCE MODE enabled.')

    def toggle_transparency(self):
        self.run_command("reg add \"HKCU\\Software\\Microsoft\\Windows\\DWM\" /v \"EnableTransparency\" /t REG_DWORD /d 0 /f")
        QMessageBox.information(self, 'Transparency', 'Transparency toggled off.')

    def clear_temporary_files(self):
        self.run_command("del /q /f %temp%\\*")
        QMessageBox.information(self, 'Temporary Files', 'Temporary files cleared.')

    def disable_startup_programs(self):
        self.run_command("wmic startup get caption,command")
        QMessageBox.information(self, 'Startup Programs', 'List of startup programs shown in console. Use the Task Manager to disable them.')

    def increase_system_performance(self):
        self.run_command("powercfg -change -monitor-timeout-ac 1")
        QMessageBox.information(self, 'System Performance', 'System performance optimized for power saving.')

    def toggle_firewall(self):
        if self.firewall_enabled:
            self.run_command("netsh advfirewall set allprofiles state off")
            self.firewall_enabled = False
            status = 'disabled'
        else:
            self.run_command("netsh advfirewall set allprofiles state on")
            self.firewall_enabled = True
            status = 'enabled'
        QMessageBox.information(self, 'Firewall', f'Firewall {status}.')

    def optimize_disk_performance(self):
        self.run_command("defrag C: /O /H")
        QMessageBox.information(self, 'Disk Optimization', 'Disk optimized.')

    def clean_up_system_files(self):
        self.run_command("cleanmgr /sagerun:1")
        QMessageBox.information(self, 'System Files Cleanup', 'System files cleanup initiated.')

    def manage_system_services(self):
        self.run_command("services.msc")
        QMessageBox.information(self, 'System Services', 'System Services window opened.')

    def adjust_visual_effects(self):
        self.run_command("SystemPropertiesPerformance")
        QMessageBox.information(self, 'Visual Effects', 'Visual Effects settings opened.')

    def disable_hibernation(self):
        self.run_command("powercfg /hibernate off")
        QMessageBox.information(self, 'Hibernation', 'Hibernation disabled.')

    def disable_superfetch(self):
        self.run_command("sc stop \"SysMain\"")
        self.run_command("sc config \"SysMain\" start=disabled")
        QMessageBox.information(self, 'Superfetch', 'Superfetch disabled.')

    def clear_dns_cache(self):
        self.run_command("ipconfig /flushdns")
        QMessageBox.information(self, 'DNS Cache', 'DNS cache cleared.')

    def increase_virtual_memory(self):
        self.run_command("SystemPropertiesPerformance")
        QMessageBox.information(self, 'Virtual Memory', 'Virtual memory settings opened.')

    def set_high_performance_mode(self):
        self.run_command("powercfg -setactive SCHEME_MIN")
        QMessageBox.information(self, 'High Performance Mode', 'High performance power plan activated.')

    def disable_windows_tips(self):
        self.run_command("reg add \"HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\PushNotifications\" /v \"ToastEnabled\" /t REG_DWORD /d 0 /f")
        QMessageBox.information(self, 'Windows Tips', 'Windows tips disabled.')

    def toggle_search_indexing(self):
        if self.search_indexing_enabled:
            self.run_command("sc stop \"WSearch\"")
            self.search_indexing_enabled = False
            status = 'disabled'
        else:
            self.run_command("sc start \"WSearch\"")
            self.search_indexing_enabled = True
            status = 'enabled'
        QMessageBox.information(self, 'Search Indexing', f'Search indexing {status}.')

    def optimize_windows_defender(self):
        self.run_command("powershell -Command \"Set-MpPreference -DisableRealtimeMonitoring $true\"")
        QMessageBox.information(self, 'Windows Defender', 'Windows Defender optimized.')

    def disable_cortana(self):
        self.run_command("reg add \"HKLM\\SOFTWARE\\Policies\\Microsoft\\Windows\\Windows Search\" /v \"AllowCortana\" /t REG_DWORD /d 0 /f")
        QMessageBox.information(self, 'Cortana', 'Cortana disabled.')

    def disable_windows_error_reporting(self):
        self.run_command("reg add \"HKLM\\SOFTWARE\\Microsoft\\Windows\\Windows Error Reporting\" /v \"Disabled\" /t REG_DWORD /d 1 /f")
        QMessageBox.information(self, 'Error Reporting', 'Windows Error Reporting disabled.')

    def disable_automatic_updates(self):
        self.run_command("sc config wuauserv start=disabled")
        QMessageBox.information(self, 'Automatic Updates', 'Automatic updates disabled.')

    def disable_defender_realtime_protection(self):
        self.run_command("powershell -Command \"Set-MpPreference -DisableRealtimeMonitoring $true\"")
        QMessageBox.information(self, 'Defender Real-time Protection', 'Defender real-time protection disabled.')

    def disable_background_apps(self):
        self.run_command("powershell -Command \"Get-AppxPackage | Remove-AppxPackage\"")
        QMessageBox.information(self, 'Background Apps', 'Background apps disabled.')

    def toggle_network_discovery(self):
        if self.network_discovery_enabled:
            self.run_command("reg add \"HKLM\\Software\\Microsoft\\Windows\\CurrentVersion\\NetCache\" /v \"EnableDiscovery\" /t REG_DWORD /d 0 /f")
            self.network_discovery_enabled = False
            status = 'disabled'
        else:
            self.run_command("reg add \"HKLM\\Software\\Microsoft\\Windows\\CurrentVersion\\NetCache\" /v \"EnableDiscovery\" /t REG_DWORD /d 1 /f")
            self.network_discovery_enabled = True
            status = 'enabled'
        QMessageBox.information(self, 'Network Discovery', f'Network discovery {status}.')

    def set_dns_google(self):
        self.run_command("netsh interface ip set dns name=\"Wi-Fi\" static 8.8.8.8")
        QMessageBox.information(self, 'DNS', 'DNS set to Google (8.8.8.8).')

    def set_dns_cloudflare(self):
        self.run_command("netsh interface ip set dns name=\"Wi-Fi\" static 1.1.1.1")
        QMessageBox.information(self, 'DNS', 'DNS set to Cloudflare (1.1.1.1).')

    def check_best_dns(self):
        self.run_command("powershell -Command \"Test-Connection 1.1.1.1 -Count 1\"")
        self.run_command("powershell -Command \"Test-Connection 8.8.8.8 -Count 1\"")
        QMessageBox.information(self, 'DNS Check', 'Checked DNS servers. Review output for best DNS.')

    def toggle_qos(self):
        self.run_command("netsh interface ipv4 set global dsc=enable")
        QMessageBox.information(self, 'QoS', 'QoS settings toggled.')

    def change_mtu(self):
        self.run_command("netsh interface ipv4 set subinterface \"Wi-Fi\" mtu=1500 store=persistent")
        QMessageBox.information(self, 'MTU', 'MTU changed to 1500.')

    def reset_tcpip_stack(self):
        self.run_command("netsh int ip reset")
        QMessageBox.information(self, 'TCP/IP Stack', 'TCP/IP stack reset.')

if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = PerformanceOptimizer()
    window.show()
    sys.exit(app.exec_())
