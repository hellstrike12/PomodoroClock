import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Clock',
      home: Scaffold(
        appBar: AppBar(title: Text('Pomodoro Clock')),
        body: Center(child: Body()),
      ),
    );
  }
}

//----------------------------------- BODY -------------------------------------
class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int _min = 25;
  int _sec = 0;
  bool _breakTime = false;
  bool _pause = true;

  void _tick() {
    if (mounted && !_pause) {
      if (_min == 0 && _sec == 0) {
        _breakTime = !_breakTime;
        if (_breakTime) {
          _min = 5;
          _sec = 0;
        } else {
          _min = 25;
          _sec = 0;
        }
      } else if (_sec == 0) {
        _min--;
        _sec = 59;
      } else {
        _sec--;
      }
      setState(() {});
      _setTimer();
    }
  }

  Timer _setTimer() {
    var duration = Duration(seconds: 1);
    return new Timer(duration, _tick);
  }

  void _startTimer() {
    _pause = false;
    _setTimer();
  }

  void _stopTimer() {
    _pause = true;
    if (mounted) setState(() {});
  }

  void _resetTimer() {
    _stopTimer();
    _min = 25;
    _sec = 0;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        '${_min > 9 ? _min : "0$_min"}:${_sec > 9 ? _sec : "0$_sec"}',
        style: TextStyle(fontSize: 50),
      ),
      onPressed: () => _pause ? _startTimer() : _stopTimer(),
      onLongPress: () => _resetTimer(),
    );
  }
}
