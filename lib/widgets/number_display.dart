import 'package:elevinfo/essential.dart';
import 'package:elevinfo/widgets/number_display_tiles.dart';
import 'package:flutter/material.dart';

class NumberDisplay extends StatefulWidget {

  const NumberDisplay({
    super.key,
    required this.numbers,
    this.height = 40,
  });

  final List<int?> numbers;

  final double height;

  @override
  State<NumberDisplay> createState() => _NumberDisplayState();
}

class _NumberDisplayState extends State<NumberDisplay> {

  @override
  Widget build(BuildContext context) {

    return Container(
      height: widget.height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          NumberDisplayTiles(
            height: widget.height,
            number: widget.numbers[0].toString(),
          ),
          NumberDisplayTiles(
            height: widget.height,
            number: widget.numbers[1].toString(),
          ),
          NumberDisplayTiles(
            height: widget.height,
            number: widget.numbers[2].toString(),
          ),
          NumberDisplayTiles(
            height: widget.height,
            number: widget.numbers[3].toString(),
          ),
          NumberDisplayTiles(
            height: widget.height,
            number: widget.numbers.where((element) => element != null).length >= 5 ? '-' : null,
          ),
          NumberDisplayTiles(
            height: widget.height,
            number: widget.numbers[4].toString(),
          ),
          NumberDisplayTiles(
            height: widget.height,
            number: widget.numbers[5].toString(),
          ),
          NumberDisplayTiles(
            height: widget.height,
            number: widget.numbers[6].toString(),
          ),
        ],
      ),
    );
  }
}
