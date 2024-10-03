import 'dart:async';
import 'package:deepgram_speech_to_text/deepgram_speech_to_text.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:socrita/core/constants/show_snack_bar.dart';
import 'package:socrita/features/canvas/presentation/controllers/home_controller.dart';
import 'package:socrita/secrets.dart';
import 'package:toastification/toastification.dart';

class DeepgramController extends GetxController {
  final RxString _transcript = ''.obs;
  final RxString _sttStatus = 'Inactive'.obs;
  final RxBool _isRecording = false.obs;

  late Deepgram _deepgram;
  late Deepgram _deepgramTTS;
  late AudioRecorder _recorder;
  late AudioPlayer _audioPlayer;
  StreamSubscription<DeepgramSttResult>? _deepgramStreamSubscription;

  @override
  void onInit() {
    super.onInit();
    _deepgram = Deepgram(DEEPGRAM_API_KEY, baseQueryParams: {
      'model': 'nova-2-general',
      'detect_language': true,
      'filler_words': false,
      'punctuation': true,
    });
    _recorder = AudioRecorder();
    _audioPlayer = AudioPlayer();
    _setupAudioPlayerListeners();
  }

  String get transcript => _transcript.value;
  set transcript(String value) {
    _transcript.value = value;
  }

  String get sttStatus => _sttStatus.value;
  bool get isRecording => _isRecording.value;

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
      if (await _recorder.hasPermission()) {
        _audioPlayer.pause();
        _sttStatus.value = 'Listening';
        _isRecording.value = true;
        _transcript.value = '';

        Stream<List<int>> micStream =
            await _recorder.startStream(const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 16000,
          numChannels: 1,
        ));

        print(sttStatus);

        final streamParams = {
          'detect_language': false,
          'language': 'en',
          'encoding': 'linear16',
          'sample_rate': 16000,
        };

        Stream<DeepgramSttResult> stream =
            _deepgram.transcribeFromLiveAudioStream(micStream,
                queryParams: streamParams);

        _deepgramStreamSubscription = stream.listen((res) {
          if (res.transcript != null && res.transcript!.isNotEmpty) {
            _transcript.value += ' ${res.transcript!}';
            print("Transcript: ${res.transcript}");
          }
        });
      } else {
        print("no per");
        // Request microphone permission
      }
    } catch (e) {
      showSnackBar(type: ToastificationType.error, msg: "Error in recording!");
    }
  }

  Future<void> stopListening() async {
    try {
      _isRecording.value = false;
      _sttStatus.value = 'Processing';

      print(sttStatus);
      // await Future.delayed(const Duration(seconds: 1));
      await _recorder.stop();
      await _deepgramStreamSubscription?.cancel();
      if (_transcript.value != '') {
        print("hey");
        await Get.find<HomeController>().getResponse(_transcript.value);
        String messageText = Get.find<HomeController>().newChats.last.text;

        // ? (Get.find<HomeController>().chats.last.parts.last as TextPart)
        //     .text
        // : 'Sorry I am not able to process, can you please repeate your question?';
        await speak(messageText);
      } else {
        _sttStatus.value = 'Inactive';
      }
      _transcript.value = '';
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> speak(String text) async {
    try {
      print("print");
      if (text.isNotEmpty) {
        _deepgramTTS = Deepgram(DEEPGRAM_API_KEY, baseQueryParams: {
          'model': Get.find<HomeController>().selectedAIVoice,
          'encoding': "linear16",
          'container': "wav",
        });
        print("print");
        final res = await _deepgramTTS.speakFromText("$text");
        _sttStatus.value = 'Speaking';

        print(sttStatus);
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
    _recorder.dispose();
    _audioPlayer.dispose();
    _deepgramStreamSubscription?.cancel();
    super.onClose();
  }
}
