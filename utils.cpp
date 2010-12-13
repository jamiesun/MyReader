#include "utils.h"
#include <QFile>
#include <QTextStream>
Utils::Utils(QObject *parent) :
    QObject(parent)
{
}


void Utils::write(const QString &fname, const QString &ctx)
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

