import 'package:flutter/material.dart';
import 'package:flux/color_pallete.dart';
import 'package:flux/screens/models/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final Account account;

  const ProfileScreen({super.key, required this.account});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    return Scaffold(
      body: _isLoading ?
        const Center(child: CircularProgressIndicator()) :
        Column(
          children: [
            Row(
              children: [
                Image.network(widget.account.profilePictureUrl, width: 60,),
                Column(
                  children: [
                    Text(widget.account.username),
                  ],
                ),
              ],
            ),
          ],
        ),
      bottomNavigationBar: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.popAndPushNamed(context, 'home');
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