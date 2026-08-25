#pragma once

#include <QObject>
#include <QJsonObject>
#include <QFileSystemWatcher>
#include <QString>
#include <QtQml/qqml.h>

class ConfigManager : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    
    Q_PROPERTY(QJsonObject behavior READ getBehavior NOTIFY configChanged)
    Q_PROPERTY(QJsonObject components READ getComponents NOTIFY configChanged)
    Q_PROPERTY(QJsonObject launcher READ getLauncher NOTIFY configChanged)
    Q_PROPERTY(QJsonObject layout READ getLayout NOTIFY configChanged)
    Q_PROPERTY(QJsonObject panels READ getPanels NOTIFY configChanged)
    Q_PROPERTY(QJsonObject presets READ getPresets NOTIFY configChanged)
    Q_PROPERTY(QJsonObject theme READ getTheme NOTIFY configChanged)

public:
    explicit ConfigManager(QObject *parent = nullptr);

    static ConfigManager* instance();

    QJsonObject getBehavior() const { return m_behavior; }
    QJsonObject getComponents() const { return m_components; }
    QJsonObject getLauncher() const { return m_launcher; }
    QJsonObject getLayout() const { return m_layout; }
    QJsonObject getPanels() const { return m_panels; }
    QJsonObject getPresets() const { return m_presets; }
    QJsonObject getTheme() const { return m_theme; }

signals:
    void configChanged();

private:
    QJsonObject m_behavior;
    QJsonObject m_components;
    QJsonObject m_launcher;
    QJsonObject m_layout;
    QJsonObject m_panels;
    QJsonObject m_presets;
    QJsonObject m_theme;
    
    QFileSystemWatcher m_watcher;

    QJsonObject defaultBehavior();
    QJsonObject defaultComponents();
    QJsonObject defaultLauncher();
    QJsonObject defaultLayout();
    QJsonObject defaultPanels();
    QJsonObject defaultPresets();
    QJsonObject defaultTheme();

    QJsonObject mergeJson(const QJsonObject &defaults, const QString &filePath);
    void loadAllConfigs();

private slots:
    void onFileChanged(const QString &path);
};
