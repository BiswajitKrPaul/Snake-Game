import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizedbox/providers/constant.dart';
import 'package:sizedbox/widgets/game_controller.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'Snake Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final score = StateProvider((ref) => 0);

enum Direction {
  up,
  down,
  left,
  right,
}

class _MyHomePageState extends State<MyHomePage> {
  static Duration gameSpeed = Duration(milliseconds: 150);
  Direction direction = Direction.right;
  List snake = [
    [11, 15],
    [10, 15],
    [9, 15],
    [8, 15],
    [7, 15],
  ];
  List food = [
    [Random().nextInt(kTotalNoRow), Random().nextInt(kTotalNoColumn)]
  ];

  bool isPlaying = false;

  void createFood() {
    int x = Random().nextInt(kTotalNoRow);
    int y = Random().nextInt(kTotalNoColumn);
    food = [
      [x, y]
    ];
  }

  void newSnake() {
    direction = Direction.right;
    snake = [
      [11, 15],
      [10, 15],
      [9, 15],
      [8, 15],
      [7, 15],
    ];
    isPlaying = false;
    context.read(score).state = 0;
  }

  void startGame() {
    isPlaying = true;
    Timer.periodic(gameSpeed, (timer) {
      setState(
        () {
          if (isGameOver()) {
            isPlaying = false;
            timer.cancel();
            showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: const Text('Game Over'),
                    content: Text('Your Score : ${context.read(score).state}'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            direction = null;
                            newSnake();
                            createFood();
                          });

                          Navigator.pop(context);
                        },
                        child: Text('Ok'),
                      )
                    ],
                  );
                });
          } else {
            moveSnake(direction);
            if (foodEatenBySnake()) {
              createFood();
              context.read(score).state += 10;
            }
          }
        },
      );
    });
  }

  bool isGameOver() {
    for (int i = 1; i < snake.length; i++) {
      if (listEquals(snake[0], snake[i])) {
        return true;
      }
    }
    return false;
  }

  bool foodEatenBySnake() {
    for (var pos in snake) {
      if (pos[0] == food.first[0] && pos[1] == food.first[1]) {
        return true;
      }
    }

    return false;
  }

  void moveSnake(Direction direction) {
    if (Direction.right == direction) {
      if (snake.first[0] >= kTotalNoRow - 1) {
        snake.insert(0, [0, snake.first[1]]);
      } else {
        snake.insert(0, [snake.first[0] + 1, snake.first[1]]);
      }
    } else if (Direction.left == direction) {
      if (snake.first[0] <= 0) {
        snake.insert(0, [kTotalNoRow - 1, snake.first[1]]);
      } else {
        snake.insert(0, [snake.first[0] - 1, snake.first[1]]);
      }
    } else if (Direction.up == direction) {
      if (snake.first[1] <= 0) {
        snake.insert(0, [snake.first[0], kTotalNoColumn - 1]);
      } else {
        snake.insert(0, [snake.first[0], snake.first[1] - 1]);
      }
    } else if (Direction.down == direction) {
      if (snake.first[1] >= kTotalNoColumn - 1) {
        snake.insert(0, [snake.first[0], 0]);
      } else {
        snake.insert(0, [snake.first[0], snake.first[1] + 1]);
      }
    }

    setState(() {
      this.direction = direction;
    });
    if (!foodEatenBySnake()) {
      snake.removeLast();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[300],
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Center(
                        child: AspectRatio(
                          aspectRatio: kTotalNoRow / kTotalNoColumn,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: kTotalNoColumn * kTotalNoRow,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: kTotalNoRow),
                              itemBuilder: (ctx, index) {
                                int xAxis = index % kTotalNoRow;
                                int yAxis = (index / kTotalNoRow).floor();
                                Color color;
                                bool isSnakeBody = false;

                                for (var pos in snake) {
                                  if (pos[0] == xAxis && pos[1] == yAxis) {
                                    isSnakeBody = true;
                                    break;
                                  }
                                }
                                if (snake.first[0] == xAxis &&
                                    snake.first[1] == yAxis) {
                                  color = Colors.red;
                                } else if (isSnakeBody) {
                                  color = Colors.black;
                                } else if (food.first[0] == xAxis &&
                                    food.first[1] == yAxis) {
                                  color = Colors.green;
                                } else {
                                  color = Colors.transparent;
                                }
                                return Container(
                                  child: Container(color: color),
                                  margin: EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.rectangle,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      isPlaying
                          ? Container()
                          : Align(
                              child: Container(
                                height: 200,
                                width: 200,
                                color: Colors.black54,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Tap To Play',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.play_arrow_rounded,
                                        color: Colors.white,
                                      ),
                                      iconSize: 60,
                                      onPressed: isPlaying ? () {} : startGame,
                                    )
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              GameController(moveSnake, direction),
            ],
          ),
        ),
      ),
    );
  }
}
