import 'package:flutter/material.dart';
import 'package:ppv_components/core/secure_storage.dart';
import 'package:ppv_components/core/app_routes.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _index = 0;

  Future<void> _logout() async {
    await SecureStorage.clear();
    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final pages = const [
      _DashboardHome(),
      _DashboardUsers(),
      _DashboardOrganizations(),
      _DashboardSettings(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Admin Dashboard'),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CircleAvatar(child: Icon(Icons.person)),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Dashboard')),
              NavigationRailDestination(icon: Icon(Icons.group_outlined), selectedIcon: Icon(Icons.group), label: Text('Users')),
              NavigationRailDestination(icon: Icon(Icons.apartment_outlined), selectedIcon: Icon(Icons.apartment), label: Text('Organizations')),
              NavigationRailDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: Text('Settings')),
            ],
            trailing: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: IconButton(
                tooltip: 'Logout',
                onPressed: _logout,
                icon: const Icon(Icons.logout),
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: pages[_index]),
        ],
      ),
    );
  }
}

class _DashboardHome extends StatelessWidget {
  const _DashboardHome();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Widget card(IconData icon, String title, String value) => Expanded(
      child: Card(
        color: cs.primaryContainer.withValues(alpha: 0.3),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: cs.primary),
              const SizedBox(height: 8),
              Text(title, style: TextStyle(color: cs.onSurfaceVariant)),
              const SizedBox(height: 6),
              Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: cs.onSurface)),
            ],
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              card(Icons.people, 'Total Users', '24'),
              const SizedBox(width: 12),
              card(Icons.apartment, 'Organizations', '5'),
              const SizedBox(width: 12),
              card(Icons.work, 'Active Projects', '12'),
            ],
          ),
          const SizedBox(height: 16),
          Text('Recent Activity', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: 6,
              itemBuilder: (_, i) => ListTile(
                leading: const Icon(Icons.timeline),
                title: Text('Activity item #$i'),
                subtitle: const Text('Placeholder item from API'),
              ),
              separatorBuilder: (_, __) => const Divider(height: 1),
            ),
          )
        ],
      ),
    );
  }
}

class _DashboardUsers extends StatelessWidget {
  const _DashboardUsers();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Users', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('GET /users placeholder list'),
        ],
      ),
    );
  }
}

class _DashboardOrganizations extends StatelessWidget {
  const _DashboardOrganizations();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Organizations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('GET /organizations placeholder list'),
        ],
      ),
    );
  }
}

class _DashboardSettings extends StatelessWidget {
  const _DashboardSettings();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Settings'));
  }
}
