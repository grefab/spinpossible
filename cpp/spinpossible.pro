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

CONFIG(release, debug|release):QMAKE_CXXFLAGS_RELEASE += -O3 -funroll-loops

TEMPLATE = app


SOURCES += main.cpp \
    grid.cpp \
    spin.cpp \
    tile.cpp \
    solver.cpp \
    solver_dfs.cpp \
#    solver_bfs_mt.cpp \
#    solver_bfs.cpp \
#    solver_dfs_random.cpp

HEADERS += \
    grid.h \
    spin.h \
    tile.h \
    solver.h \
    solver_dfs.h \
 #   solver_bfs_mt.h \
 #   solver_bfs.h \
 #   solver_dfs_random.h
    external/qjson/src/serializer.h \
    external/qjson/src/parser.h \
    external/qjson/src/json_scanner.h \
    external/qjson/src/json_parser.hh

















