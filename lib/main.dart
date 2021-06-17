import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizedbox/providers/constant.dart';
import 'package:sizedbox/providers/generate_list.dart';
import 'package:sizedbox/widgets/colored_brick.dart';
import 'package:sizedbox/widgets/small_brick.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final screenSize = ChangeNotifierProvider((ref) => Constants());
final gameGridList = ChangeNotifierProvider((ref) => GameGrid());

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final List data = context.read(gameGridList).gameGridList;
    context.read(screenSize).width = size.width * 0.8 - 6;
    context.read(screenSize).height = (size.width * 0.7) * 2 - 6;
    data[10][5] = 1;
    data[10][3] = 1;
    data[10][4] = 1;
    data[10][6] = 1;
    data[10][7] = 1;
    print(data);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      //nBqeYdDh5CSPjwWX
      body: Center(
        child: UnconstrainedBox(
          child: Container(
            padding: EdgeInsets.all(3),
            child: Column(
              children: [
                ...data.map(
                  (e) => Row(
                    children: [
                      ...e.map((e) => e == 1
                          ? ColorBrick(e.toString())
                          : SmallBrick(e.toString())),
                    ],
                  ),
                ),
              ],
            ),
            width: size.width * 0.8, //23.5632
            height: (size.width * 0.7) * 2, //same
            color: Colors.black12,
          ),
        ),
      ),
    );
  }
}
