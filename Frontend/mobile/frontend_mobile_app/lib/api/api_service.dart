/*
A singleton class.
Ensures a single instance throughout the entire app
*/
import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/models/user.dart';
import 'package:http/http.dart' as http;
import '../models/boxes.dart';

class ApiService extends ChangeNotifier {
  //Singleton Instance
  static ApiService? _apiInstance;

  //Http client used as gateway for requests
  final _client = http.Client();
  http.Client get httpClient {
    return _client;
  }
  /*------------------------------*/

  // Constructor that's ran first time "instance is called"
  ApiService._init() {
    Boxes.getUser() != null ? signedIn = true : signedIn = false;
    debugPrint("Just got inited");
  }
  /*------------------------------*/

  //Used to fetch the private instance to portray it publicly
  static ApiService? get instance {
    _apiInstance ??= ApiService._init();
    return _apiInstance;
  }
  /*------------------------------*/

  //Auth purposed var and method to let app root know auth status
  late bool signedIn;
  Future<bool> isSignedIn() async {
    await Future.delayed(const Duration(seconds: 2));
    if (Boxes.getUser() == null) {
      signedIn = false;
      return signedIn;
    } else {
      signedIn = true;
      return signedIn;
    }
  }
  /*------------------------------*/

  //Auth method called when middle layer of app determines if signed in
  Future<void> signIn() async {
    signedIn = true;
    notifyListeners();
  }
  /*------------------------------*/

  Future<void> handleUser(Map res) async {
print(res);
    try {
 /*     List<String> stringInterests =[];
   List? fromJson = res['interests'];
       fromJson != null ?  fromJson!.forEach((element) {
        stringInterests.add(element as String);
      },): null;*/
      print("woop woop ");
      debugPrint(res.toString());
      var currentUser = User(
          shortLifeJwt: res['jwt'],
          id: res['id'],
          name: res['name'],
          interests:  res['interests'],
          verifiedStudent: res['verified_student']);
      await Boxes.getUserBox().put('mainUser', currentUser);
      await signIn();
    } catch (e) {
      print("uhoh");
      debugPrint(e.toString());
    }
  }

  Future<void> signout() async {
    await Boxes.getUserBox().delete('mainUser');
    signedIn = false;
    notifyListeners();
  }
}
