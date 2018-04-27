import 'package:flutter/material.dart';
import 'package:instagram_big_picture/models/user.dart';

class UserWidget extends StatelessWidget {
  UserWidget({this.user, this.onTap, this.onDelete, this.enabled});
  final User user;
  final onTap, onDelete;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[
          new ListTile(
            leading: new CircleAvatar(
              child: new Image.network(user.smallPicture),
            ),
            title: new Text("@" + user.username),
            subtitle: new Text(user.fullName),
            trailing: new IconButton(
              icon: new Icon(Icons.close),
              onPressed: () => onDelete(user),
            ),
            onTap: () => onTap(user),
            enabled: enabled,
          ),
          new Divider(
            height: 2.0,
          )
        ],
      ),
    );
  }
}
