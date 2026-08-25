#pragma once

#include <QObject>
#include <QString>
#include <QJsonObject>
#include <QFileSystemWatcher>
#include <QtQml/qqml.h>

class ThemeManager : public QObject {
    Q_OBJECT
    QML_NAMED_ELEMENT(Theme)
    QML_SINGLETON

    Q_PROPERTY(QVariantMap md3 READ getMd3 NOTIFY colorsChanged)

public:
    explicit ThemeManager(QObject *parent = nullptr);

    Q_INVOKABLE QString roleColor(const QString &moduleKey, const QString &variant = "base") const;
    QVariantMap getMd3() const { return m_colors.toVariantMap(); }

signals:
    void colorsChanged(); 

private slots:
    void loadColors();

private:
    QJsonObject m_colors;
    QFileSystemWatcher m_watcher;
};