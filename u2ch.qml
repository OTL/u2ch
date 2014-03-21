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
    applicationName: "com.ubuntu.developer..u2ch"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    width: units.gu(100)
    height: units.gu(75)

    PageStack {
        id: rootStack
	height: units.gu(60)
        Component.onCompleted: {
            push(boardViewPage)
        }

        Tabs {
            id: rootTabs
            Tab {
                title: i18n.tr("u2ch")
                page: boardViewPage
            }
            Tab {
		id: settingTab
                title: i18n.tr("Settings")
            }
            Component.onCompleted: {
                boardView.getListByURL("http://menu.2ch.net/bbsmenu.html")
            }
        }

	Page {
            id: threadPage
            title: i18n.tr("thread list")
	    Rectangle {
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
		height: units.gu(55)
		anchors.centerIn: parent
		id: threadListView
	    }
	}
	
	Page {
            id: boardViewPage
            title: i18n.tr("Ubuntu 2ch Viewer")
	    Rectangle {
		id: boardLabelRect
		color: UbuntuColors.lightAubergine
		width: parent.width
		height: units.gu(5)
		Label {
		    anchors.centerIn: parent
		    text: "Board Lists"
		    fontSize: "large"
		}
	    }
            BoardListView {
		height: units.gu(55)
		//anchors.centerIn: parent
		anchors.top: boardLabelRect.bottom
		id: boardView
            }
	}

	Page {
            id: contentsPage
            title: i18n.tr("contents")
	    Rectangle {
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
		height: units.gu(55)
		anchors.centerIn: parent
		id: contentsView
	    }
	}
	

	    
	/*        Column {
		  spacing: units.gu(1)
		  BoardListView {
                  id: boardView
		  }
		  
		  anchors {
                  margins: units.gu(2)
                  fill: parent
		  }
		  Button {
                  objectName: "button"
                  width: parent.width
		  
                  text: i18n.tr("Get Boards")
		  
                  onClicked: {
                  boardView.getListByURL("http://menu.2ch.net/bbsmenu.html")
                  //label.text = i18n.tr("..world!")
                  }
		  }
		  
		  }
		  */
    }
}
