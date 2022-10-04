// my_custom_messages.dart
import 'package:timeago/timeago.dart';

class MyCustomMessages implements LookupMessages {
  @override
  String prefixAgo() => '';

  @override
  String prefixFromNow() => '';

  @override
  String suffixAgo() => '';

  @override
  String suffixFromNow() => '';

  @override
  String lessThanOneMinute(int seconds) => 'الآن';

  @override
  String aboutAMinute(int minutes) => '${minutes} دقيقة';

  @override
  String minutes(int minutes) => '${minutes} دقيقة';

  @override
  String aboutAnHour(int minutes) => '${minutes} دقيقة';

  @override
  String hours(int hours) => '${hours} ساعة';

  @override
  String aDay(int hours) => '${hours} يوم';

  @override
  String days(int days) => '${days} يوم';

  @override
  String aboutAMonth(int days) => '${days} يوم';

  @override
  String months(int months) => '${months} شهر';

  @override
  String aboutAYear(int year) => '${year} شهر';

  @override
  String years(int years) => '${years} سنة';

  @override
  String wordSeparator() => ' ';
}
