import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flux/color_pallete.dart';
import 'package:flux/screens/models/account.dart';
import 'package:flux/screens/models/posting.dart';
import 'package:flux/screens/widgets/bottom_navigation.dart';
import 'package:flux/screens/widgets/post_box.dart';
import 'package:flux/services/authentication_service.dart';
import 'package:flux/services/post_service.dart';
import 'package:flux/services/profile_service.dart';
import 'package:flux/services/social_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final String profileUid;

  const ProfileScreen({super.key, required this.profileUid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ColorPallete colorPallete;
  late SharedPreferences prefs;
  late Account comerAccount;
  late Account profileAccount;
  late bool isFollowed;

  bool _isLoading = true;
  String selectedOption = "posted";

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    prefs = await SharedPreferences.getInstance().then((value) async {
      colorPallete = value.getBool('isDarkMode') ?? false
          ? DarkModeColorPallete()
          : LightModeColorPallete();
      comerAccount = (await ProfileService.getAccountByUid(
          FirebaseAuth.instance.currentUser!.uid))!;
      profileAccount =
          (await ProfileService.getAccountByUid(widget.profileUid))!;
      setState(() {
        if (profileAccount.followers
            .contains(FirebaseAuth.instance.currentUser!.uid)) {
          isFollowed = true;
        } else {
          isFollowed = false;
        }
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
            body: Padding(
              padding: const EdgeInsets.only(top: 40.0, right: 12, left: 12),
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
                                NetworkImage(profileAccount.profilePictureUrl),
                            radius: 60,
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(profileAccount.username,
                                  style:
                                      TextStyle(color: colorPallete.fontColor)),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                          profileAccount.followers.length
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: colorPallete.fontColor)),
                                      Text('Followers',
                                          style: TextStyle(
                                              color: colorPallete.fontColor))
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    children: [
                                      Text(
                                          profileAccount.followings.length
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: colorPallete.fontColor)),
                                      Text('Followings',
                                          style: TextStyle(
                                              color: colorPallete.fontColor)),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    children: [
                                      Text(profileAccount.posts.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
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
                      Row(
                        children: [
                          Text.rich(
                            TextSpan(
                                text: profileAccount.bio,
                                style: TextStyle(
                                  color: colorPallete.fontColor,
                                )),
                          )
                        ],
                      ),
                      if (comerAccount.username == profileAccount.username)
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
                      if (comerAccount.username != profileAccount.username) ...[
                        if (!isFollowed)
                          GestureDetector(
                            onTap: () async {
                              String? comerUid =
                                  await ProfileService.getUidByUsername(
                                      comerAccount.username);
                              await SocialService.follow(
                                      comerUid!, widget.profileUid)
                                  .whenComplete(() {
                                initialize();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 120),
                              decoration: BoxDecoration(
                                color: colorPallete.buttonColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Follow',
                                style: TextStyle(
                                  color: colorPallete.fontColor,
                                ),
                              ),
                            ),
                          ),
                        if (isFollowed)
                          GestureDetector(
                            onTap: () async {
                              String? comerUid =
                                  await ProfileService.getUidByUsername(
                                      comerAccount.username);
                              await SocialService.unfollow(
                                      comerUid!, widget.profileUid)
                                  .whenComplete(() => initialize());
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
                                if (post.uid == widget.profileUid) {
                                  postingBoxes.add(PostBox(
                                    colorPallete: colorPallete,
                                    uid: post.uid!,
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
                      if (profileAccount.profilePictureUrl ==
                          comerAccount.profilePictureUrl) ...[
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
                            await AuthenticationService.logout()
                                .whenComplete(() {
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
                      if (profileAccount.profilePictureUrl !=
                          comerAccount.profilePictureUrl) ...[
                        PopupMenuItem(
                          onTap: () {},
                          child: Text(
                            'Report',
                            style: TextStyle(color: colorPallete.fontColor),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigation(
                colorPallete: colorPallete,
                uid: FirebaseAuth.instance.currentUser!.uid),
          );
  }
}
