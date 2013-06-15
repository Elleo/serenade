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


class Artist(QtCore.QObject):


	def __init__(self, name, image):
		self.name = name
		self.image = image


class ArtistModel(QtCore.QAbstractListModel):


	NAME_ROLE = QtCore.Qt.UserRole + 1
	IMAGE_ROLE = QtCore.Qt.UserRole + 2


	def __init__(self, parent=None):
		super(ArtistModel, self).__init__(parent)
		self._data = []
		keys = {}
		keys[ArtistModel.NAME_ROLE] = 'name'
		keys[ArtistModel.IMAGE_ROLE] = 'image'
		self.setRoleNames(keys)


	def rowCount(self, index):
		return len(self._data)


	def data(self, index, role):
		aritst = self._data[index.row()]

		if role == ArtistModel.NAME_ROLE:
			return aritst.name
		elif role == ArtistModel.IMAGE_ROLE:
			return aritst.image
		else:
			return None


	def sort(self):
		self.beginRemoveRows(QtCore.QModelIndex(), 0, len(self._data))
		self.endRemoveRows()
		self.beginInsertRows(QtCore.QModelIndex(), 0, len(self._data))
		self._data = sorted(self._data, key=lambda x: x.name)
		self.endInsertRows()
			

	def add(self, aritst):
		self.beginInsertRows(QtCore.QModelIndex(), 0, 0) #notify view about upcoming change        
		self._data.insert(0, aritst)
		self.endInsertRows() #notify view that change happened


	def addToEnd(self, aritst):
		count = len(self._data)
		self.beginInsertRows(QtCore.QModelIndex(), count, count)
		self._data.insert(count, aritst)
		self.endInsertRows()


	def getIndex(self, aritstid):
		for aritst in self._data:
			if aritst.aritstid == aritstid:
				return self._data.index(aritst)

		return None


	def setData(self, index, value, role):
		# dataChanged signal isn't obeyed by ListView (QTBUG-13664)
		# so work around it by removing then re-adding rows
		self.beginRemoveRows(QtCore.QModelIndex(), index, index)
		aritst = self._data.pop(index)
		self.endRemoveRows()
		self.beginInsertRows(QtCore.QModelIndex(), index, index)
		if role == ArtistModel.NAME_ROLE:
			artist.name = value
		self._data.insert(index, status)
		self.endInsertRows()
