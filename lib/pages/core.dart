import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoom_clone/main.dart';
import 'package:zoom_clone/pages/join.dart';

class Core extends StatefulWidget {
  const Core({Key? key}) : super(key: key);

  @override
  State<Core> createState() => _CoreState();
}

var keyy = GlobalKey();

class _CoreState extends State<Core> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      backgroundColor: const Color(0xff242424),
      appBar: AppBar(
        title: const Text('Meet & Chat'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Image.asset('assets/edit.png', width: 30),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: const TextField(
                enabled: false,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: Color(0xffa2a2a2),
                  ),
                  fillColor: Color(0xff383838),
                  filled: true,
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Color(0xffa2a2a2),
                    fontSize: 18,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () =>
                      Navigator.push(context, _createRoute(const Meeting())),
                  child: _item(w, Icons.photo_camera_front, 'New Meeting',
                      c: 0xfff36a32),
                ),
                GestureDetector(
                    onTap: () =>
                        Navigator.push(context, _createRoute(const Join())),
                    child: _item(w, Icons.add, 'Join')),
                _item(w, Icons.calendar_today, 'Schedule'),
                _item(w, Icons.screen_share_outlined, 'Share Screen'),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Divider(color: Colors.grey.withOpacity(.5)),
          const Spacer(),
          Image.asset('assets/image1.png'),
          const SizedBox(height: 25),
          const Text(
            'Find People and Start Chatting!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 35),
          SizedBox(
            width: 243,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color(0xff1774e6),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10)),
                onPressed: () {},
                child: const Text('Add Contacts'),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xff1a1a1a),
          unselectedItemColor: const Color(0xff9a9a9a),
          selectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble), label: 'Meet & Chat'),
            BottomNavigationBarItem(
                icon: Icon(Icons.schedule), label: 'Meeting'),
            BottomNavigationBarItem(
                icon: Icon(Icons.contacts), label: 'Contacts'),
            BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz, size: 28), label: 'More'),
          ]),
    );
  }
}

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Widget _item(w, i, t, {c}) {
  c ??= 0xff1774e6;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: w * 15,
        height: w * 15,
        decoration: BoxDecoration(
          color: Color(c),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(i, color: Colors.white, size: 28),
      ),
      const SizedBox(height: 5),
      Text(
        t,
        maxLines: 1,
        style: const TextStyle(fontSize: 12, color: Color(0xff9a9a9a)),
      )
    ],
  );
}
