import 'package:flutter/material.dart';

class Emoji extends StatelessWidget {
  const Emoji(this.emoji, {Key? key}) : super(key: key);

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Text(
        emoji,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
