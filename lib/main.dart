import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:test/login/login_page.dart';
import 'package:test/time_scheduler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: TimeScheduler(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        int sensitivity = 8;

        if (details.delta.dy > sensitivity) {
          _navigate(false);
        } else if (details.delta.dy < -sensitivity) {
          _navigate(true);
        }
      },
      child: Scaffold(
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Text('Swap up or down for next screen')),
      ),
    );
  }

  void _navigate(bool isUp) {
    PageTransitionType transition;
    if (isUp) {
      transition = PageTransitionType.bottomToTop;
    } else {
      transition = PageTransitionType.topToBottom;
    }
    Navigator.push(
      context,
      PageTransition(
        child: LoginPage(),
        type: transition,
        duration: Duration(seconds: 1),
      ),
    );
  }
}
