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
    /*return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Image.network(user.smallPicture)),
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(user.username, style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(user.fullName),
                  )
                ],
              ),
            ),
            new Container(
              child: new IconButton(
                icon: new Icon(Icons.close, color: Colors.red),
                tooltip: "Delete",
                onPressed: (){},
              ),
            ),
          ],
        ),
    );*/
  }
}
