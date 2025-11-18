import 'package:flutter/material.dart';

class SuperAdminDashboard extends StatelessWidget {
  const SuperAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.waving_hand,
                        color: Colors.orange,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Welcome back, Super Admin!',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Here\'s what\'s happening with your expense management today',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: const Text('Nov 2025'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Export Report'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Stats Cards Row
          Row(
            children: [
              Expanded(child: _buildStatCard(
                context,
                icon: Icons.description,
                iconColor: Colors.blue,
                title: 'Total Notes',
                value: '0',
                subtitle: '↑ +0% from last month',
                subtitleColor: Colors.green,
                backgroundColor: Colors.blue.withValues(alpha: 0.1),
              )),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard(
                context,
                icon: Icons.pending_actions,
                iconColor: Colors.orange,
                title: 'Pending Approvals',
                value: '0',
                subtitle: 'Require your attention',
                subtitleColor: colorScheme.onSurfaceVariant,
                backgroundColor: Colors.orange.withValues(alpha: 0.1),
              )),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard(
                context,
                icon: Icons.check_circle,
                iconColor: Colors.green,
                title: 'Completed This Month',
                value: '0',
                subtitle: '↑ +0% vs last month',
                subtitleColor: Colors.green,
                backgroundColor: Colors.green.withValues(alpha: 0.1),
              )),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard(
                context,
                icon: Icons.people,
                iconColor: Colors.teal,
                title: 'Active Users',
                value: '0',
                subtitle: '↑ +3 new this week',
                subtitleColor: Colors.green,
                backgroundColor: Colors.teal.withValues(alpha: 0.1),
              )),
            ],
          ),
          const SizedBox(height: 32),

          // Bottom Section with Quick Actions and Recent Activity
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick Actions
                Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 0,
                    color: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.flash_on, color: Colors.orange, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Quick Actions',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildQuickActionButton(
                            context,
                            'Create Note',
                            Colors.green,
                            () {},
                          ),
                          const SizedBox(height: 12),
                          _buildQuickActionButton(
                            context,
                            'Payment',
                            Colors.blue,
                            () {},
                          ),
                          const SizedBox(height: 12),
                          _buildQuickActionButton(
                            context,
                            'Reimbursement',
                            colorScheme.primary,
                            () {},
                          ),
                          const SizedBox(height: 20),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.visibility, size: 16),
                            label: const Text('View Activity'),
                            style: TextButton.styleFrom(
                              foregroundColor: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Recent Activity
                Expanded(
                  flex: 2,
                  child: Card(
                    elevation: 0,
                    color: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.history, color: colorScheme.primary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Recent Activity',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView.separated(
                              itemCount: 5,
                              separatorBuilder: (context, index) => const SizedBox(height: 16),
                              itemBuilder: (context, index) => _buildActivityItem(
                                context,
                                'Super Admin logged in',
                                'Super Admin • ${4 + index} hours ago',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
    required Color subtitleColor,
    required Color backgroundColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const Spacer(),
                if (title == 'Pending Approvals')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '0',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else if (title == 'Completed This Month')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '+0%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else if (title == 'Active Users')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '+3',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: subtitleColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, String title, String subtitle) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
