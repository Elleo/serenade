TEMPLATE = lib
DEPENDPATH += . 

#install
serenade.path = /opt/serenade/
serenade.files = *.py

gmusicapi.path = /opt/serenade/gmusicapi/
gmusicapi.files = gmusicapi/*

validictory.path = /opt/serenade/validictory/
validictory.files = validictory/*

google.path = /opt/serenade/google/
google.files = google/*

lib.path = /opt/serenade/lib/
lib.files = lib/*

images.path = /opt/serenade/
images.files = *.png

desktop.path = /usr/share/applications/
desktop.files = serenade.desktop

qml.path = /opt/serenade/qml/
qml.files = qml/*

INSTALLS += serenade gmusicapi validictory google lib images desktop qml
