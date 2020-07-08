import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:soundpool/soundpool.dart';
import 'package:permission_handler/permission_handler.dart';

part 'listening_event.dart';
part 'listening_state.dart';

class ListeningBloc extends Bloc<ListeningEvent, ListeningState> {
  ListeningBloc() : super(ListeningInitial());

  Soundpool _soundpool = Soundpool();
  int _alarmSoundStreamId;  //kao unused ne laži
  Future<int> _soundId0, _soundId1, _soundId2, _soundId3;

  bool _isRecording = false;
  StreamSubscription<NoiseReading> _noiseSubscription;
  NoiseMeter _noiseMeter = new NoiseMeter();
  double volume;
  double originalVolume;
  bool playing = false;

  double buffer = 0;
  int i = 40; //inicijalih 6 sec
  int j = 0; //ako se predugo buffer drži 0-i (npr 300), ovo restarta i i sebe
  int played =
      -1; //how many times did the app play the sound (nakon cca 4 puta odustani)
  // -1 da se slaže s indeksom zvuka --> manje varijabli ja se nadan
  int k = 0; //control var for AAAAAAA situation

  String soundPath = "lib/assets/test_voice/Shhh-sound";
  // String soundPathOG = "lib/assets/Shhh-sound.mp3";

  Future<int> _loadSound(String path) async {
    var asset = await rootBundle.load(path);
    return await _soundpool.load(asset);
  }

  //  NEMRE
  // Map<int, Future<int>> mapPlayedToSoundId = {
  //   0 : _soundId0,
  //   1 : _soundId1,
  //   2 : _soundId2,
  //   3 : _soundId3
  // };

  Future<void> _playSound(int number) async {
    //inače bez param int number
    // var _alarmSound = await _soundId0;  //_soundId
    // _alarmSoundStreamId = await _soundpool.play(_alarmSound);

    if (number == 0) {
      var _alarmSound = await _soundId0; //_soundId
      _alarmSoundStreamId = await _soundpool.play(_alarmSound);
    } else if (number == 1) {
      var _alarmSound = await _soundId1; //_soundId
      _alarmSoundStreamId = await _soundpool.play(_alarmSound);
    } else if (number == 2) {
      var _alarmSound = await _soundId2; //_soundId
      _alarmSoundStreamId = await _soundpool.play(_alarmSound);
    } else {
      var _alarmSound = await _soundId3; //_soundId
      _alarmSoundStreamId = await _soundpool.play(_alarmSound);
    }
  }

  void onData(NoiseReading noiseReading) {
    // this.setState(() {
    if (!this._isRecording) {
      this._isRecording = true;
    }

    // buffer ni vrit ni mimo određeno vrime
    if (buffer > 1 && buffer > 0) {
      j++;
    } else {
      j--;
    }

    print("buffer value: " + buffer.toString());
    print("volume value: " + volume.toString());

    if (noiseReading.meanDecibel >= volume) {
      buffer++;

      if (j > 300) {
        k = 7; //ekvivalent čekanja sekunde
        i = 40;
        j = 0;
        volume = originalVolume;
        played = -1;
        print(
            "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
      }

      if (k > 0) {
        k--;
        print("k value on decrease: " + k.toString());
        print("UwU");
      }

      if (buffer >= i) {
        i += 40; //+40 va i value (dodaj 6 sec)
        print("i value : " + i.toString());
        print("k value : " + k.toString());

        volume = noiseReading
            .meanDecibel; //povisi threshold na meanDecibel, odnosno triba bit glasniji nego ča je bilo do sada (kasnije kada se isprazni buffer vrati na og volume value)

        print("volume on update: " + volume.toString());

        played++;
        print("played value: " + played.toString());
        if (played < 4 && k == 0) {
          //implementirat puštanje određenih zvuka iz voice packa (array ili čagodre)
          _playSound(played); //bez param OG played
        } else {
          //  final sound played situation?

        }
      }
    } else if (noiseReading.meanDecibel < volume && buffer > 0) {
      buffer -=
          0.5; //ako se spustilo spod thresholda i buffer nije prazan, prazni buffer
      if (buffer == 0) {
        //ako dovoljno dugo tiho da se buffer stigne ispraznit
        played = -1; //ššš sound vrati na početni najtiši
        volume =
            originalVolume; //stavi volume koji se koristi na og volume koji je određen od korisnika
        i = 40; //vrati controlnu var na start da opet za šest sec more srat ovaj
        print("values on buffer == 0: " +
            "\nplayed: " +
            played.toString() +
            "\nvolume: " +
            volume.toString() +
            "\ni: " +
            i.toString() +
            "\n");
      }
    }
    // });
    // print(noiseReading.toString());
  }

  void start() async {
    try {
      print("buffer value on start: " + buffer.toString());
      print("i value on start: " + i.toString());
      print("played value on start: " + played.toString());
      _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
    } catch (err) {
      print(err);
    }
  }

  void stop() async {
    try {
      if (_noiseSubscription != null) {
        _noiseSubscription.cancel();
        _noiseSubscription = null;
      }
      // this.setState(() {
      this._isRecording = false;
      // });
    } catch (err) {
      print('stopRecorder error: $err');
    }
    buffer = 0;
    i = 40;
    played = -1;
  }

  @override
  Stream<ListeningState> mapEventToState(
    ListeningEvent event,
  ) async* {
    if (event is StartListening) {
      // stupid fucking permission handled
      if (await Permission.microphone.request().isGranted) {
        // soundPath = event.path;    TODO UNCOMMENT WHEN IMPLEMENTED FINAL SOUND PACKS
        volume = event.volume;
        originalVolume = event.volume; //pamti volume ki odredi user
        _soundId0 = _loadSound(soundPath + "0.mp3");
        print(soundPath + "0.mp3");
        _soundId1 = _loadSound(soundPath + "1.mp3");
        print(soundPath + "1.mp3");
        _soundId2 = _loadSound(soundPath + "2.mp3");
        print(soundPath + "2.mp3");
        _soundId3 = _loadSound(soundPath + "3.mp3");
        print(soundPath + "3.mp3");

        // og
        // _soundId = _loadSound(soundPathOG);

        start();
        print("STARTED");
        yield Listening();
      } else {
        yield NotListening();
      }
    }
    if (event is StopListening) {
      stop();
      print("STOPPED");
      yield NotListening();
    }
  }
}
