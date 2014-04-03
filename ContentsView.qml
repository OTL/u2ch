import QtQuick 2.0
import Ubuntu.Components.ListItems 0.1  as ListItem

Rectangle {
    width: parent.width
    property string currentThreadUrl
    property string currentThreadName

    ListModel {
        id: contentsModel
    }

    Component {
        id: contentsDelegate
        ListItem.Standard {
            width: parent.width
            height: (FontUtils.sizeToPixels('medium') + 2) * (lines + 2)
            Column {
                Text {
                    id: nameText
                    width: parent.width
                    text: number + ': <b>' + name + '</b>' + date
                    font.family: webFont.name
                    font.pixelSize: FontUtils.sizeToPixels('medium')
                    wrapMode: Text.WrapAnywhere
                }
                Text {
                    anchors.top: nameText.bottom
                    width: parent.width
                    text: contentsText
                    font.family: webFont.name
                    font.pixelSize: FontUtils.sizeToPixels('medium')
                    wrapMode: Text.WrapAnywhere
                }
            }
//            MouseArea {
//                anchors.fill: parent
//                onClicked: {
//                    console.log(name)
//                }
//            }
        }
    }

    function positionViewAtBeginning() {
        contentsViewListView.positionViewAtBeginning();
    }
    
    function positionViewAtEnd() {
        contentsViewListView.positionViewAtEnd();
    }

    function positionViewAtIndex(x) {
        contentsViewListView.positionViewAtIndex(x, ListView.Beginning);
    }

    function getCount() {
        return contentsViewListView.count;
    }
    ListView {
        id: contentsViewListView
        clip: true
        anchors.fill: parent
        model: contentsModel
        delegate: contentsDelegate
        //highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
        //focus: true
    }

    function getListByURL(url) {
        contentsActivity.running = true;
        var doc = new XMLHttpRequest();
        contentsModel.clear();
        doc.onreadystatechange = function() {

            if (doc.readyState == XMLHttpRequest.DONE) {
                doc.responseText.split("\n").forEach(
                    function(line) {
                        var contentsMatch = line.match(/<dt>(\d+) .+<b>(.+)<\/b><\/font>(.+)<dd>(.*)/);
                        if (contentsMatch) {
                            contentsModel.append(
                                {number: contentsMatch[1],
                                 name: contentsMatch[2],
                                 mail: '',
                                 date: contentsMatch[3],
                                 contentsText: contentsMatch[4],
                                 lines: line.split('<br>').length});
                        }

                        var titleMatch = line.match(/<title>(.*)<\/title>/);
                        if (titleMatch) {
                            contentsLabel.text = titleMatch[1];
                        }
                    });
                contentsActivity.running = false;
            }
        }

        doc.open("get", url)
        doc.send();
    }

}
