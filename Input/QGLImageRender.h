/*
 * QGLImageRender.h
 *
 *  Created on: 28 févr. 2011
 *	  Author: davidroussel
 */

#ifndef QGLIMAGERENDER_H_
#define QGLIMAGERENDER_H_

#include <QGLWidget>
#include <QSize>
#include <QSizePolicy>
#include <opencv/cv.h>

using namespace cv;

/**
 * A Class allowing to draw OpenCV Mat images using OpenGL
 */
class QGLImageRender: public QGLWidget
{
	private:
		/**
		 * The RGB image to draw
		 */
		Mat image;

//		size_t fCount;

	public:
		/**
		 * QGLImageRender Constructor
		 * @param image the RGB image to draw in the pixel buffer
		 * @param parent the parent widget
		 */
		QGLImageRender(const Mat & image, QWidget *parent = NULL);

		/**
		 * QGLImageRender destructor
		 */
		virtual ~QGLImageRender();

		/**
		 * Size hint
		 * @return Qsize containing size hint
		 */
		QSize sizeHint () const;

		/**
		 * Minimum Size hint
		 * @return QSize containing the minimum size hint
		 */
		QSize minimumSizeHint() const;

		/**
		 * Size Policy for this widget
		 * @return A No resize at all policy
		 */
		QSizePolicy	sizePolicy () const;

	protected :
		/**
		 * Initialise GL drawing (called once on each QGLContext)
		 */
		void initializeGL();
		/**
		 * Paint GL : called whenever the widget needs to be painted
		 */
		void paintGL();
		/**
		 * Resize GL : called whenever the widget has been resized
		 */
		void resizeGL(int width, int height);
};

#endif /* QGLIMAGERENDER_H_ */
