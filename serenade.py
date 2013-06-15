#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright (C) 2012 Mike Sheldon <elleo@gnu.org>
# 
# This program is free software: you can redistribute it and/or modify 
# it under the terms of the GNU General Public License as published by 
# the Free Software Foundation, either version 3 of the License, or 
# (at your option) any later version. 
# 
# This program is distributed in the hope that it will be useful, 
# but WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
# GNU General Public License for more details. 
# 
# You should have received a copy of the GNU General Public License 
# along with this program. If not, see <http://www.gnu.org/licenses/>.

from PySide import QtCore, QtGui, QtDeclarative
from QtMobility import MultimediaKit
from gmusicapi.api import Api
from artistmodel import *
from songmodel import *
import sys, datetime, os, os.path, urllib2, gconf, signal, threading


class Signals(QtCore.QObject):


	onDoneWorking = QtCore.Signal()
	onError = QtCore.Signal(str, str)


	def __init__(self, parent=None):
		super(Signals, self).__init__(parent)


class Serenade():


	def __init__(self):
		self.app = QtGui.QApplication(sys.argv)
		self.app.setApplicationName("Serenade")
		signal.signal(signal.SIGINT, signal.SIG_DFL)

		self.position = 0

		self.player = MultimediaKit.QMediaPlayer(self.app)
		self.player.positionChanged.connect(self.positionChanged)

		self.signals = Signals()

		self.client = gconf.client_get_default()

		self.api = Api()
		self.artists = []
		self.library = {}

		self.cacheDir = QtGui.QDesktopServices.storageLocation(QtGui.QDesktopServices.CacheLocation)
		if not os.path.exists(self.cacheDir):
			os.mkdir(self.cacheDir)
		self.artistModel = ArtistModel()
		self.songModel = SongModel()
		self.signals.onDoneWorking.connect(self.doneWorking)
		self.signals.onError.connect(self.error)
		self.view = QtDeclarative.QDeclarativeView()
		self.view.setSource("/opt/serenade/qml/Main.qml")
		self.rootObject = self.view.rootObject()
		self.context = self.view.rootContext()
		self.context.setContextProperty('songModel', self.songModel)
		self.context.setContextProperty('artistModel', self.artistModel)
		self.rootObject.openFile("MenuPage.qml")
		self.rootObject.refresh.connect(self.updateSongs)
		self.rootObject.newLogin.connect(self.newLogin)
		self.rootObject.play.connect(self.play)
		self.rootObject.togglePause.connect(self.togglePause)
		self.login()
		self.view.showFullScreen()

		sys.exit(self.app.exec_())


	def login(self):
		email = self.client.get_string('/apps/serenade/email')
		passwd = self.client.get_string('/apps/serenade/passwd')
		if not email or not passwd:
			self.rootObject.openFile("LoginPage.qml")
		else:
			logged_in = self.api.login(email, passwd)
			if not logged_in:
				self.rootObject.openFile("LoginPage.qml")
				self.rootObject.showMessage("Login failed", "Please check your email and password and try again. If you're using two-factor authentication you may need to set an application specific password in your Google account.")
			else:
				self.rootObject.openFile("MenuPage.qml")
				self.updateSongs()

	
	def newLogin(self, email, passwd):
		self.client.set_string('/apps/serenade/email', email)
		self.client.set_string('/apps/serenade/passwd', passwd)
		self.login()


	def updateSongs(self):
		self.rootObject.startWorking()
		thread = threading.Thread(target=self._updateSongs)
		thread.start()


	def _updateSongs(self):
		self.library = sorted(self.api.get_all_songs(), key=lambda x: x['title'])
		self.library.reverse()
		for s in self.library:
			if "albumArtUrl" in s:
				art = self.getImage(s['albumArtUrl'])
			else:
				art = "/opt/serenade/no-art.png"
			if s['artist'] not in self.artists:
				artist = Artist(s['artist'], art)
				self.artists.append(s['artist'])
				self.artistModel.add(artist)
			song = Song(s['id'], s['title'], s['album'], s['artist'], False, art)
			self.songModel.add(song)
		self.artistModel.sort()
		self.signals.onDoneWorking.emit()


	def doneWorking(self):
		self.rootObject.stopWorking()


	def error(self, title, message):
		self.rootObject.showMessage(title, message)


	def getImage(self, url):
		filename = url.split("/")[-1]
		imagePath = os.path.join(self.cacheDir, filename)		
		imagePath = imagePath.replace("?", "")
		if not os.path.exists(imagePath):
			try:   
				out = open(imagePath, 'wb')
				out.write(urllib2.urlopen("http:" + url).read())
				out.close()
			except Exception, err:
				return "/opt/serenade/no-art.png"
		return imagePath
	

	def play(self, songid):
		url = self.api.get_stream_url(songid)
		self.playlist = MultimediaKit.QMediaPlaylist()
		self.playlist.addMedia(MultimediaKit.QMediaContent(QtCore.QUrl(url)))
		self.player.setPlaylist(self.playlist)
		self.player.play()
		print url


	def togglePause(self):
		if self.player.state() == MultimediaKit.QMediaPlayer.PlayingState:
			self.player.pause()
		else:
			self.player.play()


	def positionChanged(self, pos):
		print pos, self.player.duration()
		self.position = pos / float(self.player.duration())
		self.rootObject.setPosition(self.position)
		print self.position


	def openLink(self, link):
		QtGui.QDesktopServices.openUrl(link)


if __name__ == "__main__":
	Serenade()
