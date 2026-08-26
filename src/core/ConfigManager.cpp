#include "ConfigManager.h"
#include <QStandardPaths>
#include <QFileInfo>
#include <QDir>
#include <QDebug>

#define TOML_EXCEPTIONS 0
#include <toml++/toml.hpp>

ConfigManager::ConfigManager(QObject *parent) : QObject(parent) {
    reload();
    setupWatcher();
}

ConfigManager* ConfigManager::instance() {
    static ConfigManager _instance;
    return &_instance;
}

ConfigManager* ConfigManager::create(QQmlEngine*, QJSEngine*) {
    QQmlEngine::setObjectOwnership(instance(), QQmlEngine::CppOwnership);
    return instance();
}

QString ConfigManager::getConfigFilePath() const {
    QString configDir = QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation);
    return configDir + "/quickshell/config/config.toml";
}

void ConfigManager::setupWatcher() {
    QString filePath = getConfigFilePath();
    if (QFileInfo::exists(filePath)) {
        m_watcher.addPath(filePath);
        connect(&m_watcher, &QFileSystemWatcher::fileChanged, 
                this, &ConfigManager::handleFileChanged);
    }
}

void ConfigManager::handleFileChanged(const QString &path) {
    if (!m_watcher.files().contains(path) && QFileInfo::exists(path)) {
        m_watcher.addPath(path);
    }

    if (reload()) {
        qInfo() << "[ConfigManager] Configuration reloaded successfully.";
        emit configChanged();
    }
}

static QVariant parseTomlNode(const toml::node &node) {
    if (node.is_table()) {
        QVariantMap map;
        for (auto &&[key, val] : *node.as_table()) {
            std::string_view k = key.str();
            map[QString::fromUtf8(k.data(), k.size())] = parseTomlNode(val);
        }
        return map;
    } else if (node.is_array()) {
        QVariantList list;
        for (auto &&elem : *node.as_array()) {
            list.append(parseTomlNode(elem));
        }
        return list;
    } else if (node.is_string()) {
        return QString::fromStdString(node.as_string()->get());
    } else if (node.is_integer()) {
        return static_cast<qlonglong>(node.as_integer()->get());
    } else if (node.is_floating_point()) {
        return node.as_floating_point()->get();
    } else if (node.is_boolean()) {
        return node.as_boolean()->get();
    }
    return QVariant();
}

bool ConfigManager::reload() {
    auto result = toml::parse_file(getConfigFilePath().toStdString());
    if (!result) {
        qWarning() << "[ConfigManager] Failed to parse TOML config:" << result.error().description();
        return false;
    }

    m_configData = parseTomlNode(result.table()).toMap();
    return true;
}

QVariantMap ConfigManager::behavior() const { return m_configData.value("behavior").toMap(); }
QVariantMap ConfigManager::components() const { return m_configData.value("components").toMap(); }
QVariantMap ConfigManager::launcher() const { return m_configData.value("launcher").toMap(); }
QVariantMap ConfigManager::layout() const { return m_configData.value("layout").toMap(); }
QVariantMap ConfigManager::panels() const { return m_configData.value("panels").toMap(); }
QVariantMap ConfigManager::presets() const { return m_configData.value("presets").toMap(); }
QVariantMap ConfigManager::themeRoles() const { return m_configData.value("themeRoles").toMap(); }

QVariant ConfigManager::get(const QString &keyPath, const QVariant &defaultValue) const {
    const QStringList parts = keyPath.split('.');
    QVariant current = m_configData;

    for (const QString &part : parts) {
        if (current.typeId() == QMetaType::QVariantMap) {
            const QVariantMap map = current.toMap();
            if (map.contains(part)) {
                current = map.value(part);
            } else {
                return defaultValue;
            }
        } else {
            return defaultValue;
        }
    }
    return current;
}