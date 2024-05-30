import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flux/color_pallete.dart';
import 'package:flux/models/account.dart';
import 'package:flux/models/posting.dart';
import 'package:flux/screens/widgets/bottom_navigation.dart';
import 'package:flux/screens/widgets/post_box.dart';
import 'package:flux/services/authentication_service.dart';
import 'package:flux/services/post_service.dart';
import 'package:flux/services/profile_service.dart';
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
  late Account comerAccount;
  late Account ownerAccount;
  late String _accountUid;
  late String _targetUid;

  bool _isLoading = true;
  String selectedOption = "posted";

  @override
  void initState() {
    super.initState();
    ownerAccount = widget.account;
    initialize();
  }

  void initialize() async {
    prefs = await SharedPreferences.getInstance().then((value) async {
      colorPallete = value.getBool('isDarkMode') ?? false
          ? DarkModeColorPallete()
          : LightModeColorPallete();
      comerAccount = (await ProfileService.getAccountByUid(
          FirebaseAuth.instance.currentUser!.uid))!;
      _accountUid = FirebaseAuth.instance.currentUser!.uid;
      _targetUid =
          (await ProfileService.getUidByUsername(ownerAccount.username))!;
      ownerAccount = (await ProfileService.getAccountByUid(_targetUid))!;
      setState(() {
        _isLoading = false;
        ownerAccount = ownerAccount;
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
            body: Padding(
              padding: const EdgeInsets.only(top: 40.0, right: 8, left: 8),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(ownerAccount.profilePictureUrl),
                            radius: 60,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ownerAccount.username,
                                  style:
                                      TextStyle(color: colorPallete.fontColor)),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                          ownerAccount.followers.length
                                              .toString(),
                                          style: TextStyle(
                                              color: colorPallete.fontColor)),
                                      Text('Followers',
                                          style: TextStyle(
                                              color: colorPallete.fontColor))
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                          ownerAccount.followings.length
                                              .toString(),
                                          style: TextStyle(
                                              color: colorPallete.fontColor)),
                                      Text('Followings',
                                          style: TextStyle(
                                              color: colorPallete.fontColor)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(ownerAccount.posts.toString(),
                                          style: TextStyle(
                                              color: colorPallete.fontColor)),
                                      Text('Posts',
                                          style: TextStyle(
                                              color: colorPallete.fontColor)),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                              text: ownerAccount.bio,
                              style: TextStyle(color: colorPallete.fontColor)),
                        ),
                      ),
                      if (comerAccount.username == ownerAccount.username)
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 120),
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
                      if (comerAccount.username != ownerAccount.username) ...[
                        if (ownerAccount.followers.contains(_accountUid))
                          GestureDetector(
                            onTap: () {
                              ProfileService.unfollow(_accountUid, _targetUid)
                                  .whenComplete(
                                () {
                                  initialize();
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 120),
                              decoration: BoxDecoration(
                                color: colorPallete.buttonColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Unfollow',
                                style: TextStyle(
                                  color: colorPallete.fontColor,
                                ),
                              ),
                            ),
                          ),
                        if (!ownerAccount.followers.contains(_accountUid))
                          GestureDetector(
                            onTap: () {
                              ProfileService.follow(_accountUid, _targetUid)
                                  .whenComplete(
                                () {
                                  initialize();
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 120),
                              decoration: BoxDecoration(
                                color: colorPallete.buttonColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                !ownerAccount.followings.contains(_accountUid)
                                    ? 'Follow'
                                    : 'Follow Back',
                                style: TextStyle(
                                  color: colorPallete.fontColor,
                                ),
                              ),
                            ),
                          ),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedOption = "posted";
                              });
                            },
                            child: Text(
                              'Posted',
                              style: TextStyle(
                                color: colorPallete.fontColor,
                                fontWeight: selectedOption == "posted"
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedOption = "liked";
                              });
                            },
                            child: Text(
                              'Liked',
                              style: TextStyle(
                                color: colorPallete.fontColor,
                                fontWeight: selectedOption == "liked"
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (selectedOption == "posted") ...[
                        Expanded(
                          child: StreamBuilder(
                            stream: PostService.getPostingList(),
                            builder: (context, snapshot) {
                              // ignore: unnecessary_cast
                              List<Posting> posts = (snapshot.data ??
                                  List<Posting>.empty()) as List<Posting>;
                              List<Widget> postingBoxes = [];
                              for (Posting post in posts) {
                                if (post.posterUid == _accountUid) {
                                  postingBoxes.add(PostBox(
                                    colorPallete: colorPallete,
                                    uid: post.posterUid!,
                                    post: post,
                                  ));
                                  postingBoxes.add(const SizedBox(height: 10));
                                }
                              }
                              return ListView(
                                children: postingBoxes,
                              );
                            },
                          ),
                        ),
                      ]
                    ],
                  ),
                  PopupMenuButton(
                    iconColor: colorPallete.fontColor,
                    color: colorPallete.postBackgroundColor,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () {
                          Navigator.pushNamed(context, 'settings')
                              .then((_) => setState(() {
                                    initialize();
                                  }));
                        },
                        child: Text(
                          'Settings',
                          style: TextStyle(color: colorPallete.fontColor),
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () async {
                          await AuthenticationService.logout().whenComplete(() {
                            Navigator.pushNamedAndRemoveUntil(
                                context, 'login', (route) => false);
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
            bottomNavigationBar: BottomNavigation(
                colorPallete: colorPallete, account: comerAccount),
          );
  }
}
