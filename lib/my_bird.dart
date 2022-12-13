import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyBird extends StatelessWidget {
  final double birdY;
  final double birdWidth;
  final double birdHeight;

  const MyBird(
      {Key? key,
      required this.birdY,
      required this.birdWidth,
      required this.birdHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, (2 * birdY + birdHeight) / (2 - birdHeight)),
      child: SvgPicture.asset(
        "assets/avatar_bird/icon_flat_bird.svg",
        width: MediaQuery.of(context).size.height * birdWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * birdHeight / 2,
        fit: BoxFit.fill,
      ),
    );
  }
}
