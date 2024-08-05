// main code fo the game which displays all the widgets and content on the screen
import 'dart:async';
import 'package:angry_bird_game/flappyBird/barriers.dart';
import 'package:flutter/material.dart';
import 'bird.dart';

class Hpage extends StatefulWidget {
  @override
  _HpageState createState() => _HpageState();
}

class _HpageState extends State<Hpage> {
  static double bYaxis = 0; // bird's y coordinate
  double time = 0; // time of flight
  double height = 0; // height of bird
  double initHeight = bYaxis; // initial height of the bird
  bool gameStarted = false;
  double xBarrier1 = 1;
  double xBarrier2 = 2;
  double xBarrier3 = 3;
  int score = 0;

  void resetGame() {
    setState(() {
      bYaxis = 0;
      time = 0;
      height = 0;
      initHeight = bYaxis;
      xBarrier1 = 1;
      xBarrier2 = 2;
      xBarrier3 = 3;
      gameStarted = false;
      score = 0;
    });
  }

  void jump() {
    gameStarted = true;
    setState(() {
      time = 0;
      initHeight = bYaxis;
    });
  }

  // checking if bird crashes into any barrier
  bool crashCheck() {
    if (xBarrier1 < 0.2 && xBarrier1 > -0.2) {
      if (bYaxis < -0.6 || bYaxis > 0.4) return true;
    }
    if (xBarrier2 < 0.2 && xBarrier2 > -0.2) {
      if (bYaxis < -0.6 || bYaxis > 0.4) return true;
    }
    return false;
  }

  void showGameOverDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.yellow[900],
            title: Text(
              "GAME OVER",
              style: TextStyle(color: Colors.yellow),
            ),
            // ignore: unused_label
            actions: [
              // ignore: deprecated_member_use
              // FlatButton(
              //   child: Text(
              //     "PLAY AGAIN ?",
              //     style: TextStyle(color: Colors.white),
              //   ),
              //   onPressed: () {
              //     resetGame();
              //     setState(() {
              //       gameStarted = false;
              //     });
              //     Navigator.of(context).pop();
              //   },
              // )
              ElevatedButton(
                onPressed: () {
                  resetGame();
                  setState(() {
                    gameStarted = false;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text("PLAY AGAIN ?"),
              ),
            ],
          );
        });
  }

  void gameBeg() {
    gameStarted = true;
    Timer.periodic(Duration(milliseconds: 29), (timer) {
      // manages the frames
      // one frame for 10 millisecs
      time +=
          0.035; // increasing time continously to increase bird's height in below eq.n
      height = -4.9 * time * time +
          3 * time; // 2nd equation of gravitational motion (g/2 = 4.9)
      setState(() {
        // dynamically set the bird at the required position
        bYaxis = initHeight - height;

        // looping the barriers
        if (xBarrier1 < -2) {
          score += 1;
          xBarrier1 += 3.1;
        } else {
          xBarrier1 -= 0.05;
        }
        if (xBarrier2 < -2) {
          score += 1;
          xBarrier2 += 3.1;
        } else {
          xBarrier2 -= 0.05;
        }
        if (xBarrier3 < -2) {
          score += 1;
          xBarrier3 += 3.1;
        } else {
          xBarrier3 -= 0.05;
        }
      });

      // to prevent the bird from escaping BELOW screen
      if (bYaxis >= 0.95 || crashCheck()) {
        // bYaxis = 1; // change the height of bird
        timer.cancel(); // cancel that particular time count
        showGameOverDialog();
      }

      // to prevent bird escaping the ABOVE screen
      if (bYaxis <= -1) {
        bYaxis = -1; // change the height of bird
        timer.cancel(); // cancel that particular time count
        gameBeg(); // recursive call to continue bird's flight
      }
    }); // 1 frame ends here
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // once clicked or tapped on the screen
        if (gameStarted) {
          // if the game has started (which initially isn't)
          jump(); // call the jump function
        } else if (!gameStarted) {
          gameBeg(); // else start the game
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                // for the sky background
                flex: 5, // to fill the available space along the axis
                child: Stack(
                  // to stack all widgets on 1 another respectively
                  children: [
                    AnimatedContainer(
                      alignment: Alignment(
                          0, bYaxis), // Bird's position at (x,y) coordinate
                      duration: Duration(milliseconds: 29),
                      color: Colors.blue[200],
                      child:
                          Bird(), // Object of class Bird (image imported from the device)
                    ),
                    Container(
                        // to display : tap to play
                        alignment: Alignment(0, -0.25),
                        child: gameStarted
                            ? Text("")
                            : Text("TAP  TO  FLY",
                                style: TextStyle(fontSize: 35))),

                    // deploying barriers
                    AnimatedContainer(
                      alignment: Alignment(xBarrier1, 1),
                      duration: Duration(milliseconds: 0),
                      child: Barrier(
                        size: 150.0, // barrier's height
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(xBarrier1, -1), // inverted barrier
                      duration: Duration(milliseconds: 0),
                      child: Barrier(
                        size: 90.0, // barrier's height
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(xBarrier2, 1),
                      duration: Duration(milliseconds: 0),
                      child: Barrier(
                        size: 190.0, // barrier's height
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(xBarrier2, -1), // inverted barrier
                      duration: Duration(milliseconds: 0),
                      child: Barrier(
                        size: 85.0, // barrier's height
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(xBarrier1, 1),
                      duration: Duration(milliseconds: 0),
                      child: Barrier(
                        size: 150.0, // barrier's height
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(xBarrier1, -1), // inverted barrier
                      duration: Duration(milliseconds: 0),
                      child: Barrier(
                        size: 90.0, // barrier's height
                      ),
                    ),
                  ],
                )),
            Expanded(
                // fir green ground
                child: Container(
              color: Colors.green[900],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // to display the scores
                  Text("SCORE : ",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  Text(score.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 20))
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
