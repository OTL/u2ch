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
                U2chjs.removeBoardFromFavorite(title, url, type);
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
                   if (type == 'Board') {
                       rootStack.push(threadPage);
                       threadListView.getListByURL(url);
                       threadLabel.text = title;
                       threadListView.currentBoardName = title
                       threadListView.currentBoardUrl = url
                       rootTabs.selectedTabIndex = 0
                   } else if (type == 'Thread') {
                       rootStack.push(contentsPage);
                       contentsView.getListByURL(url);
                       contentsLabel.text = title;
                       contentsView.currentThreadName = title
                       contentsView.currentThreadUrl = url
                       rootTabs.selectedTabIndex = 0

                   }
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

    function addBoardByTitleAndURL(title, url, type) {
        if (!type) {
            type = 'Board';
        }
        U2chjs.addBoardToFavorite(title, url, type);
        favoriteBoardModel.append({title: title, url: url, type: type});
    }

    function setBoardListFromDB() {
        favoriteBoardModel.clear();
        var boards = U2chjs.getFavoriteBoardList('Board');
        boards.forEach(function(board) {
                           board.type = 'Board'
                           favoriteBoardModel.append(board);
                           });
        var threads = U2chjs.getFavoriteBoardList('Thread');
        threads.forEach(function(thread) {
                           thread.type = 'Thread'
                           favoriteBoardModel.append(thread);
                           });
    }
}
