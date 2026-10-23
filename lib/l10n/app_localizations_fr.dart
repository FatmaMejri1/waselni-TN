// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Waselni';

  @override
  String get login => 'Connexion';

  @override
  String get signup => 'Créer un compte';

  @override
  String get email => 'Adresse e-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get logout => 'Déconnexion';

  @override
  String get home => 'Accueil';

  @override
  String get chooseLanguage => 'Choisir la langue';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get arabic => 'Arabe';

  @override
  String get notifications => 'Notifications';

  @override
  String get account => 'Compte';

  @override
  String get signingOut => 'Déconnexion en cours...';

  @override
  String get signOutError => 'Impossible de se déconnecter. Réessayez.';

  @override
  String get schedules => 'Horaires';

  @override
  String get transportSchedules => 'Horaires des transports';

  @override
  String get scheduleDescription =>
      'Les horaires des bus, du métro, des trains et du TGM apparaîtront ici.';

  @override
  String get favorites => 'Favoris';

  @override
  String get yourFavorites => 'Vos favoris';

  @override
  String get favoritesDescription =>
      'Vos itinéraires et lignes de transport enregistrés apparaîtront ici.';

  @override
  String get accountInformation => 'Informations du compte';

  @override
  String welcome(String name) {
    return 'Bienvenue, $name !';
  }

  @override
  String get traveler => 'voyageur';

  @override
  String get journeyStarts => 'Votre voyage commence ici.';

  @override
  String get travelSmarter => 'Voyagez plus intelligemment';

  @override
  String get travelDescription =>
      'Trouvez des informations sur les transports et aidez les autres voyageurs.';

  @override
  String get transport => 'Transports';

  @override
  String get bus => 'Bus';

  @override
  String get metro => 'Métro';

  @override
  String get train => 'Train';

  @override
  String get tgm => 'TGM';

  @override
  String get community => 'Communauté';

  @override
  String get reportProblem => 'Signaler un problème';

  @override
  String get reportDescription =>
      'Signalez les retards, l\'affluence ou les interruptions.';

  @override
  String get transportUpdates => 'Actualités des transports';

  @override
  String get updatesDescription => 'Restez informé de vos trajets.';

  @override
  String get sectionUnavailable =>
      'Cette section n\'est pas encore connectée aux données de transport.';

  @override
  String comingSoon(String feature) {
    return '$feature sera disponible dans une prochaine mise à jour.';
  }

  @override
  String get busSchedules => 'Horaires des bus';

  @override
  String get metroSchedules => 'Horaires du métro';

  @override
  String get trainSchedules => 'Horaires des trains';

  @override
  String get tgmSchedules => 'Horaires du TGM';

  @override
  String get communityReports => 'Signalements de la communauté';
}
