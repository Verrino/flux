import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flux/screens/models/account.dart';

class ProfileService {
  static Future<Map<String, dynamic>> addUser(String username,
      String phoneNumber, String bio, String? profileImageUrl) async {
    try {
      var isAccountMade = false;

      await FirebaseFirestore.instance
          .collection('accounts')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        isAccountMade = value.data() != null;
      });

      if (isAccountMade) {
        return {'isError': true, 'message': "Account has been made."};
      }

      final snapshot =
          await FirebaseFirestore.instance.collection('accounts').get();

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

      await FirebaseFirestore.instance
          .collection('accounts')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "username": username,
        "phone_number": phoneNumber,
        "bio": bio,
        "followings": [],
        "followers": [],
        "profilePictureUrl": profileImageUrl ?? '',
        "posts": 0,
      }).whenComplete(() {
        print("Submit Selesai");
      });
      return {
        'isError': false,
        'message': "Account has been made successfully."
      };
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

  static Future<Account?> getAccountByUid(String uid) async {
    Account? account;
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('accounts')
          .doc(uid)
          .get();
      final data = snapshot.data() as Map<String, dynamic>?;
      account = Account.fromJson(data!);
    } catch (e) {
      return null;
    }

    return account;
  }

  static Future<String?> getUidByUsername(String username) async {
    String? uid;
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('accounts').get();

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

  static Future<void> updateAccount(
      String uid,
      String? username,
      String? phoneNumber,
      String? bio,
      List<String>? followers,
      List<String>? followings,
      String? profilePictureUrl,
      int? posts) async {
    Account? account = await getAccountByUid(uid);
    try {
      Map<String, dynamic> updatedData = {
        'username': username ?? account!.username,
        'phone_number': phoneNumber ?? account!.phoneNumber,
        'bio': bio ?? account!.bio,
        'followers': followers ?? account!.followers,
        'followings': followings ?? account!.followings,
        'profilePictureUrl': profilePictureUrl ?? account!.profilePictureUrl,
        'posts': posts ?? account!.posts
      };
      await FirebaseFirestore.instance
          .collection('accounts')
          .doc(uid)
          .update(updatedData);
    } catch (e) {}
  }
}
