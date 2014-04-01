import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1  as ListItem

import QtQuick.LocalStorage 2.0
import "scripts.js" as U2chjs

Rectangle {
    width: parent.width

    ListModel {
        id: favoriteBoardModel
    }
    
    Component {
        id: favoriteBoardDelegate
        ListItem.Standard {
            width: parent.width
            height: units.gu(4)
            removable: true
            confirmRemoval: true
            backgroundIndicator: Rectangle {
                anchors.fill: parent
                color: Theme.palette.normal.base
            }
            
            onItemRemoved: {
                U2chjs.removeBoardFromFavorite(title, url);
            }
            Column {
                Text {
                    id: favoriteBoardText
                    text: title
                    font.family: webFont.name
                    font.pixelSize: FontUtils.sizeToPixels('medium')
                }
            }
           MouseArea {
               anchors.left: parent.left
               anchors.top: parent.top
               width: parent.width / 2
               height: parent.height
               onClicked: {
                   rootStack.push(threadPage);
                   threadListView.getListByURL(url);
                   threadLabel.text = title;
                   threadListView.currentBoardName = title
                   threadListView.currentBoardUrl = url
                   rootTabs.selectedTabIndex = 0
               }
           }
        }
    }

    ListView {
        clip: true
        anchors.fill: parent
        model: favoriteBoardModel
        delegate: favoriteBoardDelegate
    }

    function setBoardList(boards) {
        favoriteBoardModel.clear();
        boards.forEach(function(board) {
                           console.log("add " + board.title);
                           favoriteBoardModel.append(board);
                           });
    }
}
