#include "videostreamocv.h"
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/opencv.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/videoio.hpp>
#include <QDebug>
#include <QAtomicInt>
#include <QCoreApplication>

VideoStreamOCV::VideoStreamOCV(QObject *parent) :
    QObject(parent),
    m_stopStreaming(false)
{

}

VideoStreamOCV::~VideoStreamOCV() {
    qDebug() << "Closing video stream";
    if (cam->isOpened())
        cam->release();
}

void VideoStreamOCV::setCameraID(int cameraID)  {
    m_cameraID = cameraID;
}

void VideoStreamOCV::setBufferParameters(cv::Mat *buf, int bufferSize, QSemaphore *freeFramesS, QSemaphore *usedFramesS, QAtomicInt *acqFrameNum){
    buffer = buf;
    frameBufferSize = bufferSize;
    freeFrames = freeFramesS;
    usedFrames = usedFramesS;
    m_acqFrameNum = acqFrameNum;
}

void VideoStreamOCV::startStream()
{
    int idx = 0;
    cv::Mat frame;
    cam = new cv::VideoCapture;

    m_stopStreaming = false;
    cam->open(m_cameraID);
    if (cam->isOpened()) {
        m_isStreaming = true;
        forever {
            QCoreApplication::processEvents(); // Is there a better way to do this. This is against best practices
            if (m_stopStreaming == true) {
                m_isStreaming = false;
                break;
            }
            cam->grab();
            //            freeFrames->acquire();
            cam->retrieve(frame);
            buffer[idx%frameBufferSize] = frame;
            m_acqFrameNum->operator++();
            idx++;
            usedFrames->release();
        }
        cam->release();
    }
    else {
        qDebug() << "Camera " << m_cameraID << " failed to open.";
    }
}

void VideoStreamOCV::stopSteam()
{
    m_stopStreaming = true;
}

void VideoStreamOCV::setProperty(QString type, double value)
{
    qDebug() << "IN SLOT!!!!! " << type << " is " << value;
}
