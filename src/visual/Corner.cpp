#include "Corner.h"
#include <QSGGeometryNode>
#include <QSGFlatColorMaterial>
#include <QSGGeometry>
#include <QtMath>
#include <algorithm>
#include <cmath>

CornerItem::CornerItem(QQuickItem *parent) : QQuickItem(parent) {
    setFlag(ItemHasContents, true);
    setImplicitWidth(24);
    setImplicitHeight(24);
}

void CornerItem::geometryChange(const QRectF &newGeometry, const QRectF &oldGeometry) {
    QQuickItem::geometryChange(newGeometry, oldGeometry);

    if (newGeometry.size() != oldGeometry.size()) {
        m_dirty = true;
        update();
    }
}

void CornerItem::setColor(const QColor &c) {
    if (m_color == c) return;
    m_color = c;
    m_dirty = true;
    emit colorChanged();
    update();
}

void CornerItem::setCorner(int c) {
    if (m_corner == c) return;
    m_corner = c;
    m_dirty = true;
    emit cornerChanged();
    update();
}

void CornerItem::setTargetWidth(qreal w) {
    if (qFuzzyCompare(m_targetWidth, w)) return;
    m_targetWidth = w;
    m_dirty = true;
    emit targetWidthChanged();
    update();
}

void CornerItem::setTargetHeight(qreal h) {
    if (qFuzzyCompare(m_targetHeight, h)) return;
    m_targetHeight = h;
    m_dirty = true;
    emit targetHeightChanged();
    update();
}

QSGNode *CornerItem::updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *) {
    QSGGeometryNode *node = static_cast<QSGGeometryNode *>(oldNode);
    QSGGeometry *geometry = nullptr;
    QSGFlatColorMaterial *material = nullptr;

    const int segments = 48;
    const int vertexCount = segments + 2;

    if (!node) {
        node = new QSGGeometryNode();
        geometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), vertexCount);
        geometry->setDrawingMode(QSGGeometry::DrawTriangleFan);
        node->setGeometry(geometry);
        node->setFlag(QSGNode::OwnsGeometry);

        material = new QSGFlatColorMaterial();
        node->setMaterial(material);
        node->setFlag(QSGNode::OwnsMaterial);
    } else {
        geometry = node->geometry();
        material = static_cast<QSGFlatColorMaterial *>(node->material());
    }

    material->setColor(m_color);

    if (m_dirty) {
        QSGGeometry::Point2D *vertices = geometry->vertexDataAsPoint2D();

        qreal W = std::max(0.0, width());
        qreal H = std::max(0.0, height());

        if (W <= 0.001 || H <= 0.001 || std::isnan(W) || std::isnan(H)) {
            for (int i = 0; i < vertexCount; ++i) {
                vertices[i].set(0, 0);
            }
            geometry->markVertexDataDirty();
            node->markDirty(QSGNode::DirtyGeometry);
            m_dirty = false;
            return node;
        }

        const qreal k = 0.72;

        QPointF hub;
        QPointF p0, p1, p2, p3;

        switch (m_corner) {
        case 0: // Top-Left fillet
            hub = QPointF(0, H);
            p0  = QPointF(0, 0);
            p1  = QPointF(0, H * (1.0 - k));
            p2  = QPointF(W * k, H);
            p3  = QPointF(W, H);
            break;

        case 1: // Top-Right fillet
            hub = QPointF(W, H);
            p0  = QPointF(W, 0);
            p1  = QPointF(W, H * (1.0 - k));
            p2  = QPointF(W * (1.0 - k), H);
            p3  = QPointF(0, H);
            break;

        case 2: // Bottom-Right fillet
            hub = QPointF(W, 0);
            p0  = QPointF(W, H);
            p1  = QPointF(W, H * k);
            p2  = QPointF(W * (1.0 - k), 0);
            p3  = QPointF(0, 0);
            break;

        case 3: // Bottom-Left fillet
        default:
            hub = QPointF(0, 0);
            p0  = QPointF(0, H);
            p1  = QPointF(0, H * k);
            p2  = QPointF(W * k, 0);
            p3  = QPointF(W, 0);
            break;
        }

        vertices[0].set(hub.x(), hub.y());

        for (int i = 0; i <= segments; ++i) {
            qreal t = static_cast<qreal>(i) / segments;
            qreal u = 1.0 - t;

            qreal x = u*u*u*p0.x() + 3*u*u*t*p1.x() + 3*u*t*t*p2.x() + t*t*t*p3.x();
            qreal y = u*u*u*p0.y() + 3*u*u*t*p1.y() + 3*u*t*t*p2.y() + t*t*t*p3.y();

            vertices[i + 1].set(x, y);
        }

        geometry->markVertexDataDirty();
        node->markDirty(QSGNode::DirtyGeometry | QSGNode::DirtyMaterial);
        m_dirty = false;
    }

    return node;
}