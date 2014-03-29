import QtQuick 2.0
import Ubuntu.Components.ListItems 0.1  as ListItem

Rectangle {
    width: parent.width

    ListModel {
	id: threadModel
    }

    Component {
	id: threadDelegate
	ListItem.Standard {
            width: parent.width
	    height: units.gu(3)
	    progression: true
            Column {
		Text { text: name
		       font.family: webFont.name
		       font.pixelSize: FontUtils.sizeToPixels('medium')
		     }
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
	delegate: threadDelegate
    }

    function getListByURL(url) {
	var doc = new XMLHttpRequest();
	doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
		threadModel.clear()
		doc.responseText.split("\n").forEach(
		    function(line) {
			var threadMatch = line.match(/(.+)<>(.+)/);
			if (threadMatch) {
			    threadModel.append({url: url,
						dat: threadMatch[1],
						name: threadMatch[2]})
			}
		    });
	    }
	}
	var server_url = 'http://smilerobotics.com:25252/utf/'
	doc.open("get", server_url + url + '/subject.txt')
	console.log(server_url + url + '/subject.txt')
	doc.setRequestHeader("Content-Encoding", "UTF-8");
	doc.send()
    }

}