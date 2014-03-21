import QtQuick 2.0
import Ubuntu.Components 0.1

Rectangle {
    width: parent.width
    
    ListModel {
        id: contactModel
    }
    Component {
        id: contactDelegate
        Item {
            width: 180; height: 40
            Column {
                Text { text: '<b>Name:</b> ' + name }
                Text { text: '<b>server:</b> ' + url }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
		    rootStack.push(threadPage)
		    threadLabel = name
		    threadListView.getListByURL(url)
                }
            }
        }
    }

    ListView {
        anchors.fill: parent
        model: contactModel
        delegate: contactDelegate
//        highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
//        focus: true
    }

    function getListByURL(url) {
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            contactModel.clear()
            if (doc.readyState == XMLHttpRequest.DONE) {
                doc.responseText.split("\n").forEach(
		    function(line) {
            if (line.match(/(http:\/\/.+\.2ch\.net\/.+)\/>(.+)</)) {
                contactModel.append({url: RegExp.$1,
                         name: RegExp.$2})
			}
		    });
            }
        }
        doc.open("get", url);
        doc.setRequestHeader("Content-Encoding", "UTF-8");
        doc.send();
    }
}
