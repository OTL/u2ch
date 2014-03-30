import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1  as ListItem

Rectangle {
    width: parent.width

    ListModel {
        id: boardModel
    }
    
    Component {
        id: boardDelegate
        ListItem.Standard {
            width: parent.width; height: units.gu(3)
	    progression: true

            Column {
                Text {
		    text: ' ' + name
		    font.family: webFont.name
		    font.pixelSize: FontUtils.sizeToPixels('medium')
		}
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
		    rootStack.push(threadPage);
		    threadListView.getListByURL(url);
		    threadLabel.text = name;
                }
            }
        }
    }

    ListView {
        anchors.fill: parent
        model: boardModel
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

    function setBoardList(boards) {
	boardModel.clear();
	for (var i = 0; i < boards.count; ++i) {
	    boardModel.append(
		{
		    url: boards.get(i).url,
		    name: boards.get(i).name,
		});
	}
    }
}
