import 'package:flux/screens/models/account.dart';
import 'package:flux/services/profile_service.dart';

class SocialService {
  static Future<void> follow(String uid, String targetUid) async {
    Account? account = await ProfileService.getAccountByUid(uid);
    Account? targetAccount = await ProfileService.getAccountByUid(targetUid);

    try {
      List<String> userFollowings = [];
      for (var following in account!.followings) {
        userFollowings.add(following.toString());
      }
      List<String> targetFollowers = [];
      for (var follower in targetAccount!.followers) {
        targetFollowers.add(follower.toString());
      }

      userFollowings.add(targetUid);
      targetFollowers.add(uid);

      await ProfileService.updateAccount(
          uid, null, null, null, null, userFollowings, null, null);
      await ProfileService.updateAccount(
          targetUid, null, null, null, targetFollowers, null, null, null);
    } catch (e) {
      print(e);
    }
  }

  static Future<void> unfollow(String uid, String targetUid) async {
    Account? account = await ProfileService.getAccountByUid(uid);
    Account? targetAccount = await ProfileService.getAccountByUid(targetUid);

    try {
      List<String> userFollowings = [];
      for (var following in account!.followings) {
        userFollowings.add(following.toString());
      }
      List<String> targetFollowers = [];
      for (var follower in targetAccount!.followers) {
        targetFollowers.add(follower.toString());
      }

      userFollowings.remove(targetUid);
      targetFollowers.remove(uid);

      await ProfileService.updateAccount(
          uid, null, null, null, null, userFollowings, null, null);
      await ProfileService.updateAccount(
          targetUid, null, null, null, targetFollowers, null, null, null);
    } catch (e) {
      print(e);
    }
  }
}
