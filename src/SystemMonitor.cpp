#include "SystemMonitor.h"
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <QProcess>
#include <QRegularExpression> 
#include <sys/statvfs.h>

SystemMonitor::SystemMonitor(QObject *parent) : QObject(parent) {
    updateFastStats();
    updateSlowStats();

    connect(&m_fastTimer, &QTimer::timeout, this, &SystemMonitor::updateFastStats);
    m_fastTimer.start(2000); 

    connect(&m_slowTimer, &QTimer::timeout, this, &SystemMonitor::updateSlowStats);
    m_slowTimer.start(60000); 
}

void SystemMonitor::updateFastStats() {
    updateCpu();
    updateRam();
}

void SystemMonitor::updateSlowStats() {
    updateDisk();
    updateBattery();
    updateUptime();
    updatePackages();
}

void SystemMonitor::updateCpu() {
    QFile file("/proc/stat");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) return;

    QTextStream in(&file);
    QString line = in.readLine();
    file.close();

    if (line.startsWith("cpu ")) {
        QStringList values = line.mid(4).trimmed().split(QRegularExpression("\\s+"));
        if (values.size() >= 8) {
            unsigned long long user = values[0].toULongLong();
            unsigned long long nice = values[1].toULongLong();
            unsigned long long system = values[2].toULongLong();
            unsigned long long idle = values[3].toULongLong();
            unsigned long long iowait = values[4].toULongLong();
            unsigned long long irq = values[5].toULongLong();
            unsigned long long softirq = values[6].toULongLong();
            unsigned long long steal = values[7].toULongLong();

            unsigned long long currentIdle = idle + iowait;
            unsigned long long currentTotal = currentIdle + user + nice + system + irq + softirq + steal;

            unsigned long long totalDiff = currentTotal - m_prevTotal;
            unsigned long long idleDiff = currentIdle - m_prevIdle;

            if (totalDiff > 0) {
                int newUsage = (totalDiff - idleDiff) * 100 / totalDiff;
                if (m_cpuUsage != newUsage) {
                    m_cpuUsage = newUsage;
                    emit cpuUsageChanged();
                }
            }
            m_prevTotal = currentTotal;
            m_prevIdle = currentIdle;
        }
    }
}

void SystemMonitor::updateRam() {
    QFile file("/proc/meminfo");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) return;

    QTextStream in(&file);
    QString line;
    unsigned long long memTotal = 0, memAvailable = 0;

    while (in.readLineInto(&line)) {
        if (line.startsWith("MemTotal:")) {
            memTotal = line.section(QRegularExpression("\\s+"), 1, 1).toULongLong();
        } else if (line.startsWith("MemAvailable:")) {
            memAvailable = line.section(QRegularExpression("\\s+"), 1, 1).toULongLong();
        }
        if (memTotal > 0 && memAvailable > 0) break;
    }
    file.close();

    if (memTotal > 0) {
        int newUsage = ((memTotal - memAvailable) * 100) / memTotal;
        if (m_ramUsage != newUsage) {
            m_ramUsage = newUsage;
            emit ramUsageChanged();
        }
    }
}

void SystemMonitor::updateDisk() {
    struct statvfs stat;
    if (statvfs("/", &stat) == 0) {
        unsigned long long total = stat.f_blocks * stat.f_frsize;
        unsigned long long available = stat.f_bavail * stat.f_frsize;
        
        if (total > 0) {
            int newUsage = ((total - available) * 100) / total;
            if (m_diskUsage != newUsage) {
                m_diskUsage = newUsage;
                emit diskUsageChanged();
            }
        }
    }
}

void SystemMonitor::updateBattery() {
    QFile file("/sys/class/power_supply/BAT0/capacity");
    if (!file.exists()) {
        file.setFileName("/sys/class/power_supply/BAT1/capacity");
    }

    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        int newBattery = file.readAll().trimmed().toInt();
        file.close();
        if (m_batteryPercent != newBattery) {
            m_batteryPercent = newBattery;
            emit batteryPercentChanged();
        }
    }
}

void SystemMonitor::updateUptime() {
    QFile file("/proc/uptime");
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QString line = file.readLine();
        file.close();
        
        double totalSeconds = line.section(' ', 0, 0).toDouble();
        
        int hours = totalSeconds / 3600;
        int minutes = ((int)totalSeconds % 3600) / 60;
        
        QString newUptime = QString("%1h %2m").arg(hours).arg(minutes);
        if (m_uptime != newUptime) {
            m_uptime = newUptime;
            emit uptimeChanged();
        }
    }
}

void SystemMonitor::updatePackages() {
    int totalPackages = 0;

    QDir pacmanDir("/var/lib/pacman/local");
    if (pacmanDir.exists()) {
        totalPackages += pacmanDir.count() - 2;
    }

    QFile dpkgFile("/var/lib/dpkg/status");
    if (dpkgFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&dpkgFile);
        while (!in.atEnd()) {
            if (in.readLine().startsWith("Package: ")) {
                totalPackages++;
            }
        }
        dpkgFile.close();
    }

    if (QFile::exists("/usr/bin/rpm")) {
        QProcess rpmProcess;
        rpmProcess.start("rpm", QStringList() << "-qa");
        rpmProcess.waitForFinished();
        QString output = rpmProcess.readAllStandardOutput();
        totalPackages += output.split('\n', Qt::SkipEmptyParts).size();
    }

    QFile apkFile("/lib/apk/db/installed"); 
    if (apkFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&apkFile);
        while (!in.atEnd()) {
            if (in.readLine().startsWith("C:")) {
                totalPackages++;
            }
        }
        apkFile.close();
    }

    QDir flatpakSystemDir("/var/lib/flatpak/app"); 
    if (flatpakSystemDir.exists()) {
        totalPackages += flatpakSystemDir.count() - 2;
    }

    QDir flatpakUserDir(QDir::homePath() + "/.local/share/flatpak/app");
    if (flatpakUserDir.exists()) {
        totalPackages += flatpakUserDir.count() - 2;
    }

    QDir snapDir("/var/lib/snapd/snaps");
    if (snapDir.exists()) {
        QStringList snapFiles = snapDir.entryList(QStringList() << "*.snap", QDir::Files);
        totalPackages += snapFiles.size();
    }

    if (m_packages != totalPackages) {
        m_packages = totalPackages;
        emit packagesChanged();
    }
}
