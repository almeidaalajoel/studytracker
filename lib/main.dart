import 'package:flutter/material.dart';
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int minutes;
  @override
  void initState() {
    _returnCounter().then((c) {
      setState(() {
        minutes = c;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: minutes == null
          ? Container()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Total Hours Spent'),
                Text('${minutes ~/ 60} hours and ${minutes % 60} minutes'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text(
                          'Add 1 hour',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          setState(() {
                            _increaseCounter(60);
                            minutes += 60;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: 'Add Minutes'),
                          onSubmitted: (mins) {
                            setState(() {
                              _increaseCounter(int.parse(mins));
                              minutes += int.parse(mins);
                            });
                          }),
                    ),
                  ],
                )
              ],
            ),
    );
  }
}

_increaseCounter(int minutes) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int counter = (prefs.getInt('counter') ?? 0) + minutes;
  await prefs.setInt('counter', counter);
}

_returnCounter() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('counter') ?? 0;
}
