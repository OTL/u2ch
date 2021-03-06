import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1  as ListItem

Rectangle {
    width: parent.width
    
    ListModel {
        id: categoryModel
    }

    Component {
        id: categoryDelegate
        ListItem.Standard {
            width: parent.width; height: units.gu(3)
            progression: true

            Column {
                Text {
                    text: name
                    font.family: webFont.name
                    font.pixelSize: FontUtils.sizeToPixels('medium')
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    boardView.setBoardList(boards);
                    boardLabel.text = name;
                    rootStack.push(boardPage);
                }
            }
        }
    }

    ListView {
        clip: true
        anchors.fill: parent
        model: categoryModel
        delegate: categoryDelegate
        width: parent.width; height: units.gu(3)
        Text {
            text: text
            font.family: webFont.name
            font.pixelSize: FontUtils.sizeToPixels('medium')
        }
    }

    function getListByURL(url) {
        var req = new XMLHttpRequest();
        categoryActivity.running = true
        req.onreadystatechange = function() {
            categoryModel.clear()
            if (req.readyState == XMLHttpRequest.DONE) {
                var categoryName = '';
                var boards = []
                req.responseText.split("\n").forEach(
                    function(line) {
                        var urlExp = /(http:\/\/.+\.2ch\.net\/.+)\/>(.+)<\/A>/;
                        var machiExp = /(http:\/\/.+\.machi\.to\/.+)\/.*>(.+)<\/A>/;
                        var categoryExp = /<BR><BR><B>(.+)<\/B><BR>/;
                        var urlMatch = line.match(urlExp);
                        var machiMatch = line.match(machiExp);
                        var categoryMatch = line.match(categoryExp);
                        if (urlMatch) {
                            boards.push(
                                {
                                    url: urlMatch[1],
                                    name: urlMatch[2],
                                    category: categoryName
                                });
                        } else if (machiMatch) {
                            boards.push(
                                {
                                    url: machiMatch[1],
                                    name: machiMatch[2],
                                    category: categoryName
                                });
                        } else if (categoryMatch) {
                            if (categoryName != '') {
                                categoryModel.append(
                                    {
                                        name: categoryName,
                                        boards: boards
                                    });
                            }
                            categoryName = categoryMatch[1];
                            boards = [];
                        }
                    });
                categoryActivity.running = false
            }
        }
        
        req.open("get", url);
        req.send();
    }
}
