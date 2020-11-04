import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';

/// event states
///

abstract class ShushEventState extends Equatable {}

class ShushStartListening extends ShushEventState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ShushStopListening extends ShushEventState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ShushInitial extends ShushEventState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ShushListening extends ShushEventState {
  final double buffer;
  final double data;
  ShushListening({this.buffer, this.data});

  List<Object> get props => [buffer, data];
}

class ShushBloc extends Bloc<ShushEventState, ShushEventState> {
  ShushBloc() : super(ShushInitial());

  Soundpool _soundpool = Soundpool();
  Future<int> _soundId0, _soundId1, _soundId2; // _soundId3;

  bool _isRecording = false;
  StreamSubscription<NoiseReading> _noiseSubscription;
  NoiseMeter _noiseMeter = NoiseMeter();
  double _volume = 90;
  double _originalVolume;
  bool playing = false;

  double data;

  double buffer = 0;
  int i = 46; //inicijalih 6 sec
  int j = 0; //ako se predugo buffer drži 0-i (npr 300), ovo restarta i i sebe
  int played =
      -1; //how many times did the app play the sound (nakon cca 4 puta odustani)
  int k = 0; //control var for AAAAAAA situation

  //shit that gotta persist
  bool gender;

  String soundPath = "lib/assets/male_voice/Shhh-sound";
  String lang = "English";

  int testValue = 0;

  init() async {
    _originalVolume = _volume;
    await checkSP();

    soundPath ??= "lib/assets/male_voice/Shhh-sound";
    //again, default to English just in case
    lang ??= "English";

    _soundId0 = _loadSound(soundPath + "1.mp3"); //b4 0
    print(soundPath + "1.mp3");
    _soundId1 = _loadSound(soundPath + "2.mp3"); //b4 1
    print(soundPath + "2.mp3");
    // _soundId2 = _loadSound(soundPath + "2.mp3");
    // print(soundPath + "2.mp3");
    //_soundId3 = _loadSound(soundPath + "3.mp3");  <-- og
    _soundId2 = _loadSound(soundPath + "3" + "-" + lang + ".mp3"); //b4 soundid3
    print(soundPath + "3" + "-" + lang + ".mp3");

    buffer = 0;
  }

  Future<void> checkSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('gender') == null) {
      //ako ni namešćen, default
      await prefs.setBool('gender', true);
    } else {
      gender = prefs.getBool('gender');
      if (gender) {
        soundPath = "lib/assets/male_voice/Shhh-sound";
      } else {
        soundPath = "lib/assets/female_voice/Shhh-sound";
      }
      print("Soundpath in bloc is : " + soundPath);
    }
    lang = prefs.getString('lang');
  }

  Future<int> _loadSound(String path) async {
    var asset = await rootBundle.load(path);
    return await _soundpool.load(asset);
  }

  @override
  Future<void> close() async {
    await stop();
    return super.close();
  }

  Future<void> _playSound(int number) async {
    if (number == 0) {
      var _alarmSound = await _soundId0; //_soundId
      _soundpool.play(_alarmSound);
    } else if (number == 1) {
      var _alarmSound = await _soundId1; //_soundId
      _soundpool.play(_alarmSound);
    } else {
      var _alarmSound = await _soundId2; //_soundId
      _soundpool.play(_alarmSound);
    }
  }

  void onData(NoiseReading noiseReading) {
    testValue += 1;

    if (!this._isRecording) {
      this._isRecording = true;
    }

    // buffer ni vrit ni mimo određeno vrime
    if (buffer > 1 && buffer > 0) {
      j++;
    } else {
      j--;
    }
    // print(" noise reading  " + noiseReading.meanDecibel.toString());
    // print(" set volume  " + _volume.toString());
    if (noiseReading.meanDecibel >= _volume && playing) {
      if (buffer < 140) {
        //buffer += 0.5;
        //ako noisereading puno veći od volume (za sad 150%volume-a)
        if (noiseReading.meanDecibel > (_volume * 1.5)) {
          //brže puni --> nezz +1
          buffer += 1;
        } else {
          //inače
          //puni normalno +.5
          buffer += 0.5;
        }
      }

      //ako je predugo buffer između
      if (j > 300) {
        k = 7; //ekvivalent čekanja sekunde
        i = 46;
        j = 0;
        _volume = _originalVolume;
        played = -1;
        print(
            "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
      }

      //čekanje između play sounda
      if (k > 0) {
        k--;
        print("k value on decrease: " + k.toString());
      }

      if (buffer >= i) {
        i += 46; //+46 va i value (dodaj 6 sec)

        //povisi threshold na meanDecibel, odnosno triba bit glasniji nego ča je bilo do sada (kasnije kada se isprazni buffer vrati na og volume value)
        // volume = noiseReading
        //     .meanDecibel;

        played++;
        print("played value: " + played.toString());
        if (playing && played < 3 && k == 0) {
          //played b4  < 4
          _playSound(played);
        }
      }
    } else if (noiseReading.meanDecibel < _volume && buffer > 0) {
      buffer -=
          0.5; //ako se spustilo spod thresholda i buffer nije prazan, prazni buffer
      if (buffer == 0) {
        //ako dovoljno dugo tiho da se buffer stigne ispraznit
        played = -1; //ššš sound vrati na početni najtiši
        _volume =
            _originalVolume; //stavi volume koji se koristi na og volume koji je određen od korisnika
        i = 46; //vrati controlnu var na start da opet za šest sec more srat ovaj
        print("reseted values because buffer empty");
      }
    }

    data = noiseReading.meanDecibel;

    add(ShushListening(buffer: buffer, data: data));
  }

  void start() {
    try {
      _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
    } catch (err) {
      print(err);
    }
  }

  Future<void> stop() async {
    try {
      if (_noiseSubscription != null) {
        await _noiseSubscription.cancel();
        _noiseSubscription = null;
      }
      this._isRecording = false;
    } catch (err) {
      print('stopRecorder error: $err');
    }
    buffer = 0;
    i = 46;
    played = -1;
  }

  setVolume(double volume) {
    _volume = volume;
    _originalVolume = volume;
  }

  double getVolume() {
    return _volume;
  }

  @override
  Stream<ShushEventState> mapEventToState(ShushEventState event) async* {
    if (event is ShushListening) {
      print("noise sent to ui " + event.data.toString());
      yield ShushListening(buffer: event.buffer, data: event.data);
    }
    if (event is ShushStartListening) {
      Permission.microphone.request().then((value) {
        if (value == PermissionStatus.granted) {
          start();
        }
      });
    }

    if (event is ShushStopListening) {
      yield ShushInitial();
      stop();
    }
  }
}
