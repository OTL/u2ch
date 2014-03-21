import QtQuick 2.0

Rectangle {
    width: parent.width

    ListModel {
	id: contentsModel
    }

    Component {
	id: contactDelegate
	Item {
            width: parent.width; height: 40
            Column {
		Text { text: '<b>name:</b> ' + name}
		Text { text: '<b>mail:</b> ' + mail}
            }
            MouseArea {
		anchors.fill: parent
		onClicked: {
                    console.log(name)
		}
            }
	}
    }

    ListView {
	anchors.fill: parent
	model: contentsModel
	delegate: contactDelegate
	//highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
	//focus: true
    }

    function getListByURL(url) {
	var doc = new XMLHttpRequest();
	doc.onreadystatechange = function() {
            contentsModel.clear()
            if (doc.readyState == XMLHttpRequest.DONE) {
		doc.responseText.split("\n").forEach(
		    function(line) {
			//			contentsModel.append({data: line})
                        console.log(line)
			if (line.match(/(.*)<>(.*)<>/)) {
			    contentsModel.append({name: RegExp.$1,
						  mail: RegExp.$2})
			}
		    });
            }
	}
	doc.open("get", url);
	doc.setRequestHeader("Content-Encoding", "UTF-8");
	doc.send();
    }

}