#pragma once

#include <QObject>
#include <QVariantMap>
#include <QFileSystemWatcher>
#include <QtQml/qqmlregistration.h>
#include <QQmlEngine>
#include <QJSEngine>

class ConfigManager : public QObject {
    Q_OBJECT
    QML_NAMED_ELEMENT(ConfigManager)
    QML_SINGLETON

    Q_PROPERTY(QVariantMap behavior READ behavior NOTIFY configChanged)
    Q_PROPERTY(QVariantMap components READ components NOTIFY configChanged)
    Q_PROPERTY(QVariantMap launcher READ launcher NOTIFY configChanged)
    Q_PROPERTY(QVariantMap layout READ layout NOTIFY configChanged)
    Q_PROPERTY(QVariantMap panels READ panels NOTIFY configChanged)
    Q_PROPERTY(QVariantMap presets READ presets NOTIFY configChanged)
    Q_PROPERTY(QVariantMap themeRoles READ themeRoles NOTIFY configChanged)

public:
    explicit ConfigManager(QObject *parent = nullptr);

    static ConfigManager* instance();
    static ConfigManager* create(QQmlEngine*, QJSEngine*);

    QVariantMap behavior() const;
    QVariantMap components() const;
    QVariantMap launcher() const;
    QVariantMap layout() const;
    QVariantMap panels() const;
    QVariantMap presets() const;
    QVariantMap themeRoles() const;

    Q_INVOKABLE QVariant get(const QString &keyPath, const QVariant &defaultValue = QVariant()) const;

signals:
    void configChanged();

public slots:
    bool reload();

private:
    void setupWatcher();
    void handleFileChanged(const QString &path);
    QString getConfigFilePath() const;

    QVariantMap m_configData;
    QFileSystemWatcher m_watcher;
};