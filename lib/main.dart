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
        body: Center(child: Clock()),
        floatingActionButton: IconButton(
          // Create activity
          icon: Icon(
            Icons.add_circle_rounded,
            size: 60,
            color: Colors.blue,
          ),
          padding: EdgeInsets.all(4.0),
          onPressed: null,
        ),
      ),
    );
  }
}

//----------------------------------- BODY -------------------------------------
class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  int _min = 25;
  int _sec = 0;
  bool _breakTime = false;
  bool _pause = true;
  Color _bgBreakColor = Colors.lightGreen[200];
  Color _fgBreakColor = Colors.green;

  Color _bgWorkColor = Colors.lightBlue[200];
  Color _fgWorkColor = Colors.blue;

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
    _breakTime = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment(0, 0),
        children: [
          Container(
            child: CircularProgressIndicator(
              value: _breakTime
                  ? ((_min * 60) + _sec) / 300
                  : ((_min * 60) + _sec) / 1500,
              backgroundColor: (_breakTime ? _bgBreakColor : _bgWorkColor),
              valueColor: AlwaysStoppedAnimation(
                  _breakTime ? _fgBreakColor : _fgWorkColor),
            ),
            height: 165,
            width: 165,
          ),
          FlatButton(
            child: Text(
              '${_min > 9 ? _min : "0$_min"}:${_sec > 9 ? _sec : "0$_sec"}',
              style: TextStyle(
                fontSize: 50,
              ),
            ),
            onPressed: () => _pause ? _startTimer() : _stopTimer(),
            onLongPress: () => _resetTimer(),
            shape: CircleBorder(),
            height: 160,
            color: Colors.white,
          ),
        ],
      ),
      alignment: Alignment.center,
    );
  }
}
