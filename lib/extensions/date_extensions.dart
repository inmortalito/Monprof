
import 'package:eclass/extensions/time_ago_trans.dart';
import 'package:timeago/timeago.dart' as timeago;


extension DateExtension on DateTime {

  String timeAgo(){
    timeago.setLocaleMessages('ar', MyCustomMessages());
    return timeago.format(this, locale: 'ar');
  }
}
