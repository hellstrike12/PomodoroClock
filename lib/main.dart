import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

void main() => runApp(MyApp());

//--------------------------------- ROOT ---------------------------------------
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Clock',
      home: Home(),
    );
  }
}

//------------------------------------------------------------------------------
//---------------------------------- HOME --------------------------------------
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pomodoro Clock')),
      body: Center(child: Clock()),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                children: [
                  // Titulo
                  Text(
                    'Pomodoro Clock',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Text(
                    // Subtitulo
                    "Simple pomodoro clock\nusing Google's Flutter API",
                    style: TextStyle(color: Colors.grey[200]),
                    textAlign: TextAlign.end,
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Minhas atividades'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Activities(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

//------------------------------------------------------------------------------
//--------------------------------- CLOCK --------------------------------------
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
            height: 220,
            width: 220,
          ),
          FlatButton(
            child: Text(
              '${_min > 9 ? _min : "0$_min"}:${_sec > 9 ? _sec : "0$_sec"}',
              style: TextStyle(
                fontSize: 70,
              ),
            ),
            onPressed: () => _pause ? _startTimer() : _stopTimer(),
            onLongPress: () => _resetTimer(),
            shape: CircleBorder(),
            color: Colors.white,
            height: 250,
          ),
        ],
      ),
      alignment: Alignment.center,
    );
  }
}

//------------------------------------------------------------------------------
//------------------------------- ACTIVITIES -----------------------------------
class Activities extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Atividades'),
      ),
      body: Center(
        child: Text('Teste'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 30),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return PopUp();
            },
          );
        },
      ),
    );
  }
}

//------------------------------------------------------------------------------
//---------------------------------- POP UP ------------------------------------
class PopUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        // HEADING
        children: [
          // Heading
          PopUpHead(),
          PopUpBody()
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    );
  }
}

//------------------------------------------------------------------------------
//----------------------------- POP-UP HEAD ------------------------------------
class PopUpHead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'Criar nova atividade',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      width: 300,
    );
  }
}

//------------------------------------------------------------------------------
//----------------------------- POP-UP BODY ------------------------------------
class PopUpBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Nome da atividade"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Nome da atividade não especificado";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        padding: EdgeInsets.all(15),
      ),
    );
  }
}
//------------------------------------------------------------------------------
