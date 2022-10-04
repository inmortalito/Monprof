import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eclass/model/comment.dart';
import 'package:eclass/services/firebase_controller.dart';

import '../Screens/bottom_navigation_screen.dart';
import '../common/global.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LoadingScreen extends StatefulWidget {
  String token;
  LoadingScreen(this.token);
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _visible = false;

  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var token = await storage.read(key: "token");
      authToken = token;
      HomeDataProvider homeData =
          Provider.of<HomeDataProvider>(context, listen: false);
      await homeData.getHomeDetails(context);
      setState(() {
        authToken = token;
      });
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          _visible = true;
        });
      });
    });
  }

  Widget logoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/new/logo_new.png",width: 200,),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF44A4A)),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _visible == true
          ? MyBottomNavigationBar(
              pageInd: 0,
            )
          : logoWidget(),
    );
  }
}
