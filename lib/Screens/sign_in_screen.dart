import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

import '../provider/home_data_provider.dart';
import '../Screens/bottom_navigation_screen.dart';
import '../Widgets/email_field.dart';
import '../Widgets/password_field.dart';
import '../provider/user_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../services/http_services.dart';
import 'dart:async';

import 'filiers_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
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
  Widget logo() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      child: AnimatedOpacity(
        opacity: _visible == true ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: new Image.asset(
          "assets/new/logo_new.png",
          scale: 1.2,
        ),
      ),
    );
  }

  Widget signInButton(width) {
    var userDetails = Provider.of<UserDetailsProvider>(context, listen: false);
    return Container(
      child: ButtonTheme(
        minWidth: width - 50,
        height: 10,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(15.0),
          child: Text(
            "Connexion",
            style: TextStyle(
                fontFamily: "Mada", fontSize: 15.0, color: Color(0xFFFFFFFF)),
          ),
          color: Color(0xFF037FF2),
          disabledColor: Color(0xFF037FF2).withOpacity(0.5),
          onPressed: userDetails.getSignInEmail
              ? () async {
                  showLoaderDialog(context);
                  int statuCode = await httpService.login(
                      userDetails.getEmail.value,
                      userDetails.getPass.value,
                      context);
                  Navigator.pop(context);

                  if (statuCode == 200) {
                    userDetails.destroyLoginValues();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyBottomNavigationBar(
                                  pageInd: 0,
                                )));
                    //Navigator.push(context,
                    //   MaterialPageRoute(builder: (context) => Filiers()));

                  } else if (statuCode == 499) {
                    //Navigator.of(context).pushNamed('/SignIn');
                    Navigator.pushNamed(context, "/underreview");
                    /*sk.currentState.showSnackBar(SnackBar(
                        backgroundColor: Color(0xFFffc107),
                        content: Text("Votre compte est en cours d'examen")));*/
                  } else {
                    sk.currentState.showSnackBar(SnackBar(
                        backgroundColor: Color(0xFFdf4759),
                        content: Text(
                            "Demande échoué! S'il vous plaît vérifier vos informations!")));
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
          "Vous n'avez pas un compte?",
          style: TextStyle(
            fontFamily: "Mada",
            fontSize: 12,
            color: Color(0xFF707070),
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
              color: Color(0xFF037FF2), // Text colour here
              width: 1.0, // Underline width
            ))),
            child: InkWell(
              child: Text(
                "Créez-en un maintenant!",
                style: TextStyle(
                    fontFamily: "Mada", fontSize: 12, color: Color(0xFF037FF2)),
              ),
              onTap: () {
                return Navigator.of(context).pushNamed('/signUp');
              },
            )),
      ],
    );
  }

  //  Contact row
  Widget contactez() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MaterialButton(
          padding: EdgeInsets.all(8.0),
          textColor: Colors.white,
          splashColor: Colors.white,
          elevation: 8.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: AssetImage('assets/images/whatsapp.png'),
                  fit: BoxFit.cover),
            ),
            child: Padding(padding: const EdgeInsets.only(top: 50, right: 120)),
          ),
          onPressed: () {
            openwhatsapp();
          },
        ),
        SizedBox(
          width: 10.0,
        ),
        MaterialButton(
          padding: EdgeInsets.all(8.0),
          textColor: Colors.white,
          splashColor: Colors.white,
          elevation: 8.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: AssetImage('assets/images/fb.png'), fit: BoxFit.cover),
            ),
            child: Padding(padding: const EdgeInsets.only(top: 50, right: 120)),
          ),
          onPressed: () {
            openfb();
          },
        ),
      ],
    );
  }

  openfb() async {
    String fbProtocolUrl;
    if (Platform.isIOS) {
      fbProtocolUrl = 'fb://profile/111807941553397';
    } else {
      fbProtocolUrl = 'fb://page/111807941553397';
    }

    String fallbackUrl = 'https://www.facebook.com/AvecMonProf';

    try {
      bool launched = await launch(fbProtocolUrl, forceSafariVC: false);

      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false);
    }
  }

  openwhatsapp() async {
    var whatsapp = "+212717607747";
    //var whatsappURl_android =
       // "whatsapp://send?phone=" + whatsapp + "&text=عرض الدعم2 باك";
    var whatappURL = "https://wa.me/$whatsapp?text=${Uri.parse("عرض الدعم2 باك")}";

      // android , web
      if (await canLaunch(whatappURL)) {
        await launch(whatappURL);
      } else {
        sk.currentState
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }

  }

//  Login View
  Widget loginFields(homeAPIData) {
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            logo(),
            SizedBox(
              height: 30,
            ),
            Text(
              "Login".toUpperCase(),
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 1.0),
            ),
            SizedBox(
              height: 30, // <-- SEE HERE
            ),
            EmailField(),
            SizedBox(
              height: 30.0,
            ),
            PasswordField(),
            SizedBox(
              height: 10.0,
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
                      "Mot de passe oublié?",
                      style: TextStyle(
                          fontFamily: "Mada",
                          fontSize: 14,
                          color: Color(0xFF037FF2)),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/forgotPassword");
                  },
                )),
            signInButton(width),
            SizedBox(
              height: 10,
            ),
            signUpRow(),
            SizedBox(
              height: 50.0,
            ),
            Text(
              "Contactez-Nous".toUpperCase(),
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 1.0),
            ),
            contactez(),
            SizedBox(
              height: 0.0,
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(25.0),
                child: Text(
                  "Copyright ©2022 MonProf",
                  style: TextStyle(
                      fontFamily: "Mada",
                      color: Color(0xFF037FF2).withOpacity(0.5),
                      height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
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
                image: DecorationImage(
                  image: AssetImage('assets/new/background_login.png'),
                  fit: BoxFit.fill,
                ),
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
                      Image.asset("assets/new/logo_new.png", width: 300),
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
