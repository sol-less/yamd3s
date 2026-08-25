#include "ConfigManager.h"
#include <QFile>
#include <QJsonDocument>
#include <QDir>
#include <QDebug>
#include <QFileInfo>

static ConfigManager* s_instance = nullptr;

ConfigManager* ConfigManager::instance() {
    return s_instance;
}

ConfigManager::ConfigManager(QObject *parent) : QObject(parent) {
    s_instance = this;
    connect(&m_watcher, &QFileSystemWatcher::directoryChanged, this, &ConfigManager::onFileChanged);
    
    QFileInfo configDir("config/");
    if (configDir.exists() && configDir.isDir()) {
        m_watcher.addPath(configDir.absoluteFilePath());
        qDebug() << "[Config] Watching directory:" << configDir.absoluteFilePath();
    } else {
        qDebug() << "[Config] WARNING: config/ directory not found!";
    }

    loadAllConfigs();
}

void ConfigManager::loadAllConfigs() {
    QString dir = "config/";

    m_behavior   = mergeJson(defaultBehavior(),   dir + "behavior.json");
    m_components = mergeJson(defaultComponents(), dir + "components.json");
    m_launcher   = mergeJson(defaultLauncher(),   dir + "launcher.json");
    m_layout     = mergeJson(defaultLayout(),     dir + "layout.json");
    m_panels     = mergeJson(defaultPanels(),     dir + "panels.json");
    m_presets    = mergeJson(defaultPresets(),    dir + "presets.json");
    m_theme      = mergeJson(defaultTheme(),      dir + "theme.json");

    emit configChanged();
}

QJsonObject ConfigManager::mergeJson(const QJsonObject &defaults, const QString &filePath) {
    QJsonObject finalJson = defaults;
    QFileInfo fileInfo(filePath);
    QString absPath = fileInfo.absoluteFilePath();
    
    QFile file(absPath);
    if (file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        QJsonObject userJson = doc.object();

        for (auto it = userJson.begin(); it != userJson.end(); ++it) {
            if (it.value().isObject() && finalJson.contains(it.key()) && finalJson[it.key()].isObject()) {
                QJsonObject defaultObj = finalJson[it.key()].toObject();
                QJsonObject userObj = it.value().toObject();
                
                for (auto nestedIt = userObj.begin(); nestedIt != userObj.end(); ++nestedIt) {
                    defaultObj[nestedIt.key()] = nestedIt.value();
                }
                finalJson[it.key()] = defaultObj;
            } else {
                finalJson[it.key()] = it.value();
            }
        }
        file.close();
    }
    return finalJson;
}

void ConfigManager::onFileChanged(const QString &path) {
    qDebug() << "[Config] Detected change in:" << path;
    loadAllConfigs();
}

QJsonObject ConfigManager::defaultBehavior() {
    QByteArray json = R"({
        "bar": { "autoHide": true, "autoHideDelay": 300, "revealOnEdge": true },
        "panels": { "closeOnFocusLoss": true, "closeOnEscape": true, "animationEnabled": true }
    })";
    return QJsonDocument::fromJson(json).object();
}

QJsonObject ConfigManager::defaultComponents() {
    QByteArray json = R"({
        "bar": { "workspaces": true, "clock": true, "volume": true, "brightness": true, "notifications": true, "power": true },
        "hub": { "launcher": true, "wallpaper": true, "system": true, "music": true, "notifications": true }
    })";
    return QJsonDocument::fromJson(json).object();
}

QJsonObject ConfigManager::defaultLauncher() {
    QByteArray json = R"({
        "type": "grid", 
        "sortMode": "frequency"
    })";
    return QJsonDocument::fromJson(json).object();
}

QJsonObject ConfigManager::defaultLayout() {
    QByteArray json = R"({
        "bar": { "height": 42, "spacing": 8, "margin": 8 }
    })";
    return QJsonDocument::fromJson(json).object();
}

QJsonObject ConfigManager::defaultPanels() {
    QByteArray json = R"({
        "apps": { "width": 565, "height": 350 }
    })";
    return QJsonDocument::fromJson(json).object();
}

QJsonObject ConfigManager::defaultPresets() {
    QByteArray json = R"({
        "active": "default"
    })";
    return QJsonDocument::fromJson(json).object();
}

QJsonObject ConfigManager::defaultTheme() {
    QByteArray json = R"({
        "themeRoles": { "workspaces": "tertiary" }
    })";
    return QJsonDocument::fromJson(json).object();
}
