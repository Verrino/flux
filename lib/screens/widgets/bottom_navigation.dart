import 'package:flutter/material.dart';
import 'package:flux/color_pallete.dart';
import 'package:flux/screens/navigation/profile_screen.dart';

class BottomNavigation extends StatelessWidget {
  final ColorPallete colorPallete;
  final String uid;
  BottomNavigation({super.key, required this.colorPallete, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, 'home');
              },
              child: Column(
                children: [
                  Icon(
                    Icons.home,
                    color: colorPallete.fontColor,
                    size: 32,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                // Navigator.pushNamed(context, '');
              },
              child: Column(
                children: [
                  Icon(
                    Icons.search,
                    color: colorPallete.fontColor,
                    size: 32,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'post');
              },
              child: const CircleAvatar(
                radius: 40,
                child: Icon(Icons.upload),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Column(
                children: [
                  Icon(
                    Icons.notifications,
                    color: colorPallete.fontColor,
                    size: 32,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(profileUid: uid),
                    ));
              },
              child: Column(
                children: [
                  Icon(
                    Icons.person,
                    color: colorPallete.fontColor,
                    size: 32,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
