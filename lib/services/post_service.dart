import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flux/screens/models/posting.dart';

class PostService {
   static final DatabaseReference _database = FirebaseDatabase.instance.ref().child('posting_list');

   static Stream<List<Posting>> getPostingList() {
    return _database.onValue.map((event) {
      List<Posting> items = [];
      DataSnapshot snapshot = event.snapshot;
      try {
        if (snapshot.value != null) {
          Map<Object?, Object?> listData = snapshot.value as Map<Object?, Object?>;
          listData.forEach((key, value) {
            final data = value as Map<Object?, Object?>;
            Map<String, dynamic> accountData = {};
            data.forEach((key, value) {
              accountData[key.toString()] = value;
            });
            accountData['post_id'] = key.toString();
            items.add(Posting.fromJson(accountData));
          });
        }
      } catch (e) {
        print(e);
      }
      return items;
    });
   }

   static Future<void> post(Posting posting, String uid) async {
    await _database.push().set({
      'uid': uid,
      'location': posting.location,
      'posting_image_url': posting.postingImageUrl,
      'description': posting.postingDescription,
      'count_likes': posting.countLikes,
      'count_comments': posting.countComments,
      'postedTime': DateTime.now().toString(),
    });
   }

   static Future<String?> addPostingImage(File? selectedImage) async {
    try {
      if (selectedImage == null) {
        return null;
      }
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final storageRef = FirebaseStorage.instance.ref();
      final timestamp = DateTime.now().microsecondsSinceEpoch;
      final uploadRef = storageRef.child("posts/$userId/$timestamp");

      final taskSnapshot = await uploadRef.putFile(selectedImage);

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
}