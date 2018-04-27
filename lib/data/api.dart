import 'dart:async';
import 'dart:convert';
import 'package:instagram_big_picture/utils/network_util.dart';
import 'package:instagram_big_picture/models/user.dart';
import 'package:instagram_big_picture/utils/database_helper.dart';

class Api {
  NetworkUtil networkUtil = new NetworkUtil();
  DatabaseHelper db = new DatabaseHelper();
  Future<int> getUserID(String username) async {
    var user = await db.getUser(username);
    if(user != null){
      return user.id;
    }
    final String response = await networkUtil
        .get("https://www.instagram.com/" + username.toLowerCase() + "/");
    RegExp exp = new RegExp(r'profilePage_(\d+)');
    var match = exp.firstMatch(response);
    if (match.group(1).length > 0) {
      try {
        final int id = int.parse(match.group(1));
        return id;
      } catch (e) {
        return 0;
      }
    }
    return 0;
  }

  Future<User> getUserInfo(int id) async {
    final String response = await networkUtil.get(
        "https://i.instagram.com/api/v1/users/" + id.toString() + "/info/");
    Map decoded = json.decode(response);
    if (decoded["status"] == "ok") {
      var u = decoded["user"];
      User user = new User(id, u["username"], u["full_name"],
          u["profile_pic_url"], u["hd_profile_pic_url_info"]["url"]);
      await db.saveOrUpdateUser(user);
      return user;
    }
    return null;
  }

  Future<List<User>> getRecentlyUsers() async{
    var resp = await db.getRecentlyUsers(10);
    return resp;
  }

  Future<int> deleteUser(User user) async{
    return await db.deleteUser(user);
  }
}
