import 'package:flutter/material.dart';

import '../../auth/data/auth_service.dart';
import '../../../core/constants/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();

  int _selectedIndex = 0;
  bool _isSigningOut = false;

  Future<void> _signOut() async {
    setState(() => _isSigningOut = true);

    try {
      await _authService.signOut();

      if (!mounted) return;

      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.login, (route) => false);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to sign out. Please try again.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSigningOut = false);
      }
    }
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature will be available in a future update.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final displayName = user?.displayName?.trim();
    final greetingName = displayName != null && displayName.isNotEmpty
        ? displayName
        : 'traveler';

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.directions_bus_rounded),
            SizedBox(width: 8),
            Text('Waselni'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => _showComingSoon('Notifications'),
            icon: const Icon(Icons.notifications_outlined),
          ),
          PopupMenuButton<String>(
            tooltip: 'Account',
            onSelected: (value) {
              if (value == 'logout') {
                _signOut();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    const Icon(Icons.logout),
                    const SizedBox(width: 12),
                    Text(_isSigningOut ? 'Signing out...' : 'Log out'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildDashboard(greetingName),
          _buildSimplePage(
            icon: Icons.schedule_outlined,
            title: 'Transport schedules',
            description:
                'Bus, Metro, Train and TGM schedules will appear here.',
          ),
          _buildSimplePage(
            icon: Icons.favorite_outline,
            title: 'Your favorites',
            description:
                'Your saved routes and transport lines will appear here.',
          ),
          _buildSimplePage(
            icon: Icons.person_outline,
            title: 'Your account',
            description: user?.email ?? 'Account information',
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.schedule_outlined),
            selectedIcon: Icon(Icons.schedule),
            label: 'Schedules',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(String name) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Welcome, $name!',
          style: Theme.of(context).textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Your journey starts here.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),

        // Main banner
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
                      'Travel smarter',
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Find transport information and help other travelers.',
                    ),
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
          'Transport',
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
              title: 'Bus',
              icon: Icons.directions_bus_rounded,
              onTap: () => _showComingSoon('Bus schedules'),
            ),
            _TransportCard(
              title: 'Metro',
              icon: Icons.tram_rounded,
              onTap: () => _showComingSoon('Metro schedules'),
            ),
            _TransportCard(
              title: 'Train',
              icon: Icons.train_rounded,
              onTap: () => _showComingSoon('Train schedules'),
            ),
            _TransportCard(
              title: 'TGM',
              icon: Icons.directions_railway_rounded,
              onTap: () => _showComingSoon('TGM schedules'),
            ),
          ],
        ),
        const SizedBox(height: 28),

        Text(
          'Community',
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.campaign_outlined)),
            title: const Text('Report a problem'),
            subtitle: const Text('Share delays, crowding or interruptions'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showComingSoon('Community reports'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.notifications_active_outlined),
            ),
            title: const Text('Transport updates'),
            subtitle: const Text('Stay informed about your journeys'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showComingSoon('Transport updates'),
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
            const Text(
              'This section is not connected to transport data yet.',
              textAlign: TextAlign.center,
            ),
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
