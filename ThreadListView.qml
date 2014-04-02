import QtQuick 2.0
import Ubuntu.Components.ListItems 0.1  as ListItem

Rectangle {
    width: parent.width
    property string currentBoardUrl
    property string currentBoardName
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
                Text {
                    text: name
                    font.family: webFont.name
                    font.pixelSize: FontUtils.sizeToPixels('medium')
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    rootStack.push(contentsPage);
                    contentsView.currentThreadName = name;
                    contentsView.currentThreadUrl = url;
                    contentsLabel.text = name;
                    contentsView.getListByURL(url);
                }
            }
        }
    }

    ListView {
        clip: true
        anchors.fill: parent
        model: threadModel
        delegate: threadDelegate
    }



    function getListByURL(url) {
        threadActivity.running = true;
        var doc = new XMLHttpRequest();
        threadModel.clear()
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.DONE) {
                doc.responseText.split("\n").forEach(
                    function(line) {
                        var threadMatch = line.match(/<a href=\"(\d+)\/l50\">\d+: (.+)<\/a>/);
                        if (threadMatch) {
                            var urlMatch = url.match(/(.+\.2ch\.net)\/(.+)/);
                            var machiMatch = url.match(/(.+\.machi\.to)\/(.+)/);
                            if (urlMatch) {
                                var wholeUrl = urlMatch[1] + '/test/read.cgi/' + urlMatch[2] + '/' + threadMatch[1];
                                threadModel.append({url: wholeUrl,
                                                    originalUrl: url,
                                                    dat: threadMatch[1],
                                                    name: threadMatch[2]})
                            } else if (machiMatch) {
                                var wholeUrl = machiMatch[1] + '/bbs/read.cgi/' + machiMatch[2] + '/' + threadMatch[1];
                                threadModel.append({url: wholeUrl,
                                                    originalUrl: url,
                                                    dat: threadMatch[1],
                                                    name: threadMatch[2]})
                            }
                        }
                    });
                threadActivity.running = false
            }
        }
        doc.open("get", url + '/subback.html')
        doc.send()
    }

}
