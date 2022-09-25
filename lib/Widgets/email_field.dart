import '../provider/user_details_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class EmailField extends StatelessWidget {
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
        style:
            TextStyle(color: Colors.black, fontFamily: "Mada", fontSize: 18.0),
        onChanged: (String value) {
          usedeob.changeEmail(value);
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration.collapsed(
          hintText: "Email Address",
          hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontFamily: "Muli",
              fontSize: 14.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return passField(context);
  }
}
