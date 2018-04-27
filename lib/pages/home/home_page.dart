import 'dart:async';
import 'package:flutter/material.dart';
import 'package:instagram_big_picture/data/api.dart';
import 'package:instagram_big_picture/models/user.dart';
import 'package:instagram_big_picture/witgets/user_widget.dart';
import 'home_presenter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> implements HomePageContract {
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  HomePagePresenter presenter;
  bool isLoading = false;
  Api api = new Api();
  String username;
  List<User> recently = <User>[];

  _HomePageState() {
    this.presenter = new HomePagePresenter(this);
  }

  void _submit() {
    if (!isLoading) {
      FocusScope.of(context).requestFocus(new FocusNode());
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        presenter.doSearch(username);
      }
    }
  }

  void _delete(User user) async {
    int resp = await api.deleteUser(user);
    if (resp > 0) {
      setState(() {
        recently.remove(user);
      });
    }
  }

  void _tap(User user) {
    presenter.doGetInfo(user.id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    api.getRecentlyUsers().then((response) {
      setState(() {
        recently = response;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var searchForm = new Form(
      key: formKey,
      child: new Row(
        children: <Widget>[
          new Flexible(
            child: new TextFormField(
              enabled: !isLoading,
              decoration: new InputDecoration(
                labelText: "Username",
              ),
              onSaved: (value) => username = value,
              onFieldSubmitted: (value) => _submit(),
            ),
          ),
          new Container(
            child: new IconButton(
              icon: new Icon(Icons.search),
              onPressed: _submit,
              color: Theme.of(context).accentColor,
              tooltip: "Search",
            ),
          ),
        ],
      ),
    );

    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text("Instagram Big Picture"),
        centerTitle: true,
      ),
      body: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: new Column(
            children: <Widget>[
              searchForm,
              new Flexible(
                child: new ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemBuilder: (BuildContext context, int index) =>
                      new UserWidget(
                          user: recently[index],
                          onTap: _tap,
                          onDelete: _delete,
                          enabled: !isLoading),
                  itemCount: recently.length,
                ),
              )
            ],
          )),
    );
  }

  void showSnackBar(String text) {
    hideSnackBar();
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
      duration: new Duration(minutes: 1),
    ));
  }

  void hideSnackBar() {
    scaffoldKey.currentState.hideCurrentSnackBar();
  }

  @override
  void onGetUserInfoError(error) {
    showSnackBar(error.toString());
    setState(() {
      isLoading = false;
    });
  }

  @override
  void onGetUserInfoStarted() {
    showSnackBar("Getting user information...");
    setState(() {
      isLoading = true;
    });
  }

  @override
  void onGetUserInfoSuccessfull(User user) {
    Navigator.of(context).pushNamed("/picture/" +
        Uri.encodeQueryComponent(user.fullName) +
        "/" +
        Uri.encodeQueryComponent(user.hdPicture));
    user.hdPicture = null;
    recently.removeWhere((u) => u.id == user.id);
    recently.insert(0, user);
    hideSnackBar();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void onSearchEnd() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  void onSearchError(error) {
    showSnackBar(error.toString());
  }

  @override
  void onSearchStarted() {
    showSnackBar("Searching...");
    setState(() {
      isLoading = true;
    });
  }

  @override
  void onUserNotFound(String username) async {
    showSnackBar("User not found");
    await new Future.delayed(new Duration(seconds: 5));
    hideSnackBar();
  }

  @override
  void onUserFound(int id) {
    // TODO: implement onUserFound
  }

  @override
  void onGetUserInfoEnd() {
    // TODO: implement onGetUserInfoEnd
  }
}
