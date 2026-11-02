import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Waselni'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signup;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @signingOut.
  ///
  /// In en, this message translates to:
  /// **'Signing out...'**
  String get signingOut;

  /// No description provided for @signOutError.
  ///
  /// In en, this message translates to:
  /// **'Unable to sign out. Please try again.'**
  String get signOutError;

  /// No description provided for @schedules.
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get schedules;

  /// No description provided for @transportSchedules.
  ///
  /// In en, this message translates to:
  /// **'Transport schedules'**
  String get transportSchedules;

  /// No description provided for @scheduleDescription.
  ///
  /// In en, this message translates to:
  /// **'Bus, Metro, Train and TGM schedules will appear here.'**
  String get scheduleDescription;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @yourFavorites.
  ///
  /// In en, this message translates to:
  /// **'Your favorites'**
  String get yourFavorites;

  /// No description provided for @favoritesDescription.
  ///
  /// In en, this message translates to:
  /// **'Your saved routes and transport lines will appear here.'**
  String get favoritesDescription;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account information'**
  String get accountInformation;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String welcome(String name);

  /// No description provided for @traveler.
  ///
  /// In en, this message translates to:
  /// **'traveler'**
  String get traveler;

  /// No description provided for @journeyStarts.
  ///
  /// In en, this message translates to:
  /// **'Your journey starts here.'**
  String get journeyStarts;

  /// No description provided for @travelSmarter.
  ///
  /// In en, this message translates to:
  /// **'Travel smarter'**
  String get travelSmarter;

  /// No description provided for @travelDescription.
  ///
  /// In en, this message translates to:
  /// **'Find transport information and help other travelers.'**
  String get travelDescription;

  /// No description provided for @transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// No description provided for @bus.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get bus;

  /// No description provided for @metro.
  ///
  /// In en, this message translates to:
  /// **'Metro'**
  String get metro;

  /// No description provided for @train.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get train;

  /// No description provided for @tgm.
  ///
  /// In en, this message translates to:
  /// **'TGM'**
  String get tgm;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @reportProblem.
  ///
  /// In en, this message translates to:
  /// **'Report a problem'**
  String get reportProblem;

  /// No description provided for @reportDescription.
  ///
  /// In en, this message translates to:
  /// **'Share delays, crowding or interruptions'**
  String get reportDescription;

  /// No description provided for @transportUpdates.
  ///
  /// In en, this message translates to:
  /// **'Transport updates'**
  String get transportUpdates;

  /// No description provided for @updatesDescription.
  ///
  /// In en, this message translates to:
  /// **'Stay informed about your journeys'**
  String get updatesDescription;

  /// No description provided for @sectionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This section is not connected to transport data yet.'**
  String get sectionUnavailable;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} will be available in a future update.'**
  String comingSoon(String feature);

  /// No description provided for @busSchedules.
  ///
  /// In en, this message translates to:
  /// **'Bus schedules'**
  String get busSchedules;

  /// No description provided for @metroSchedules.
  ///
  /// In en, this message translates to:
  /// **'Metro schedules'**
  String get metroSchedules;

  /// No description provided for @trainSchedules.
  ///
  /// In en, this message translates to:
  /// **'Train schedules'**
  String get trainSchedules;

  /// No description provided for @tgmSchedules.
  ///
  /// In en, this message translates to:
  /// **'TGM schedules'**
  String get tgmSchedules;

  /// No description provided for @communityReports.
  ///
  /// In en, this message translates to:
  /// **'Community reports'**
  String get communityReports;

  /// No description provided for @noSchedulesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No schedules available yet.'**
  String get noSchedulesAvailable;

  /// No description provided for @scheduleLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load schedules. Please try again.'**
  String get scheduleLoadError;

  /// No description provided for @departureTime.
  ///
  /// In en, this message translates to:
  /// **'Departure time'**
  String get departureTime;

  /// No description provided for @operatingDays.
  ///
  /// In en, this message translates to:
  /// **'Operating days'**
  String get operatingDays;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @officialSchedule.
  ///
  /// In en, this message translates to:
  /// **'Official schedule'**
  String get officialSchedule;

  /// No description provided for @submitSchedule.
  ///
  /// In en, this message translates to:
  /// **'Suggest a schedule'**
  String get submitSchedule;

  /// No description provided for @selectLine.
  ///
  /// In en, this message translates to:
  /// **'Select a transport line'**
  String get selectLine;

  /// No description provided for @noActiveLines.
  ///
  /// In en, this message translates to:
  /// **'No active transport lines available.'**
  String get noActiveLines;

  /// No description provided for @selectDepartureTime.
  ///
  /// In en, this message translates to:
  /// **'Choose departure time'**
  String get selectDepartureTime;

  /// No description provided for @selectAtLeastOneDay.
  ///
  /// In en, this message translates to:
  /// **'Select at least one operating day.'**
  String get selectAtLeastOneDay;

  /// No description provided for @scheduleSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Your schedule suggestion was submitted successfully.'**
  String get scheduleSubmitted;

  /// No description provided for @scheduleSubmitError.
  ///
  /// In en, this message translates to:
  /// **'Unable to submit your suggestion. Please try again.'**
  String get scheduleSubmitError;

  /// No description provided for @transportLines.
  ///
  /// In en, this message translates to:
  /// **'Transport lines'**
  String get transportLines;

  /// No description provided for @noLinesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No transport lines available.'**
  String get noLinesAvailable;

  /// No description provided for @linesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load transport lines. Please try again.'**
  String get linesLoadError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @stationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No stations} =1{1 station} other{{count} stations}}'**
  String stationsCount(int count);

  /// No description provided for @transportStations.
  ///
  /// In en, this message translates to:
  /// **'Transport stations'**
  String get transportStations;

  /// No description provided for @noStationsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No stations available.'**
  String get noStationsAvailable;

  /// No description provided for @stationsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load stations. Please try again.'**
  String get stationsLoadError;

  /// No description provided for @coordinates.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get coordinates;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
