import 'package:instagram_big_picture/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class DatabaseHelper{
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;
  DatabaseHelper.internal();

  Future<Database> get db async{
    if(_db != null){
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async{
    io.Directory documentDir = await getApplicationDocumentsDirectory();
    String path = join(documentDir.path, "instabig.db");
    print(path);
    var myDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return myDb;
  }

  void _onCreate(Database db, int ver) async{
    await db.execute("CREATE TABLE Users(id INTEGER PRIMARY KEY, username TEXT, full_name TEXT, small TEXT, last_search INTEGER)");
  }
  Future<int> saveOrUpdateUser(User user) async{
    int resp;
    if(await getUser(user.username) == null){
      resp = await saveUser(user);
    }else{
      resp = await updateUser(user);
    }
    return resp;
  }
  Future<int> saveUser(User user) async{
    var dbClient = await db;
    Map temp = user.toMap();
    temp.remove("hd");
    temp["last_search"] = new DateTime.now().millisecondsSinceEpoch;
    int resp = await dbClient.insert("Users", temp);
    return resp;
  }

  Future<int> deleteUser(User user) async{
    var dbClient = await db;
    int resp = await dbClient.delete("Users", where: "id = ?", whereArgs: [user.id]);
    return resp;
  }

  Future<int> updateUser(User user) async{
    var dbClient = await db;
    Map temp = user.toMap();
    temp.remove("hd");
    temp["last_search"] = new DateTime.now().millisecondsSinceEpoch;
    int resp = await dbClient.update("Users", temp, where: 'id = ?', whereArgs: [user.id]);
    return resp;
  }

  Future<User> getUser(String username) async{
    var dbClient = await db;
    List<Map> maps = await dbClient.query("Users", where: "username = ?", whereArgs: [username]);
    if(maps.length > 0){
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<User>> getRecentlyUsers(int lim) async{
    var dbClient = await db;
    List<Map> maps = await dbClient.query("Users", orderBy: "last_search DESC", limit: lim);
    List<User> recently = maps.map((user) => User.fromMap(user)).toList();
    return recently;
  }
}