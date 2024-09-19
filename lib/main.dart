import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart' as livekit;
import 'package:smart_calculator/core/theme/app_theme.dart';
import 'package:smart_calculator/features/calculator/presentation/controller/calculator_controller.dart';
import 'package:smart_calculator/features/calculator/presentation/pages/calculator_screen.dart';
import 'package:smart_calculator/secrets.dart';

// import 'features/calculator/presentation/pages/vid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(CalculatorController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1536, 729.60),
      builder: (context, child) {
        return MaterialApp(
          title: 'Smart Calculator',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkThemeMode,
          home: const CalculatorScreen(),
          // home: FutureBuilder<livekit.Room>(
          //   future: connectToRoom(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       if (snapshot.hasData) {
          //         return VideoCallScreen(room: snapshot.data!);
          //       } else {
          //         return const Text('Failed to connect to room');
          //       }
          //     } else {
          //       return const CircularProgressIndicator();
          //     }
          //   },
          // ),
        );
      },
    );
  }
}

Future<livekit.Room> connectToRoom() async {
  final roomOptions = const livekit.RoomOptions(
    adaptiveStream: true,
    dynacast: true,
  );

  final room = livekit.Room(
    connectOptions:
        livekit.ConnectOptions(rtcConfiguration: livekit.RTCConfiguration()),
  );

  await room.connect(
    LIVEKIT_URL,
    TOKEN,
    roomOptions: roomOptions,
  );

  try {
    await room.localParticipant!.setMicrophoneEnabled(true);
    await room.localParticipant!.setCameraEnabled(true);
    await room.localParticipant!.setScreenShareEnabled(true);

    var localVideo = await livekit.LocalVideoTrack.createCameraTrack();
    await room.localParticipant!.publishVideoTrack(localVideo);
  } catch (error) {
    print('Could not publish video, error: $error');
  }

  return room;
}
