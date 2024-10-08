import 'dart:async';
import 'package:deepgram_speech_to_text/deepgram_speech_to_text.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:socrita/features/canvas/presentation/controllers/home_controller.dart';
import 'package:socrita/secrets.dart';

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
  }

  String get transcript => _transcript.value;
  set transcript(String value) {
    _transcript.value = value;
  }

  String get sttStatus => _sttStatus.value;
  bool get isRecording => _isRecording.value;

  Future<void> startListening() async {
    try {
      if (await _recorder.hasPermission()) {
        _sttStatus.value = 'Listening...';
        _isRecording.value = true;
        _transcript.value = '';
        print("listening");

        Stream<List<int>> micStream =
            await _recorder.startStream(const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 16000,
          numChannels: 1,
        ));

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
      print("err: $e");
    }
  }

  Future<void> stopListening() async {
    try {
      _isRecording.value = false;
      await Future.delayed(Duration(seconds: 2));
      print("processing");
      await _recorder.stop();
      await _deepgramStreamSubscription?.cancel();
      _sttStatus.value = 'Processing...';
      if (_transcript.value != '') {
        await Get.find<HomeController>().getResponse(_transcript.value);
        String messageText = Get.find<HomeController>().chats.last.parts.last
                is TextPart
            ? (Get.find<HomeController>().chats.last.parts.last as TextPart)
                .text
            : 'Sorry I am not able to process, can you please repeate your question?';
        await speak(messageText);
      }
      _transcript.value = '';
      _sttStatus.value = 'Inactive';
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
