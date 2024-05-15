import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileService {
  static Future<Map<String, dynamic>> addUser(String username, String phoneNumber, String bio, String? profileImageUrl) async {
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
            "profilePictureUrl": profileImageUrl ?? '',
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

  static Future<String?> addPhotoProfile(File? selectedImage) async {
    try {
      if (selectedImage == null) {
        return null;
      }
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final storageRef = FirebaseStorage.instance.ref();
      final timestamp = DateTime.now().microsecondsSinceEpoch;
      final uploadRef = storageRef.child("profile_pictures/$userId/$timestamp");

      final taskSnapshot = await uploadRef.putFile(selectedImage);

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getAccountByUid(String uid) async {
    Map<String, dynamic>? account;
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('accounts').doc(uid).get();
      account = snapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }

    return account;
  }

  static Future<String?> getUidByUsername(String username) async {
    String? uid;
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('accounts').get();
      
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['username'] == username) {
          uid = doc.id;
        }
      }
      
    } catch (e) {
      print('Error');
      return null;
    }

    return uid;
  }
}

