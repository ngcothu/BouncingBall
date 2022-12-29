import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    id: main
    width: 640
    height: 480
    visible: true
    title: qsTr("Bouncing Ball")
    property bool started: false
    property int missp: 0
    property int hitp: 0

    Text{
        id: text
        font.pixelSize: 24
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: main.width*0.4
        anchors.topMargin: 5
        text: qsTr("Click mouse to start")
    }
    Text{
        id: pmiss
        font.pixelSize: 24
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: main.width*0.05
        anchors.topMargin: 5
        text: qsTr("Miss: ")
    }
    Text{
        id: phit
        font.pixelSize: 24
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: main.width*0.8
        anchors.topMargin: 5
        text: qsTr("Hit: ")
    }
    Rectangle{ //Playground
        id: playGround
        property int clickCount: 0

        anchors.fill: parent
        anchors.margins: 10
        anchors.topMargin: 36
        color: "lightGray"
        Rectangle { //Ball
            id: ball
            property double altitude: 100
            property double velocity: 1
            property double gravity: -1.5
            property double force: 0

            property double xincrement: Math.random() + 0.5
            property double yincrement: Math.random() + 0.5

            property int move: 5

            width: 15
            height: width
            radius: width / 2
            color: "#AA1818"
            x: parent.width / 2 - width / 2
            y: parent.height / 3 * 2.75 - altitude

            function update() {
                //Ball is really near the ground, bounce up
                if (altitude <= 20) {
                    force = 30
                    velocity = 0
                    //If the ball is within playground, randomly change direction
                    if(ball.x >= 105 && ball.x <= playGround.width - 105)
                    {
                        move = Math.floor(Math.random() * playGround.width*0.03)
                        move = move * (Math.random() < 0.5 ? -1 : 1); // change direction
                    }
                    if(main.started === true)
                    {

                        console.log("bar x", bar.x)
                        console.log("ball x", ball.x)
                        if(ball.x > (bar.x - 10) && ball.x < (bar.x+bar.width + 1)){
                            text.text = "Hit"
                            main.hitp ++
                            phit.text = "Hit: " + main.hitp
                        }
                        else
                        {
                            text.text = "Miss"
                            main.missp ++
                            pmiss.text = "Miss: " + main.missp
                        }

                    }
                }
                //Ball is on the top, fall down
                else
                {
                    force = 0
                }

                //Ball hits right playground will be bounced back
                if(ball.x >= playGround.width - 20)
                {
                   move = -Math.floor(Math.random() * playGround.width*0.03)
                }
                //Ball hits left playground will be bounced back
                if(ball.x <= 20 )
                {
                    move = Math.floor(Math.random() * playGround.width*0.03)
                }
                //Set the ball to move
                ball.x += move
                //Increase velocity due to bouncing
                velocity += gravity + force
                //change altitude due to bouncing
                altitude += velocity
            }

            Timer {
                running: true
                interval: 33
                repeat: true
                onTriggered: ball.update()
            }
        } // End ball
        //the bar
        Rectangle{
            id: bar
            width: 95
            height: 15
            color: "#0065A2"
            x: parent.width / 2 - width / 2
            y: parent.height / 3 * 2.75 -5

            Keys.onPressed: {
                   if (event.key === Qt.Key_Left) {
                        event.accepted = true;
                        bar.x-=30;
                    }
                   if (event.key === Qt.Key_Right) {
                        event.accepted = true;
                        bar.x+=30;
                    }
                }
        }

        MouseArea {
            anchors.fill: parent
            drag.target: root
            onPressed: {
                text.text = "Miss"
                text.anchors.leftMargin = main.width*0.45
                bar.focus = true
                main.started = true
            }
        }
    } //End Playground
}
