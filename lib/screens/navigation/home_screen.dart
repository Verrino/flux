import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flux/color_pallete.dart';
import 'package:flux/models/account.dart';
import 'package:flux/models/posting.dart';
import 'package:flux/screens/widgets/bottom_navigation.dart';
import 'package:flux/screens/widgets/post_box.dart';
import 'package:flux/services/post_service.dart';
import 'package:flux/services/profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ColorPallete colorPallete;
  late SharedPreferences prefs;
  late Account account;

  bool _isLoading = true;

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
      account = (await ProfileService.getAccountByUid(
          FirebaseAuth.instance.currentUser!.uid))!;

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
                  Expanded(
                    child: StreamBuilder(
                      stream: PostService.getPostingList(),
                      builder: (context, snapshot) {
                        // ignore: unnecessary_cast
                        List<Posting> posts = (snapshot.data ??
                            List<Posting>.empty()) as List<Posting>;
                        List<Widget> postingBoxes = [];
                        for (Posting post in posts) {
                          if (account.followings.contains(post.posterUid)) {
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
                ],
              ),
            ),
            bottomNavigationBar:
                BottomNavigation(colorPallete: colorPallete, account: account),
          );
  }
}
