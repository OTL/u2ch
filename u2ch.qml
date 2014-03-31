import QtQuick 2.0
import Ubuntu.Components 0.1
import "components"

/*!
  \brief MainView with a Label and Button elements.
  */

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"
    
    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.o.u2ch"
    
    /*
      This property enables the application to change orientation
      when the device is rotated. The default is false.
      */
    //automaticOrientation: true
    
    width: units.gu(100)
    height: units.gu(75)
    
    FontLoader {
        id: webFont
        source: "https://dl.dropboxusercontent.com/u/1658499/FLOPDesignFont.ttf" 
    }
    
    PageStack {
        id: rootStack
        height: units.gu(60)
        Component.onCompleted: {
            push(categoryPage)
        }
        
        Tabs {
            id: rootTabs
            Tab {
                title: i18n.tr("u2ch")
                page: boardPage
            }
//            Tab {
//                id: settingTab
//                title: i18n.tr("Settings")
//            }
            Component.onCompleted: {
                categoryView.getListByURL("http://menu.2ch.net/bbsmenu.html")
            }
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
            }
            ThreadListView {
                anchors.bottom: parent.bottom
                anchors.top: threadLabelRect.bottom
                id: threadListView
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
            }
            ContentsView {
                anchors.bottom: parent.bottom
                anchors.top: contentsLabelRectangle.bottom
                id: contentsView
            }
        }
    }
}
