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
            width: parent.width; height: units.gu(3)
	    progression: true

            Column {
                Text { text: ' ' + name
		       font.family: webFont.name
		       font.pixelSize: FontUtils.sizeToPixels('medium')
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
	section.property: "category"
	section.criteria: ViewSection.FullString
	section.delegate: ListItem.Header {
            width: parent.width; height: units.gu(3)
	    Text {
		text: '<b>' + section + '</b>'
		font.family: webFont.name
		font.pixelSize: FontUtils.sizeToPixels('medium')
	    }
	}
    }

    function getListByURL(url) {
        var req = new XMLHttpRequest();
        req.onreadystatechange = function() {
            contactModel.clear()
            if (req.readyState == XMLHttpRequest.DONE) {
                var boardCategory = '';
		req.responseText.split("\n").forEach(
		    function(line) {
			if (line.match(/(http:\/\/.+\.2ch\.net\/.+)\/>(.+)<\//)) {
			    contactModel.append({url: RegExp.$1,
						 name: RegExp.$2,
						 category: boardCategory});
			    threadLabel = RegExp.$2;
			} else if (line.match(/<BR><BR><B>(.+)<\/B><BR>/)) {
			    boardCategory = RegExp.$1
			}
		    });
            }
        }

	req.open("get", url);
	req.setRequestHeader("Content-Encoding", "UTF-8");
	req.send();
    }
}
