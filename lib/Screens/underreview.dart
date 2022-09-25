import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UnderReview extends StatefulWidget {
  @override
  _UnderReview createState() => _UnderReview();
}

class _UnderReview extends State<UnderReview> {
  Animation<double> animation;
  var squareScaleB = 1.0;


  @override
  Widget build(BuildContext context) {
    var widthscreen = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/new/background_login.png"),
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
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.2),
                            spreadRadius: 1),
                      ],
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    width: widthscreen,
                    //height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/new/circle.png',
                          width: 100,
                          height: 100,
                        ),
                        Text(
                          'Succès !',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0477E3)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                            'votre compte est en cours d\'examen, veuillez nous contacter pour activer votre compte dès que possible . Merci',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            )),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                      //decoration: BoxDecoration(color: Colors.white)
                    ),
                  ),
                ),
              )),
        ) /* add child content here */,
      ),
    );
  }
}
