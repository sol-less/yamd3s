// ConfigManager.cpp
#include "ConfigManager.h"
#include <QCoreApplication>
#include <QFile>
#include <QFileInfo>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include <QProcessEnvironment>
#include <QDirIterator>
#include <QStandardPaths>
#include <QVariant>
#include <QFileSystemWatcher>

static ConfigManager* s_instance = nullptr;

const QString DEFAULT_TOML = R"(# Auto configuration for [ Yamd3s ]

[general]
preset = "default"

# | Togglables
[components.bar]
launcher = true
workspaces = true
clock = true
volume = true
brightness = true
notifications = true
power = true

[components.hub]
dashboard = true
wallpaper = true
system = true
music = true
notifications = true

[components.widgets]
clock = true

# | Launcher Settings
[components.launcher]
mode = "list"
showIcons = true
iconSize = 24

# | Component behavior
[behavior.bar]
autoHide = true
autoHideDelay = 1000
revealOnEdge = true

[behavior.panels]
closeOnFocusLoss = true
closeOnEscape = true
animationEnabled = true

# | Theme Roles
[theme.roles]
workspaces = "tertiary"
clock = "secondary"
switcher = "secondary"
musicProgress = "secondary"
musicPlayButton = "primary"
volumeIcon = "tertiary"
brightnessIcon = "tertiary"
powermenu = "error"
notificationButton = "tertiary"
actionsButton = "secondary"
)";

static QVariantMap mergeVariantMaps(const QVariantMap& base, const QVariantMap& overlay) {
    QVariantMap result = base;
    for (auto it = overlay.constBegin(); it != overlay.constEnd(); ++it) {
        if (result.contains(it.key())) {
            if (result.value(it.key()).canConvert<QVariantMap>() && 
                it.value().canConvert<QVariantMap>()) {
                
                result[it.key()] = mergeVariantMaps(result.value(it.key()).toMap(), it.value().toMap());
            } else {
                result[it.key()] = it.value(); 
            }
        } else {
            qWarning() << "[ConfigManager] Ignoring unknown key in user config.toml:" << it.key();
        }
    }
    return result;
}

ConfigManager::ConfigManager(QObject *parent) : QObject(parent) {
    s_instance = this;

    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    QString configPath = env.value("M3I_CONFIG_PATH");
    QString userConfigDir = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) + "/quickshell";

    if (configPath.isEmpty()) {
        configPath = userConfigDir + "/config/config.toml";
    }
    
    QString modPath = userConfigDir + "/config/mod.toml";

    loadUserConfig(configPath);

    QFileSystemWatcher* watcher = new QFileSystemWatcher(this);
    
    if (QFile::exists(configPath)) watcher->addPath(configPath);
    if (QFile::exists(modPath)) watcher->addPath(modPath);
    
    QFileInfo fileInfo(configPath);
    watcher->addPath(fileInfo.dir().absolutePath());

    connect(watcher, &QFileSystemWatcher::fileChanged, this, [this, watcher, configPath, modPath](const QString& path) {
        qDebug() << "[ConfigManager] File modified on disk:" << path << "- Hot-reloading...";
        if (path == configPath) {
            loadUserConfig(configPath);
        } else if (path == modPath) {
            updateQVariantCache(); 
        }
        
        if (!watcher->files().contains(path) && QFile::exists(path)) {
            watcher->addPath(path);
        }
    });
    
    connect(watcher, &QFileSystemWatcher::directoryChanged, this, [this, watcher, configPath, modPath]() {
        if (!watcher->files().contains(configPath) && QFile::exists(configPath)) {
            qDebug() << "[ConfigManager] config.toml created! Hooking it up...";
            watcher->addPath(configPath);
            loadUserConfig(configPath);
        }
        if (!watcher->files().contains(modPath) && QFile::exists(modPath)) {
            qDebug() << "[ConfigManager] mod.toml created! Hooking it up...";
            watcher->addPath(modPath);
            updateQVariantCache();
        }
    });
}

ConfigManager* ConfigManager::instance() {
    return s_instance;
}

void ConfigManager::loadUserConfig(const QString& filePath) {
    if (QFile::exists(filePath)) {
        try {
            m_tomlData = toml::parse_file(filePath.toStdString());
            qDebug() << "[ConfigManager] Loaded user overrides from:" << filePath;
        } catch (const toml::parse_error& err) {
            qWarning() << "[ConfigManager] Failed to parse config.toml at" << filePath << ":" << err.description().data();
            m_tomlData = toml::table();
        }
    } else {
        qDebug() << "[ConfigManager] No user config found at" << filePath << ". Using pure internal defaults.";
        m_tomlData = toml::table();
    }

    updateQVariantCache();
}

QVariant ConfigManager::tomlToQVariant(const toml::node& node) {
    if (node.is_string()) {
        return QVariant(QString::fromStdString(node.as_string()->get()));
    } else if (node.is_integer()) {
        return QVariant(static_cast<qint64>(node.as_integer()->get()));
    } else if (node.is_floating_point()) {
        return QVariant(node.as_floating_point()->get());
    } else if (node.is_boolean()) {
        return QVariant(node.as_boolean()->get());
    } else if (node.is_array()) {
        QVariantList list;
        const auto& arr = *node.as_array();
        for (const auto& item : arr) {
            list.append(tomlToQVariant(item));
        }
        return list;
    } else if (node.is_table()) {
        QVariantMap map;
        const auto& table = *node.as_table();
        for (auto it = table.begin(); it != table.end(); ++it) {
            map.insert(QString::fromStdString(std::string(it->first.str())), tomlToQVariant(it->second));
        }
        return map;
    }
    return QVariant();
}

void ConfigManager::flattenMap(const QVariantMap& source, QVariantMap& dest, const QString& prefix) const {
    for (auto it = source.constBegin(); it != source.constEnd(); ++it) {
        QString newKey = prefix.isEmpty() ? it.key() : prefix + "." + it.key();
        
        if (it.value().canConvert<QVariantMap>()) {
            flattenMap(it.value().toMap(), dest, newKey);
        } else {
            dest.insert(newKey, it.value());
        }
    }
}

void ConfigManager::updateQVariantCache() {
    QString userConfigDir = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) + "/quickshell";

    QStringList candidatePaths = {
        ":/qt/qml/Yamd3s/src/configuration/system.json",
        ":/system.json",
        "src/configuration/system.json",   
        userConfigDir + "/system.json"     
    };

    QString resolvedPath;
    for (const QString &path : candidatePaths) {
        if (QFile::exists(path)) {
            resolvedPath = path;
            break;
        }
    }

    if (!resolvedPath.isEmpty()) {
        QFile dbFile(resolvedPath);
        if (dbFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
            QByteArray jsonData = dbFile.readAll();
            QJsonDocument document = QJsonDocument::fromJson(jsonData);
            
            if (!document.isNull() && document.isObject()) {
                QJsonObject rootObj = document.object();
                m_layout = rootObj["layout"].toVariant().toMap();
                m_panels = rootObj["panels"].toVariant().toMap();
            }
            dbFile.close();
        }
    } else {
        qWarning() << "[ConfigManager] CRITICAL: system.json not found in candidate paths! Layout values will be missing.";
    }
 
    toml::table defaultToml;
    try {
        defaultToml = toml::parse(DEFAULT_TOML.toStdString());
    } catch (const toml::parse_error& err) {
        qWarning() << "[ConfigManager] FATAL: Failed to parse internal DEFAULT_TOML string:" << err.description().data();
    }

    QVariantMap baseGeneral, baseComponents, baseBehavior, baseThemeRoles;
    if (defaultToml.contains("general")) baseGeneral = tomlToQVariant(*defaultToml["general"].as_table()).toMap();
    if (defaultToml.contains("components")) baseComponents = tomlToQVariant(*defaultToml["components"].as_table()).toMap();
    if (defaultToml.contains("behavior")) baseBehavior = tomlToQVariant(*defaultToml["behavior"].as_table()).toMap();
    if (defaultToml.contains("theme")) baseThemeRoles = tomlToQVariant(*defaultToml["theme"].as_table()).toMap().value("roles").toMap();

    QVariantMap userGeneral, userComponents, userBehavior, userThemeRoles;
    if (m_tomlData.contains("general")) userGeneral = tomlToQVariant(*m_tomlData["general"].as_table()).toMap();
    if (m_tomlData.contains("components")) userComponents = tomlToQVariant(*m_tomlData["components"].as_table()).toMap();
    if (m_tomlData.contains("behavior")) userBehavior = tomlToQVariant(*m_tomlData["behavior"].as_table()).toMap();
    if (m_tomlData.contains("theme")) userThemeRoles = tomlToQVariant(*m_tomlData["theme"].as_table()).toMap().value("roles").toMap();

    m_general    = mergeVariantMaps(baseGeneral, userGeneral);
    m_components = mergeVariantMaps(baseComponents, userComponents);
    m_behavior   = mergeVariantMaps(baseBehavior, userBehavior);
    m_themeRoles = mergeVariantMaps(baseThemeRoles, userThemeRoles);

    m_launcher   = m_components.value("launcher").toMap();

    QString modPath = userConfigDir + "/config/mod.toml";
    if (QFile::exists(modPath)) {
        try {
            toml::table modToml = toml::parse_file(modPath.toStdString());
            m_modConfig = tomlToQVariant(modToml).toMap();
            qDebug() << "[ConfigManager] Loaded mod.toml successfully.";
        } catch (const toml::parse_error& err) {
            qWarning() << "[ConfigManager] Failed to parse mod.toml:" << err.description().data();
            m_modConfig.clear();
        }
    } else {
        m_modConfig.clear();
    }

    QVariantMap fullVanilla;
    fullVanilla.insert("general", m_general);
    fullVanilla.insert("components", m_components);
    fullVanilla.insert("behavior", m_behavior);
    fullVanilla.insert("layout", m_layout);
    fullVanilla.insert("panels", m_panels);
    fullVanilla.insert("themeRoles", m_themeRoles);

    m_vanillaFlat.clear();
    flattenMap(fullVanilla, m_vanillaFlat);

    m_modFlat.clear();
    flattenMap(m_modConfig, m_modFlat);

    emit configChanged();
}