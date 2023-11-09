import 'package:flutter/material.dart';

class Calculating extends StatefulWidget {
  const Calculating({Key? key}) : super(key: key);
  @override
  State<Calculating> createState() => _CalculatingState();
}

class _CalculatingState extends State<Calculating>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11;
  late Tween a1T;

  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    a1T = Tween(begin: 0, end: 1.0);
    a1 = animate(0.0, 0.11);
    a2 = animate(0.07, 0.2);
    a3 = animate(0.16, 0.29);
    a4 = animate(0.25, 0.38);
    a5 = animate(0.34, 0.47);
    a6 = animate(0.43, 0.56);
    a7 = animate(0.52, 0.65);
    a8 = animate(0.61, 0.74);
    a9 = animate(0.70, 0.83);
    a10 = animate(0.79, 0.92);
    a11 = animate(0.88, 1.0);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController
          ..reset()
          ..forward();
      }
    });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        animationChild(a1, context, 'c'),
        animationChild(a2, context, 'a'),
        animationChild(a3, context, 'l'),
        animationChild(a4, context, 'c'),
        animationChild(a5, context, 'u'),
        animationChild(a6, context, 'l'),
        animationChild(a7, context, 'a'),
        animationChild(a8, context, 't'),
        animationChild(a9, context, 'i'),
        animationChild(a10, context, 'n'),
        animationChild(a11, context, 'g'),
      ],
    );
  }

  AnimatedBuilder animationChild(
      Animation a, BuildContext context, String char) {
    return AnimatedBuilder(
        animation: a,
        child: Text(char,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        builder: (context, child) {
          return Transform.translate(
              offset: Offset(0, -15 * (0.5 - (a.value - 0.5).abs())),
              child: child);
        });
  }

  Animation animate(double start, double end) {
    return a1T.animate(CurvedAnimation(
      curve: Interval(start, end, curve: Curves.linear),
      parent: animationController,
    ));
  }
}
