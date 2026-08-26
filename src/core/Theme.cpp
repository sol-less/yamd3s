#include "Theme.h"
#include "ConfigManager.h"  
#include <QDir>
#include <QFile>
#include <QJsonDocument>
#include <QDebug>

ThemeManager::ThemeManager(QObject *parent) : QObject(parent) {
    QString genDir = QDir::homePath() + "/.local/state/quickshell/generated";
    QString filePath = genDir + "/colors.json";

    QDir().mkpath(genDir); 
    
    m_watcher.addPath(genDir);
    if (QFile::exists(filePath)) {
        m_watcher.addPath(filePath);
    }
    
    connect(&m_watcher, &QFileSystemWatcher::directoryChanged, this, &ThemeManager::loadColors);
    connect(&m_watcher, &QFileSystemWatcher::fileChanged, this, &ThemeManager::loadColors);

    if (ConfigManager::instance()) {
        connect(ConfigManager::instance(), &ConfigManager::configChanged, this, [this]() {
            emit colorsChanged();
        });
    }

    loadColors();
}

void ThemeManager::loadColors() {
    QString filePath = QDir::homePath() + "/.local/state/quickshell/generated/colors.json";

    if (QFile::exists(filePath) && !m_watcher.files().contains(filePath)) {
        m_watcher.addPath(filePath);
    }

    QFile file(filePath);
    if (file.open(QIODevice::ReadOnly)) {
        QByteArray data = file.readAll();
        file.close();

        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (!doc.isNull() && doc.isObject()) {
            m_colors = doc.object().value("md3").toObject();
            qDebug() << "[Theme] Loaded colors successfully from" << filePath;
            emit colorsChanged();
            return;
        }
        qDebug() << "[Theme] WARNING: colors.json parsed as empty or invalid JSON";
    } else {
        qDebug() << "[Theme] WARNING: Could not open colors.json at" << filePath;
    }
}

QString ThemeManager::roleColor(const QString &moduleKey, const QString &variant) const {
    QVariantMap roles;
    if (ConfigManager::instance()) {
        roles = ConfigManager::instance()->themeRoles();
    }
    
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