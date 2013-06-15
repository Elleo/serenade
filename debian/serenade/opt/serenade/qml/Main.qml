import QtQuick 1.1;
import Qt 4.7
import com.nokia.meego 1.0;

PageStackWindow {
	id: rootWin;
	property int pageMargin: 16;
	property bool showFetch: true;
	property int currentStatus: -1;
	property bool currentStatusFavourite: false;
	property bool currentStatusFollowing: false;
	property bool inPortrait: true;
	property int currentUserId: -1;
	property int songPosition: 0;
	property string currentUsername;
	property string artist;
	property string song;
	property string albumArt: "/opt/serenade/no-art.png";

	Component.onCompleted: {
		theme.inverted = true;
	}

	signal back();
	signal refresh();
	signal newLogin(string email, string password);
	signal play(string id);
	signal next();
	signal prev();
	signal togglePause();

	function showMessage(title, message) {
		messageDialog.titleText = title;
		messageDialog.message = message;
		messageDialog.open();
	}

	function startWorking() {
		indicator.running = true;
		indicator.visible = true;
	}

	function stopWorking() {
		indicator.running = false;
		indicator.visible = false;
	}
	
	function setPosition(pos) {
		songPosition = pos;
	}

	function showBack() {
		backIcon.visible = true;
	}

	function hideBack() {
		backIcon.visible = false;
	}

	function openFile(file) {
		var component = Qt.createComponent(file);
		if (component.status == Component.Ready) {
			pageStack.push(component);
		} else {
			console.log("Error loading component:", component.errorString());
		}
	}

	Menu {
		id: toolMenu
		content: MenuLayout {

			MenuItem {
				text: "Refresh"
				onClicked: rootWin.refresh();
			}

			MenuItem {
				text: "About"
				onClicked: rootWin.showMessage("Serenade", "Author: Mike Sheldon (elleo@gnu.org)\n\nLicense: GPL 3.0 or later")
			}

			MenuItem {
				text: "Privacy Policy"
				onClicked: rootWin.showMessage("Privacy Policy", "This application stores information required for authenticating with Google services. This information is only ever transmitted to Google and is sent via SSL (a secure communications mechanism).");
			}
		}
	}

	ToolBarLayout {
		id: commonTools;
		visible: true;

		Image {
			id: menuIcon
			anchors.right: parent.right;
			anchors.rightMargin: 10;
			height: status.height;
			fillMode: Image.PreserveAspectFit;
			smooth: true;
			source: "image://theme/icon-m-toolbar-view-menu-white";
			MouseArea {
				anchors.fill: parent;
				onClicked: toolMenu.open();
			}
		}
			
		Image {
			id: backIcon
			height: status.height;
			width: menuIcon.width;
			fillMode: Image.PreserveAspectFit;
			anchors.left: parent.left;
			anchors.leftMargin: 10;
			anchors.verticalCenter: parent.verticalCenter;
			smooth: true;
			visible: false;
			source: "image://theme/icon-m-toolbar-back-white";
			MouseArea {
				anchors.fill: parent;
				onClicked: {
					pageStack.pop();
					if(pageStack.depth == 1) {
						rootWin.hideBack();
					}
				}
			}
		}
	
		BusyIndicator {
			id: indicator
			platformStyle: BusyIndicatorStyle { size: "small" }
			running: false;
			visible: false;
			anchors.centerIn: parent;
		}


	}


	QueryDialog {
		id: messageDialog;
		acceptButtonText: "Okay";
	}
}
