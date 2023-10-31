import 'package:easy_localization/easy_localization.dart';

enum TypeSettingsValue {
  locale,
}

enum TypeEntry {
  nt,
  vt,
}

String getNameMonth(DateTime date) {
  var monthIndex = date.month;
  var year = date.year;
  String nameMonth = '';
  switch (monthIndex) {
    case 1:
      {
        nameMonth = tr('january');
        break;
      }
    case 2:
      {
        nameMonth = tr('february');
        break;
      }
    case 3:
      {
        nameMonth = tr('march');
        break;
      }
    case 4:
      {
        nameMonth = ('april').tr();
        break;
      }
    case 5:
      {
        nameMonth = ('mai').tr();
        break;
      }
    case 6:
      {
        nameMonth = ('june').tr();
        break;
      }
    case 7:
      {
        nameMonth = ('july').tr();
        break;
      }
    case 8:
      {
        nameMonth = ('august').tr();
        break;
      }
    case 9:
      {
        nameMonth = ('september').tr();
        break;
      }
    case 10:
      {
        nameMonth = ('october').tr();
        break;
      }
    case 11:
      {
        nameMonth = ('november').tr();
        break;
      }
    case 12:
      {
        nameMonth = ('december').tr();
        break;
      }
  }

  return '$nameMonth $year';
}
