import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animations Intro',
      debugShowCheckedModeBanner: false,
      home: LogoApp(),
    );
  }
}

class ForTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  final Tween<double> sizeTween = Tween<double>(begin: 0, end: 300);
  final Tween<double> opacityTween = Tween<double>(begin: 0.1, end: 1);

  ForTransition({
    required this.child,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) => Opacity(
          opacity: opacityTween.evaluate(animation).clamp(0, 1),
          child: Container(
            height: sizeTween.evaluate(animation),
            width: sizeTween.evaluate(animation),
            child: child,
          ),
        ),
        child: child,
      ),
    );
  }
}

class LogoApp extends StatefulWidget {
  @override
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ForTransition(
      child: FlutterLogo(),
      animation: animation,
    );
  }
}
