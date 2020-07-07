import 'package:flutter/material.dart';
import 'package:Shush/bloc/listening_bloc.dart';
import 'package:Shush/styles/main_text.dart';
import 'package:permission_handler/permission_handler.dart';

class NotListeningPage extends StatefulWidget {
  final ListeningBloc listeningBloc;
  NotListeningPage({this.listeningBloc});

  @override
  _NotListeningPageState createState() => _NotListeningPageState();
}

class _NotListeningPageState extends State<NotListeningPage> {
  double volume = 70.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      color: Colors.grey.withOpacity(0.4), //TODO bolje ovo? ili onaj drugi color
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          "App description",
                                          style: TextStyle(
                                            fontSize: 25.0,
                                            fontFamily: 'OpenSansCondensed',
                                            letterSpacing: 4.0,
                                            color: Colors.yellow[800]
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.0),
                                      Center(
                                        child: Text(
                                          "The point is you should shut up",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontFamily: 'OpenSansCondensed',
                                            letterSpacing: 2.0,
                                            color: Colors.grey.withOpacity(0.8),
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
                    SizedBox(width: 20.0),
                    IconButton(
                      // za permissions ako seljak neki deny-a i nezna doć do app settings
                      // at least for now
                      // dodat još ili odabir voice packa ili još neke retardacije ke mi padu na pamet i actually ih stignen implementirt
                      icon: Icon(Icons.settings),
                      color: Colors.yellow[800].withOpacity(0.4),
                      onPressed: () {
                        openAppSettings();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 58.0),
                Text(
                  'Shush',
                  style: mainText(),
                ),
                SizedBox(height: 30.0),
                RaisedButton(
                  onPressed: () {

                    widget.listeningBloc.add(StartListening(volume: volume));
                  },
                  child: Text(
                    'Start Listening',
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
                SizedBox(height: 150.0),
                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.yellow[800], width: 3.0),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Slider(
                    activeColor: Colors.yellow[800],
                    inactiveColor: Colors.grey[300],
                    min:
                        20.0, //sidenote, 50.0 je već otprilike šum sobe kad se niš ne događa
                    max: 120.0, //bar ča se tiče PCMa mog mobitela
                    value: volume,
                    onChanged: (newVolume) {
                      setState(() => volume = newVolume);
                    },
                  ),
                ),
                SizedBox(height: 30.0),
                Row(
                  children: <Widget>[
                    SizedBox(width: 40.0),
                    Icon(
                      Icons.volume_up,
                      color: Colors.grey.withOpacity(0.8),
                      size: 30.0,
                    ),
                    SizedBox(width: 30.0),
                    Text(
                      'dB input volume: ',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'OpenSansCondensed',
                        letterSpacing: 3.0,
                      ),
                    ),
                    SizedBox(width: 30.0),
                    Text(
                      volume.round().toString(),
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'OpenSansCondensed',
                        letterSpacing: 3.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
