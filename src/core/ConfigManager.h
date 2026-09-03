// ConfigManager.h
#pragma once

#include <QObject>
#include <QVariantMap>
#include <QVariant>
#include <QString>
#include <QtQml/qqml.h>
#include <toml++/toml.h> 

class ConfigManager : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    
    Q_PROPERTY(QVariantMap general READ general NOTIFY configChanged)
    Q_PROPERTY(QVariantMap launcher READ launcher NOTIFY configChanged)
    Q_PROPERTY(QVariantMap components READ components NOTIFY configChanged)
    Q_PROPERTY(QVariantMap behavior READ behavior NOTIFY configChanged)
    Q_PROPERTY(QVariantMap layout READ layout NOTIFY configChanged)
    Q_PROPERTY(QVariantMap panels READ panels NOTIFY configChanged)
    Q_PROPERTY(QVariantMap themeRoles READ themeRoles NOTIFY configChanged)
    
    Q_PROPERTY(QVariantMap vanilla READ vanilla NOTIFY configChanged)
    Q_PROPERTY(QVariantMap mod READ mod NOTIFY configChanged)

public:
    explicit ConfigManager(QObject *parent = nullptr);

    static ConfigManager* instance();

    QVariantMap general() const { return m_general; }
    QVariantMap launcher() const { return m_launcher; }
    QVariantMap components() const { return m_components; }
    QVariantMap behavior() const { return m_behavior; }
    QVariantMap layout() const { return m_layout; }
    QVariantMap panels() const { return m_panels; }
    QVariantMap themeRoles() const { return m_themeRoles; }
    
    QVariantMap vanilla() const { return m_vanillaFlat; }
    QVariantMap mod() const { return m_modFlat; }

    Q_INVOKABLE void updateQVariantCache(); 
    Q_INVOKABLE void loadUserConfig(const QString& filePath); 

    Q_INVOKABLE QVariant getNum(const QString& key, double fallback = 0.0) const {
        if (m_vanillaFlat.contains(key)) {
            return m_vanillaFlat.value(key);
        }
        return fallback;
    }
    
    Q_INVOKABLE QString getStr(const QString& key, const QString& fallback = "") const {
        if (m_vanillaFlat.contains(key)) {
            return m_vanillaFlat.value(key).toString();
        }
        return fallback;
    }

signals:
    void configChanged();

private:
    QVariantMap m_general;
    QVariantMap m_launcher;
    QVariantMap m_components;
    QVariantMap m_behavior;
    QVariantMap m_layout;
    QVariantMap m_panels;
    QVariantMap m_themeRoles;
    QVariantMap m_modConfig;
    
    QVariantMap m_vanillaFlat;
    QVariantMap m_modFlat;
    
    toml::table m_tomlData; 

    QVariant tomlToQVariant(const toml::node& node);
    void flattenMap(const QVariantMap& source, QVariantMap& dest, const QString& prefix = "") const;
};