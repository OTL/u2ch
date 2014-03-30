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
            width: parent.width
	    height: FontUtils.sizeToPixels('medium') * (lines + 3)
            Column {
		Text {
		    text: '<b>' + name + '</b>:' + date
		    font.family: webFont.name
		    font.pixelSize: FontUtils.sizeToPixels('medium')
		}
		Text {
		    text: contentsText
		    font.family: webFont.name
		    font.pixelSize: FontUtils.sizeToPixels('medium')
		}
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
			var contentsMatch = line.match(/<dt>(\d+) .+<b>(.+)<\/b><\/font>(.+)<dd>(.*)/);
			if (contentsMatch) {
			    contentsModel.append(
				{name: contentsMatch[2],
				 mail: '',
				 date: contentsMatch[3],
				 contentsText: contentsMatch[4],
				 lines: line.split('<br>').length});
			}

			var titleMatch = line.match(/<title>(.*)<\/title>/);
			if (titleMatch) {
			    console.log("set thread title =" + titleMatch[1])
			    contentsLabel.text = titleMatch[1];
			}
		    });
            }
	}

	doc.open("get", url)
	doc.send();
    }

}
