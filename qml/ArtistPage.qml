import QtQuick 1.1;
import com.nokia.meego 1.0;

Page {
	id: artistPage;
	anchors.margins: rootWin.pageMargin;
	tools: commonTools;

	ListView {
		id: artistView
		height: parent.height;
		width: parent.width;
		spacing: 10;
		model: artistModel;
		delegate: artistDelegate;
		cacheBuffer: 100;
	}

	Component {
		id: artistDelegate;

		Item {
			height: artistDelegateImage.height;
			width: artistView.width;

			Image {
				id: artistDelegateImage;
				anchors.left: parent.left;
				smooth: true;
				source: model.image;
				height: 100;
				width: 100;
			}

			Label {
				id: artistDelegateName;
				width: parent.width - artistDelegateImage.width - 20 - 32; 
				font.bold: false;
				font.pixelSize: 24;
				anchors.left: artistDelegateImage.right;
				anchors.leftMargin: 16;
				anchors.verticalCenter: artistDelegateImage.verticalCenter;
				text: model.name;
			}

			MouseArea {
				anchors.fill: parent;
				z: -1;
				onClicked: {
					rootWin.artist = model.name;
					rootWin.openFile("SongPage.qml");
					rootWin.showBack();
				}
			}

		}

	}

}
