import 'dart:convert';
import '../common/apidata.dart';
import '../common/global.dart';
import '../provider/full_course_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class CourseDetailsProvider with ChangeNotifier {
  FullCourse courseDetails;

  Future<FullCourse> getCourseDetails(int id, BuildContext ctx) async {
    String url = APIData.courseDetail + id.toString() + "?secret=${APIData.secretKey}";
    Response res = await get(url);
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body)["course"][0];
      courseDetails = FullCourse.fromJson(body);
    } else {
      throw "err";
    }
    return courseDetails;
  }

}
