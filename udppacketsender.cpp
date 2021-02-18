#include "udppacketsender.h"
#include "QUdpSocket"
#include "QHostAddress"
#include "QObject"
#include <QString>
#include <QDebug>
#include <QtGui>
#include <QtQml>

UdpPacketSender::UdpPacketSender()
{
    udpSocket = new QUdpSocket();
}

QString UdpPacketSender::readCurrentDatagram()
{
    return this->ReceivedDatagram;
}

void UdpPacketSender::sendPacket(QString data)
{
    QByteArray *datagram = new QByteArray;
    datagram->insert(0,data.toLocal8Bit());
    udpSocket->write(*datagram);
    qDebug() <<"#############################################    INVIO DATAGRAM";
}

void UdpPacketSender::onFinished()
{
    QIODevice * content = static_cast<QIODevice*>(QObject::sender());
    qDebug() << content->readAll();
    content->deleteLater();
}

int UdpPacketSender::analizeIp(QString IP)
{
    int firstIp = 0;
    int secondIp = 0;
    int threeIp = 0;
    int fourIp = 0;

    IP.replace("."," ");

    QTextStream myteststream(&IP);

    myteststream >> firstIp >> secondIp >> threeIp >> fourIp;


    qDebug()<<"############################################# !! IP DETECTED : " + QString::number(firstIp) + " " + QString::number(secondIp) + " " +\
                                                                                  QString::number(threeIp) + " " +QString::number(fourIp);

    if((firstIp == 0) || (firstIp > 255))
    {
        qDebug()<<("############################################# !! ERRORE !!       FIRST IP");
        return 1;
    }

    if((secondIp > 255))
    {
        qDebug()<<("############################################# !! ERRORE !!       SECOND IP");
    }
    if((threeIp > 255))
    {
        qDebug()<<("############################################# !! ERRORE !!       THREE IP");
        return 1;
    }
    if((fourIp == 0) || (fourIp > 255))
    {
        qDebug()<<("############################################# !! ERRORE !!       FOUR IP");
        return 1;
    }

    return 0;
}

QString UdpPacketSender::viewAllAddress()
{
    QString addr;
    foreach (const QHostAddress &address, QNetworkInterface::allAddresses()) {
        if (address.protocol() == QAbstractSocket::IPv4Protocol && address != QHostAddress(QHostAddress::LocalHost))
        {
             addr = (address.toString());
             qDebug() << "###################################################   LOCAL ADDR: " + addr;
            break;
        }
    }
    return addr;
}

void UdpPacketSender::initPacket(QString IpDest,QString MyIp, QString PortDest, QString ListenPort)
{
    host  = new QHostAddress(MyIp);//MY IP
    broadcast = new QHostAddress(MyIp);
    int tempBroadcast = 0;


    if((host->toIPv4Address() & 0xFF000000) >= 192){
        tempBroadcast = host->toIPv4Address();

        tempBroadcast &= 0xFFFFFF00;
        tempBroadcast |= 0xFF;

    }else if((host->toIPv4Address() & 0xFF000000) >= 128){

        tempBroadcast = host->toIPv4Address();

        tempBroadcast &= 0xFFFF0000;
        tempBroadcast |= 0xFFFF;

    }else if((host->toIPv4Address() & 0xFF000000) >= 1){
        tempBroadcast = host->toIPv4Address();

        tempBroadcast &= 0xFF000000;
        tempBroadcast |= 0xFFFFFF;
    }else{
        qDebug() << "Error";
    }

    broadcast = new QHostAddress(tempBroadcast);

    pc = new QHostAddress(IpDest);

    bool ok ;

    qDebug()<<"##################################### port dest NO CONVERSION: " + PortDest;
    qDebug()<<"##################################### port Src NO CONVERSION: " + ListenPort;

    udpSocket->bind(*host, ListenPort.toInt(&ok,10));
    udpSocket->connectToHost(*pc,PortDest.toInt(&ok,10));

    QObject::connect(udpSocket,SIGNAL(readyRead()),this,SLOT(readPendingDatagrams()));

    QByteArray *datagram = new QByteArray();
    datagram->insert(0,QString("!! HEY, I'M ALIVE :) !!").toLocal8Bit());
    udpSocket->write(*datagram);

    qDebug()<<"##################################### port dest: " + QString::number(PortDest.toInt(&ok,10));
    qDebug()<<"##################################### port src: " + QString::number(ListenPort.toInt(&ok,10));

}

void UdpPacketSender::lookedUp(const QHostInfo &host)
{
    if (host.error() != QHostInfo::NoError) {
        qDebug() << "Lookup failed:" << host.errorString();
        return;
    }

    const auto addresses = host.addresses();
    for (const QHostAddress &address : addresses)
    {
        qDebug() << "Found address:" << address.toString();

    }
}

void UdpPacketSender::readPendingDatagrams()
{
    QHostAddress sender;
    uint16_t port;
    while (udpSocket->hasPendingDatagrams())
    {
        QByteArray datagram;
        datagram.resize(udpSocket->pendingDatagramSize());
        udpSocket->readDatagram(datagram.data(),datagram.size(),&sender,&port);
        qDebug() <<"#############################################    Message From :: " << sender.toString();
        qDebug() <<"#############################################    Port From :: "<< port;
        qDebug() <<"#############################################    Message :: " << datagram;
        this->ReceivedDatagram = datagram;
        emit onCurrentDatagramChanged();
   }
}




