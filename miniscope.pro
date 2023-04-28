QT += qml quick widgets
CONFIG += c++11

QT += 3dcore

DEFINES += QT_DEPRECATED_WARNINGS

#DEFINES += DEBUG
DEFINES += USE_PYTHON

#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        src/backend.cpp \
        src/behaviorcam.cpp \
        src/behaviortracker.cpp \
        src/behaviortrackerworker.cpp \
        src/controlpanel.cpp \
        src/datasaver.cpp \
        src/main.cpp \
        src/miniscope.cpp \
        src/newquickview.cpp \
        src/tracedisplay.cpp \
        src/videodevice.cpp \
        src/videodisplay.cpp \
        src/videostreamocv.cpp

RESOURCES += resources/qml.qrc

# Additional import path used to resolve QML modules in Qt Creator code model
#QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
#QML_DESIGNER_IMPORT_PATH =

# Add Icon
RC_ICONS = resources/miniscope_icon.ico

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    include/backend.h \
    include/behaviorcam.h \
    include/behaviortracker.h \
    include/behaviortrackerworker.h \
    include/controlpanel.h \
    include/datasaver.h \
    include/miniscope.h \
    include/newquickview.h \
    include/tracedisplay.h \
    include/videodevice.h \
    include/videodisplay.h \
    include/videostreamocv.h

INCPATH += "include"

DISTFILES += \
    scripts/DLCwrapper.py \
    config/behaviorCams.json \
    config/miniscopes.json \
    config/userConfigProps.json \
    config/videoDevices.json

# For Python
INCLUDEPATH += /usr/include/python3.10/
LIBS += -L/usr/lib -lpython3.10


# For numpy
INCLUDEPATH += /usr/lib/python3.10/site-packages/numpy/core/include

LIBS += -L/usr/local/opencv/lib -lopencv_calib3d  -lopencv_core -lopencv_imgcodecs -lopencv_highgui -lopencv_features2d -lopencv_imgproc -lopencv_video -lopencv_videoio 
INCLUDEPATH += /usr/local/opencv/include/opencv4

# Move user and device configs to build directory
copydata.commands = $(COPY_DIR) "$$shell_path($$PWD/config)" "$$shell_path($$OUT_PWD/config)"
copydata2.commands = $(COPY_DIR) "$$shell_path($$PWD/userconfig)/" "$$shell_path($$OUT_PWD/userconfig)"
copydata3.commands = $(COPY_DIR) "$$shell_path($$PWD/scripts)" "$$shell_path($$OUT_PWD/scripts)"
first.depends = $(first) copydata copydata2 copydata3
export(first.depends)
export(copydata.commands)
export(copydata2.commands)
export(copydata3.commands)

QMAKE_EXTRA_TARGETS += first copydata copydata2 copydata3
