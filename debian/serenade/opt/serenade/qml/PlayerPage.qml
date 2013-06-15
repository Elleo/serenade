import QtQuick 1.1;
import com.nokia.meego 1.0;

Page {
	id: playerPage;
	anchors.margins: rootWin.pageMargin;
	tools: commonTools;

	states: [
		State {
			name: "inLandscape"
			when: !rootWin.inPortrait
			PropertyChanges {
				target: grid_details
				rows: 1
				columns: 2
			}
			PropertyChanges {
				target: col_details
				anchors.verticalCenterOffset: 0
			}
			PropertyChanges {
				target: imgCover
				anchors.horizontalCenterOffset: -250
			}
		},
		State {
			name: "inPortrait"
			when: rootWin.inPortrait
			PropertyChanges {
				target: grid_details
				rows: 2
				columns: 1
			}
			PropertyChanges {
				target: col_details
				anchors.verticalCenterOffset: 100
			}
			PropertyChanges {
				target: imgCover
				anchors.horizontalCenterOffset: 0
			}
		}
	]

	Grid {
		id: grid_details;
		spacing: 50;
		anchors.horizontalCenter: parent.horizontalCenter;
		Image {
			id: imgCover;
			anchors.horizontalCenter: parent.horizontalCenter;
			source: rootWin.albumArt;
			smooth: true;
			height: 200;
			width: 200;
		}

		Column {
			id: col_details;
			spacing: 40;
			anchors.verticalCenter: parent.verticalCenter;
			Column {
				anchors.horizontalCenter: parent.horizontalCenter;
				Label {
					id: lblArtist;
					text: rootWin.artist;
				}
				Label {
					id: lblSpacer;
				}
				Label {
					id: lblTrack;
					text: rootWin.song;
				}
			}

			Slider {
				id: songProgress;
				value: rootWin.songPosition;
			}
		}

	}

	ButtonRow {
		exclusive: false;
		anchors.bottom: parent.bottom;

		Button {
			id: btnPrevious;
			Image {
				anchors.centerIn: parent;
				source: "image://theme/icon-m-toolbar-mediacontrol-previous" + (theme.inverted ? "-white" : "");
			}
			onClicked: {
				rootWin.prev();
			}
		}

		Button {
			id: btnPlay;
			property bool playing: false;
			Image {
				id: imgPlay;
				anchors.centerIn: parent;
				visible: false;
				source: "image://theme/icon-m-toolbar-mediacontrol-play" + (theme.inverted ? "-white" : "");
			}

			Image {
				id: imgPause;
				anchors.centerIn: parent;
				source: "image://theme/icon-m-toolbar-mediacontrol-pause" + (theme.inverted ? "-white" : "");
			}

			onClicked: {
				rootWin.togglePause();
				if (imgPlay.visible) {
					imgPlay.visible = false;
					imgPause.visible = true;
				} else {
					imgPlay.visible = true;
					imgPause.visible = false;
				}
			}

		}

		Button {
			id: btnNext;
			Image {
				anchors.centerIn: parent;
				source: "image://theme/icon-m-toolbar-mediacontrol-next" + (theme.inverted ? "-white" : "");
			}
			onClicked: {
				rootWin.next();
			}
		}

	}	

}
