import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flux/color_pallete.dart';
import 'package:flux/screens/models/account.dart';
import 'package:flux/screens/models/posting.dart';
import 'package:flux/screens/navigation/profile_screen.dart';
import 'package:flux/screens/widgets/bottom_navigation.dart';
import 'package:flux/screens/widgets/post_box.dart';
import 'package:flux/services/post_service.dart';
import 'package:flux/services/profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  late ColorPallete colorPallete;
  late SharedPreferences prefs;
  late Account account;

  bool _isLoading = true;
  List<Account> result = [];

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

  void onChangedSearch(String username) async {
    if (username.isNotEmpty) {
      result = await ProfileService.getAccountsByUsername(username);
    } else {
      result = [];
    }
    setState(() {
      result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: colorPallete.backgroundColor,
            appBar: AppBar(
              title: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: colorPallete.borderColor)),
                ),
                style: TextStyle(color: colorPallete.fontColor),
                onChanged: (value) {
                  onChangedSearch(value);
                },
                onSubmitted: (value) {
                  onChangedSearch(value);
                },
              ),
              automaticallyImplyLeading: false,
              backgroundColor: colorPallete.backgroundColor,
            ),
            body: result.isEmpty
                ? Column(
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
                              postingBoxes.add(PostBox(
                                colorPallete: colorPallete,
                                uid: post.uid!,
                                post: post,
                              ));
                              postingBoxes.add(const SizedBox(height: 10));
                            }
                            return ListView(
                              children: postingBoxes,
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreen(account: result[index])));
                        },
                        child: Card(
                          color: colorPallete.postBackgroundColor,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    result[index].profilePictureUrl),
                              ),
                              Text(result[index].username,
                                  style:
                                      TextStyle(color: colorPallete.fontColor))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            bottomNavigationBar:
                BottomNavigation(colorPallete: colorPallete, account: account),
          );
  }
}
