import QtQuick 1.1;
import com.nokia.meego 1.0;

Page {
	id: musicPage;
	anchors.margins: rootWin.pageMargin;
	tools: commonTools;

	ListModel {
		id: menuModel;
		ListElement {
			title: "Artists";
			page: "ArtistPage.qml";
		}
		ListElement {
			title: "All albums";
			page: "AlbumPage.qml";
		}
		ListElement {
			title: "All songs";
			page: "SongPage.qml";
		}
		ListElement {
			title: "Playlists";
			page: "PlaylistPage.qml";
		}
	}

	ListView {
		id: menuView
		height: parent.height;
		width: parent.width;
		spacing: 10;
		model: menuModel;
		delegate: menuDelegate;
		cacheBuffer: 5;
	}

	Component {
		id: menuDelegate;

		Item {
			height: menuDelegateTitle.height * 2;
			width: menuView.width;

			Label {
				id: menuDelegateTitle;
				width: parent.width - 20 - 32; 
				font.bold: true;
				font.pixelSize: 48;
				anchors.left: parent.left;
				anchors.leftMargin: 16;
				text: model.title;
			}

			Label {
				anchors.left: menuDelegateTitle.right;
				text: ">";	
				font.bold: true;
				font.pixelSize: 48;
			}

			MouseArea {
				anchors.fill: parent;
				z: -1;
				onClicked: {
					rootWin.openFile(model.page)
					rootWin.showBack();
				}
			}

		}

	}

	Menu {
		id: songMenu
		anchors.bottomMargin: commonTools.height;
		content: MenuLayout {

			MenuItem {
				text: "Download this song"
				onClicked: rootWin.repeat(rootWin.currentStatus);
			}

		}
	}

}
