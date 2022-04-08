import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

class Join extends StatefulWidget {
  const Join({Key? key}) : super(key: key);

  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {
  var idController = TextEditingController();
  var nameController = TextEditingController();
  bool audio = true, video = true;

  _joinMeeting() async {
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };

    if (Platform.isAndroid) {
      featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
    } else if (Platform.isIOS) {
      featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
    }
    final iosAppBarRGBAColor =
        TextEditingController(text: "#0080FF80"); //transparent blue
    var options = JitsiMeetingOptions(room: idController.text)
      ..subject = ''
      ..userDisplayName = nameController.text
      ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
      ..audioOnly = false
      ..audioMuted = !audio
      ..videoMuted = !video
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff242424),
      appBar: AppBar(
        leadingWidth: 100,
        leading: CupertinoButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        title: const Text(
          'Join a Meeting',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(color: Colors.grey, endIndent: 0, height: 0),
                Container(
                  color: const Color(0xff2d2d2d),
                  child: TextField(
                    controller: idController,
                    onChanged: (xd) => setState(() {}),
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Meeting ID',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Divider(color: Colors.grey, endIndent: 0, height: 0),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              'Join with a personal link name',
              style: TextStyle(color: Colors.blue.shade700),
            ),
            const SizedBox(height: 15),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(color: Colors.grey, endIndent: 0, height: 0),
                Container(
                  color: const Color(0xff2d2d2d),
                  child: TextField(
                    controller: nameController,
                    onChanged: (a) => setState(() {}),
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Your Name',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Divider(color: Colors.grey, endIndent: 0, height: 0),
              ],
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: idController.text.length < 6 &&
                                nameController.text.isEmpty
                            ? const Color(0xff383838)
                            : const Color(0xff1774e6),
                        padding: const EdgeInsets.symmetric(vertical: 15)),
                    onPressed: idController.text.length < 6 ||
                            nameController.text.isEmpty
                        ? null
                        : () => _joinMeeting(),
                    child: const Text(
                      'Join',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                children: const [
                  Text(
                    'JOIN OPTIONS',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Container(
              color: const Color(0xff2d2d2d),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(color: Colors.grey, endIndent: 0, height: 0),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(children: [
                      const Text('Don\'t Connect To Audio',
                          style: TextStyle(fontSize: 16)),
                      const Spacer(),
                      CupertinoSwitch(
                          value: !audio,
                          onChanged: (newO) => setState(() => audio = !newO))
                    ]),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(color: Colors.grey, endIndent: 0, height: 0),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(children: [
                      const Text('Turn Off My Video',
                          style: TextStyle(fontSize: 16)),
                      const Spacer(),
                      CupertinoSwitch(
                          value: !video,
                          onChanged: (newO) => setState(() => video = !newO))
                    ]),
                  ),
                  const Divider(color: Colors.grey, endIndent: 0, height: 0)
                ],
              ),
            ),
          ],
        ),
      ),
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
