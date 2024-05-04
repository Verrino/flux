import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileService {
  static Future<void> addUser(String username, String phoneNumber, String bio) async {
    try {
      await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid)
        .add(
          {
            "username": username, 
            "phone_number": phoneNumber, 
            "bio": bio,
            "followings": [],
            "followers": [],
            "posts": 0,
          }
        ).whenComplete(() {
          print("Submit Selesai");
        });
    } catch (e) {
      print(e);
    }
  }

  static Future<void> addPhotoProfile(File selectedImage) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
        final storageRef = FirebaseStorage.instance.ref();
        final imageFileName = selectedImage.path.split("/").last;
        final timestamp = DateTime.now().microsecondsSinceEpoch;
        final uploadRef = storageRef.child("$userId/uploads/$timestamp-$imageFileName");

        await uploadRef.putFile(selectedImage);
  }
}

