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
		    var urlMatch = url.match(/(.+\.2ch\.net)\/(.+)/);
		    contentsView.getListByURL(urlMatch[1] + '/test/read.cgi/' + urlMatch[2] + '/' + dat)
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
			var threadMatch = line.match(/<a href=\"(\d+)\/l50\">\d+: (.+)<\/a>/);
			if (threadMatch) {
			    threadModel.append({url: url,
						dat: threadMatch[1],
						name: threadMatch[2]})
			}
		    });
	    }
	}
	doc.open("get", url + '/subback.html')
	doc.send()
    }

}