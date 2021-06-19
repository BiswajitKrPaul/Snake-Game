import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';

class GameController extends ConsumerWidget {
  final Function moveSnake;
  final Direction direction;
  GameController(this.moveSnake, this.direction);

  @override
  Widget build(BuildContext context, watch) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Score : ${watch(score).state}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Icon(Icons.keyboard_arrow_up),
              onPressed: () {
                if (direction != Direction.down) moveSnake(Direction.up);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    child: Icon(Icons.keyboard_arrow_left),
                    onPressed: () {
                      if (direction != Direction.right)
                        moveSnake(Direction.left);
                    }),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  child: Icon(Icons.keyboard_arrow_right),
                  onPressed: () {
                    if (direction != Direction.left) moveSnake(Direction.right);
                  },
                ),
              ],
            ),
            ElevatedButton(
              child: Icon(Icons.keyboard_arrow_down),
              onPressed: () {
                if (direction != Direction.up) moveSnake(Direction.down);
              },
            ),
          ],
        ),
      ],
    );
  }
}
