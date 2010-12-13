#ifndef UTILS_H
#define UTILS_H

#include <QObject>
#include <QFSFileEngine>

class Utils : public QObject
{
    Q_OBJECT
public:
    explicit Utils(QObject *parent = 0);
    Q_INVOKABLE QString read(const QString &fname);
    Q_INVOKABLE void write(const QString &fname,const QString &ctx);
signals:

public slots:

private:
    QString getPath()
    {
    #if defined(Q_OS_SYMBIAN)
        return QString("C://");
    #else
        return QFSFileEngine::homePath()+"/.myreader/";
    #endif
    }
};

#endif // UTILS_H
