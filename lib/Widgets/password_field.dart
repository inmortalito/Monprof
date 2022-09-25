import '../provider/user_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PasswordField extends StatefulWidget {
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _showPassword = true;

  Widget passField(context) {
    var usedeob = Provider.of<UserDetailsProvider>(context);
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 2),
            )
          ]),
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      child: TextField(
        obscureText: _showPassword,
        style:
            TextStyle(color: Colors.black, fontFamily: "Mada", fontSize: 18.0),
        onChanged: (String value) {
          usedeob.changePass(value);
        },
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            padding: EdgeInsets.zero,
            icon: this._showPassword
                ? Icon(
                    Icons.visibility_off,
                    color: Colors.grey,
                  )
                : Icon(
                    Icons.visibility,
                    color: Colors.grey,
                  ),
            onPressed: () {
              setState(() => this._showPassword = !this._showPassword);
            },
          ),
          hintText: "Password",
          hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontFamily: "Muli",
              fontSize: 14.0),
          focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.0)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.0)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return passField(context);
  }
}
