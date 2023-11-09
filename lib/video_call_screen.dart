import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});
  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: "6015c56dc1d649609733c121a8a21382",
      channelName: "test1",
      username: "user",
      tempToken:
          '007eJxTYNjOxXvzwYp1TCWrdy9v2X10j6ff2abdXGZF+ltLP7w3d9VXYDAzMDRNNjVLSTZMMTOxNDOwNDc2TjY0Mky0SDQyNLYwUg73Tm0IZGSQNhFjYIRCEJ+VoSS1uMSQgQEAT3Adig==',
    ),
    enabledPermission: [Permission.camera, Permission.microphone],
    agoraChannelData: AgoraChannelData(
      channelProfileType: ChannelProfileType.channelProfileCommunication1v1,
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
    ),
  );

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: client,
              layoutType: Layout.floating,
              enableHostControls: true, // Add this to enable host controls
            ),
            AgoraVideoButtons(
              client: client,
              addScreenSharing: false, // Add this to enable screen sharing
            ),
          ],
        ),
      ),
    );
  }
}
