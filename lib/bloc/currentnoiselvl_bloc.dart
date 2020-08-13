import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:noise_meter/noise_meter.dart';

part 'currentnoiselvl_event.dart';
part 'currentnoiselvl_state.dart';

class CurrentnoiselvlBloc
    extends Bloc<CurrentnoiselvlEvent, CurrentnoiselvlState> {
  CurrentnoiselvlBloc() : super(CurrentnoiselvlInitial());

  bool _isRecording = false;
  StreamSubscription<NoiseReading> _noiseSubscription;
  NoiseMeter _noiseMeter = new NoiseMeter();
  double data;

  void start() async {
    try {
      _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
    } catch (err) {
      print(err);
    }
  }

  Stream<void> something(double data) async* {
    print("#data in something:" + data.toString());
    yield ListeningCurrentNoiseLvl(data: data);
  }


  void onData(NoiseReading noiseReading) {
    
    if (!this._isRecording) {
      this._isRecording = true;
    }

    data = noiseReading.meanDecibel;
    print("current noise data = " + data.toString());

    something(data);
  }

  void stopRecorder() async {
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
  }

  @override
  Stream<CurrentnoiselvlState> mapEventToState(
    CurrentnoiselvlEvent event,
  ) async* {
    if (event is StartListeningCurrentNoiseLvl) {
      start();
      yield ListeningCurrentNoiseLvl(data: data);
    }
    if (event is StopListeningCurrentNoiseLvl) {
      stopRecorder();
    }
  }
}
