import 'dart:io';

import 'package:flutter/services.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:soundpool/soundpool.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'dart:async';

Soundpool _soundpool;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _soundpool = new Soundpool();
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isRecording = false;
  StreamSubscription<NoiseReading> _noiseSubscription;
  NoiseMeter _noiseMeter;
  Soundpool pool = Soundpool(streamType: StreamType.notification);
  Future<int> soundId;
  int _soundStreamId;
  double volume;
  Timer timer;
  bool playing = false;

  void requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage,
    ].request();
    print(statuses.toString());
  }

  Future<int> _loadSound() async {
    var asset = await rootBundle.load("lib/assets/Shhh-sound.mp3");
    return await _soundpool.load(asset);
  }

  @override
  void initState() {
    super.initState();
    soundId = _loadSound();
    _noiseMeter = new NoiseMeter();
    volume = 50.0;
  }

  // ignore: missing_return
  Future<void> onData(NoiseReading noiseReading) {
    this.setState(() {
      if (!this._isRecording) {
        this._isRecording = true;
      }
    });

    //delay for a sec?
    timer = Timer(Duration(seconds: 1, milliseconds: 500), () {
      playing = !playing;
      print("playing : " + playing.toString());
    });

    //checks if shit too loud
    if (noiseReading.meanDecibel >= volume && playing) {
    // if (noiseReading.meanDecibel >= volume) {
      // sleep(Duration(seconds: 1)); //razjebe se živo ništa od ovoga
      print("playing sound: ");
      _playSound();
    }

    print(noiseReading.toString());
  }

  void start() async {
    try {
      _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
    } catch (exception) {
      print(exception);
    }
  }

  Future<void> _playSound() async {
    var _alarmSound = await soundId;
    _soundStreamId = await _soundpool.play(_alarmSound);
  }

  void stopRecorder() async {
    try {
      if (_noiseSubscription != null) {
        _noiseSubscription.cancel();
        _noiseSubscription = null;
      }
      this.setState(() {
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shush',
      theme: ThemeData(
        // brightness: Brightness.dark, //dark mode UwU
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.yellow[800],
            fontSize: 70.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: Scaffold(
        body: new Container(
          padding: EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Shush',
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(height: 100.0),
                RaisedButton(
                  onPressed: () {
                    start();
                  },
                  child: Text(
                    'Start listening!',
                    style: TextStyle(
                      fontSize: 25.0,
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
                RaisedButton(
                  onPressed: () async {
                    // requestPermission();
                    print("playing sound: ");
                    _playSound();
                  },
                  child: Text(
                    'Grant me permissions',
                    style: TextStyle(
                      fontSize: 25.0,
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
                RaisedButton(
                  onPressed: () async {
                    stopRecorder();
                    print("STOPPED RECORDING");
                  },
                  child: Text(
                    'stop',
                    style: TextStyle(
                      fontSize: 25.0,
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
                SizedBox(height: 40.0),
                SliderTheme(
                  data: SliderThemeData(),
                  child: Slider(
                    activeColor: Colors.yellow[800],
                    inactiveColor: Colors.grey[300],
                    min: 0.0, //sidenote, 50.0 je već otprilike šum sobe kad senine događa
                    max: 100.0, //bar ča se tiče PCMa mog mobitela
                    value: volume,
                    onChanged: (newVolume) {
                      setState(() => volume = newVolume);
                      print("slider dB value: ");
                      print(volume);
                    },
                  ),
                ),
                SizedBox(height: 30.0),
                Row(
                  children: <Widget>[
                    SizedBox(width: 40.0),
                    Icon(
                      Icons.volume_up,
                      color: Colors.grey[600],
                      size: 30.0,
                    ),
                    SizedBox(width: 30.0),
                    Text(
                      'dB input volume: ',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(width: 30.0),
                    Text(
                      volume.round().toString(),
                      style: TextStyle(
                        fontSize: 20.0,
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
