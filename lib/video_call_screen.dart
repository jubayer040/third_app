import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:third_app/video_call6_screen.dart';

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFECF6FF),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: size.height * .3,
              child: Stack(
                children: [
                  Positioned.fill(
                    bottom: 25,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(.9),
                            Colors.white.withOpacity(.6),
                            Colors.white.withOpacity(.4)
                          ],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(255, 144, 176, 208),
                            blurRadius: 40,
                            offset: Offset(5, 2),
                          ),
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 40,
                            offset: Offset(-5, -2),
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Desclaimer',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            desclaimerText,
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //
                  Positioned(
                    bottom: 0,
                    left: 30,
                    right: 30,
                    child: InkWell(
                      onTap: () {
                        _requestPermissions(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          //color: MyColor.bluePrimary,
                          color: const Color(0xFF01204E),
                        ),
                        child: const Text(
                          'Join The Call',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () {
                Fluttertoast.showToast(msg: 'I\'m not ur servant, Quack Doc!');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  //color: MyColor.bluePrimary,
                  color: const Color(0xFFBDDDFC),
                ),
                child: const Text(
                  'Write a Prescription',
                  style: TextStyle(
                    color: Color(0xFF01204E),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _requestPermissions(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    // Check if permissions are granted
    if (statuses[Permission.camera] == PermissionStatus.granted &&
        statuses[Permission.microphone] == PermissionStatus.granted) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const VideoCall6Screen()),
      );
    } else {
      // Permissions denied, handle accordingly
      // ...
    }
  }
}

const desclaimerText = """
  * Reload button: to reload the app.
  1. There is a Document button at the top.
  2. You can add immediate note of the patient by Document button.
  3. Immediate notes will be shown, while writing the Prescription.
""";
