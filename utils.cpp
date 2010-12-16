#include "utils.h"
#include <QFile>
#include <QTextStream>
#include <QDateTime>
#include <QDebug>
Utils::Utils(QObject *parent) :
    QObject(parent)
{
}


void  Utils::write(const QString &fname, const QString &ctx)
{
    QFile file(getPath()+fname);
    file.open(QIODevice::WriteOnly | QIODevice::Text);
    QTextStream out(&file);
    out << ctx.toUtf8();
    file.close();
}


QString Utils::read(const QString &fname)
{
    if(!QFile::exists(getPath()+fname))
    {
        return "";
    }
    QFile file(getPath()+fname);
    file.open(QIODevice::ReadOnly | QIODevice::Text);
    return QString::fromUtf8(file.readAll());
}

QString Utils::getCache(const QString &fname)
{
    QFile file(getPath()+fname);
    QFileInfo info(file);
    if(QDateTime::currentDateTime()> info.lastModified().addSecs(10*60))
    {
        return "";
    }

    file.open(QIODevice::ReadOnly | QIODevice::Text);
    return QString::fromUtf8(file.readAll());
}


void Utils::setCache(const QString &key,const QString &value)
{
    QFile file(getPath()+key);
    file.open(QIODevice::WriteOnly | QIODevice::Text);
    QTextStream out(&file);
    out << value.toUtf8();
    file.close();
}

