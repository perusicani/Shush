import 'dart:math';

import 'package:Shush/styles/wave_widget.dart';
import 'package:flutter/material.dart';
import 'package:Shush/bloc/listening_bloc.dart';

// ignore: must_be_immutable
class ListeningPage extends StatefulWidget {
  final listeningBloc;
  ListeningPage({this.listeningBloc});

  @override
  _ListeningPageState createState() => _ListeningPageState();
}

class _ListeningPageState extends State<ListeningPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        // padding: EdgeInsets.all(30.0),
        child: Stack(children: <Widget>[
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () async {
                      widget.listeningBloc.add(StopListening());
                    },
                    child: Text(
                      'Stop Listening',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontFamily: 'OpenSansCondensed',
                        letterSpacing: 4.0,
                      ),
                    ),
                    padding: EdgeInsets.all(14.0),
                    color: Colors.white,
                    textColor: Colors.yellow[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(
                        width: 3.0,
                        color: Colors.yellow[800],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  // Text(buffer.toString()),
                ],
              ),
            ),
          ),
          onBottom(AnimatedWave(
            height: 580,
            speed: 1.0,
          )),
          onBottom(AnimatedWave(
            height: 320,
            speed: 0.9,
            offset: pi,
          )),
          onBottom(AnimatedWave(
            height: 420,
            speed: 1.2,
            offset: pi / 2,
          )),
        ]),
      ),
    );
  }

  onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );
}
