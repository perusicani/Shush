import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';
import 'package:permission_handler/permission_handler.dart';

part 'listening_event.dart';
part 'listening_state.dart';

class ListeningBloc extends Bloc<ListeningEvent, ListeningState> {
  ListeningBloc() : super(ListeningInitial());

  Soundpool _soundpool = Soundpool();
  int _alarmSoundStreamId; //kao unused ne laži
  Future<int> _soundId0, _soundId1, _soundId2, _soundId3;

  bool _isRecording = false;
  StreamSubscription<NoiseReading> _noiseSubscription;
  NoiseMeter _noiseMeter = new NoiseMeter();
  double volume;
  double originalVolume;
  bool playing = false;

  double data;

  double buffer = 0;
  int i = 40; //inicijalih 6 sec
  int j = 0; //ako se predugo buffer drži 0-i (npr 300), ovo restarta i i sebe
  int played =
      -1; //how many times did the app play the sound (nakon cca 4 puta odustani)
  int k = 0; //control var for AAAAAAA situation

  //shit that gotta persist
  bool gender;

  String soundPath;

  void checkSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('gender') == null) {
      //ako ni namešćen, default
      await prefs.setBool('gender', true);
    } else {
      gender = prefs.getBool('gender'); //ako je ulovi ga
      if (gender) {
        soundPath = "lib/assets/male_voice/Shhh-sound";
      } else {
        soundPath = "lib/assets/female_voice/Shhh-sound";
      }
      print("Soundpath in bloc is : " + soundPath);
    }
    print("gender set to " +
        gender.toString() +
        " in bloc shit fucking hell this is giving me nightmares also depression is hitting again, life is pain");
  }

  Future<int> _loadSound(String path) async {
    var asset = await rootBundle.load(path);
    return await _soundpool.load(asset);
  }

  Future<void> _playSound(int number) async {
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
    if (!this._isRecording) {
      this._isRecording = true;
    }

    // buffer ni vrit ni mimo određeno vrime
    if (buffer > 1 && buffer > 0) {
      j++;
    } else {
      j--;
    }

    // print("buffer value: " + buffer.toString());
    // print("volume value: " + volume.toString());

    if (noiseReading.meanDecibel >= volume) {
      if (buffer < 140) buffer += 0.5;  //TODO not good fix, indicator goes only to 100 but dB goes above

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
          _playSound(played);
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

    data = noiseReading.meanDecibel;

    add(UpdateListening());
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
      // ignore: await_only_futures
      await checkSP();
      // stupid fucking permission handled
      if (await Permission.microphone.request().isGranted) {
        //ako ništa ne odabrano, default je male (aš san isto sexist UwU)
        soundPath ??= "lib/assets/male_voice/Shhh-sound";
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

        buffer = 0;

        start();
        print("STARTED");
        yield Listening();
      } else {
        yield NotListening(gender: gender);
      }
    }
    if (event is StopListening) {
      // ignore: await_only_futures
      await checkSP();
      stop();
      print("STOPPED");
      yield NotListening(gender: gender);
    }
    if (event is UpdateListening) {
      // print("on yield update listening buffer value = " + buffer.toString());
      // print("on yield updatelistening data value = " + data.toString());
      yield UpdatedListening(buffer: buffer, data: data);
    }
  }
}
