#include "Theme.h"
#include "ConfigManager.h"  
#include <QDir>
#include <QFile>
#include <QJsonDocument>
#include <QDebug>

ThemeManager::ThemeManager(QObject *parent) : QObject(parent) {
    QString genDir = QDir::homePath() + "/.local/state/quickshell/generated";
    
    QDir().mkpath(genDir); 
    m_watcher.addPath(genDir);
    
    connect(&m_watcher, &QFileSystemWatcher::directoryChanged, this, &ThemeManager::loadColors);

    loadColors();
}

void ThemeManager::loadColors() {
    QString filePath = QDir::homePath() + "/.local/state/quickshell/generated/colors.json";
    QFile file(filePath);
    
    if (file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        m_colors = doc.object().value("md3").toObject();
        file.close();
        
        qDebug() << "[Theme] Loaded colors from" << filePath;
        emit colorsChanged();
    } else {
        qDebug() << "[Theme] WARNING: Could not open colors.json at" << filePath;
    }
}

QString ThemeManager::roleColor(const QString &moduleKey, const QString &variant) const {
    QJsonObject themeConfig;
    if (ConfigManager::instance()) {
        themeConfig = ConfigManager::instance()->getTheme();
    }
    
    QJsonObject roles = themeConfig.value("themeRoles").toObject();
    QString role = roles.contains(moduleKey) ? roles.value(moduleKey).toString() : "primary";

    QString key;
    if (variant == "container") key = QString("%1_container").arg(role);
    else if (variant == "on") key = QString("on_%1").arg(role);
    else if (variant == "onContainer") key = QString("on_%1_container").arg(role);
    else key = role;

    if (m_colors.contains(key)) {
        return m_colors.value(key).toString();
    }

    if (variant == "on") return "#FFFFFF";
    if (variant == "onContainer" || variant == "container") return "#000000";
    if (m_colors.contains(role)) return m_colors.value(role).toString();
    
    return "#000000"; 
}