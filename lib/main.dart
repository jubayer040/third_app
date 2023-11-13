import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:third_app/url_check_screen.dart';
import 'package:third_app/video_call2_screen.dart';
import 'package:third_app/video_call3_screen.dart';
import 'package:third_app/video_call5_screen.dart';
import 'package:third_app/video_call6_screen.dart';
import 'package:third_app/video_call_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () =>
                  _checkPermission(context, const VideoCallScreen()),
              child: const Text('Demo 1'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  _checkPermission(context, const VideoCall2Screen()),
              child: const Text('Demo 2'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  _checkPermission(context, const VideoCall3Screen()),
              child: const Text('Demo 3'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  _checkPermission(context, const UrlCheckScreen()),
              child: const Text('Demo 4'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  _checkPermission(context, const VideoCall5Screen()),
              child: const Text('Demo 5'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  _checkPermission(context, const VideoCall6Screen()),
              child: const Text('Demo 6'),
            ),
          ],
        ),
      ),
    );
  }

  void _checkPermission(BuildContext context, Widget screen) async {
    await Permission.camera.request();
    await Permission.microphone.request();
    // var status = await Permission.camera.status;
    // if (status.isGranted) {
    //   status = await Permission.microphone.status;
    //   if (status.isGranted) {
    // ignore: use_build_context_synchronously
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    //   }
    // }
  }
}
