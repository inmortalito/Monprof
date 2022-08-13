import '../provider/home_data_provider.dart';
import '../Screens/bottom_navigation_screen.dart';
import '../Widgets/email_field.dart';
import '../Widgets/password_field.dart';
import '../provider/user_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../services/http_services.dart';
import 'dart:async';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with TickerProviderStateMixin {
  int _duration;
  bool _visible = false;
  Animation<double> animation;
  AnimationController animationController;
  var squareScaleB = 1.0;
  AnimationController _controllerB;
  final HttpService httpService = HttpService();

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      HomeDataProvider homeData =
          Provider.of<HomeDataProvider>(context, listen: false);
      await homeData.getHomeDetails(context);
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          _visible = true;
        });
      });
    });

    _duration = 1200;
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: _duration));
    animation = Tween<double>(begin: 0, end: -165).animate(animationController)
      ..addListener(() {
        setState(() {});
      });

    _controllerB = AnimationController(
        vsync: this,
        lowerBound: 1.0,
        upperBound: 1.20,
        duration: Duration(milliseconds: 3000));
    _controllerB.addListener(() {
      setState(() {
        squareScaleB = _controllerB.value;
      });
    });

    Timer(Duration(milliseconds: 500), () {
      animationController.forward();
      _controllerB.forward(from: 0.0);
    });
    super.initState();
  }

// Alert dialog after clicking on login button
  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Signing In ...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

// Logo on login page
  Widget logo(String img) {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 60.0),
      child: AnimatedOpacity(
        opacity: _visible == true ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: new Image.asset(
          "assets/images/logologin.png",
          scale: 1.5,
        ),
      ),
    );
  }

  Widget signInButton(width) {
    var userDetails = Provider.of<UserDetailsProvider>(context, listen: false);
    return Container(
      child: ButtonTheme(
        minWidth: width - 50,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
          padding: EdgeInsets.all(15.0),
          child: Text(
            "Sign In",
            style: TextStyle(
                fontFamily: "Mada", fontSize: 22.0, color: Color(0xFF181632)),
          ),
          color: Colors.white,
          disabledColor: Colors.white.withOpacity(0.5),
          onPressed: userDetails.getSignInEmail
              ? () async {
                  showLoaderDialog(context);
                  bool login = await httpService.login(
                      userDetails.getEmail.value,
                      userDetails.getPass.value,
                      context);
                  Navigator.pop(context);
                  if (login) {
                    userDetails.destroyLoginValues();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyBottomNavigationBar(
                                  pageInd: 0,
                                )));
                  } else {
                    sk.currentState.showSnackBar(SnackBar(
                        content: Text(
                            "Request Fail ! Please recheck Your Details!")));
                  }
                }
              : null,
        ),
      ),
    );
  }

  final sk = new GlobalKey<ScaffoldState>();

//  Sign up row
  Widget signUpRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Don't have an account ?",
          style: TextStyle(
            fontFamily: "Mada",
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Container(
            padding: EdgeInsets.only(
              bottom: 3, // space between underline and text
            ),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: Colors.white, // Text colour here
              width: 1.0, // Underline width
            ))),
            child: InkWell(
              child: Text(
                "Sign Up",
                style: TextStyle(
                    fontFamily: "Mada", fontSize: 16, color: Colors.white),
              ),
              onTap: () {
                return Navigator.of(context).pushNamed('/signUp');
              },
            )),
      ],
    );
  }

//  Login View
  Widget loginFields(homeAPIData) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          logo(homeAPIData.homeModel.settings.logo),
          SizedBox(
            height: 30,
          ),
          EmailField(),
          SizedBox(
            height: 30.0,
          ),
          PasswordField(),
          SizedBox(
            height: 30.0,
          ),
          signInButton(width),
          SizedBox(
            height: 90.0,
          ),
          signUpRow(),
          SizedBox(
            height: 10,
          ),
          Container(
              padding: EdgeInsets.only(
                bottom: 3, // space between underline and text
              ),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Colors.white, // Text colour here
                width: 1.0, // Underline width
              ))),
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        fontFamily: "Mada", fontSize: 14, color: Colors.white),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/forgotPassword");
                },
              )),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(25.0),
              child: Text(
                homeAPIData.homeModel.settings.cpyTxt,
                style: TextStyle(
                    fontFamily: "Mada",
                    color: Colors.white.withOpacity(0.5),
                    height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget backgroundView(width) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: IntrinsicHeight(
          child: Stack(children: <Widget>[
            Transform.translate(
              offset: Offset(0, animation.value),
              child: Transform.scale(
                scale: squareScaleB,
                child: Container(
                  width: width,
                  child: Image.asset(
                    'assets/images/loginbgscroll.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: FractionalOffset.bottomCenter,
                    stops: [
                      0.0,
                      0.20,
                      0.28,
                      0.60
                    ],
                    colors: [
                      Color(0xFF181632).withOpacity(0.3),
                      Color(0xFF181632).withOpacity(0.7),
                      Color(0xFF181632).withOpacity(0.9),
                      Color(0xFF181632)
                    ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

// All Login field logo, text fields, text, social icons, copyright text, sign up text
  Widget loginView(width, homeAPIData) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
          height: MediaQuery.of(context).orientation == Orientation.landscape
              ? 1.6 * MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(16),
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: loginFields(homeAPIData),
          )),
    );
  }

  Widget scaffoldView(width, homeAPIData) {
    return Stack(
      children: <Widget>[
        backgroundView(width),
        loginView(width, homeAPIData),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var homeData = Provider.of<HomeDataProvider>(context);
    return Scaffold(
      key: sk,
      resizeToAvoidBottomInset: false,
      body: homeData.homeModel == null
          ? Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/logo.png"),
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
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFF44A4A)),
                      ),
                    ],
                  )
                ],
              ),
            )
          : scaffoldView(width, homeData),
    );
  }
}
