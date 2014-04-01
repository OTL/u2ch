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

    ListView {
        clip: true
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
                                {number: contentsMatch[1],
                                 name: contentsMatch[2],
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
