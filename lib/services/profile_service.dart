import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileService {
  static Future<Map<String, dynamic>> addUser(String username, String phoneNumber, String bio) async {
    try {
      var isAccountMade = false;

      await FirebaseFirestore.instance.collection('accounts').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
        isAccountMade = value.data() != null;
      });

      if (isAccountMade) {
        return {'isError': true, 'message': "Account has been made."};
      }
      
      final snapshot = await FirebaseFirestore.instance.collection('accounts').get();

      var isUsernameTaken = false;

      for (var account in snapshot.docs) {
        if (account.data()['username'] == username) {
          isUsernameTaken = true;
          break;
        }
      }

      if (isUsernameTaken) {
        return {'isError': true, 'message': "Username has been taken."};
      }

      await FirebaseFirestore.instance.collection('accounts').doc(FirebaseAuth.instance.currentUser!.uid)
        .set(
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
      return {'isError': false, 'message': "Account has been made successfully."};
    } catch (e) {
      print(e);
    }

    return {'isError': true, 'message': "There is something error."};
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

