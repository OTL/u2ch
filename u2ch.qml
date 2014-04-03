import QtQuick 2.0
import Ubuntu.Components 0.1

import "components"

import QtQuick.LocalStorage 2.0
import "scripts.js" as U2chjs

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"
    
    // applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.o.u2ch"
    
    /*
      This property enables the application to change orientation
      when the device is rotated. The default is false.
      */
    automaticOrientation: true
    
    width: units.gu(100)
    height: units.gu(75)


    FontLoader {
        id: webFont
        source: "https://dl.dropboxusercontent.com/u/1658499/FLOPDesignFont.ttf" 
    }
    Label {
        id: fontLoadingLable
        anchors.right: parent.right
        anchors.top: parent.top
        text: {
            U2chjs.checkFontAndAddLoading(
                webFont, "", "loading fonts", fontLoadingActivity);
        }
    }
    ActivityIndicator {
        anchors.right: fontLoadingLable.left
        anchors.verticalCenter: fontLoadingLable.verticalCenter
        id: fontLoadingActivity
    }
    
    Tabs {
        id: rootTabs
        Tab {
            title: i18n.tr("View 2ch")
            page: rootStack
        }
        Tab {
            id: favoriteTab
            title: i18n.tr("Favorites")
            page: favoritePage
            Component.onCompleted: {
                //U2chjs.clearBoardList('Board');
                //U2chjs.clearBoardList('Thread');
                favoriteView.setBoardListFromDB();
            }
        }
    }
    
    Page {
        id: favoritePage
        title: i18n.tr("Favorites")
        FavoriteListView {
            id: favoriteView
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            width: parent.width
            height: units.gu(300)
        }
    }


    PageStack {
        id: rootStack
        height: units.gu(60)
        Component.onCompleted: {
            push(categoryPage)
            categoryView.getListByURL("http://menu.2ch.net/bbsmenu.html")
        }
        
        Page {
            id: categoryPage
            title: i18n.tr("Categories")
            Rectangle {
                id: categoryLabelRect
                color: UbuntuColors.lightAubergine
                width: parent.width
                height: units.gu(5)
                Label {
                    id: categoryLabel
                    anchors.centerIn: parent
                    text: "Category Lists"
                    fontSize: "large"
                }
                ActivityIndicator {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    id: categoryActivity
                }
            }
            CategoryListView {
                anchors.bottom: parent.bottom
                anchors.top: categoryLabelRect.bottom
                id: categoryView
            }
        }

        Page {
            id: boardPage
            title: i18n.tr("Board List")
            Rectangle {
                id: boardLabelRect
                color: UbuntuColors.lightAubergine
                width: parent.width
                height: units.gu(5)
                Label {
                    id: boardLabel
                    anchors.centerIn: parent
                    text: "Board Lists"
                    fontSize: "large"
                }
            }
            BoardListView {
                anchors.bottom: parent.bottom
                anchors.top: boardLabelRect.bottom
                id: boardView
            }
        }

        Page {
            id: threadPage
            title: i18n.tr("Thread List")
            Rectangle {
                id: threadLabelRect
                color: UbuntuColors.lightAubergine
                width: parent.width
                height: units.gu(5)
                Label {
                    id: threadLabel
                    anchors.centerIn: parent
                    text: "Thread Lists"
                    fontSize: "large"
                }
                ActivityIndicator {
                    anchors.right: parent.right
                    anchors.horizontalCenter: parent.center
                    id: threadActivity
                }
            }
            ThreadListView {
                anchors.bottom: parent.bottom
                anchors.top: threadLabelRect.bottom
                id: threadListView
            }
            tools: ToolbarItems {
                id: threadToolbar
                opened: true
                Button {
                    anchors.verticalCenter: parent.verticalCenter
                    text: i18n.tr("Add to favorite")
                    onClicked: {
                        var name = threadListView.currentBoardName;
                        var url = threadListView.currentBoardUrl;
                        favoriteView.addBoardByTitleAndURL(name, url, 'Board');
                        rootTabs.selectedTabIndex = 1
                    }
                }
            }
        }
        
        
        Page {
            id: contentsPage
            title: i18n.tr("Contents")
            Rectangle {
                id: contentsLabelRectangle
                color: UbuntuColors.lightAubergine
                width: parent.width
                height: units.gu(5)
                Label {
                    id: contentsLabel
                    anchors.centerIn: parent
                    text: "Contents"
                    fontSize: "large"
                }
                ActivityIndicator {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    id: contentsActivity
                }
            }
            tools: ToolbarItems {
                id: contentsToolbar
                Button {
                    anchors.verticalCenter: parent.verticalCenter
                    text: i18n.tr("^")
                    color: UbuntuColors.warmGrey
                    onClicked: {
                        contentsView.positionViewAtBeginning();
                    }
                    width: units.gu(3)
                }
                Slider {
                    anchors.verticalCenter: parent.verticalCenter
                    id: contentsSlider
                    function formatValue(v) {
                        contentsView.positionViewAtIndex(Math.round(v));
                        return (v + 1).toFixed(0);
                    }
                    maximumValue: {
                        contentsView.getCount();
                    }
                    width: units.gu(10)
                    live: true
                }
                Button {
                    anchors.verticalCenter: parent.verticalCenter
                    text: i18n.tr("V")
                    color: UbuntuColors.warmGrey
                    onClicked: {
                        contentsView.positionViewAtEnd();
                    }
                    width: units.gu(3)
                }
                Button {
                    anchors.verticalCenter: parent.verticalCenter
                    text: i18n.tr("favorite")
                    onClicked: {
                        var name = contentsView.currentThreadName;
                        var url = contentsView.currentThreadUrl;
                        favoriteView.addBoardByTitleAndURL(name, url, 'Thread');
                        rootTabs.selectedTabIndex = 1
                    }
                }
                opened: true
            }
            ContentsView {
                anchors.bottom: parent.bottom
                anchors.top: contentsLabelRectangle.bottom
                id: contentsView
            }
        }
    }
}
