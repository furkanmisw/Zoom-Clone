import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:zoom_clone/pages/core.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Core(),
    );
  }
}

class Meeting extends StatefulWidget {
  const Meeting({Key? key}) : super(key: key);

  @override
  _MeetingState createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
  final iosAppBarRGBAColor =
      TextEditingController(text: "#0080FF80"); //transparent blue

  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  bool videoOn = true;
  bool voiceOn = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff242424),
      appBar: AppBar(
        leadingWidth: 100,
        leading: CupertinoButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        title: const Text('Start a Meeting', style: TextStyle(fontSize: 17)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          const Divider(color: Colors.grey),
          Container(
            color: const Color(0xff2d2d2d),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Video On',
                        style: TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      CupertinoSwitch(
                          value: videoOn,
                          onChanged: (newV) => setState(() => videoOn = newV)),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  Row(
                    children: [
                      const Text(
                        'Voice On',
                        style: TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      CupertinoSwitch(
                          value: voiceOn,
                          onChanged: (newV) => setState(() => voiceOn = newV)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      primary: const Color(0xff1774e6)),
                  onPressed: () => _joinMeeting(),
                  child: const Text(
                    'Start a Meeting',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  final _chars = '1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  _joinMeeting() async {
    String randomString = getRandomString(6);
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };

    if (Platform.isAndroid) {
      featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
    } else if (Platform.isIOS) {
      featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
    }

    var options = JitsiMeetingOptions(room: randomString)
      ..subject = ''
      ..userDisplayName = 'Admin'
      ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
      ..audioOnly = false
      ..audioMuted = !voiceOn
      ..videoMuted = !videoOn
      ..featureFlags.addAll(featureFlags);

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
          onConferenceWillJoin: (message) {
            debugPrint("${options.room} will join with message: $message");
          },
          onConferenceJoined: (message) {
            debugPrint("${options.room} joined with message: $message");
          },
          onConferenceTerminated: (message) {
            debugPrint("${options.room} terminated with message: $message");
          },
          genericListeners: [
            JitsiGenericListener(
                eventName: 'readyToClose',
                callback: (dynamic message) {
                  debugPrint("readyToClose callback");
                }),
          ]),
    );
  }

  void _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}
