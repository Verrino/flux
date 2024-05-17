import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flux/color_pallete.dart';
import 'package:flux/screens/models/posting.dart';
import 'package:flux/services/post_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostingScreen extends StatefulWidget {
  const PostingScreen({super.key});

  @override
  State<PostingScreen> createState() => _PostingScreenState();
}

class _PostingScreenState extends State<PostingScreen> {
  final TextEditingController _descriptionController = TextEditingController();

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
        appBar: AppBar(
          backgroundColor: colorPallete.backgroundColor,
          title: Text('Post', style: TextStyle(color: colorPallete.fontColor, fontWeight: FontWeight.bold, fontSize: 24)),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(colorPallete.buttonColor),
                ),
                onPressed: () {
                  PostService.post(
                    Posting(
                      location: 'Palembang', 
                      postingDescription: _descriptionController.text,
                      postingImageUrl: '',
                      countComments: 0,
                      countLikes: 0,
                      postedTime: DateTime.now(),
                      postId: null, 
                      uid: '',
                    ),
                    FirebaseAuth.instance.currentUser!.uid,
                  ).whenComplete(() {
                    Navigator.of(context).pop();
                  });
                }, 
                child: const Text('Post'),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Media', style: TextStyle(color: colorPallete.fontColor, fontSize: 18)),
                Center(
                  child: GestureDetector(
                    child: Container(
                      width: 340,
                      height: 340,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black26
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined, color: colorPallete.fontColor.withOpacity(0.4), size: 60),
                          Text('Add media', style: TextStyle(fontSize: 18, color: colorPallete.fontColor.withOpacity(0.4)))
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: colorPallete.borderColor),
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Pilih Lokasi', style: TextStyle(color: colorPallete.fontColor)),
                          Icon(Icons.fmd_good_sharp, color: colorPallete.fontColor),
                        ],
                      ),
                    ),
                  ),
                ),
                Text('Description', style: TextStyle(color: colorPallete.fontColor, fontSize: 18)),
                Container(
                  constraints: const BoxConstraints(
                    minHeight: 200,
                  ),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: colorPallete.postBackgroundColor,
                  ),
                  child: TextField(
                    controller: _descriptionController,
                    style: TextStyle(
                      color: colorPallete.fontColor,
                    ),
                    decoration: InputDecoration(
                      hintText: "Masukkan deskripsi",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: colorPallete.fontColor.withOpacity(0.4),
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}