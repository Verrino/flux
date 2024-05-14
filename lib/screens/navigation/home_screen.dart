import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flux/color_pallete.dart';
import 'package:flux/screens/widgets/post_box.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ColorPallete colorPallete;
  late SharedPreferences prefs;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    prefs = await SharedPreferences.getInstance().then((value) {
      colorPallete = value.getBool('isDarkMode') ?? false
          ? DarkModeColorPallete()
          : LightModeColorPallete();
      setState(() {
        _isLoading = false;
      });
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading 
    ? const Center(child: CircularProgressIndicator())
    : Scaffold(
      backgroundColor: colorPallete.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Expanded(
            //   child: StreamBuilder(
            //     stream: ,
            //   ),
            // ),
            PostBox(colorPallete: colorPallete, 
              username: 'Tester', 
              postDescription: 'post Description', 
              pictureProfileUrl: 'https://firebasestorage.googleapis.com/v0/b/flux-test-255c8.appspot.com/o/profile_pictures%2FXUoAR0ZCTfb3YcRneh4l6FJyepf2%2F1715684388293715?alt=media&token=6562a4ad-12f7-45aa-b586-0cf8988e6f39', 
              postedTime: DateTime.now(), 
              countLikes: 0, 
              countComments: 0,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  
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
              child: InkWell(
                onTap: () {
                  
                },
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
                  Navigator.pushNamed(context, 'profile');
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
      ),
    );
  }
}