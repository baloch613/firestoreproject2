import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AudioController extends GetxController {
  final _isRecordPlaying = false.obs;
  final _currentId = 999999.obs;
  final start = DateTime.now().obs;
  final end = DateTime.now().obs;

  String _total = "";
  String get total => _total;

  var completedPercentage = 0.0.obs;
  var currentDuration = 0.obs; // Updated to store in **seconds**
  var totalDuration = 0.obs; // Updated to store in **seconds**
  var remainingDuration = 0.obs; // Stores remaining time (counts down)
  bool get isRecordPlaying => _isRecordPlaying.value;
  int get currentId => _currentId.value;

  late final AudioPlayerService _audioPlayerService;

  @override
  void onInit() {
    _audioPlayerService = AudioPlayerAdapter();

    // _audioPlayerService.getAudioPlayer.onDurationChanged.listen((duration) {
    //   totalDuration.value = duration.inSeconds; // Store in seconds
    // });

    // _audioPlayerService.getAudioPlayer.onPositionChanged.listen((duration) {
    //   currentDuration.value = duration.inSeconds; // Store in seconds
    //   completedPercentage.value = currentDuration.value / totalDuration.value;
    // });

    // _audioPlayerService.getAudioPlayer.onPlayerComplete.listen((event) async {
    //   await _audioPlayerService.getAudioPlayer.seek(Duration.zero);
    //   _isRecordPlaying.value = false;
    //   currentDuration.value = 0; // Reset duration
    //   completedPercentage.value = 0.0;
    // });
    _audioPlayerService.getAudioPlayer.onDurationChanged.listen((duration) {
      totalDuration.value = duration.inSeconds;
      remainingDuration.value = duration.inSeconds; // Initialize remaining time
    });

    _audioPlayerService.getAudioPlayer.onPositionChanged.listen((duration) {
      currentDuration.value = duration.inSeconds;
      remainingDuration.value =
          totalDuration.value - currentDuration.value; // Countdown
      completedPercentage.value = currentDuration.value / totalDuration.value;
    });

    _audioPlayerService.getAudioPlayer.onPlayerComplete.listen((event) async {
      await _audioPlayerService.getAudioPlayer.seek(Duration.zero);
      _isRecordPlaying.value = false;
      currentDuration.value = 0;
      remainingDuration.value = totalDuration.value; // Reset countdown
      completedPercentage.value = 0.0;
    });

    super.onInit();
  }

  @override
  void onClose() {
    _audioPlayerService.dispose();
    super.onClose();
  }

  void onPressedPlayButton(int id, String content) async {
    _currentId.value = id;
    if (isRecordPlaying) {
      await _pauseRecord();
    } else {
      _isRecordPlaying.value = true;
      await _audioPlayerService.play(content);
    }
  }

  void calcDuration() {
    var a = end.value.difference(start.value).inSeconds;
    _total = "$a"; // Store only seconds
  }

  Future<void> _pauseRecord() async {
    _isRecordPlaying.value = false;
    await _audioPlayerService.pause();
  }

  /// Returns formatted remaining time (e.g., `30s`)
  String getRemainingTime() {
    return "${remainingDuration.value}s";
  }
}

abstract class AudioPlayerService {
  void dispose();
  Future<void> play(String url);
  Future<void> resume();
  Future<void> pause();
  Future<void> release();

  AudioPlayer get getAudioPlayer;
}

class AudioPlayerAdapter implements AudioPlayerService {
  late AudioPlayer _audioPlayer;

  @override
  AudioPlayer get getAudioPlayer => _audioPlayer;

  AudioPlayerAdapter() {
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() async {
    await _audioPlayer.dispose();
  }

  @override
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> play(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  @override
  Future<void> release() async {
    await _audioPlayer.release();
  }

  @override
  Future<void> resume() async {
    await _audioPlayer.resume();
  }
}

class AudioDuration {
  static double calculate(Duration soundDuration) {
    if (soundDuration.inSeconds > 60) {
      return 70.w;
    } else if (soundDuration.inSeconds > 50) {
      return 65.w;
    } else if (soundDuration.inSeconds > 40) {
      return 60.w;
    } else if (soundDuration.inSeconds > 30) {
      return 55.w;
    } else if (soundDuration.inSeconds > 20) {
      return 50.w;
    } else if (soundDuration.inSeconds > 10) {
      return 45.w;
    } else {
      return 40.w;
    }
  }
}
