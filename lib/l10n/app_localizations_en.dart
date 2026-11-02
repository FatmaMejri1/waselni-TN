// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Waselni';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Sign up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get logout => 'Log out';

  @override
  String get home => 'Home';

  @override
  String get chooseLanguage => 'Choose language';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get arabic => 'Arabic';

  @override
  String get notifications => 'Notifications';

  @override
  String get account => 'Account';

  @override
  String get signingOut => 'Signing out...';

  @override
  String get signOutError => 'Unable to sign out. Please try again.';

  @override
  String get schedules => 'Schedules';

  @override
  String get transportSchedules => 'Transport schedules';

  @override
  String get scheduleDescription =>
      'Bus, Metro, Train and TGM schedules will appear here.';

  @override
  String get favorites => 'Favorites';

  @override
  String get yourFavorites => 'Your favorites';

  @override
  String get favoritesDescription =>
      'Your saved routes and transport lines will appear here.';

  @override
  String get accountInformation => 'Account information';

  @override
  String welcome(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get traveler => 'traveler';

  @override
  String get journeyStarts => 'Your journey starts here.';

  @override
  String get travelSmarter => 'Travel smarter';

  @override
  String get travelDescription =>
      'Find transport information and help other travelers.';

  @override
  String get transport => 'Transport';

  @override
  String get bus => 'Bus';

  @override
  String get metro => 'Metro';

  @override
  String get train => 'Train';

  @override
  String get tgm => 'TGM';

  @override
  String get community => 'Community';

  @override
  String get reportProblem => 'Report a problem';

  @override
  String get reportDescription => 'Share delays, crowding or interruptions';

  @override
  String get transportUpdates => 'Transport updates';

  @override
  String get updatesDescription => 'Stay informed about your journeys';

  @override
  String get sectionUnavailable =>
      'This section is not connected to transport data yet.';

  @override
  String comingSoon(String feature) {
    return '$feature will be available in a future update.';
  }

  @override
  String get busSchedules => 'Bus schedules';

  @override
  String get metroSchedules => 'Metro schedules';

  @override
  String get trainSchedules => 'Train schedules';

  @override
  String get tgmSchedules => 'TGM schedules';

  @override
  String get communityReports => 'Community reports';

  @override
  String get noSchedulesAvailable => 'No schedules available yet.';

  @override
  String get scheduleLoadError => 'Unable to load schedules. Please try again.';

  @override
  String get departureTime => 'Departure time';

  @override
  String get operatingDays => 'Operating days';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get officialSchedule => 'Official schedule';

  @override
  String get submitSchedule => 'Suggest a schedule';

  @override
  String get selectLine => 'Select a transport line';

  @override
  String get noActiveLines => 'No active transport lines available.';

  @override
  String get selectDepartureTime => 'Choose departure time';

  @override
  String get selectAtLeastOneDay => 'Select at least one operating day.';

  @override
  String get scheduleSubmitted =>
      'Your schedule suggestion was submitted successfully.';

  @override
  String get scheduleSubmitError =>
      'Unable to submit your suggestion. Please try again.';

  @override
  String get transportLines => 'Transport lines';

  @override
  String get noLinesAvailable => 'No transport lines available.';

  @override
  String get linesLoadError =>
      'Unable to load transport lines. Please try again.';

  @override
  String get retry => 'Retry';

  @override
  String stationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stations',
      one: '1 station',
      zero: 'No stations',
    );
    return '$_temp0';
  }

  @override
  String get transportStations => 'Transport stations';

  @override
  String get noStationsAvailable => 'No stations available.';

  @override
  String get stationsLoadError => 'Unable to load stations. Please try again.';

  @override
  String get coordinates => 'Coordinates';
}
