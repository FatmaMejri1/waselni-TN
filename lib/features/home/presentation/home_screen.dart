import 'package:flutter/material.dart';

import '../../../core/constants/routes.dart';
import '../../../core/localization/locale_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();

  int _selectedIndex = 0;
  bool _isSigningOut = false;

  AppLocalizations get _l10n => AppLocalizations.of(context)!;

  Future<void> _signOut() async {
    setState(() => _isSigningOut = true);

    try {
      await _authService.signOut();

      if (!mounted) return;

      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.login, (route) => false);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_l10n.signOutError)));
    } finally {
      if (mounted) {
        setState(() => _isSigningOut = false);
      }
    }
  }

  Future<void> _changeLanguage(String languageCode) async {
    await LocaleController.setLocale(Locale(languageCode));

    if (!mounted) return;

    final languageName = switch (languageCode) {
      'en' => _l10n.english,
      'fr' => _l10n.french,
      'ar' => _l10n.arabic,
      _ => languageCode,
    };

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$languageName selected')));
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(_l10n.comingSoon(feature))));
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final displayName = user?.displayName?.trim();
    final greetingName = displayName != null && displayName.isNotEmpty
        ? displayName
        : _l10n.traveler;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.directions_bus_rounded),
            const SizedBox(width: 8),
            Text(_l10n.appTitle),
          ],
        ),
        actions: [
          IconButton(
            tooltip: _l10n.notifications,
            onPressed: () => _showComingSoon(_l10n.notifications),
            icon: const Icon(Icons.notifications_outlined),
          ),
          PopupMenuButton<String>(
            tooltip: _l10n.account,
            onSelected: (value) {
              if (value == 'logout') {
                _signOut();
              } else if (value.startsWith('lang_')) {
                _changeLanguage(value.substring(5));
              }
            },
            itemBuilder: (context) {
              final currentLanguage = Localizations.localeOf(context)
                  .languageCode;

              return [
                PopupMenuItem<String>(
                  enabled: false,
                  child: Row(
                    children: [
                      const Icon(Icons.language),
                      const SizedBox(width: 12),
                      Text(_l10n.chooseLanguage),
                    ],
                  ),
                ),
                _languageItem('en', _l10n.english, currentLanguage),
                _languageItem('fr', _l10n.french, currentLanguage),
                _languageItem('ar', _l10n.arabic, currentLanguage),
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      const Icon(Icons.logout),
                      const SizedBox(width: 12),
                      Text(_isSigningOut ? _l10n.signingOut : _l10n.logout),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboard(greetingName),
          _buildSimplePage(
            icon: Icons.schedule_outlined,
            title: _l10n.transportSchedules,
            description: _l10n.scheduleDescription,
          ),
          _buildSimplePage(
            icon: Icons.favorite_outline,
            title: _l10n.yourFavorites,
            description: _l10n.favoritesDescription,
          ),
          _buildSimplePage(
            icon: Icons.person_outline,
            title: _l10n.account,
            description: user?.email ?? _l10n.accountInformation,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: _l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.schedule_outlined),
            selectedIcon: const Icon(Icons.schedule),
            label: _l10n.schedules,
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_outline),
            selectedIcon: const Icon(Icons.favorite),
            label: _l10n.favorites,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: _l10n.account,
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _languageItem(
    String code,
    String label,
    String currentLanguage,
  ) {
    return PopupMenuItem<String>(
      value: 'lang_$code',
      child: Row(
        children: [
          const SizedBox(width: 36),
          Text(label),
          const Spacer(),
          if (currentLanguage == code) const Icon(Icons.check, size: 18),
        ],
      ),
    );
  }

  Widget _buildDashboard(String name) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          _l10n.welcome(name),
          style: Theme.of(context).textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(_l10n.journeyStarts, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _l10n.travelSmarter,
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(_l10n.travelDescription),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.directions_transit_rounded,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text(
          _l10n.transport,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.25,
          children: [
            _TransportCard(
              title: _l10n.bus,
              icon: Icons.directions_bus_rounded,
              onTap: () => _showComingSoon(_l10n.busSchedules),
            ),
            _TransportCard(
              title: _l10n.metro,
              icon: Icons.tram_rounded,
              onTap: () => _showComingSoon(_l10n.metroSchedules),
            ),
            _TransportCard(
              title: _l10n.train,
              icon: Icons.train_rounded,
              onTap: () => _showComingSoon(_l10n.trainSchedules),
            ),
            _TransportCard(
              title: _l10n.tgm,
              icon: Icons.directions_railway_rounded,
              onTap: () => _showComingSoon(_l10n.tgmSchedules),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          _l10n.community,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.campaign_outlined)),
            title: Text(_l10n.reportProblem),
            subtitle: Text(_l10n.reportDescription),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showComingSoon(_l10n.communityReports),
          ),
        ),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.notifications_active_outlined),
            ),
            title: Text(_l10n.transportUpdates),
            subtitle: Text(_l10n.updatesDescription),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showComingSoon(_l10n.transportUpdates),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSimplePage({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(description, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text(_l10n.sectionUnavailable, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _TransportCard extends StatelessWidget {
  const _TransportCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: colors.primary),
              const SizedBox(height: 10),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
