//import 'package:eclass/provider/categories.dart';
//import 'package:eclass/provider/home_data_provider.dart';
//import 'package:provider/provider.dart';

import '../Widgets/utils.dart';
import '../services/http_services.dart';
import 'package:flutter/material.dart';
import '../model/home_model.dart';

import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';
import '../common/apidata.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController lastController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController faculteController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  Future<List<String>> get_city() async {
    List<String> city = [];
    String url = APIData.city + "${APIData.secretKey}";
    Response res = await get(url);

    //print(res.body);
    //print(res.statusCode);
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body)["city"];

      //print("===========333333====");
      //print(body.length);
      //print("===========333333====");

      for (int i = 0; i < body.length; i++) {
        //print(body[i]["name"]);
        city.add(body[i]["name"]);
      }
      //print("===========333333====");
      return city;
    }
  }

  Future<List<String>> get_category() async {
    List<String> subcategories = [];
    String url = APIData.subCategories + "${APIData.secretKey}";
    Response res = await get(url);

    //print(res.body);
    //print(res.statusCode);
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body)["category"];

      //print("===========333333====");
      //print(body.length);
      //print("===========333333====");

      for (int i = 0; i < body.length; i++) {
        //print(body[i]["title"]["en"]);
        subcategories.add(body[i]["title"]["en"]);
      }
      //print("===========333333====");
      return subcategories;
    }
  }

  List<String> categories = [];
  List<String> city = [];

  @override
  void initState() {
    super.initState();
    //Future<List<String>> subcategories = get_category();
    get_city().then((value) {
      setState(() {
        city = value;
      });
      //print(value);
    });

    get_category().then((value) {
      setState(() {
        categories = value;
      });
      //print(value);
    });
    //List subcategories = await _subcategories ;
    //print(value);
  }

  String _citie;

  Widget cityField() {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5.0,
      shadowColor: Colors.grey.withOpacity(0.6),
      child: DropdownButtonFormField(
        items: city.map((String category) {
          return new DropdownMenuItem(
              value: category,
              child: Row(
                children: <Widget>[
                  Text(category),
                ],
              ));
        }).toList(),
        onChanged: (newValue) {
          // do other stuff with _category
          setState(() => _citie = newValue);
        },
        value: _citie,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Ville",
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  String _category;

  Widget filiereField() {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5.0,
      shadowColor: Colors.grey.withOpacity(0.6),
      child: DropdownButtonFormField(
        isExpanded: true,
        items: categories.map((String category) {
          return new DropdownMenuItem(
              value: category,
              child: Row(
                children: <Widget>[
                  Text(category,
                      style: TextStyle(fontSize: 15),
                      overflow: TextOverflow.ellipsis),
                ],
              ));
        }).toList(),
        onChanged: (newValue) {
          // do other stuff with _category
          setState(() => _category = newValue);
        },
        value: _category,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Filiére",
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget privacyPolicy() {
    return Container(
      // width: MediaQuery.of(context).size.width - 100,
      padding: EdgeInsets.symmetric(horizontal: 25),
      height: 65,
      alignment: Alignment.center,
      child: Wrap(
        runAlignment: WrapAlignment.center,
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            "En vous inscrivant, vous acceptez nos ",
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            "Termes & Conditions, Politique de confidentialité",
            style: TextStyle(fontSize: 16.0, color: Colors.blue[400]),
          )
        ],
      ),
    );
  }

  bool _hidePass = true;

  Widget nameField() {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5.0,
      shadowColor: Colors.grey.withOpacity(0.6),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: nameController,
        decoration: InputDecoration(
          hintText: "Nom",
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter name';
          }
          return null;
        },
      ),
    );
  }

  Widget lastnameField() {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5.0,
      shadowColor: Colors.grey.withOpacity(0.6),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: lastController,
        decoration: InputDecoration(
          hintText: "Prénom",
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter name';
          }
          return null;
        },
      ),
    );
  }

  Widget phoneField() {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5.0,
      shadowColor: Colors.grey.withOpacity(0.6),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: phoneController,
        decoration: InputDecoration(
          hintText: "Téléphone",
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter phone';
          }
          return null;
        },
      ),
    );
  }

  Widget faculteField() {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5.0,
      shadowColor: Colors.grey.withOpacity(0.6),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: faculteController,
        decoration: InputDecoration(
          hintText: "École",
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Entre le nom de votre faculté';
          }
          return null;
        },
      ),
    );
  }

  //List<SubCategory> subCategoryList = [];

  Widget emailField() {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5.0,
      shadowColor: Colors.grey.withOpacity(0.6),
      child: TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: "Address Email",
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value.length == 0) {
            return 'Email can not be empty';
          } else {
            if (!value.contains('@')) {
              return 'Invalid Email';
            } else {
              return null;
            }
          }
        },
      ),
    );
  }

  Widget passwordField() {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 5.0,
      shadowColor: Colors.grey.withOpacity(0.6),
      child: TextFormField(
        controller: passwordController,
        decoration: InputDecoration(
          hintText: "Mot de pass",
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: IconButton(
            padding: EdgeInsets.zero,
            icon: this._hidePass
                ? Icon(
                    Icons.visibility_off,
                    color: Colors.grey,
                  )
                : Icon(
                    Icons.visibility,
                    color: Colors.grey,
                  ),
            onPressed: () {
              setState(() => this._hidePass = !this._hidePass);
            },
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return "Enter password";
          } else {
            if (value.length < 6) {
              return "Minimum 6 characters required";
            } else {
              return null;
            }
          }
        },
        obscureText: _hidePass == true ? true : false,
      ),
    );
  }

  Widget logopng() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 60.0),
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 500),
        child: new Image.asset(
          "assets/new/logo_new.png",
          scale: 1.5,
        ),
      ),
    );
  }

  Widget signUpText() {
    return Container(
      alignment: Alignment.center,
      height: 60.0,
      padding: EdgeInsets.only(left: 17.0),
      width: MediaQuery.of(context).size.width - 20,
      child: Column(
        children: [
          Text(
            "S’inscrire",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 1.0),
          ),
          Text(
            "C’est rapide et facile.",
            style:
                TextStyle(fontSize: 14, letterSpacing: 1.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  //sign up button to submit details to server
  Widget signUpButton(formKey) {
    return InkWell(
      onTap: () async {
        FocusScope.of(context).unfocus();
        final form = formKey.currentState;
        form.save();
        if (form.validate() == true) {
          setState(() {
            isloading = true;
          });
          int signUp;
          signUp = await httpService.signUp(
              nameController.value.text,
              lastController.value.text,
              emailController.value.text,
              phoneController.value.text,
              faculteController.value.text,
              _category,
              _citie,
              passwordController.value.text);
          if (signUp==200) {
            setState(() {
              isloading = false;
            });
            scaffoldKey.currentState.showSnackBar(SnackBar(
              backgroundColor: Color(0xFF42ba96),
              content:
                  Text("Inscription réussie!! Connectez-vous à votre compte"),
              action: SnackBarAction(
                  textColor: Colors.white,
                  label: "ok",
                  onPressed: () {
                    Navigator.of(context).pushNamed('/SignIn');
                  }),
            ));
            await Future.delayed(Duration(seconds: 4));

            Navigator.of(context).pushNamed('/SignIn');
          } else if(signUp==302) {
            setState(() {
              isloading = false;
            });
            scaffoldKey.currentState.showSnackBar(SnackBar(
              backgroundColor: Color(0xFFdf4759),
              content: Text("Cette adresse e-mail a été déjà utilisée !!"),
              action: SnackBarAction(
                  textColor: Colors.white,
                  label: "Recommencez",
                  onPressed: () {
                    setState(() {});
                  }),
            ));
          }else{
            setState(() {
              isloading = false;
            });
            scaffoldKey.currentState.showSnackBar(SnackBar(
              backgroundColor: Color(0xFFdf4759),
              content: Text("L'inscription a échoué !!"),
              action: SnackBarAction(
                  textColor: Colors.white,
                  label: "Recommencez",
                  onPressed: () {
                    setState(() {});
                  }),
            ));
          }
        } else {
          return;
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: 55,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Color(0xFF037FF2),
            borderRadius: BorderRadius.circular(10.0)),
        child: !isloading
            ? Text(
                "S’inscrire",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              )
            : CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation(Colors.white),
              ),
      ),
    );
  }

  //form for taking inputs
  Widget form() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            nameField(),
            SizedBox(
              height: 10.0,
            ),
            lastnameField(),
            SizedBox(
              height: 10.0,
            ),
            emailField(),
            SizedBox(
              height: 10.0,
            ),
            passwordField(),
            SizedBox(
              height: 10.0,
            ),
            phoneField(),
            SizedBox(
              height: 10.0,
            ),
            filiereField(),
            SizedBox(
              height: 10.0,
            ),
            faculteField(),
            SizedBox(
              height: 10.0,
            ),
            cityField(),
            SizedBox(
              height: 30,
            ),
            signUpButton(_formKey),
          ],
        ),
      ),
    );
  }

  Widget scaffoldBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 0.0),
        child: Column(
          children: [
            logopng(),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              child: Column(
                children: [
                  signUpText(),
                  SizedBox(
                    height: 20,
                  ),
                  form(),
                  //privacyPolicy(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: cusDivider(Colors.grey),
                  ),
                  tologin(),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final HttpService httpService = HttpService();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        //backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/new/background_login.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: scaffoldBody() /* add child content here */,
        ));
  }

  //navigate back to login
  Widget tologin() {
    return Container(
        width: MediaQuery.of(context).size.width - 100,
        padding: EdgeInsets.symmetric(horizontal: 25),
        height: 45,
        alignment: Alignment.center,
        child: Wrap(
          runAlignment: WrapAlignment.center,
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              "Vous avez déja un compte ? ",
              style: TextStyle(fontSize: 12.0),
            ),
            InkWell(
              onTap: () {
                return Navigator.of(context).pushNamed('/SignIn');
              },
              child: Container(
                child: Text(
                  "Connexion",
                  style: TextStyle(fontSize: 12.0, color: Colors.blue[400]),
                ),
              ),
            )
          ],
        ));
  }
}
