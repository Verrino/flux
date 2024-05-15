import 'package:flutter/material.dart';
import 'package:flux/color_pallete.dart';
import 'package:flux/screens/models/account.dart';
import 'package:flux/services/authentication_service.dart';
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
    return _isLoading ?
      const Center(child: CircularProgressIndicator()) : 
      Scaffold(
        backgroundColor: colorPallete.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.only(top: 40.0, right: 8, left: 8),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.account.profilePictureUrl),
                        radius: 60,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.account.username, style: TextStyle(color: colorPallete.fontColor)),
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text(widget.account.followers.length.toString(), style: TextStyle(color: colorPallete.fontColor)),
                                  Text('Followers', style: TextStyle(color: colorPallete.fontColor))
                                ],
                              ),
                              Column(
                                children: [
                                  Text(widget.account.followings.length.toString(), style: TextStyle(color: colorPallete.fontColor)),
                                  Text('Followings', style: TextStyle(color: colorPallete.fontColor)),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(widget.account.posts.toString(), style: TextStyle(color: colorPallete.fontColor)),
                                  Text('Posts', style: TextStyle(color: colorPallete.fontColor)),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Text(widget.account.bio, style: TextStyle(color: colorPallete.fontColor)),
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 120),
                      decoration: BoxDecoration(
                        color: colorPallete.buttonColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: colorPallete.fontColor,
                        ),
                        ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        child: Text(
                          'Posted',
                          style: TextStyle(
                            color: colorPallete.fontColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          'Liked',
                          style: TextStyle(
                            color: colorPallete.fontColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                ],
              ),
              PopupMenuButton(
                iconColor: colorPallete.fontColor,
                color: colorPallete.postBackgroundColor,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () {
                      Navigator.pushNamed(context, 'settings');
                    },
                    child: Text(
                      'Settings', 
                      style: TextStyle(color: colorPallete.fontColor),
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () async {
                      await AuthenticationService.logout().whenComplete(() {
                        Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
                      });
                    },
                    child: Text(
                      'Logout', 
                      style: TextStyle(color: colorPallete.fontColor),
                    ),
                  ),
                ],
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