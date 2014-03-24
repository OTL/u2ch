import QtQuick 2.0
import Ubuntu.Components.ListItems 0.1  as ListItem

Rectangle {
    width: parent.width

    ListModel {
	id: contentsModel
    }

    Component {
	id: contentsDelegate
    ListItem.Standard {
            width: parent.width; height: units.gu(3) * (lines + 1)

            Column {
		Text { text: '<b>' + name + '</b>:' + date
		       font.family: webFont.name
		       font.pointSize: units.gu(1)
		     }
		Text { text: text
		       font.family: webFont.name
		       font.pointSize: units.gu(3)}
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
	delegate: contentsDelegate
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
                        console.log(line)
			if (line.match(/^(.*)<>(.*)<>(.*)<>(.*)/)) {
			    contentsModel.append({name: RegExp.$1,
						  mail: RegExp.$2,
						  date: RegExp.$3,
                          text: RegExp.$4,
                          lines: line.split('<br>').length});
			}
		    });
            }
	}

	var server_url = 'http://smilerobotics.com:25252/utf/'
	doc.open("get", server_url + url)
	doc.setRequestHeader("Content-Encoding", "UTF-8");
	doc.send();
    }

}
