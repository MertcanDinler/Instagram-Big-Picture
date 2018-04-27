import 'package:instagram_big_picture/data/api.dart';
import 'package:instagram_big_picture/models/user.dart';

abstract class HomePageContract {
  void onSearchStarted();
  void onSearchEnd();
  void onSearchError(error);
  void onUserFound(int id);
  void onUserNotFound(String username);
  void onGetUserInfoStarted();
  void onGetUserInfoEnd();
  void onGetUserInfoSuccessfull(User user);
  void onGetUserInfoError(error);
}

class HomePagePresenter {
  HomePageContract _view;
  Api api = new Api();
  HomePagePresenter(this._view);

  doSearch(String username) {
    _view.onSearchStarted();
    api.getUserID(username).then((int id) {
      _view.onSearchEnd();
      if (id == 0) {
        _view.onUserNotFound(username);
        return;
      }
      _view.onUserFound(id);
      doGetInfo(id);
    }).catchError((error) {
      _view.onSearchEnd();
      if (error.runtimeType == NoSuchMethodError) {
        _view.onUserNotFound(username);
        return;
      }
      _view.onSearchError(error);
    });
  }

  doGetInfo(int id) {
    _view.onGetUserInfoStarted();
    api.getUserInfo(id).then((user) {
      _view.onGetUserInfoSuccessfull(user);
    }).catchError((error) => _view.onGetUserInfoError(error));
    _view.onGetUserInfoEnd();
  }
}
