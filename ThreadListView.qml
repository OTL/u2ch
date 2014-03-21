import QtQuick 2.0

Rectangle {
    width: parent.width

    ListModel {
	id: threadModel
    }

    Component {
	id: contactDelegate
	Item {
            width: parent.width; height: 40
            Column {
		Text { text: '<b>Name:</b> ' + name }
		Text { text: '<b>dat:</b> ' + dat }
            }
            MouseArea {
		anchors.fill: parent
		onClicked: {
		    rootStack.push(contentsPage)
		    contentsLabel = name
		    contentsView.getListByURL(url + '/dat/' + dat)
		}
            }
	}
    }

    ListView {
	anchors.fill: parent
	model: threadModel
	delegate: contactDelegate
	//highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
	//focus: true
    }

    function getListByURL(url) {
	var doc = new XMLHttpRequest();
	doc.onreadystatechange = function() {
            threadModel.clear()
            if (doc.readyState == XMLHttpRequest.DONE) {
		doc.responseText.split("\n").forEach(
		    function(line) {
			if (line.match(/(.+)<>(.+)/)) {
			    threadModel.append({url: url,
						dat: RegExp.$1,
						name: RegExp.$2})
			}
		    });
            }
	}
	doc.open("get", url + '/subject.txt');
	doc.setRequestHeader("Content-Encoding", "UTF-8");
	doc.send();
    }

}