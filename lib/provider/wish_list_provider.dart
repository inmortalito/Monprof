import '../common/apidata.dart';
import '../common/global.dart';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WishListProvider with ChangeNotifier {
  List<dynamic> courseIds = [];

  bool checkForFav(dynamic id) {
    bool ans = false;
    courseIds.forEach((element) {
      if (element == id) ans = true;
    });
    return ans;
  }

  int checkDataType(dynamic x) {
    if (x is int) {
      return 0;
    } else {
      return 1;
    }
  }

  Future<void> initDetails(context) async {
    authToken = await storage.read(key: "token");
    String url = "${APIData.wishList}${APIData.secretKey}";
    http.Response res = await http.post(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    });
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body)["wishlist"];

      courseIds = [];
      for (int i = 0; i < body.length; i++) {
        dynamic id = int.parse(body[i]["course_id"]);
        courseIds.add(checkDataType(id) == 0 ? id : int.parse(id));
      }
    } else if (res.statusCode == 401){
      await storage.deleteAll();
      Navigator.of(context).pushNamed('/SignIn');
    }else {
      throw "Can't get wishlist";
    }
    notifyListeners();
  }

  List<dynamic> dura = [
    [0, 2],
    [3, 6],
    [6, 1000]
  ];

  bool duration(String dur, int durv) {
    if (durv == -1) return true;
    int d;
    if (dur == null) {
      d = 0;
    } else {
      d = int.parse(dur);
    }
    return d >= dura[durv][0] && d <= dura[durv][1];
  }

  List<dynamic> get getwishcourseid {
    return [...courseIds];
  }

  Future<bool> toggle(dynamic id, bool isFav) async {
    if (!isFav) {
      String url = "${APIData.addToWishList}" + APIData.secretKey;
      // authToken = await storage.read(key: "token");
      http.Response res = await http.post(url, body: {
        "course_id": "$id"
      }, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      });
      print(res.body);
      if (res.statusCode == 200) {
        courseIds.add(id);
        notifyListeners();
        return true;
      } else
        // notifyListeners();
        return false;
      // }
    } else {
      // bool shouldDo = false;
      // courseIds.forEach((element) {
      //   if (element == id) shouldDo = true;
      // });

      // if (shouldDo) {
      String url = "${APIData.removeWishList}" + APIData.secretKey;

      http.Response res = await http.post(url, body: {
        "course_id": "$id"
      }, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      });

      if (res.statusCode == 200) {
        courseIds.remove(id);
        notifyListeners();
        return true;
      } else
        notifyListeners();
      return false;
      // }
    }
  }
}
