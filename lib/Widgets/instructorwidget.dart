import 'package:cached_network_image/cached_network_image.dart';
import '../common/apidata.dart';
import '../model/instructor_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InstructorWidget extends StatelessWidget {
  final Instructor details;
  InstructorWidget(this.details);

  Widget showImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: CircleAvatar(
          radius: 33.0,
          backgroundImage: details.user.userImg == null
              ? AssetImage("assets/placeholder/avatar.png")
              : CachedNetworkImageProvider(
                  APIData.userImage + "${details.user.userImg}"),
        ),
      ),
    );
  }

  Widget showDetails(BuildContext context) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                details.user.fname + " " + details.user.lname,
                style: TextStyle(
                    color: Color(0xff404455),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('/InstructorScreen', arguments: details);
                  },
                  child: Text(
                    "View more",
                    style: TextStyle(
                        color: Color(0xff8A8C99),
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ))
            ],
          ),
        ),
        Container(
          height: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.user,
                    size: 15.0,
                    color: Color(0xff404455),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(details.enrolledUser.toString() + " Students",
                      style: TextStyle(color: Color(0xff8A8C99)))
                ],
              ),
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.playCircle,
                    size: 15.0,
                    color: Color(0xff404455),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(details.courseCount.toString() + " Courses",
                      style: TextStyle(color: Color(0xff8A8C99)))
                ],
              ),
            ],
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: EdgeInsets.fromLTRB(6.0, 0.0, 12.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          showImage(),
          SizedBox(
            width: 7.0,
          ),
          showDetails(context)
        ],
      ),
    );
  }
}
