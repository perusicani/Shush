import 'dart:async';

import 'package:Shush/bloc/currentnoiselvl_bloc.dart';
import 'package:flutter/material.dart';
import 'package:Shush/bloc/listening_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';

class NotListeningPage extends StatefulWidget {
  final ListeningBloc listeningBloc;
  final bool gender;
  final CurrentnoiselvlBloc currentnoiselvlBloc;
  NotListeningPage({this.listeningBloc, this.gender, this.currentnoiselvlBloc});

  @override
  _NotListeningPageState createState() => _NotListeningPageState();
}

class _NotListeningPageState extends State<NotListeningPage> {
  double volume = 70.0;
  String path;
  bool male = true;
  Color unselectedColor = Colors.grey.withOpacity(0.4);
  Color selectedColor = Colors.yellow[800].withOpacity(0.6);
  double currentNoiseLvl = 0.7; //scale to range 0.0-1.0

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
      body: new Container(
        padding: EdgeInsets.all(30.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.info_outline),
                      color: Colors.grey.withOpacity(0.4),
                      iconSize: MediaQuery.of(context).size.height * 0.035,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              backgroundColor: Colors.white,
                              insetAnimationCurve: Curves.ease,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              child: Container(
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          "App description",
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.035,
                                            fontFamily: 'OpenSansCondensed',
                                            letterSpacing: 4.0,
                                            color: Colors.yellow[800]
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20.0),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "The point is you should shut up",
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.03,
                                              fontFamily: 'OpenSansCondensed',
                                              letterSpacing: 2.0,
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(width: 30.0),
                    IconButton(
                      icon: Icon(Icons.settings),
                      color: Colors.grey.withOpacity(0.4),
                      iconSize: MediaQuery.of(context).size.height * 0.035,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              insetAnimationCurve: Curves.ease,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              child: Container(
                                height: 250,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          "Voice pack",
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                            fontFamily: 'OpenSansCondensed',
                                            letterSpacing: 4.0,
                                            color: Colors.yellow[800]
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              "Male voice",
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.03,
                                                fontFamily: 'OpenSansCondensed',
                                                letterSpacing: 4.0,
                                                color: Colors.grey
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20.0),
                                          IconButton(
                                            color: widget.gender ?? male
                                                ? selectedColor
                                                : unselectedColor,
                                            icon: Icon(Icons.check),
                                            onPressed: () async {
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              prefs.setBool('gender', true);
                                              path =
                                                  "lib/assets/male_voice/Shhh-sound";
                                              print(path);
                                              Navigator.pop(context);
                                              widget.listeningBloc.add(
                                                  StopListening()); //rebuild
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              "Female voice",
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.03,
                                                fontFamily: 'OpenSansCondensed',
                                                letterSpacing: 4.0,
                                                color: Colors.grey
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20.0),
                                          IconButton(
                                            color: widget.gender ?? male
                                                ? unselectedColor
                                                : selectedColor,
                                            icon: Icon(Icons.check),
                                            onPressed: () async {
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              prefs.setBool('gender', false);
                                              path =
                                                  "lib/assets/female_voice/Shhh-sound";
                                              print(path);
                                              Navigator.pop(context);
                                              widget.listeningBloc.add(
                                                  StopListening()); //rebuild
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 58.0),
                Text(
                  'Shush',
                  style: TextStyle(
                    fontFamily: 'OpenSansCondensed',
                    fontSize: MediaQuery.of(context).size.height * 0.07,
                    letterSpacing: 25.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 30.0),
                RaisedButton(
                  onPressed: _clickable
                      ? () async {
                          widget.listeningBloc
                              .add(StartListening(volume: volume, path: path));
                          widget.currentnoiselvlBloc
                              .add(StopListeningCurrentNoiseLvl());
                        }
                      : null,
                  child: Text(
                    'Start Listening',
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
                SizedBox(height: 150.0),
                Stack(
                  children: <Widget>[
                    Container(
                      height: 40.0,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(19.0, 0, 17.0, 0),
                        child: BlocBuilder<CurrentnoiselvlBloc,
                            CurrentnoiselvlState>(
                          builder: (context, state) {
                            if (state is ListeningCurrentNoiseLvl) {
                              // print("state data is: " + state.data.toString());
                              return LinearPercentIndicator(
                                width: MediaQuery.of(context).size.width * 0.7,
                                lineHeight: 2.0,
                                percent: ((state.data ?? 0) / 100),
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
                    Container(
                      width: MediaQuery.of(context).size.width * 0.81,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        border:
                            Border.all(color: Colors.yellow[800], width: 3.0),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: SliderTheme(
                        data: SliderThemeData(
                          thumbColor: Colors.yellow[800],
                          activeTrackColor: Colors.yellow[800].withOpacity(0.3),
                          inactiveTrackColor: Colors.grey[300].withOpacity(0.5),
                        ),
                        child: Slider(
                          min:
                              20.0, //sidenote, 50.0 je već otprilike šum sobe kad se niš ne događa
                          max: 120.0, //bar ča se tiče PCMa mog mobitela
                          value: volume,
                          onChanged: (newVolume) {
                            setState(() => volume = newVolume);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.0),
                Row(
                  children: <Widget>[
                    SizedBox(width: 40.0),
                    Icon(
                      Icons.volume_up,
                      color: Colors.grey.withOpacity(0.8),
                      size: MediaQuery.of(context).size.width * 0.06,
                    ),
                    SizedBox(width: 20.0),
                    Text(
                      'dB input volume: ',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontFamily: 'OpenSansCondensed',
                        letterSpacing: 3.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Text(
                      volume.round().toString(),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontFamily: 'OpenSansCondensed',
                        letterSpacing: 3.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.0,
                ),
                //TODO remove/comment later when logic done
                SizedBox(height: 20.0),
                RaisedButton(
                  onPressed: () async {
                    widget.currentnoiselvlBloc
                        .add(StopListeningCurrentNoiseLvl());
                    print("stopped finally fucker");
                  },
                  child: Text("stop current"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
