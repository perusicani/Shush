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
  int _alarmSoundStreamId;
  Future<int> _soundId;

  bool _isRecording = false;
  StreamSubscription<NoiseReading> _noiseSubscription;
  NoiseMeter _noiseMeter = new NoiseMeter();
  double volume;
  double originalVolume;
  bool playing = false;

  double buffer = 0;
  int i = 40; //inicijalih 6 sec
  int j = 0;  //ako se predugo buffer drži 0-i (npr 300), ovo restarta i i sebe
  int played =
      -1; //how many times did the app play the sound (nakon cca 4 puta odustani)
      // -1 da se slaže s indeksom zvuka --> manje varijabli ja se nadan

  String soundPath = "lib/assets/Shhh-sound.mp3";

  Future<int> _loadSound(String path) async {
    var asset = await rootBundle.load(path);
    return await _soundpool.load(asset);
  }

  Future<void> _playSound() async {
    var _alarmSound = await _soundId;
    _alarmSoundStreamId = await _soundpool.play(_alarmSound);
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
        i = 40;
        j = 0;
        volume = originalVolume;
        played = 0;
        print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
      }

      //ako buffer val veći od inicijalnih 6 sec, play sound
      // pukne aaaaaaaaa ali je buffer već napunjen!!!!!!
      // TODO PLS FIX
      if (buffer >= i) {
        i += 40; //+40 va i value (dodaj 6 sec)
        print("i value : " + i.toString());

        volume = noiseReading
            .meanDecibel; //povisi threshold na meanDecibel, odnosno triba bit glasniji nego ča je bilo do sada (kasnije kada se isprazni buffer vrati na og volume value)

        print("volume on update: " + volume.toString());

        played++;
        print("played value: " + played.toString());
        if (played < 4) {
          //implementirat puštanje određenih zvuka iz sound packa (array ili čagodre)
          _playSound();
        } else {

          //  final sound played situation?

        } 
      }
    } else if (noiseReading.meanDecibel < volume && buffer > 0) {
      buffer -=
          0.5; //ako se spustilo spod thresholda i buffer nije prazan, prazni buffer
      if (buffer == 0) {   //ako dovoljno dugo tiho da se buffer stigne ispraznit
        played = 0; //ššš sound vrati na početni najtiši
        volume =
            originalVolume; //stavi volume koji se koristi na og volume koji je određen od korisnika
        i = 40; //vrati controlnu var na start da opet za šest sec more srat ovaj
        print("values on buffer == 0: " + "\nplayed: " + played.toString() + "\nvolume: " + volume.toString() + "\ni: " + i.toString() + "\n");
      }
    }
    // });
    print(noiseReading.toString());
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
    played = 0;
  }

  //probs not neccssary, on start listen sam pita
  // void requestPermission() async {
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.microphone,
  //     Permission.storage,
  //   ].request();
  //   print(statuses.toString());
  // }

  @override
  Stream<ListeningState> mapEventToState(
    ListeningEvent event,
  ) async* {
    if (event is StartListening) {

      // requestPermission();

      volume = event.volume;
      originalVolume = event.volume; //pamti volume koji je korisnik odredio
      _soundId = _loadSound(soundPath); //uzimat će string (path od asseta)

      start();
      print("STARTED");
      yield Listening();
    }
    if (event is StopListening) {
      stop();
      print("STOPPED");
      yield NotListening();
    }
  }
}
