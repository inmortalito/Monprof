import 'package:eclass/model/course.dart';
import 'package:eclass/model/my_courses_model.dart';
import 'package:eclass/provider/courses_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cours_live.dart';

class Cours extends StatefulWidget {
  String semesterId;
  Function(String,String) onCoureSelected;

  Cours({this.semesterId,this.onCoureSelected});


  @override
  _Cours createState() => _Cours();
}

class _Cours extends State<Cours> {
  Animation<double> animation;
  var squareScaleB = 1.0;

  int page = 0;
  String getTitle;

  Function(String,String) get onCoureSelected => widget.onCoureSelected;
  Object get semesterId => widget.semesterId;

  Widget screen1(int cours_id) {
    return CoursLive("$cours_id", getTitle);
  }

  Widget button_cours(width, String title, int coursID, bool active) {
    int clr;
    if (active) {
      clr = 0xFF376AED;
    } else {
      clr = 0xFF707070;
    }
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: ButtonTheme(
        minWidth: width - 50,
        height: 10,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.all(15.0),
          child: Text(
            title,
            style: TextStyle(
                fontFamily: "Mada", fontSize: 18.0, color: Color(0xFFFFFFFF)),
          ),
          color: Color(clr).withOpacity(0.2),
          disabledColor: Color(clr).withOpacity(0.5),
          onPressed: () {
            onCoureSelected("$coursID",title);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // final arguments = (ModalRoute.of(context)?.settings.arguments ??
    //    <String, dynamic>{}) as Map;

    CoursesProvider courses = Provider.of<CoursesProvider>(context);
    //List<Course> allCourses = courses.allCourses;
    List<EnrollDetail> studing = courses.studyingList;
    List<EnrollDetail> mycours = [];

    //String s = arguments['S'];

    /* print("================");
     print("================");*/
    //print("================");
    //print("semester id : " + semesterId);
    //print("================");
    //print("id:" + semesterId);
    studing.forEach((elm) {
      //print(elm.course.title);

      if (elm.course.institude_id == semesterId) {
        if (mycours.contains(elm)) {
          //print("#already added !");
        } else {
          //print("first time add");
          mycours.add(elm);
        }
      }
    });

    //print(mycours.length);
    //print("args : " + arguments['S']);

    return page == 0
        ? Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/new/background_2.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                    height: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? 1.6 * MediaQuery.of(context).size.height
                        : MediaQuery.of(context).size.height,
                    padding: EdgeInsets.all(16),
                    child: Align(
                      alignment: FractionalOffset.center,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 0.0),
                        child: ListView(
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 0.0),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.all(15.0),
                                child: Text(
                                  "Semester " + semesterId,
                                  style: TextStyle(
                                      fontFamily: "Mada",
                                      fontSize: 18.0,
                                      color: Color(0xFFFFFFFF)),
                                ),
                                color: Color(0xFF037FF2),
                                disabledColor:
                                    Color(0xFF037FF2).withOpacity(0.5),
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(
                              height: 60,
                            ),
                            for (int i = 0; i < mycours.length; i++)
                              button_cours(width, mycours[i].course.title,
                                  mycours[i].course.id, true),
                          ],
                          //decoration: BoxDecoration(color: Colors.white)
                        ),
                      ),
                    )),
              ),
            ),
          )
        : screen1(page);
    throw UnimplementedError();
  }
}
