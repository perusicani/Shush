import 'dart:async';

import 'package:Shush/bloc/currentnoiselvl_bloc.dart';
import 'package:flutter/material.dart';
import 'package:Shush/bloc/listening_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ListeningPage extends StatefulWidget {
  // final listeningBloc;
  final currentnoiselvlBloc;
  // ListeningPage({this.listeningBloc, this.currentnoiselvlBloc});
  final double volume;
  ListeningPage({this.volume, this.currentnoiselvlBloc});

  @override
  _ListeningPageState createState() => _ListeningPageState();
}

class _ListeningPageState extends State<ListeningPage> {
  bool _clickable = false;
  ListeningBloc listeningBloc;

  @override
  void initState() {
    listeningBloc = new ListeningBloc();
    Timer(
      Duration(seconds: 2),
      () {
        _clickable = true;
        print("Šanko pederčina");
        setState(() {});
      },
    );
    super.initState();
    print("ON ADD EVENT VOLUME = " + widget.volume.toString());
    listeningBloc.add(StartListening(volume: widget.volume));
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => listeningBloc,
      child: Scaffold(
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
                              listeningBloc.add(StopListening());
                              Navigator.of(context).pop();
                              //TODO somehow trigger currentnoiseBloc na drugon screenu (shit fix za sad passan bloc celi)
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
                    SizedBox(height: 20.0),
                    Text(
                      'buffer',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        fontFamily: 'OpenSansCondensed',
                        letterSpacing: 4.0,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: BlocBuilder<ListeningBloc, ListeningState>(
                          builder: (context, state) {
                            if (state is UpdatedListening) {
                              // print("state buffer = " + state.buffer.toString());
                              return LinearPercentIndicator(
                                width: MediaQuery.of(context).size.width * 0.8,
                                lineHeight: 2.0,
                                percent: ((state.buffer ?? 0) /
                                    100) , //deal with situation when buffer over 100
                                backgroundColor:
                                    Colors.grey[300].withOpacity(0.7),
                                progressColor: Colors.yellow[900],
                                animation: true,
                                animateFromLastPercent: true,
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
