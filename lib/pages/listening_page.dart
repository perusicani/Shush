import 'dart:async';

import 'package:Shush/assets/animation/animation.dart';
import 'package:Shush/bloc/currentnoiselvl_bloc.dart';
import 'package:Shush/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:Shush/bloc/listening_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart' as provider;

const MAX_BUFFER_VALUE = 140;

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
  void dispose() {
    listeningBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => listeningBloc,
      child: WillPopScope(
        onWillPop: () {
          //fixes on back button stop bloc
          listeningBloc.add(StopListening());
          Navigator.of(context).pop();
          widget.currentnoiselvlBloc.add(StopListeningCurrentNoiseLvl());
          widget.currentnoiselvlBloc.add(StartListeningCurrentNoiseLvl());
          return;
        },
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: BlocBuilder<ListeningBloc, ListeningState>(
                builder: (context, state) {
              if (state is UpdatedListening) {
                return Column(
                  children: [
                    Expanded(
                      flex: 17,
                      child: Container(
                          // color: Color(
                          //         (math.Random().nextDouble() * 0xFFFFFF).toInt())
                          //     .withOpacity(1.0),
                          ),
                    ),
                    Expanded(
                      flex: 18,
                      child: FittedBox(
                        child: Container(
                          child: RaisedButton(
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
                              'stopButton'.tr().toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                // fontSize: MediaQuery.of(context).size.height * 0.03,
                                letterSpacing: 3.0,
                              ),
                            ),
                            elevation: 3,
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
                      flex: 20,
                      child: Container(
                          // color: Color(
                          //         (math.Random().nextDouble() * 0xFFFFFF).toInt())
                          //     .withOpacity(1.0),
                          ),
                    ),
                    // TODO: VIDI STA SI RADIO NA LAGANINIJU ZA OVO
                    Expanded(
                      flex: 55,
                      child: GestureDetector(
                        onTap: () => getOpacityFromBuffer(state.buffer),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                child: child, scale: animation);
                          },
                          child: Container(
                            key: ValueKey<int>(
                                int.parse(getImageFromBuffer(state.buffer))),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: ExactAssetImage(
                                        "lib/assets/svg/level${getImageFromBuffer(state.buffer)}.png"),
                                    fit: BoxFit.fitHeight)),
                          ),
                        ),
                      ),
                      // child: LayoutBuilder(builder: (context, constraints) {
                      //   print("CONSTRAINTS " + constraints.maxHeight.toString());
                      //   // return Container();
                      //   return Container(
                      //     color:
                      //         Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                      //             .withOpacity(1.0),
                      //     child: FittedBox(
                      //       child: BlocBuilder<ListeningBloc, ListeningState>(
                      //         builder: (context, state) {
                      //           if (state is UpdatedListening) {
                      //             // print("state data = " + state.data.toString());
                      //             return SpriteDemo(
                      //               data: state.data,
                      //               height: constraints.maxHeight,
                      //             );
                      //           }
                      //           return Container();
                      //         },
                      //       ),
                      //     ),
                      //   );
                      // }),
                    ),
                    Expanded(
                      flex: 20,
                      child: Container(
                          // color: Color(
                          //         (math.Random().nextDouble() * 0xFFFFFF).toInt())
                          //     .withOpacity(1.0),
                          ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        // color: Color(
                        //         (math.Random().nextDouble() * 0xFFFFFF).toInt())
                        //     .withOpacity(1.0),
                        child: FittedBox(
                          child: Text(
                            'buffer'.tr().toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              // fontSize: MediaQuery.of(context).size.height * 0.02,
                              letterSpacing: 3.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                          // color: Color(
                          //         (math.Random().nextDouble() * 0xFFFFFF).toInt())
                          //     .withOpacity(1.0),
                          ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        // color: Color(
                        //         (math.Random().nextDouble() * 0xFFFFFF).toInt())
                        //     .withOpacity(1.0),
                        child: FittedBox(
                          child: Text(
                            "Level " + getImageFromBuffer(state.buffer),
                            style: TextStyle(
                              letterSpacing: 3.0,
                              color: Color.fromRGBO(236, 151, 20, 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                          // color:
                          //     Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                          //         .withOpacity(1.0),
                          ),
                    ),
                    //old buffer
                    // Expanded(
                    //   flex: 7,
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width * 0.8,
                    //     color:
                    //         Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                    //             .withOpacity(1.0),
                    //     child: FittedBox(
                    //       child: BlocBuilder<ListeningBloc, ListeningState>(
                    //         builder: (context, state) {
                    //           if (state is UpdatedListening) {
                    //             // print("state buffer = " + state.buffer.toString());
                    //             return LinearPercentIndicator(
                    //               width: MediaQuery.of(context).size.width * 0.8,
                    //               // lineHeight: 2.0,
                    //               percent: ((state.buffer ?? 0) /
                    //                   161), //da se slaže s bufferun
                    //               backgroundColor:
                    //                   Colors.grey[300].withOpacity(0.7),
                    //               progressColor: Colors.yellow[900],
                    //               animation: true,
                    //               animateFromLastPercent: true,
                    //             );
                    //           }
                    //           return Container();
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      flex: 6,
                      child: NoiseBuffer(buffer: state.buffer),
                    ),
                    Expanded(
                      flex: 15,
                      child: Container(
                          // color:
                          //     Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                          //         .withOpacity(1.0),
                          ),
                    ),
                  ],
                );
              }
              return Container();
            }),
          ),
        ),
        // child: Scaffold(
        //   body: Container(
        //     height: MediaQuery.of(context).size.height,
        //     width: MediaQuery.of(context).size.width,
        //     child: Center(
        //       child: Stack(
        //         children: <Widget>[
        //           Positioned(
        //             top: 120,
        //             left: 100,
        //             right: 100,
        //             child: RaisedButton(
        //               onPressed: _clickable
        //                   ? () async {
        //                       listeningBloc.add(StopListening());
        //                       Navigator.of(context).pop();
        //                       //TODO somehow trigger currentnoiseBloc na drugon screenu (shit fix za sad passan bloc celi)
        //                       widget.currentnoiselvlBloc
        //                           .add(StartListeningCurrentNoiseLvl());
        //                     }
        //                   : null,
        //               child: Text(
        //                 'stopButton'.tr().toString(),
        //                 textAlign: TextAlign.center,
        //                 style: TextStyle(
        //                   fontSize: MediaQuery.of(context).size.height * 0.03,
        //                   letterSpacing: 4.0,
        //                 ),
        //               ),
        //               padding: EdgeInsets.all(14.0),
        //               textColor: Colors.yellow[800],
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(30.0),
        //                 side: BorderSide(
        //                   width: 3.0,
        //                   color: Colors.yellow[800],
        //                 ),
        //               ),
        //             ),
        //           ),
        //           Container(
        //             child: Padding(
        //               padding: EdgeInsets.all(30.0),
        //               child: BlocBuilder<ListeningBloc, ListeningState>(
        //                 builder: (context, state) {
        //                   if (state is UpdatedListening) {
        //                     // print("state data = " + state.data.toString());
        //                     return SpriteDemo(data: state.data);
        //                   }
        //                   return Container();
        //                 },
        //               ),
        //             ),
        //           ),
        //           Positioned(
        //             bottom: 150,
        //             left: 100,
        //             right: 100,
        //             child: Text(
        //               'buffer'.tr().toString(),
        //               textAlign: TextAlign.center,
        //               style: TextStyle(
        //                 fontSize: MediaQuery.of(context).size.height * 0.02,
        //                 letterSpacing: 4.0,
        //               ),
        //             ),
        //           ),
        //           Positioned(
        //             bottom: 100,
        //             left: 10,
        //             child: Container(
        //               child: Padding(
        //                 padding: EdgeInsets.all(30.0),
        //                 child: BlocBuilder<ListeningBloc, ListeningState>(
        //                   builder: (context, state) {
        //                     if (state is UpdatedListening) {
        //                       // print("state buffer = " + state.buffer.toString());
        //                       return LinearPercentIndicator(
        //                         width: MediaQuery.of(context).size.width * 0.8,
        //                         lineHeight: 2.0,
        //                         percent: ((state.buffer ?? 0) /
        //                             161), //da se slaže s bufferun
        //                         backgroundColor:
        //                             Colors.grey[300].withOpacity(0.7),
        //                         progressColor: Colors.yellow[900],
        //                         animation: true,
        //                         animateFromLastPercent: true,
        //                       );
        //                     }
        //                     return Container();
        //                   },
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}

class NoiseBuffer extends StatefulWidget {
  final double buffer;
  NoiseBuffer({@required this.buffer});
  @override
  _NoiseBufferState createState() => _NoiseBufferState();
}

class _NoiseBufferState extends State<NoiseBuffer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(200)
        ),
        child: Stack(
          children: [
            LayoutBuilder(builder: (context, constraints) {
              return provider.Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) {
                return Container(
                  decoration: BoxDecoration(
                    color: notifier.darkTheme
                        ? Color.fromRGBO(13, 73, 0, 1)
                        : Color.fromRGBO(154, 226, 137, 1),
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxHeight / 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: notifier.darkTheme
                                  ? Color.fromRGBO(13, 73, 0, 1)
                                  : Color.fromRGBO(154, 226, 137, 1),
                            ),
                          ),
                        ),
                        Expanded(
                          child: AnimatedContainer(
                            duration: Duration(seconds: 2),
                            color: (widget.buffer / MAX_BUFFER_VALUE) > 0.333
                                ? notifier.darkTheme
                                    ? Color.fromRGBO(120, 84, 0, 1)
                                    : Color.fromRGBO(226, 220, 137, 1)
                                : notifier.darkTheme
                                    ? Colors.grey[700]
                                    : Color.fromRGBO(214, 214, 214, 1),
                          ),
                        ),
                        Expanded(
                          child: AnimatedContainer(
                            duration: Duration(seconds: 2),
                            decoration: BoxDecoration(
                              color: (widget.buffer / MAX_BUFFER_VALUE) > 0.666
                                  ? notifier.darkTheme
                                      ? Color.fromRGBO(155, 36, 0, 1)
                                      : Color.fromRGBO(227, 124, 124, 1)
                                  : notifier.darkTheme
                                      ? Colors.grey[700]
                                      : Color.fromRGBO(214, 214, 214, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            }),
            Center(
              child: LinearPercentIndicator(
                width: MediaQuery.of(context).size.width * 0.8,
                lineHeight: 6.0,
                // percent: ((widget.buffer ?? 0) / 161), //da se slaže s bufferun
                percent: widget.buffer / MAX_BUFFER_VALUE,
                backgroundColor: Colors.grey[300].withOpacity(0.7),
                progressColor: Colors.yellow[900],
                animation: true,
                animateFromLastPercent: true,
              ),
            ),
            LayoutBuilder(builder: (context, constraints) {
              // print("CONSTRAINTS:  " + constraints.maxHeight.toString());
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: constraints.maxHeight,
                    width: constraints.maxHeight,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                  ),
                  Container(
                    height: constraints.maxHeight,
                    width: constraints.maxHeight,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (widget.buffer / MAX_BUFFER_VALUE) > 0.333
                          ? Color.fromRGBO(236, 151, 20, 1)
                          : Colors.grey,
                    ),
                  ),
                  Container(
                    height: constraints.maxHeight,
                    width: constraints.maxHeight,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (widget.buffer / MAX_BUFFER_VALUE) > 0.666
                          ? Color.fromRGBO(236, 151, 20, 1)
                          : Colors.grey,
                    ),
                  ),
                  Container(
                    height: constraints.maxHeight,
                    width: constraints.maxHeight,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (widget.buffer / MAX_BUFFER_VALUE) > 0.95
                          ? Color.fromRGBO(236, 151, 20, 1)
                          : Colors.grey,
                    ),
                  ),
                  // blocBuider(){update ? }    7/s ??
                  // ValueNotifier ???
                ],
              );
            })
          ],
        ));
  }
}

String getImageFromBuffer(double buffer) {
  double percentage = buffer / MAX_BUFFER_VALUE;
  if (percentage < 0.33) {
    return "0";
  }
  if (percentage < 0.66) {
    return "1";
  }
  if (percentage < 0.95) {
    return "2";
  }
  return "3";
}


double getOpacityFromBuffer(double buffer){
  double percentage = buffer / MAX_BUFFER_VALUE;
  if(percentage < 0.33){
    return mapToRange(x: percentage, inMin: 0.0, inMax: 0.33);
  }
  if(percentage < 0.66){
    return mapToRange(x: percentage, inMin: 0.33, inMax: 0.66);
  }
  return mapToRange(x: percentage, inMin: 0.66, inMax: 1.0);
}

double mapToRange({double x, double inMin, double inMax, double outMin = 0.0, double outMax = 1.0}){
  return (x - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
}



/// Cool stuff, moght use later
/// 
/// 
/// 
/**
 * 
                return Container(
                  decoration: BoxDecoration(
                    color: notifier.darkTheme
                        ? Color.fromRGBO(13, 73, 0, (widget.buffer / MAX_BUFFER_VALUE) < 0.33 ? mapToRange(x: (widget.buffer / MAX_BUFFER_VALUE), inMin: 0.0, inMax: 0.33) : 1)
                        : Color.fromRGBO(154, 226, 137, (widget.buffer / MAX_BUFFER_VALUE) < 0.33 ? mapToRange(x: (widget.buffer / MAX_BUFFER_VALUE), inMin: 0.0, inMax: 0.33) : 1),
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxHeight / 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: notifier.darkTheme
                                  ? Color.fromRGBO(13, 73, 0, (widget.buffer / MAX_BUFFER_VALUE) < 0.33 ? mapToRange(x: (widget.buffer / MAX_BUFFER_VALUE), inMin: 0.0, inMax: 0.33) : 1)
                                  : Color.fromRGBO(154, 226, 137, (widget.buffer / MAX_BUFFER_VALUE) < 0.33 ? mapToRange(x: (widget.buffer / MAX_BUFFER_VALUE), inMin: 0.0, inMax: 0.33) : 1),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: (widget.buffer / MAX_BUFFER_VALUE) > 0.333
                                ? notifier.darkTheme
                                    ? Color.fromRGBO(120, 84, 0, (widget.buffer / MAX_BUFFER_VALUE) < 0.66 ? mapToRange(x: (widget.buffer / MAX_BUFFER_VALUE), inMin: 0.33, inMax: 0.66) : 1)
                                    : Color.fromRGBO(226, 220, 137, (widget.buffer / MAX_BUFFER_VALUE) < 0.66 ? mapToRange(x: (widget.buffer / MAX_BUFFER_VALUE), inMin: 0.33, inMax: 0.66) : 1)
                                : notifier.darkTheme
                                    ? Colors.grey[700]
                                    : Color.fromRGBO(214, 214, 214, 1),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: (widget.buffer / MAX_BUFFER_VALUE) > 0.666
                                  ? notifier.darkTheme
                                      ? Color.fromRGBO(155, 36, 0, mapToRange(x: (widget.buffer / MAX_BUFFER_VALUE), inMin: 0.66, inMax: 1.0))
                                      : Color.fromRGBO(227, 124, 124, mapToRange(x: (widget.buffer / MAX_BUFFER_VALUE), inMin: 0.66, inMax: 1.0))
                                  : notifier.darkTheme
                                      ? Colors.grey[700]
                                      : Color.fromRGBO(214, 214, 214, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              
 */