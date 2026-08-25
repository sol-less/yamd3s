#pragma once

#include <QObject>
#include <QTimer>
#include <QString>
#include <QtQml/qqml.h>

class SystemMonitor : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(int cpuUsage READ cpuUsage NOTIFY cpuUsageChanged)
    Q_PROPERTY(int ramUsage READ ramUsage NOTIFY ramUsageChanged)
    Q_PROPERTY(int diskUsage READ diskUsage NOTIFY diskUsageChanged)
    Q_PROPERTY(int batteryPercent READ batteryPercent NOTIFY batteryPercentChanged)
    Q_PROPERTY(QString uptime READ uptime NOTIFY uptimeChanged)
    Q_PROPERTY(int packages READ packages NOTIFY packagesChanged)

public:
    explicit SystemMonitor(QObject *parent = nullptr);

    int cpuUsage() const { return m_cpuUsage; }
    int ramUsage() const { return m_ramUsage; }
    int diskUsage() const { return m_diskUsage; }
    int batteryPercent() const { return m_batteryPercent; }
    QString uptime() const { return m_uptime; }
    int packages() const { return m_packages; }

signals:
    void cpuUsageChanged();
    void ramUsageChanged();
    void diskUsageChanged();
    void batteryPercentChanged();
    void uptimeChanged();
    void packagesChanged();

private slots:
    void updateFastStats(); 
    void updateSlowStats();

private:
    void updateCpu();
    void updateRam();
    void updateDisk();
    void updateBattery();
    void updateUptime();
    void updatePackages();

    QTimer m_fastTimer;
    QTimer m_slowTimer;
    
    int m_cpuUsage = 0;
    int m_ramUsage = 0;
    int m_diskUsage = 0;
    int m_batteryPercent = -1;
    QString m_uptime = "0h 0m";
    int m_packages = 0;

    unsigned long long m_prevIdle = 0;
    unsigned long long m_prevTotal = 0;
};
