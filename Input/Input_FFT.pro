###############################################################################
# QT Project File for OpenCV 2.x and QT Fourier Transform and filter
###############################################################################
# -----------------------------------------------------------------------------
# QT Project Configuration
# -----------------------------------------------------------------------------

TEMPLATE = app
TARGET = Input_FFT
QT += core gui
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets
greaterThan(QT_MAJOR_VERSION, 4): QT += opengl # for QGLWidget
CONFIG += c++11
CONFIG += link_pkgconfig
#PKGCONFIG += opencv
DEPENDPATH += .

INCLUDEPATH += "/usr/local/Cellar/opencv/2.4.11/include"
LIBS += -L/usr/local/Cellar/opencv/2.4.11/lib \
     -lopencv_core \
     -lopencv_imgproc \
     -lopencv_features2d\
     -lopencv_highgui

MODULES = CvProcessor \
	CvProcessorException \
	QcvProcessor \
	CvSimpleDFT \
	QcvSimpleDFT \
	QcvMatWidget \
	QcvMatWidgetLabel \
	QcvMatWidgetImage \
	QcvMatWidgetGL \
	QGLImageRender \
	QcvVideoCapture \
	CaptureFactory \
	mainwindow
for(f, MODULES){
	HEADERS += $${f}.h
	SOURCES += $${f}.cpp
	ALLSOURCES += $${f}.h $${f}.cpp
}

EXTRAHEADERS =
for(f, EXTRAHEADERS){
	HEADERS += $${f}.h
	ALLSOURCES += $${f}.h
}

MAINS = main
for(f, MAINS){
	MAINSOURCES += $${f}.cpp
	SOURCES += $${f}.cpp
	ALLSOURCES += $${f}.cpp
}

FORMS    += mainwindow.ui

OTHER_FILES = \
	$${TARGET}.icns \
	$${TARGET}.ico \
	$${TARGET}.rc \
	Doxyfile

message(Headers: $${HEADERS})
message(Sources: $${SOURCES})

# -----------------------------------------------------------------------------
# Platform specific options
# -----------------------------------------------------------------------------

mac {
	# icon for mac os
	ICON = $${TARGET}.icns
}

win32 {
	# icon for windows
	RC_FILE = $${TARGET}.rc
}

# -----------------------------------------------------------------------------
# Extra tools
# -----------------------------------------------------------------------------
# directories for listings and archives
LISTDIR = listings
ARCHDIR = archives

# Listing tools
A2PS = a2ps
PS2PDF = ps2pdf -sPAPERSIZE=a4
# Documentation tool
DOCTOOL = doxygen
# Year-month-day Date
unix {
	DATE = $$system(date +%Y-%m-%d)
}
win32 {
	DATE = $$system(for /F \"usebackq tokens=1,2,3 delims=/ \" %a in \
	(`date /t`) do @echo %c-%b-%a)
}

# Archive format
unix {
	ARCHIVER = tar
	ARCHOPT = zcvfh
	ARCHEXT = tgz
}
mac {
	ARCHOPT = zcvfH
}
win32 {
	ARCHIVER = zip
	ARCHOPT =
	ARCHEXT = zip
}

# -----------------------------------------------------------------------------
# Extra targets
# -----------------------------------------------------------------------------

# Generate documention from sources -------------------------------------------
doc.target = doc
doc.depends = $${ALLSOURCES}
doc.commands = (cat Doxyfile; echo "INPUT = $?") | $${DOCTOOL} -

# linking .h to .hpp for correct printing highlight needed by a2ps ------------
for(f, HEADERS){
	LINK_ACTION+="ln -fs $${f} $${f}pp; "
	CPPHEADERS+="$${f}pp "
}
links.target = links
links.commands = $$LINK_ACTION
links.depends = $$HEADERS

# unlinking .hpp --------------------------------------------------------------
for(f, HEADERS){
	UNLINK_ACTION+="rm -f $${f}pp; "
}
unlinks.target = unlinks
unlinks.commands = $$UNLINK_ACTION

# Postscript listing generation with A2PS -------------------------------------
listings.target = listings
listings.commands = mkdir $$LISTDIR

for(f, MODULES){
	PRINTSOURCES+= $${f}.hpp $${f}.cpp
}
for(f, EXTRAHEADERS){
	PRINTSOURCES+= $${f}.hpp
}
for(f, MAINS){
	PRINTSOURCES+= $${f}.cpp
}
ps.target = ps
ps.commands = $$A2PS -2 --file-align=fill --line-numbers=1 --font-size=10 \
--chars-per-line=100 --tabsize=4 --pretty-print --highlight-level=heavy \
--prologue="gray" -o $${LISTDIR}/$${TARGET}.ps $${PRINTSOURCES}
ps.depends = links listings

# PDF listing generation from Postscript --------------------------------------
pdf.target = pdf
pdf.commands = $$PS2PDF $${LISTDIR}/$${TARGET}.ps $${LISTDIR}/$${TARGET}.pdf
pdf.depends = ps

# Timestamped archive generation ----------------------------------------------
archives.target = archives
archives.commands = mkdir $$ARCHDIR

archive.target = archive
archive.commands = $$ARCHIVER $$ARCHOPT $${ARCHDIR}/$${TARGET}-$${DATE}.$${ARCHEXT} \
$${ALLSOURCES} $${TARGET}.pro $${LISTDIR}/$${TARGET}.pdf $${FORMS} $${RESOURCES} \
$${OTHER_FILES} $${TRANSLATIONS} $${TRANSLATIONS_RES}
archive.depends = pdf archives

# Cleaning doc, listing and archives ------------------------------------------
myclean.target = myclean
myclean.commands = rm -rf $${LISTDIR}/*~ $${LISTDIR}/$${TARGET}.ps \
$${LISTDIR}/$${TARGET}.pdf doc
myclean.depends = unlinks

# Adding extra clean to regular clean -----------------------------------------
clean.depends = myclean

# Extra targets to be added in the makefile -----------------------------------
QMAKE_EXTRA_TARGETS += doc listings ps pdf archives archive myclean links \
unlinks clean
# adding clean as extra targets when there is already a clean target generated
# by QT just adds a second clean target which is also executed when invoking
# make clean

# -----------------------------------------------------------------------------
# QT Information (comment if not needed)
# -----------------------------------------------------------------------------
# message(Qt version: $$[QT_VERSION])
# message(Qt is installed in $$[QT_INSTALL_PREFIX])
# message(Qt resources can be found in the following locations:)
# message(Documentation: $$[QT_INSTALL_DOCS])
# message(Header files: $$[QT_INSTALL_HEADERS])
# message(Libraries: $$[QT_INSTALL_LIBS])
# message(Binary files (executables): $$[QT_INSTALL_BINS])
# message(Plugins: $$[QT_INSTALL_PLUGINS])
# message(Data files: $$[QT_INSTALL_DATA])
# message(Translation files: $$[QT_INSTALL_TRANSLATIONS])
# message(Settings: $$[QT_INSTALL_SETTINGS])
# message(Examples: $$[QT_INSTALL_EXAMPLES])
# message(Demonstrations: $$[QT_INSTALL_DEMOS])
message(Packages : )
for(f, PKGCONFIG){
	PACKAGE_VERSION =  $$system(pkg-config --modversion $${f})
	PACKAGE_LOCATION = $$system(pkg-config --cflags $${f})
	message($${f} : $${PACKAGE_VERSION} in $${PACKAGE_LOCATION})
}
