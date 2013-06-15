import QtQuick 1.1;
import com.nokia.meego 1.0;

Page {
	id: songPage;
	anchors.margins: rootWin.pageMargin;
	tools: commonTools;

	ListView {
		id: songView
		height: parent.height;
		width: parent.width;
		spacing: 10;
		model: songModel;
		delegate: songDelegate;
		cacheBuffer: 100;
	}

	Component {
		id: songDelegate;

		Item {
			height: songDelegateTitle.height + songDelegateAlbum.height + songDelegateArtist.height;
			width: songView.width;

			Image {
				id: songDelegateImage;
				anchors.left: parent.left;
				smooth: true;
				source: model.image;
				height: 48;
				width: 48;
			}

			Label {
				id: songDelegateTitle;
				width: parent.width - songDelegateImage.width - 20 - 32; 
				font.bold: true;
				font.pixelSize: 20;
				anchors.top: songDelegateImage.top;
				anchors.left: songDelegateImage.right;
				anchors.leftMargin: 16;
				text: model.title;
			}


			Label {
				id: songDelegateAlbum;
				width: parent.width - songDelegateImage.width - 20;
				font.pixelSize: 20;
				anchors.top: songDelegateTitle.bottom;
				anchors.left: songDelegateImage.right;
				anchors.leftMargin: 16;
				text: model.album;
			}

			Label {
				id: songDelegateArtist;
				width: parent.width - songDelegateImage.width - 20;
				font.pixelSize: 16;
				color: "#6b6b6b";
				anchors.top: songDelegateAlbum.bottom;
				anchors.left: songDelegateImage.right;
				anchors.leftMargin: 16;
				text: model.artist;
			}

			MouseArea {
				anchors.fill: parent;
				z: -1;
				onClicked: {
					rootWin.artist = model.artist;
					rootWin.song = model.title;
					rootWin.albumArt = model.image;
					rootWin.play(model.songid);
					rootWin.openFile("PlayerPage.qml");
					rootWin.showBack();
				}
				onPressAndHold: {
					rootWin.currentStatus = model.songid;
					rootWin.currentSongId = model.songid;
					songMenu.open();
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
