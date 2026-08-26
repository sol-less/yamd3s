#pragma once

#include <QQuickItem>
#include <QColor>
#include <QtQml/qqml.h>

class CornerItem : public QQuickItem {
    Q_OBJECT
    QML_NAMED_ELEMENT(Corner)

    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(int corner READ corner WRITE setCorner NOTIFY cornerChanged)
    Q_PROPERTY(qreal targetWidth READ targetWidth WRITE setTargetWidth NOTIFY targetWidthChanged)
    Q_PROPERTY(qreal targetHeight READ targetHeight WRITE setTargetHeight NOTIFY targetHeightChanged)

public:
    explicit CornerItem(QQuickItem *parent = nullptr);

    QColor color() const { return m_color; }
    void setColor(const QColor &c);

    int corner() const { return m_corner; }
    void setCorner(int c);

    qreal targetWidth() const { return m_targetWidth; }
    void setTargetWidth(qreal w);

    qreal targetHeight() const { return m_targetHeight; }
    void setTargetHeight(qreal h);

signals:
    void colorChanged();
    void cornerChanged();
    void targetWidthChanged();
    void targetHeightChanged();

protected:
    QSGNode *updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *) override;
    void geometryChange(const QRectF &newGeometry, const QRectF &oldGeometry) override;

private:
    QColor m_color = Qt::black;
    int m_corner = 0; // 0: TopLeft, 1: TopRight, 2: BottomRight, 3: BottomLeft
    qreal m_targetWidth = 0.0;
    qreal m_targetHeight = 0.0;
    bool m_dirty = true;
};