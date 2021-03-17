/// Flutter code sample for PositionedTransition

// The following code implements the [PositionedTransition] as seen in the video
// above:

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(const MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/// This is the private State class that goes with MyStatefulWidget.
/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _MyHomePageState extends State<MyStatefulWidget> with TickerProviderStateMixin {
  ///
  AnimationController intController;
  Animation<int> intAnim;

  ///
  AnimationController doubleController;

  Animation<double> doubleAnim;

  @override
  initState() {
    super.initState();
    intController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    intController.addListener(() {
      print("addListener int = ${intAnim.value}");
      setState(() {});
    });
    intController.addStatusListener((state) {
      if (AnimationStatus.completed == state) {
        intController.reverse();
      } else if (AnimationStatus.dismissed == state) {
        intController.forward();
      }
    });
    intAnim = IntTween(begin: 0, end: 1000).animate(intController);

    doubleController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    doubleController.addListener(() {
      setState(() {});
    });
    doubleController.addStatusListener((state) {
      if (AnimationStatus.completed == state) {
        doubleController.reverse();
      } else if (AnimationStatus.dismissed == state) {
        doubleController.forward();
      }
    });
    doubleAnim = Tween<double>(begin: 0, end: 1.0).animate(doubleController);

    intController.forward();
    doubleController.forward();
  }

  @override
  void dispose() {
    intController.dispose();
    doubleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: const Text('首页')),
        body: Center(
            child: Column(
          children: <Widget>[
            SizedBox(height: 100.0),
            Container(
              child: Text(
                "${intAnim.value}",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              alignment: Alignment.center,
              width: 200.0,
              height: 40.0,
            ),
            SizedBox(height: 30.0),
            _progressIndicator(),
            SizedBox(height: 60.0),
            GestureDetector(
                onTap: _stop,
                child: Container(
                  width: 200.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffFA6400), width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Seek Treble Number',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20.0,
                    ),
                  ),
                )),
          ],
        )));
  }

  /// 进度条
  _progressIndicator() {
    return Container(
      height: 15.0,
      width: 300.0,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: LinearProgressIndicator(
          backgroundColor: Colors.blue.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation(Colors.red),
          value: doubleAnim.value,
        ),
      ),
    );
  }

  int count = 0;

  _stop() {
    intController.stop();
    doubleController.stop();
    count++;
    if (count % 2 == 0) {
      int stopValue = intAnim.value;
      if (stopValue == 111 ||
          stopValue == 222 ||
          stopValue == 333 ||
          stopValue == 444 ||
          stopValue == 555 ||
          stopValue == 666 ||
          stopValue == 777 ||
          stopValue == 888 ||
          stopValue == 999) {
        Fluttertoast.showToast(msg: "牛逼了 $stopValue", gravity: ToastGravity.TOP);
      } else {
        Fluttertoast.showToast(msg: "Fail", gravity: ToastGravity.TOP);
        Future.delayed(Duration(milliseconds: 100), () {
          Fluttertoast.cancel();
        });
      }
    } else {
      intController.animateTo(0);
      intController.forward();
      doubleController.animateTo(0);
      doubleController.forward();
    }
  }
}
