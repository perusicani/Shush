import 'dart:async';

import 'package:Shush/bloc/currentnoiselvl_bloc.dart';
import 'package:flutter/material.dart';
import 'package:Shush/bloc/listening_bloc.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class ListeningPage extends StatefulWidget {
  final listeningBloc;
  final currentnoiselvlBloc;
  ListeningPage({this.listeningBloc, this.currentnoiselvlBloc});

  @override
  _ListeningPageState createState() => _ListeningPageState();
}

class _ListeningPageState extends State<ListeningPage> {
  bool _clickable = false;

  @override
  void initState() {
    Timer(
      Duration(seconds: 2),
      () {
        _clickable = true;
        print("Šanko pederčina");
        setState(() {});
      },
    );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(children: <Widget>[
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: _clickable
                        ? () async {
                            widget.listeningBloc.add(StopListening());
                            widget.currentnoiselvlBloc
                                .add(StartListeningCurrentNoiseLvl());
                          }
                        : null,
                    child: Text(
                      'Stop Listening',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                        fontFamily: 'OpenSansCondensed',
                        letterSpacing: 4.0,
                      ),
                    ),
                    padding: EdgeInsets.all(14.0),
                    color: Colors.white,
                    disabledColor: Colors.white,
                    textColor: Colors.yellow[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(
                        width: 3.0,
                        color: Colors.yellow[800],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Lottie.asset(
                        'lib/assets/lottie/24425-sound-yellow.json'),
                  ),
                ],
              ),
            ),
          ),
          // onBottom(AnimatedWave(
          //   height: 580,
          //   speed: 1.0,
          // )),
          // onBottom(AnimatedWave(
          //   height: 320,
          //   speed: 0.5,
          //   offset: pi,
          // )),
          // onBottom(AnimatedWave(
          //   height: 420,
          //   speed: 0.7,
          //   offset: pi / 2,
          // )),
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
