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

from PySide import QtCore


class Song(QtCore.QObject):


	def __init__(self, songid, title, album, artist, download, image):
		self.songid = songid
		self.title = title
		self.album = album
		self.artist = artist
		self.download = download
		self.image = image


class SongModel(QtCore.QAbstractListModel):


	SONGID_ROLE = QtCore.Qt.UserRole + 1
	TITLE_ROLE = QtCore.Qt.UserRole + 2
	ALBUM_ROLE = QtCore.Qt.UserRole + 3
	ARTIST_ROLE = QtCore.Qt.UserRole + 4
	DOWNLOAD_ROLE = QtCore.Qt.UserRole + 5
	IMAGE_ROLE = QtCore.Qt.UserRole + 6


	def __init__(self, parent=None):
		super(SongModel, self).__init__(parent)
		self._data = []
		keys = {}
		keys[SongModel.SONGID_ROLE] = 'songid'
		keys[SongModel.TITLE_ROLE] = 'title'
		keys[SongModel.ALBUM_ROLE] = 'album'
		keys[SongModel.ARTIST_ROLE] = 'artist'
		keys[SongModel.DOWNLOAD_ROLE] = 'download'
		keys[SongModel.IMAGE_ROLE] = 'image'
		self.setRoleNames(keys)


	def rowCount(self, index):
		return len(self._data)


	def data(self, index, role):
		song = self._data[index.row()]

		if role == SongModel.SONGID_ROLE:
			return song.songid
		elif role == SongModel.TITLE_ROLE:
			return song.title
		elif role == SongModel.ALBUM_ROLE:
			return song.album
		elif role == SongModel.ARTIST_ROLE:
			return song.artist
		elif role == SongModel.DOWNLOAD_ROLE:
			return song.download
		elif role == SongModel.IMAGE_ROLE:
			return song.image
		else:
			return None


	def add(self, song):
		self.beginInsertRows(QtCore.QModelIndex(), 0, 0) #notify view about upcoming change        
		self._data.insert(0, song)
		self.endInsertRows() #notify view that change happened


	def addToEnd(self, song):
		count = len(self._data)
		self.beginInsertRows(QtCore.QModelIndex(), count, count)
		self._data.insert(count, song)
		self.endInsertRows()


	def getIndex(self, songid):
		for song in self._data:
			if song.songid == songid:
				return self._data.index(song)

		return None


	def setData(self, index, value, role):
		# dataChanged signal isn't obeyed by ListView (QTBUG-13664)
		# so work around it by removing then re-adding rows
		self.beginRemoveRows(QtCore.QModelIndex(), index, index)
		song = self._data.pop(index)
		self.endRemoveRows()
		self.beginInsertRows(QtCore.QModelIndex(), index, index)
		if role == SongModel.TITLE_ROLE:
			song.title = value
		self._data.insert(index, status)
		self.endInsertRows()
