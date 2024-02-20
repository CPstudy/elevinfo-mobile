import 'package:flutter/material.dart';

class NumberDisplayTiles extends StatelessWidget {

  const NumberDisplayTiles({
    super.key,
    this.width,
    required this.height,
    required this.number,
  });

  final double? width;

  final double height;

  final String? number;

  @override
  Widget build(BuildContext context) {

    final List<String> items = List.generate(10, (index) => index.toString(), growable: true)..add('-');

    return Stack(
      children: items.map((index) {
        bool isCorrect = number != null && number == index;

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 100),
          opacity: isCorrect ? 1.0 : 0.0,
          child: AnimatedContainer(
            width: width ?? height * 0.55,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            alignment: Alignment.center,
            transform: Matrix4.translationValues(0, isCorrect || index == '-' ? 0.0 : -height * 0.5, 0),
            child: Text(
              '$index',
              style: TextStyle(
                fontSize: 54,
                fontFamily: 'NanumSquare',
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
