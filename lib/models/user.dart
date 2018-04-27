class User {
  int id;
  String username, fullName, smallPicture, hdPicture;
  User(this.id, this.username, this.fullName, this.smallPicture, this.hdPicture);
  User.fromMap(Map map) {
    this.id = map["id"];
    this.username = map["username"];
    this.fullName = map["full_name"];
    this.smallPicture = map["small"];
    this.hdPicture = map["hd"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["username"] = username;
    map["full_name"] = fullName;
    map["small"] = this.smallPicture;
    map["hd"] = this.hdPicture;
    return map;
  }
}
