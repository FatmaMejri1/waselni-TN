// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'واصلني';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get home => 'الرئيسية';

  @override
  String get chooseLanguage => 'اختر اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get french => 'الفرنسية';

  @override
  String get arabic => 'العربية';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get account => 'الحساب';

  @override
  String get signingOut => 'جارٍ تسجيل الخروج...';

  @override
  String get signOutError => 'تعذر تسجيل الخروج. يرجى المحاولة مرة أخرى.';

  @override
  String get schedules => 'الجداول';

  @override
  String get transportSchedules => 'مواعيد النقل';

  @override
  String get scheduleDescription =>
      'ستظهر هنا مواعيد الحافلات والمترو والقطارات وTGM.';

  @override
  String get favorites => 'المفضلة';

  @override
  String get yourFavorites => 'العناصر المفضلة لديك';

  @override
  String get favoritesDescription => 'ستظهر هنا مساراتك وخطوط النقل المحفوظة.';

  @override
  String get accountInformation => 'معلومات الحساب';

  @override
  String welcome(String name) {
    return 'مرحبًا، $name!';
  }

  @override
  String get traveler => 'مسافر';

  @override
  String get journeyStarts => 'رحلتك تبدأ من هنا.';

  @override
  String get travelSmarter => 'تنقّل بذكاء';

  @override
  String get travelDescription =>
      'اعثر على معلومات النقل وساعد المسافرين الآخرين.';

  @override
  String get transport => 'وسائل النقل';

  @override
  String get bus => 'الحافلة';

  @override
  String get metro => 'المترو';

  @override
  String get train => 'القطار';

  @override
  String get tgm => 'TGM';

  @override
  String get community => 'المجتمع';

  @override
  String get reportProblem => 'الإبلاغ عن مشكلة';

  @override
  String get reportDescription =>
      'شارك معلومات عن التأخير أو الازدحام أو الانقطاعات.';

  @override
  String get transportUpdates => 'تحديثات النقل';

  @override
  String get updatesDescription => 'ابقَ على اطلاع برحلاتك.';

  @override
  String get sectionUnavailable =>
      'هذا القسم غير مرتبط ببيانات النقل حتى الآن.';

  @override
  String comingSoon(String feature) {
    return 'ستتوفر ميزة $feature في تحديث مستقبلي.';
  }

  @override
  String get busSchedules => 'مواعيد الحافلات';

  @override
  String get metroSchedules => 'مواعيد المترو';

  @override
  String get trainSchedules => 'مواعيد القطارات';

  @override
  String get tgmSchedules => 'مواعيد TGM';

  @override
  String get communityReports => 'بلاغات المجتمع';
}
