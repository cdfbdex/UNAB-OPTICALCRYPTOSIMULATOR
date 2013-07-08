#-------------------------------------------------
#
# Project created by QtCreator 2013-07-02T19:11:15
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = CRIPTOGRAFIA_OPTICA
TEMPLATE = app
LIBS += -L"C:\Program Files\Windows Kits\8.0\Lib\win8\um\x86" -lkernel32


win32:CONFIG(release, debug|release) {
QMAKE_POST_LINK = $$quote(mt.exe -nologo -manifest \"WinCompat.manifest\" \"release\\CRIPTOGRAFIA_OPTICA.exe.manifest\" -outputresource:$(DESTDIR_TARGET);1)
}
else:win32:CONFIG(debug, debug|release) {
QMAKE_POST_LINK = $$quote(mt.exe -nologo -manifest \"WinCompat.manifest\" \"debug\\CRIPTOGRAFIA_OPTICA.exe.manifest\" -outputresource:$(DESTDIR_TARGET);1)
}


SOURCES += main.cpp\
        mainwindow.cpp

HEADERS  += mainwindow.h

FORMS    += mainwindow.ui

RESOURCES += \
    mainwindow.qrc
