import 'package:flutter/material.dart';

// class ThreeDotWaiting extends StatelessWidget {
//   const ThreeDotWaiting({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

class ThreeDotWaiting extends StatefulWidget {
  const ThreeDotWaiting({super.key});

  @override
  State<ThreeDotWaiting> createState() => _ThreeDotWaitingState();
}

class _ThreeDotWaitingState extends State<ThreeDotWaiting> with TickerProviderStateMixin {
  // late final List<AnimationController> animationController;
  late AnimationController animationController;
  late AnimationController animationController2;
  late Animation a1, a2, a3;
  late Tween a1T, a2T, a3T;
  bool toggle = true;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 750),
        vsync: this
    );
    a1T = Tween(begin: 0.5, end: 1.0);
    a1 = a1T.animate(
        CurvedAnimation(parent: animationController, curve: (const Interval(0.0, 0.33, curve: Curves.elasticInOut)))
    );
    a2 = a1T.animate(
        CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.33, 0.66, curve: Curves.elasticInOut))
    );
    a3 = a1T.animate(
        CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.66, 0.99, curve: Curves.elasticInOut))
    );
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        toggle = !toggle;
        a1T = toggle ? Tween(begin: 0.5, end: 1.0) : Tween(begin: 1.0, end: 0.5);
        a1 = a1T.animate(
            CurvedAnimation(parent: animationController, curve: (const Interval(0.0, 0.33, curve: Curves.linear)))
        );
        a2 = a1T.animate(
            CurvedAnimation(
                parent: animationController,
                curve: const Interval(0.33, 0.66, curve: Curves.linear))
        );
        a3 = a1T.animate(
            CurvedAnimation(
                parent: animationController,
                curve: const Interval(0.66, 0.99, curve: Curves.linear))
        );
        animationController
          ..reset()
          ..forward();
      }
    });
    animationController.forward;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: a1,
          child:  dot(),
          builder: (context, child) {
            return Transform.scale(
              scale: (a1.value),
              child: child,
            );
          },
        ),
        AnimatedBuilder(
          animation: a2,
          child:  dot(),
          builder: (context, child) {
            return Transform.scale(
              scale: (a2.value),
              child: child,
            );
          },
        ),
        AnimatedBuilder(
          animation: a3,
          child:  dot(),
          builder: (context, child) {
            return Transform.scale(
              scale: (a3.value),
              child: child,
            );
          },
        ),
      ],
    );
  }
  Widget dot() {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black
      ),
    );
  }
}
