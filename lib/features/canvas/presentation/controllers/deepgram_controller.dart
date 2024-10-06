import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:deepgram_speech_to_text/deepgram_speech_to_text.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:socrita/core/constants/show_snack_bar.dart';
import 'package:socrita/features/canvas/presentation/controllers/home_controller.dart';
import 'package:socrita/secrets.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:toastification/toastification.dart';

class DeepgramController extends GetxController {
  final RxString _transcript = ''.obs;
  final RxString _sttStatus = 'Inactive'.obs;
  final RxBool _isRecording = false.obs;

  late Deepgram _deepgramTTS;
  late AudioPlayer _audioPlayer;
  final SpeechToText _speechToText = SpeechToText();
  bool speechEnabled = false;
  StreamSubscription<DeepgramSttResult>? _deepgramStreamSubscription;

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
    _audioPlayer = AudioPlayer();
    _setupAudioPlayerListeners();
  }

  String get transcript => _transcript.value;
  set transcript(String value) {
    _transcript.value = value;
  }

  String get sttStatus => _sttStatus.value;
  bool get isRecording => _isRecording.value;

  void _initSpeech() async {
    speechEnabled = await _speechToText.initialize();
  }

  Future<void> _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _transcript.value = result.recognizedWords;
  }

  void _setupAudioPlayerListeners() {
    _audioPlayer.onPlayerComplete.listen((_) {
      _sttStatus.value = 'Inactive';
    });

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        _sttStatus.value = 'Inactive';
      }
    });
  }

  Future<void> startListening() async {
    try {
      _isRecording.value = true;
      _audioPlayer.pause();
      _sttStatus.value = 'Listening';
      await _startListening();
    } catch (e) {
      print(e);
      showSnackBar(type: ToastificationType.error, msg: "Error in recording!");
    }
  }

  Future<void> stopListening() async {
    try {
      _isRecording.value = false;
      _sttStatus.value = 'Processing';
      await _stopListening();

      await _deepgramStreamSubscription?.cancel();
      if (_transcript.value != '') {
        final res =
            await Get.find<HomeController>().getResponse(_transcript.value);
        if (res.isNotEmpty) {
          await speak(res);
        }
      } else {
        _sttStatus.value = 'Inactive';
        _isRecording.value = false;
      }
      _transcript.value = '';
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> speak(String text) async {
    try {
      if (text.isNotEmpty) {
        _deepgramTTS = Deepgram(DEEPGRAM_API_KEY, baseQueryParams: {
          'model': Get.find<HomeController>().selectedAIVoice,
          'encoding': "linear16",
          'container': "wav",
        });
        final res = await _deepgramTTS.speakFromText("$text");
        _sttStatus.value = 'Speaking';

        if (kIsWeb) {
          await _audioPlayer.play(BytesSource(res.data));
        }
      }
    } catch (e) {
      print('Error in TTS: $e');
    }
  }

  @override
  void onClose() {
    _stopListening();
    _speechToText.cancel();
    _audioPlayer.dispose();
    _deepgramStreamSubscription?.cancel();
    super.onClose();
  }
}
