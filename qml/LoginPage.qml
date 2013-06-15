import QtQuick 1.1;
import com.nokia.meego 1.0;

Page {
	id: customLoginPage;
	anchors.margins: rootWin.pageMargin;
	tools: commonTools;

	Component.onCompleted: {
		email.text = rootWin.email;
		password.text = rootWin.password;
	}

	Column {
		spacing: 40;
		anchors.centerIn: parent;
		width: 440;

		Label {
			text: "Log in using your Google account"
			width: parent.width;
		}

		TextField {
			id: email;
			width: parent.width;
			height: 48;
			placeholderText: "E-mail Address";
		}

		TextField {
			id: password;
			width: parent.width;
			height: 48;
			echoMode: TextInput.PasswordEchoOnEdit;
			placeholderText: "Password";
		}

		Button {
			id: loginButton;
			text: "Login";
			width: parent.width;
			onClicked: {
				rootWin.newLogin(email.text, password.text);
			}
		}
	}
}
