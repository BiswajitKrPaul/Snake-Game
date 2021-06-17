import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizedbox/main.dart';
import 'package:sizedbox/providers/constant.dart';

class ColorBrick extends ConsumerWidget {
  final String s;
  ColorBrick(this.s);

  @override
  Widget build(BuildContext context, watch) {
    var width = watch(screenSize).width / kTotalNoRow;
    var height = watch(screenSize).height / kTotalNoColumn;
    //print('small width :$width');
    //print('small height :$height');

    return UnconstrainedBox(
      alignment: Alignment.topLeft,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(1.2),
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        child: Container(
          color: Colors.red,
        ),
      ),
    );
  }
}
