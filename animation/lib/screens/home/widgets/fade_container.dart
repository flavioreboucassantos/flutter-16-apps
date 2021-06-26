import 'package:flutter/material.dart';

class FadeContainer extends StatelessWidget {
  final Animation<Color?> _fadeAnimation;

  FadeContainer(this._fadeAnimation);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'fade',
      child: Container(
        decoration: BoxDecoration(
          color: _fadeAnimation.value,
        ),
      ),
    );
  }
}
