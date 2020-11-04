import 'dart:async';

import 'package:Shush/bloc/shush_bloc.dart';
import 'package:Shush/pages/listening_page.dart';
import 'package:Shush/pages/settings_page.dart';
import 'package:Shush/provider/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math' as math;

class NotListeningPage extends StatefulWidget {
  // final ListeningBloc listeningBloc;
  // final bool gender;
  // final CurrentnoiselvlBloc currentnoiselvlBloc;
  // NotListeningPage({this.listeningBloc, this.gender, this.currentnoiselvlBloc});

  @override
  _NotListeningPageState createState() => _NotListeningPageState();
}

class _NotListeningPageState extends State<NotListeningPage> {
  bool gender;
  Color unselectedColor = Colors.grey.withOpacity(0.4);
  Color selectedColor = Colors.yellow[800].withOpacity(0.6);
  double currentNoiseLvl = 0.7; //scale to range 0.0-1.0

  bool _clickable = false;
  ShushBloc _shushBloc;

  @override
  // ignore: missing_return
  Future<void> initState() {
    _shushBloc = BlocProvider.of<ShushBloc>(context);
    Timer(
      Duration(seconds: 2),
      () {
        _clickable = true;
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                  // color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  //     .withOpacity(1.0),
                  ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                // color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                //     .withOpacity(1.0),
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Consumer<ThemeNotifier>(
                        builder: (context, notifier, child) => IconButton(
                          icon: notifier.darkTheme
                              ? Icon(Icons.brightness_3)
                              : Icon(Icons.wb_sunny),
                          color: Colors.grey.withOpacity(0.4),
                          // iconSize: MediaQuery.of(context).size.height * 0.035,
                          onPressed: () {
                            notifier.toggleTheme();
                          },
                        ),
                      ),
                      // SizedBox(width: 30.0),
                      IconButton(
                        icon: Icon(Icons.info_outline),
                        color: Colors.grey.withOpacity(0.4),
                        // iconSize: MediaQuery.of(context).size.height * 0.035,
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
                                  height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            'descriptionTitle'.tr().toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.035,
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
                                              'descriptionContent'
                                                  .tr()
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.03,
                                                letterSpacing: 2.0,
                                                color: Colors.grey
                                                    .withOpacity(0.8),
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
                      //here was the dialog button if necessary to return, hopefully not it was disgusting
                      // SizedBox(width: 30.0),
                      IconButton(
                        icon: Icon(Icons.settings),
                        color: Colors.grey.withOpacity(0.4),
                        // iconSize: MediaQuery.of(context).size.height * 0.035,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(
                  // color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  //     .withOpacity(1.0),
                  ),
            ),
            Expanded(
              flex: 13,
              child: Container(
                // color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                //     .withOpacity(1.0),
                child: FittedBox(
                  // fit: BoxFit.fill,
                  child: Text(
                    'Shush',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 5.0,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(
                  // color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  //     .withOpacity(1.0),
                  ),
            ),
            Expanded(
              flex: 11,
              child: FittedBox(
                child: Container(
                  // color:
                  //     Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  //         .withOpacity(1.0),
                  child: RaisedButton(
                    elevation: 3,
                    onPressed: _clickable
                        ? () async {
                            // widget.listeningBloc
                            //     .add(StartListening(volume: volume));
                            _shushBloc.playing = true;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListeningPage(),
                              ),
                            );
                          }
                        : null,
                    child: Text(
                      'startButton'.tr().toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        // fontSize: MediaQuery.of(context).size.height * 0.03,
                        letterSpacing: 3.0,
                      ),
                    ),
                    // padding: EdgeInsets.all(14.0),
                    textColor: Colors.yellow[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(
                        width: 1.0,
                        color: Colors.yellow[800],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(
                  // color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  //     .withOpacity(1.0),
                  ),
            ),
            Expanded(
              flex: 3,
              child: FittedBox(
                child: Container(
                  // color:
                  //     Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  //         .withOpacity(1.0),
                  child: Text(
                    'inputVolume'.tr().toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      // fontSize: MediaQuery.of(context).size.width * 0.04,
                      letterSpacing: 3.0,
                      color: Colors.grey[600].withOpacity(0.9),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: FittedBox(
                child: Container(
                  // color:
                  //     Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  //         .withOpacity(1.0),
                  child: Text(
                    _shushBloc.getVolume().round().toString(),
                    style: TextStyle(
                      // fontSize: MediaQuery.of(context).size.width * 0.06,
                      letterSpacing: 3.0,
                      color: Colors.yellow[900],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                  // color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  //     .withOpacity(1.0),
                  ),
            ),
            Expanded(
              flex: 10,
              child: Container(
                // color:
                //     Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                //         .withOpacity(1.0),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: 1,
                      top: 1,
                      // height: 40.0,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(19.0, 0, 17.0, 0),
                        child: BlocBuilder<ShushBloc, ShushEventState>(
                          builder: (context, state) {
                            if (state is ShushListening) {
                              // print(
                              //     "state data is: " + state.data.toString());
                              return LinearPercentIndicator(
                                //TODO same problem with the indicator, goes to 100 but slider can choose up to 120 dB
                                animationDuration: 200,
                                width: MediaQuery.of(context).size.width * 0.7,
                                lineHeight: 4.0,
                                percent: mapToRange(x: state.data ?? 10, inMin: 10, inMax: 150, outMin: 0, outMax: 1),
                                // percent: ((state.data ?? 0) /
                                //     141), //da se slaže s input sliderun
                                backgroundColor:
                                    Colors.grey[300].withOpacity(0.0),
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
                    Positioned(
                      bottom: 1,
                      top: 1,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.81,
                        // height: 40.0,
                        child: SliderTheme(
                          data: SliderThemeData(
                            overlayColor: Colors.yellow[800].withOpacity(0.15),
                            thumbColor: Colors.yellow[800],
                            activeTrackColor:
                                Colors.yellow[800].withOpacity(0.3),
                            inactiveTrackColor:
                                Colors.grey[300].withOpacity(0.3),
                            trackHeight: 11,
                          ),
                          child: Slider(
                            min:
                                40.0, //sidenote, 50.0 je već otprilike šum sobe kad se niš ne događa
                            max: 140.0, //bar ča se tiče PCMa mog mobitela
                            value: _shushBloc.getVolume(),
                            onChanged: (newVolume) {
                              _shushBloc.setVolume(newVolume);
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                  // color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  //     .withOpacity(1.0),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/**
 * ako bude trebalo zaustavit listen na startu
    RaisedButton(
      onPressed: () async {
        currentnoiselvlBloc.add(StopListeningCurrentNoiseLvl());
        print("stopped finally fucker");
      },
      child: Text("stop current"),
    ),
 */


double mapToRange(
    {double x,
    double inMin,
    double inMax,
    double outMin = 0.0,
    double outMax = 1.0}) {
  return (x - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
}