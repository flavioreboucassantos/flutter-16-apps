import 'package:animation/screens/home/widgets/animated_list_view.dart';
import 'package:animation/screens/home/widgets/fade_container.dart';
import 'package:animation/screens/home/widgets/home_top.dart';
import 'package:flutter/material.dart';

class StaggerAnimation extends StatelessWidget {
  final AnimationController _controller;
  final Animation<double> _containerGrow;
  final Animation<EdgeInsets> _listSlidePosition;
  final Animation<Color?> _fadeAnimation;

  StaggerAnimation(this._controller)
      : _containerGrow = CurvedAnimation(
          parent: _controller,
          curve: Curves.ease,
        ),
        _listSlidePosition = EdgeInsetsTween(
          begin: EdgeInsets.only(top: 0),
          end: EdgeInsets.only(top: 80),
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              0.325,
              0.8,
              curve: Curves.ease,
            ),
          ),
        ),
        _fadeAnimation = ColorTween(
          begin: Color.fromRGBO(247, 64, 106, 1.0),
          end: Color.fromRGBO(247, 64, 106, 0),
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.decelerate),
        );

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.zero,
          children: [
            HomeTop(_containerGrow),
            AnimatedListView(_listSlidePosition),
          ],
        ),
        IgnorePointer(
          child: FadeContainer(_fadeAnimation),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: AnimatedBuilder(
          animation: _controller,
          builder: _buildAnimation,
        ),
      ),
    );
  }
}
