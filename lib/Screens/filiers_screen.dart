import 'dart:async';

import 'package:eclass/Screens/contact_us_screen.dart';
import 'package:eclass/Screens/semester_screen.dart';
import 'package:eclass/model/home_model.dart';
import 'package:eclass/provider/home_data_provider.dart';
import 'package:eclass/provider/user_profile.dart';
import 'package:eclass/provider/visible_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Filiers extends StatefulWidget {
  @override
  _Filiers createState() => _Filiers();
}

class _Filiers extends State<Filiers> {
  Animation<double> animation;
  var squareScaleB = 1.0;
  bool _visible;

  Widget screen1 = Semester();

  int page = 0;

  Widget button_filiere(width, String title, bool active) {
    int clr;
    if (active) {
      clr = 0xFF037FF2;
    } else {
      clr = 0xFF707070;
    }
    return Container(
      margin: const EdgeInsets.only(top: 5.0, bottom: 5),
      child: ButtonTheme(
        minWidth: width - 50,
        height: 10,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(15.0),
          child: Text(
            title,
            style: TextStyle(
                fontFamily: "Mada", fontSize: 18.0, color: Color(0xFFFFFFFF)),
          ),
          color: Color(clr),
          disabledColor: Color(clr).withOpacity(0.5),
          onPressed: () {
            if (active) {
              setState(() {
                page = 2;
              });
              // Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => screen1));
              //  Navigator.pushNamed(context, "/semester");
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProfile user = Provider.of<UserProfile>(context, listen: false);
    var homeData = Provider.of<HomeDataProvider>(context, listen: false);
    List<SubCategory> scList = homeData.subCategoryList;
    var width = MediaQuery.of(context).size.width;

    _visible = Provider.of<Visible>(context).globalVisible;

    if (_visible) {
      int cat_id = int.parse(user.profileInstance.ifscCode);

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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              for (int i = 0; i < scList.length; i++)
                                button_filiere(width, scList[i].title,
                                    scList[i].id == cat_id),
                            ],
                            //decoration: BoxDecoration(color: Colors.white)
                          ),
                        ),
                      )),
                ),
              ),
            )
          : screen1;
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}
