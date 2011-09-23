#-------------------------------------------------
#
# Project created by QtCreator 2011-09-22T00:45:51
#
#-------------------------------------------------

QT       += core

QT       -= gui

TARGET = spinpossible
CONFIG   += console
CONFIG   -= app_bundle

CONFIG(release, debug|release):QMAKE_CXXFLAGS_RELEASE += -O3

TEMPLATE = app


SOURCES += main.cpp
