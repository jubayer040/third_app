import 'dart:math';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:third_app/video_call2_screen.dart';

class VideoCall3Screen extends StatefulWidget {
  const VideoCall3Screen({super.key});
  @override
  State<VideoCall3Screen> createState() => _VideoCall3ScreenState();
}

class _VideoCall3ScreenState extends State<VideoCall3Screen> {
  String channelName = "test1";
  String token =
      "007eJxTYNjOxXvzwYp1TCWrdy9v2X10j6ff2abdXGZF+ltLP7w3d9VXYDAzMDRNNjVLSTZMMTOxNDOwNDc2TjY0Mky0SDQyNLYwUg73Tm0IZGSQNhFjYIRCEJ+VoSS1uMSQgQEAT3Adig==";
  int uid = 0;
  int? _remoteUid;
  bool _isJoined = false;
  bool _isHost = true;
  late RtcEngine agoraEngine;

  @override
  void initState() {
    super.initState();
    // Set up an instance of Agora engine
    setupVideoSDKEngine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get started with Interactive Live Streaming'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        children: [
          // Container for the local video
          Container(
            height: 240,
            decoration: BoxDecoration(border: Border.all()),
            child: Center(child: _videoPanel()),
          ),
          // Radio Buttons
          Row(children: <Widget>[
            Radio<bool>(
              value: true,
              groupValue: _isHost,
              onChanged: (value) => _handleRadioValueChange(value),
            ),
            const Text('Host'),
            Radio<bool>(
              value: false,
              groupValue: _isHost,
              onChanged: (value) => _handleRadioValueChange(value),
            ),
            const Text('Audience'),
          ]),
          // Button Row
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  child: const Text("Join"),
                  onPressed: () => {join()},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  child: const Text("Leave"),
                  onPressed: () => {leave()},
                ),
              ),
            ],
          ),
          // Button Row ends
        ],
      ),
    );
  }

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appId));

    await agoraEngine.enableVideo();

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          Fluttertoast.showToast(
              msg: "Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          Fluttertoast.showToast(
              msg: "Remote user uid:$remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          Fluttertoast.showToast(
              msg: "Remote user uid:$remoteUid left the channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
  }

  Widget _videoPanel() {
    if (!_isJoined) {
      return const Text(
        'Join a channel',
        textAlign: TextAlign.center,
      );
    } else if (_isHost) {
      // Show local video preview
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: Random().nextInt(100)),
        ),
      );
    } else {
      // Show remote video
      if (_remoteUid != null) {
        return AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: agoraEngine,
            canvas: VideoCanvas(uid: _remoteUid),
            connection: RtcConnection(channelId: channelName),
          ),
        );
      } else {
        return const Text(
          'Waiting for a host to join',
          textAlign: TextAlign.center,
        );
      }
    }
  }

  void join() async {
    // Set channel options
    ChannelMediaOptions options;

    // Set channel profile and client role
    if (_isHost) {
      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      );
      await agoraEngine.startPreview();
    } else {
      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleAudience,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      );
    }

    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: uid,
    );
  }

  void leave() {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
  }

  void _handleRadioValueChange(bool? value) async {
    setState(() {
      _isHost = (value == true);
    });
    if (_isJoined) leave();
  }

  @override
  void dispose() async {
    await agoraEngine.leaveChannel();
    agoraEngine.release();
    super.dispose();
  }
}
