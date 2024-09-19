import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

import 'video_screen.dart';

class VideoCallScreen extends StatefulWidget {
  final Room room;

  const VideoCallScreen({Key? key, required this.room}) : super(key: key);

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Call')),
      body: Column(
        children: [
          Expanded(
            child: VideoView(widget.room.localParticipant!),
          ),
          ElevatedButton(
            onPressed: () async {
              await widget.room.disconnect();
              Navigator.of(context).pop();
            },
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );
  }
}
