#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "udppacketsender.h"
#include <QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml>
#include <QtCore/QDir>
#include <QtQml/QQmlEngine>
#include "QQuickView"

int main(int argc, char *argv[])
{
    //QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qDebug() << qApp->primaryScreen()->devicePixelRatio();

    qmlRegisterType<UdpPacketSender>("UdpSender",0,0,"UdpPacketSender");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}


