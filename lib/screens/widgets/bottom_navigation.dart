import 'package:flutter/material.dart';
import 'package:flux/color_pallete.dart';
import 'package:flux/screens/models/account.dart';
import 'package:flux/screens/navigation/profile_screen.dart';

class BottomNavigation extends StatelessWidget {
  final ColorPallete colorPallete;
  final Account? account;
  BottomNavigation(
      {super.key, required this.colorPallete, required this.account});

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
                Navigator.popAndPushNamed(
                  context,
                  'home',
                );
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(account: account!),
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
