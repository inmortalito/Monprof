import 'dart:convert';

import 'package:eclass/Screens/cours_screen.dart';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/model/home_model.dart';
import 'package:eclass/provider/home_data_provider.dart';
import 'package:eclass/provider/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class Semester extends StatefulWidget {
  Function(String) onSemesterSelected;

  Semester({this.onSemesterSelected});

  @override
  _Semester createState() => _Semester();
}

class _Semester extends State<Semester> {
  Animation<double> animation;
  var squareScaleB = 1.0;

  String page = "0";

  Function(String) get onSemesterSelected => widget.onSemesterSelected;

  List<String> semesterId = [];

  Widget button_semester(width, String title, bool active) {
    int clr;
    if (active) {
      clr = 0xFF037FF2;
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
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(15.0),
          child: Text(
            "Semester " + title,
            style: TextStyle(
                fontFamily: "Mada", fontSize: 18.0, color: Color(0xFFFFFFFF)),
          ),
          color: Color(clr),
          disabledColor: Color(clr).withOpacity(0.5),
          onPressed: () {
            if (active) {

              onSemesterSelected(title);
              /*
              Navigator.pushNamed(
                context,
                "/courses",
                arguments: {'S': title},
              );
              */
            }
          },
        ),
      ),
    );
  }

  Future<List<String>> get_semesters(String usrId) async {
    List<String> semestersId = [];
    String url = APIData.semester + "${APIData.secretKey}";
    Response res = await post(url, body: {"user_id": usrId});

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body)[0];

      for (int i = 0; i < body.length; i++) {
        semestersId.add(body[i]);
      }

      return semestersId;
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProfile user = Provider.of<UserProfile>(context, listen: false);
    int usr_id = user.profileInstance.id;

    var width = MediaQuery.of(context).size.width;
    return  Scaffold(
            body: FutureBuilder(
                future: get_semesters("$usr_id"),
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.hasData) {
                    List<String> semesterId = snapshot.data;

                    return Container(
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
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    for (var i = 1; i <= 2; i++)
                                      button_semester(width, "$i",
                                          semesterId.contains("$i")),
                                  ],
                                  //decoration: BoxDecoration(color: Colors.white)
                                ),
                              ),
                            )),
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          );

  }
}
