import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flyppy_bird_game_funny/my_barrier.dart';
import 'package:flyppy_bird_game_funny/my_bird.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Int value for bird
  static double birdY = 0; // init birdY for first open app
  double initPosBirdY = birdY;
  double height = 0;
  double time = 0;
  double gravity = -4.9; // how strong gravity is ...
  double velocity = 3.5; // how strong the jump is ...
  double birdWidth = 0.1;
  double birdHeight = 0.1;

  // Game setting start
  bool hasGameStart = false;

  // Init barrier variables
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  void _startGame() {
    hasGameStart = true;
    Timer.periodic(
      const Duration(milliseconds: 10),
      (timer) {
        height = gravity * time * time + velocity * time;

        setState(
          () {
            birdY = initPosBirdY - height;
          },
        );

        // Check if bird is dead
        if (_isBirdDead()) {
          timer.cancel();
          _showDialogEndGame();
        }

        // Keep the map moving (move barrier)
        _moveMap();

        // Keep the time going
        time += 0.01;
      },
    );
  }

  void _birdJump() {
    setState(() {
      time = 0;
      initPosBirdY = birdY;
    });
  }

  bool _isBirdDead() {
    // Check if the bird is hitting the top or the bottom os the screen
    if (birdY < -1 || birdY > 1) {
      return true;
    }

    // Check if the bird is hitting a barrier
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdWidth >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }

    return false;
  }

  void _moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= 0.005;
      });

      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
      }
    }
  }

  void _resetGame() {
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      hasGameStart = false;
      time = 0;
      initPosBirdY = birdY;
    });
  }

  void _showDialogEndGame() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: const Center(
              child: Text(
                "G A M E O V E R",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: _resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    color: Colors.white,
                    child: const Text(
                      "PLAY AGAIN",
                      style: TextStyle(
                        color: Colors.brown,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hasGameStart ? _birdJump : _startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.blue.shade300,
                child: Center(
                  child: Stack(
                    children: [
                      MyBird(
                        birdY: birdY,
                        birdWidth: birdWidth,
                        birdHeight: birdHeight,
                      ),
                      _buildTapPlayGame(),
                      MyBarrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][0],
                        isThisBottomBarrier: false,
                      ),
                      MyBarrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][1],
                        isThisBottomBarrier: true,
                      ),
                      MyBarrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][0],
                        isThisBottomBarrier: false,
                      ),
                      MyBarrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][1],
                        isThisBottomBarrier: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTapPlayGame() {
    return Container(
      alignment: const Alignment(0, -0.5),
      child: Text(
        hasGameStart ? "" : "T A P - T O - P L A Y - G A M E",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
