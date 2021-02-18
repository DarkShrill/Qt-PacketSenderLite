#ifndef UDPPACKETSENDER_H
#define UDPPACKETSENDER_H

#include "QUdpSocket"
#include "QHostAddress"
#include "QObject"
#include <QString>
#include <QDebug>
#include <QtGui>
#include <QtQml>

class UdpPacketSender : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString currentDatagram READ readCurrentDatagram NOTIFY onCurrentDatagramChanged)

public:

    UdpPacketSender();

    Q_INVOKABLE int analizeIp(QString IP);

    Q_INVOKABLE QString viewAllAddress();

    Q_INVOKABLE void initPacket(QString IpDest,QString MyIp,QString PortDest, QString ListenPort);

    Q_INVOKABLE void sendPacket(QString data);

public slots:  

    void onFinished();

private:

    QString readCurrentDatagram();

    QString userIp;

    QUdpSocket * udpSocket;
    QHostAddress *host;
    QHostAddress *broadcast;
    QHostAddress *pc;
    QString ReceivedDatagram;



private slots:

    void readPendingDatagrams();

    void lookedUp(const QHostInfo &host);

signals:
    void onIpChanged();

    void onCurrentDatagramChanged();

};

#endif // UDPPACKETSENDER_H
