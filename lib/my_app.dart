import 'package:eclass/provider/recent_course_provider.dart';
import 'Screens/cours_screen.dart';

import 'Screens/filiers_screen.dart';

import 'Screens/live.dart';
import 'Screens/loading_screen.dart';

import 'Screens/category_screen.dart';
import 'Screens/contact_us_screen.dart';
import 'Screens/course_details_screen.dart';
import 'Screens/courses_screen.dart';
import 'Screens/edit_profile.dart';
import 'Screens/filter_screen.dart';
import 'Screens/forgot_password.dart';

import 'Screens/semester_screen.dart';
import 'Screens/sign_in_screen.dart';
import 'Screens/notification_detail_screen.dart';
import 'Screens/notifications_screen.dart';

import 'Screens/sign_up_screen.dart';

import 'Screens/underreview.dart';
import 'provider/bundle_course.dart';
import 'provider/cart_pro_api.dart';
import 'provider/filter_pro.dart';
import 'provider/home_data_provider.dart';
import 'provider/payment_api_provider.dart';
import 'provider/visible_provider.dart';
import 'provider/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/courses_provider.dart';
import 'provider/user_details_provider.dart';
import 'common/theme.dart' as T;
import 'provider/user_profile.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  String token;
  MyApp(this.token);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserDetailsProvider()), // Fetch User Details
        ChangeNotifierProvider(create: (_) => T.Theme()), // Theme Data
        ChangeNotifierProvider(create: (_) => UserProfile()),
        ChangeNotifierProvider(create: (_) => WishListProvider()),
        ChangeNotifierProvider(create: (_) => CoursesProvider()),
        ChangeNotifierProvider(create: (_) => CartProducts()),
        ChangeNotifierProvider(create: (_) => FilterDetailsProvider()),
        ChangeNotifierProvider(create: (_) => BundleCourseProvider()),
        ChangeNotifierProvider(create: (_) => HomeDataProvider()),
        ChangeNotifierProvider(create: (_) => Visible()),
        ChangeNotifierProvider(create: (_) => RecentCourseProvider()),
        ChangeNotifierProvider(create: (_) => PaymentAPIProvider())
      ],
      child: MaterialApp(
        home: token == null ? SignInScreen() : LoadingScreen(token),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Mada'),
        routes: {
          '/SignIn': (context) => SignInScreen(),
          '/courseDetails': (context) => CourseDetailScreen(),
          '/CoursesScreen': (context) => CoursesScreen(),
          '/signUp': (context) => SignUpScreen(),
          '/category': (context) => CategoryScreen(),
          '/forgotPassword': (context) => ForgotPassword(),
          '/editProfile': (context) => EditProfile(),
          "/filterScreen": (context) => FilterScreen(),
          '/notifications': (context) => NotificationScreen(),
          '/contactUs': (context) => ContactUsScreen(),
          '/notificationDetail': (context) => NotificationDetail(),
          '/underreview': (context) => UnderReview(),
          '/filieres': (context) => Filiers(),
          '/semester': (context) => Semester(),
          '/live': (context) => Live(),
          //'/courses': (context) => Cours(),
        },
      ),
    );
  }
}
