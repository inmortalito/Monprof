import 'dart:io';
import '../common/apidata.dart';
import '../common/global.dart';
import '../model/faq_model.dart';
import '../model/purchase_history_model.dart';
import '../model/about_us_model.dart';
import '../model/coupon_model.dart';
import '../provider/home_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:convert' as convert;

class Access with ChangeNotifier {
  String accessToken = '';
  String secretKey = '';

  void updateAt(String at) {
    this.accessToken = at;
  }

  void updateSk(String sk) {
    this.secretKey = sk;
  }
}

class HttpService {
  Future<List<FaqElement>> fetchUserFaq() async {
    var response = await http.get("${APIData.userFaq}${APIData.secretKey}");
    var jsonResponse = (convert.jsonDecode(response.body)['faq']) as List;
    return jsonResponse.map((faq) => FaqElement.fromJson(faq)).toList();
  }

  Future<List<FaqElement>> fetchInstructorFaq() async {
    var response =
        await http.get("${APIData.instructorFaq}${APIData.secretKey}");
    var jsonResponse = (convert.jsonDecode(response.body)['faq']) as List;
    return jsonResponse.map((faq) => FaqElement.fromJson(faq)).toList();
  }

  Future<bool> resetPassword(String newPass, String email) async {
    String url = APIData.restPassword;

    http.Response res = await http.post(url, body: {
      "email": email,
      "password": newPass
    }, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    });

    return res.statusCode == 200;
  }

  Future<bool> forgotEmailReq(String _email) async {
    String url = APIData.forgotPassword;

    http.Response res = await http.post(url, body: {"email": _email});
    // return true;
    if (res.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<bool> verifyCode(String email, String code) async {
    String url = APIData.forgotPassword;

    http.Response res =
        await http.post(url, body: {"email": email, "code": code});
    // return true;
    if (res.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<int> login(String email, String pass, BuildContext context) async {
    http.Response res = await http
        .post(APIData.login, body: {"email": email, "password": pass});
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      authToken = body["access_token"];
      var refreshToken = body["access_token"];
      await storage.write(key: "token", value: "$authToken");
      await storage.write(key: "refreshToken", value: "$refreshToken");
      authToken = await storage.read(key: "token");
      HomeDataProvider homeData =
          Provider.of<HomeDataProvider>(context, listen: false);
      await homeData.getHomeDetails(context);
    }
    //print("Hello: ${res.statusCode}");
    return res.statusCode;
  }

  Future<bool> signUp(String name, String last, String email, String phone,
      String faculte, String filiere, String city, String password) async {
    //print(filiere);
    //print(city);
    //return false;
    //return true;
    http.Response res = await http.post(APIData.register, body: {
      "name": name,
      "last": last,
      "phone": phone,
      "faculte": faculte,
      "email": email,
      "filiere": filiere,
      "city": city,
      "password": password
    });
    print("ST: ${res.statusCode}");
    print("body : ${res.body}");
    if (res.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<List<About>> fetchAboutUs() async {
    var response = await http.get(APIData.aboutUs + "${APIData.secretKey}");
    var jsonResponse = (convert.jsonDecode(response.body)['about']) as List;
    return jsonResponse.map((employee) => About.fromJson(employee)).toList();
  }

  Future<bool> logout() async {
    String url = APIData.logOut;
    http.Response res = await http.post(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    });
    if (res.statusCode == 200) {
      authToken = null;
      await storage.deleteAll();
      return true;
    } else
      return false;
  }

  Future<List<CouponModel>> getCartCouponData() async {
    String url = APIData.coupon + APIData.secretKey;

    http.Response res = await http.get(url);
    List<CouponModel> couponList = [];
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body)["coupon"] as List;
      couponList = body.map((e) => CouponModel.fromJson(e)).toList();
    } else {
      throw "err";
    }
    return couponList;
  }

  Future<List<Orderhistory>> fetchPurchaseHistory() async {
    var response = await http
        .get(APIData.purchaseHistory + "${APIData.secretKey}", headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken",
      HttpHeaders.acceptHeader: "application/json"
    });
    if (response.statusCode != 200) {
      return [];
    }
    PurchaseHistory jsonResponse =
        PurchaseHistory.fromJson(convert.jsonDecode(response.body));

    return jsonResponse.orderhistory;
  }
}
