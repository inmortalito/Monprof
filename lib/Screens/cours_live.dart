import 'package:eclass/Widgets/utils.dart';
import 'package:eclass/model/course.dart';
import 'package:eclass/model/user_profile_model.dart';
import 'package:eclass/provider/courses_provider.dart';
import 'package:eclass/provider/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoursLive extends StatefulWidget {
  String coursId;
  String title;

  CoursLive(String cours_id, String get_title) {
    coursId = cours_id;
    title = get_title;
  }

  @override
  _CoursLive createState() => _CoursLive();
}

class _CoursLive extends State<CoursLive> {
  Animation<double> animation;
  var squareScaleB = 1.0;
  Object get coursID => widget.coursId;
  Object get coursTitle => widget.title;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    //UserProfileModel user = Provider.of<UserProfile>(context).profileInstance;
    CoursesProvider courses = Provider.of<CoursesProvider>(context);
    List<Course> allCourses = courses.allCourses;
    Course mainCours;

    allCourses.forEach((element) {
      //print("elem id : ${element.id}  cours id : $coursID");
      if (element.id == int.parse(coursID)) {
        mainCours = element;
      }
    });

    //print(mainCours);

    return Scaffold(
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
              height:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? 1.6 * MediaQuery.of(context).size.height
                      : MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: FractionalOffset.center,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
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
                        child: ButtonTheme(
                          minWidth: width - 50,
                          height: 10,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              coursTitle,
                              style: TextStyle(
                                  fontFamily: "Mada",
                                  fontSize: 18.0,
                                  color: Color(0xFFFFFFFF)),
                            ),
                            color: Color(0xFF376AED).withOpacity(0.2),
                            disabledColor: Color(0xFF376AED).withOpacity(0.5),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 120,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 0.0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.school,
                                color: Colors.white,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 30.0),
                                  child: Text(
                                    "Cours",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Mada",
                                        fontSize: 18.0,
                                        color: Color(0xFFFFFFFF)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          color: Color(0xFF037FF2),
                          disabledColor: Color(0xFF037FF2).withOpacity(0.5),
                          onPressed: () {
                            Navigator.of(context).pushNamed("/courseDetails",
                                arguments: DataSend(
                                    mainCours.userId,
                                    true,
                                    mainCours.id,
                                    mainCours.categoryId,
                                    mainCours.type));
                          },
                        ),
                      ),
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
                          child: Row(
                            children: [
                              Icon(
                                Icons.live_tv,
                                color: Colors.white,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 30.0),
                                  child: Text(
                                    "Live (Exercices)",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Mada",
                                        fontSize: 18.0,
                                        color: Color(0xFFFFFFFF)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          color: Color(0xFF9FA6B2),
                          disabledColor: Color(0xFF9FA6B2).withOpacity(0.5),
                          onPressed: () {
                            /*Navigator.pushNamed(
                              context,
                              '/live',
                              arguments: {
                                'coursId': mainCours.id,
                                'coursTitle': mainCours.title
                              },
                            );*/
                          },
                        ),
                      ),
                    ],
                    //decoration: BoxDecoration(color: Colors.white)
                  ),
                ),
              )),
        ),
      ),
    );
    throw UnimplementedError();
  }
}
