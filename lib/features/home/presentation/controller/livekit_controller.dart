// import 'dart:async';
// import 'package:get/get.dart';
// import 'package:livekit_client/livekit_client.dart';

// import '../../../../core/utils/replay_kit_channel.dart';
// import '../../domain/entities/participant_info.dart';

// class LiveKitController extends GetxController {
//   // 1. Room and Listener Initialization
//   late Room _room;
//   late EventsListener<RoomEvent> _listener;

//   // 2. Reactive State Variables
//   final RxString connectionState = 'Disconnected'.obs;
//   final RxList<ParticipantTrack> participantTracks = <ParticipantTrack>[].obs;
//   final RxString roomName = ''.obs;
//   final RxBool isAudioEnabled = false.obs; // Start audio as disabled
//   final RxBool isScreenShareEnabled = false.obs;

//   // 3. Track Lists and Selected Devices
//   List<MediaDevice> _audioInputs = [];
//   List<MediaDevice> _videoInputs = [];
//   MediaDevice? _selectedAudioDevice;

//   // 4. Tracks and Subscriptions
//   LocalAudioTrack? _audioTrack;
//   LocalVideoTrack? _videoTrack;
//   bool _flagStartedReplayKit = false;
//   StreamSubscription? _deviceChangeSubscription;

//   @override
//   void onInit() {
//     super.onInit();

//     // Initialize Room and Listener First
//     _initializeRoom();

//     // Setup Device Change Listener
//     _setupDeviceListeners();
//   }

//   void _initializeRoom() {
//     _room = Room();
//     _listener = _room.createListener();
//     _setUpRoomListeners();

//     // Add Participant Listener
//     _room.localParticipant?.addListener(_updateLocalTrackStatus);
//   }

//   void _setupDeviceListeners() {
//     _deviceChangeSubscription = Hardware.instance.onDeviceChange.stream
//         .listen((List<MediaDevice> devices) => _loadDevices(devices));
//     Hardware.instance.enumerateDevices().then(_loadDevices);
//   }

//   void _loadDevices(List<MediaDevice> devices) {
//     _audioInputs = devices.where((d) => d.kind == 'audioinput').toList();
//     _videoInputs = devices.where((d) => d.kind == 'videoinput').toList();

//     if (_audioInputs.isNotEmpty && _selectedAudioDevice == null) {
//       _selectedAudioDevice = _audioInputs.first;
//       _changeLocalAudioTrack(); // Call without delay
//     }

//     // if (_videoInputs.isNotEmpty && _selectedVideoDevice == null) {
//     //   _selectedVideoDevice = _videoInputs.first;
//     //   _changeLocalVideoTrack(); // Call without delay
//     // }
//   }

//   Future<void> _changeLocalAudioTrack() async {
//     if (_audioTrack != null) {
//       await _audioTrack!.stop();
//       await _room.localParticipant?.unpublishAllTracks(notify: true);
//       _audioTrack = null;
//     }

//     if (_selectedAudioDevice != null) {
//       _audioTrack = await LocalAudioTrack.create(
//         AudioCaptureOptions(deviceId: _selectedAudioDevice!.deviceId),
//       );
//       await _audioTrack!.start();
//     }
//   }

//   Future<void> _changeLocalVideoTrack() async {
//     if (_videoTrack != null) {
//       await _videoTrack!.stop();
//       await _room.localParticipant?.unpublishAllTracks(notify: true);
//       _videoTrack = null;
//     }

//     _videoTrack = await LocalVideoTrack.createScreenShareTrack(
//       const ScreenShareCaptureOptions(
//         captureScreenAudio: true,
//         maxFrameRate: 15,
//       ),
//     );
//     await _videoTrack!.start();
//   }

//   Future<void> connectToRoom(String url, String token) async {
//     try {
//       connectionState.value = 'Connecting';
//       await _room.prepareConnection(url, token);

//       // No need to call enableAudio() and enableScreenShare() here
//       // as they are handled in fastConnectOptions below.

//       await _room.connect(url, token,
//           fastConnectOptions: FastConnectOptions(
//             microphone: TrackOption(track: _audioTrack, enabled: true),
//             screen: TrackOption(
//                 track: _videoTrack,
//                 enabled:
//                     true), // Directly publish screen if _videoTrack is ready
//           ));

//       roomName.value = _room.name!;
//       connectionState.value = 'Connected';
//       _sortParticipants(); // Initial participant sorting
//     } catch (error) {
//       connectionState.value = 'Error';
//       print("Connection error: $error");
//     }
//   }

//   void _setUpRoomListeners() {
//     _listener
//       ..on<RoomDisconnectedEvent>(_handleDisconnect)
//       ..on<ParticipantEvent>((_) {
//         print('Participant event');
//         _sortParticipants();
//       })
//       ..on<LocalTrackPublishedEvent>((_) => _sortParticipants())
//       ..on<LocalTrackUnpublishedEvent>((_) => _sortParticipants())
//       ..on<TrackSubscribedEvent>((_) => _sortParticipants())
//       ..on<TrackUnsubscribedEvent>((_) => _sortParticipants())
//       ..on<ParticipantNameUpdatedEvent>((event) {
//         print(
//             'Participant name updated: ${event.participant.identity}, name => ${event.name}');
//         _sortParticipants();
//       })
//       ..on<AudioPlaybackStatusChanged>(_handleAudioPlaybackStatusChanged);
//   }

//   void _sortParticipants() {
//     List<ParticipantTrack> userMediaTracks = [];
//     List<ParticipantTrack> screenTracks = [];

//     for (var participant in _room.remoteParticipants.values) {
//       for (var track in participant.videoTrackPublications) {
//         if (track.isScreenShare) {
//           screenTracks.add(ParticipantTrack(
//             participant: participant,
//             type: ParticipantTrackType.kScreenShare,
//           ));
//         } else {
//           userMediaTracks.add(ParticipantTrack(participant: participant));
//         }
//       }
//     }

//     // Sorting logic remains the same...

//     _handleLocalParticipantTracks(screenTracks, userMediaTracks);
//     participantTracks.value = [...screenTracks, ...userMediaTracks];
//     update();
//   }

//   void _handleLocalParticipantTracks(List<ParticipantTrack> screenTracks,
//       List<ParticipantTrack> userMediaTracks) {
//     final localParticipantTracks =
//         _room.localParticipant?.videoTrackPublications;
//     if (localParticipantTracks != null) {
//       for (var track in localParticipantTracks) {
//         if (track.isScreenShare) {
//           _handleScreenShare(screenTracks);
//         } else {
//           userMediaTracks
//               .add(ParticipantTrack(participant: _room.localParticipant!));
//         }
//       }
//     }
//   }

//   void _updateLocalTrackStatus() {
//     // Corrected method name
//     // Update audio and screen share status based on local participant
//     isAudioEnabled.value =
//         _room.localParticipant?.isMicrophoneEnabled() ?? false;
//     isScreenShareEnabled.value =
//         _room.localParticipant?.isScreenShareEnabled() ?? false;
//   }

//   void _handleScreenShare(List<ParticipantTrack> screenTracks) {
//     if (lkPlatformIs(PlatformType.iOS)) {
//       if (!_flagStartedReplayKit) {
//         _flagStartedReplayKit = true;
//         ReplayKitChannel.startReplayKit();
//       }
//     }
//     screenTracks.add(ParticipantTrack(
//       participant: _room.localParticipant!,
//       type: ParticipantTrackType.kScreenShare,
//     ));
//   }

//   Future<void> disconnectFromRoom() async {
//     await _room.disconnect();
//     connectionState.value = 'Disconnected';
//     roomName.value = '';
//     isAudioEnabled.value = false;
//     isScreenShareEnabled.value = false;
//     participantTracks.clear();
//     _cleanupTracks();
//   }

//   Future<void> enableAudio() async {
//     try {
//       await _room.localParticipant?.setMicrophoneEnabled(true);
//       isAudioEnabled.value = true;
//       if (_audioTrack != null) {
//         await _room.localParticipant?.publishAudioTrack(_audioTrack!);
//       }
//     } catch (error) {
//       print("Enable Audio Error: $error");
//     }
//   }

//   Future<void> disableAudio() async {
//     try {
//       await _room.localParticipant?.setMicrophoneEnabled(false);
//       isAudioEnabled.value = false;
//     } catch (error) {
//       print("Disable Audio Error: $error");
//     }
//   }

//   Future<void> enableScreenShare() async {
//     try {
//       await _room.localParticipant?.publishVideoTrack(_videoTrack!);
//       isScreenShareEnabled.value = true;
//     } catch (e) {
//       print("Enable Screen Share Error: $e");
//     }
//   }

//   Future<void> disableScreenShare() async {
//     try {
//       await _room.localParticipant?.setScreenShareEnabled(false);
//       isScreenShareEnabled.value = false;

//       // Handle Android-specific cleanup for FlutterBackground if needed
//       if (lkPlatformIs(PlatformType.android)) {
//         // await FlutterBackground.disableBackgroundExecution();
//       }
//     } catch (e) {
//       print("Disable Screen Share Error: $e");
//     }
//   }

//   void _handleDisconnect(RoomDisconnectedEvent event) {
//     connectionState.value = 'Disconnected';
//     roomName.value = '';
//     participantTracks.clear();
//     _cleanupTracks();
//   }

//   void _handleAudioPlaybackStatusChanged(
//       AudioPlaybackStatusChanged event) async {
//     if (!_room.canPlaybackAudio) {
//       print('Audio playback failed for iOS Safari');
//     }
//   }

//   void _cleanupTracks() {
//     _audioTrack?.dispose();
//     _audioTrack = null;
//     _videoTrack?.dispose();
//     _videoTrack = null;
//   }

//   @override
//   void onClose() {
//     _listener.dispose();
//     _room.dispose();
//     _deviceChangeSubscription?.cancel();
//     _cleanupTracks();
//     super.onClose();
//   }
// }
// //here is the updated code, I did few modifications like instead of directly calling the methods, I am using the fastConnectOptions, kindly check this and if there is any mistakes then correct them
