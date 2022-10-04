import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'common/global.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  authToken = await storage.read(key: "token");
  await Firebase.initializeApp();
  runApp(MyApp(authToken));
}



