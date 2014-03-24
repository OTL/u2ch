import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1  as ListItem

Rectangle {
    width: parent.width
    
    ListModel {
        id: contactModel
    }
    Component {
        id: boardDelegate
        ListItem.Standard {
            width: parent.width; height: units.gu(5)
	    progression: true

            Column {
                Text { text: name
		       font.family: webFont.name
		       font.pointSize: units.gu(3)
		     }
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
        delegate: boardDelegate
    }

    function getListByURL(url) {
        var req = new XMLHttpRequest();
        req.onreadystatechange = function() {
            contactModel.clear()
            if (req.readyState == XMLHttpRequest.DONE) {
		req.responseText.split("\n").forEach(
		    function(line) {
			if (line.match(/(http:\/\/.+\.2ch\.net\/.+)\/>(.+)<\//)) {
			    contactModel.append({url: RegExp.$1,
						 name: RegExp.$2})
			}
		    });
            }
        }

	req.open("get", url);
	req.setRequestHeader("Content-Encoding", "UTF-8");
	req.send();
    }
}
