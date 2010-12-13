# Add more folders to ship with the application, here
folder_01.source = qml/MyReader
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =
QT +=  webkit network

# Avoid auto screen rotation
#DEFINES += ORIENTATIONLOCK

# Needs to be defined for Symbian
DEFINES += NETWORKACCESS

symbian:{
    TARGET.UID3 = 0xE7F0205E
    ICON = MyReader.svg
}

# Define QMLJSDEBUGGER to allow debugging of QML in debug builds
# (This might significantly increase build time)
# DEFINES += QMLJSDEBUGGER

# If your application uses the Qt Mobility libraries, uncomment
# the following lines and add the respective components to the 
# MOBILITY variable. 
# CONFIG += mobility
# MOBILITY +=

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    utils.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    qml/MyReader/main.qml \
    qml/MyReader/FeedList.qml \
    qml/MyReader/FeedItem.qml \
    qml/MyReader/QuitBar.qml \
    qml/MyReader/FeedDetail.qml \
    qml/MyReader/feedUpdate.js \
    qml/MyReader/auth.js \
    qml/MyReader/Lodding.qml \
    qml/MyReader/lodding.gif \
    qml/MyReader/Settings.qml \
    qml/MyReader/pic/tags.png \
    qml/MyReader/pic/subs.png \
    qml/MyReader/pic/star.png \
    qml/MyReader/pic/settings.png \
    qml/MyReader/pic/previous.png \
    qml/MyReader/pic/notes.png \
    qml/MyReader/pic/next.png \
    qml/MyReader/pic/home.png \
    qml/MyReader/pic/follows.png \
    qml/MyReader/pic/exit.png \
    qml/MyReader/pic/back.png \
    qml/MyReader/pic/alls.png \
    qml/MyReader/pic/about.png \
    qml/MyReader/Menu.qml \
    qml/MyReader/Alert.qml \
    qml/MyReader/pic/lodding.gif \
    MyReader.svg \
    qml/MyReader/About.qml \
    qml/MyReader/pic/ok.png \
    qml/MyReader/pic/jamiesun.jpg

RESOURCES +=

HEADERS += \
    utils.h
