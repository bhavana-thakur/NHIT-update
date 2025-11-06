import 'package:flutter/material.dart';
import 'package:ppv_components/common_widgets/button/primary_button.dart';
import 'package:ppv_components/common_widgets/button/outlined_button.dart';
import 'package:ppv_components/common_widgets/custom_table.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/bank_letters_page.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/escrow_accounts_page.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/create_transfer_page.dart';

class AccountTransfersPage extends StatefulWidget {
  const AccountTransfersPage({super.key});

  @override
  State<AccountTransfersPage> createState() => _AccountTransfersPageState();
}

class _AccountTransfersPageState extends State<AccountTransfersPage> {
  int rowsPerPage = 25;
  int currentPage = 0;
  String searchQuery = '';
  
  // Mock data - replace with actual data
  final List<Map<String, dynamic>> transfers = [];

  @override
  void initState() {
    super.initState();
  }

  void changeRowsPerPage(int? value) {
    setState(() {
      rowsPerPage = value ?? 25;
      currentPage = 0;
    });
  }

  void gotoPage(int page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  _buildHeader(context, constraints),
                  const SizedBox(height: 16),
                  
                  // Stats Cards
                  _buildStatsCards(context, constraints),
                  const SizedBox(height: 16),
                  
                  // Quick Actions
                  _buildQuickActions(context, constraints),
                  const SizedBox(height: 16),
                  
                  // Table Section
                  _buildTableSection(context, constraints),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, BoxConstraints constraints) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isSmallScreen = constraints.maxWidth < 900;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.swap_horiz,
                  size: 28,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Transfers',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage fund transfers between accounts and to vendors',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isSmallScreen) ...[
                const SizedBox(width: 16),
                OutlineButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icons.arrow_back,
                  label: 'Back',
                ),
              ],
            ],
          ),
          if (isSmallScreen) ...[
            const SizedBox(height: 16),
            OutlineButton(
              onPressed: () => Navigator.pop(context),
              icon: Icons.arrow_back,
              label: 'Back',
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              PrimaryButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateTransferPage(),
                    ),
                  );
                },
                icon: Icons.add,
                label: 'New Transfer',
              ),
              OutlineButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EscrowAccountsPage(escrowAccounts: []),
                    ),
                  );
                },
                icon: Icons.account_balance_wallet,
                label: 'Escrow Accounts',
              ),
              OutlineButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BankLettersPage(),
                    ),
                  );
                },
                icon: Icons.description,
                label: 'Bank Letters',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, BoxConstraints constraints) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    
    // Determine columns based on screen width
    int crossAxisCount = 4;
    if (constraints.maxWidth < 600) {
      crossAxisCount = 1;
    } else if (constraints.maxWidth < 900) {
      crossAxisCount = 2;
    }

    final stats = [
      {
        'icon': Icons.sync_alt,
        'label': 'Total Transfers',
        'value': '0',
        'color': Colors.blue,
      },
      {
        'icon': Icons.pending_actions,
        'label': 'Pending Approval',
        'value': '0',
        'color': Colors.orange,
      },
      {
        'icon': Icons.check_circle,
        'label': 'Completed',
        'value': '0',
        'color': Colors.green,
      },
      {
        'icon': Icons.currency_rupee,
        'label': 'Total Amount',
        'value': '₹0.00',
        'color': Colors.cyan,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: crossAxisCount == 1 ? 4.5 : (crossAxisCount == 2 ? 2.8 : 2.5),
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return _buildStatCard(
          context,
          icon: stat['icon'] as IconData,
          label: stat['label'] as String,
          value: stat['value'] as String,
          color: stat['color'] as Color,
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline,
          width: 0.5,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, BoxConstraints constraints) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isSmallScreen = constraints.maxWidth < 900;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.flash_on,
                color: Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Quick Transfer Actions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          isSmallScreen
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildQuickActionButton(
                      context,
                      icon: Icons.swap_horiz,
                      label: 'Internal Transfer',
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    _buildQuickActionButton(
                      context,
                      icon: Icons.send,
                      label: 'External Transfer',
                      color: Colors.purple,
                    ),
                    const SizedBox(height: 12),
                    _buildQuickActionButton(
                      context,
                      icon: Icons.description,
                      label: 'Bank Letter',
                      color: Colors.green,
                    ),
                    const SizedBox(height: 12),
                    _buildQuickActionButton(
                      context,
                      icon: Icons.add_circle_outline,
                      label: 'Add Account',
                      color: Colors.grey,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionButton(
                        context,
                        icon: Icons.swap_horiz,
                        label: 'Internal Transfer',
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionButton(
                        context,
                        icon: Icons.send,
                        label: 'External Transfer',
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionButton(
                        context,
                        icon: Icons.description,
                        label: 'Bank Letter',
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionButton(
                        context,
                        icon: Icons.add_circle_outline,
                        label: 'Add Account',
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableSection(BuildContext context, BoxConstraints constraints) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isSmallScreen = constraints.maxWidth < 900;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header
          Row(
            children: [
              Icon(
                Icons.table_chart,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'All Transfers',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const Spacer(),
              if (!isSmallScreen) ...[
                OutlineButton(
                  onPressed: () {},
                  icon: Icons.filter_list,
                  label: 'Filter',
                ),
                const SizedBox(width: 8),
                OutlineButton(
                  onPressed: () {},
                  icon: Icons.refresh,
                  label: 'Refresh',
                ),
              ],
            ],
          ),
          if (isSmallScreen) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlineButton(
                    onPressed: () {},
                    icon: Icons.filter_list,
                    label: 'Filter',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlineButton(
                    onPressed: () {},
                    icon: Icons.refresh,
                    label: 'Refresh',
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Text(
            'Track and manage all fund transfers',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),

          // Controls Row
          isSmallScreen
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Show',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: colorScheme.outline),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<int>(
                            value: rowsPerPage,
                            underline: const SizedBox(),
                            items: [10, 25, 50, 100].map((value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text('$value'),
                              );
                            }).toList(),
                            onChanged: changeRowsPerPage,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'entries',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search:',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        isDense: true,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Show',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: colorScheme.outline),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<int>(
                            value: rowsPerPage,
                            underline: const SizedBox(),
                            items: [10, 25, 50, 100].map((value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text('$value'),
                              );
                            }).toList(),
                            onChanged: changeRowsPerPage,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'entries',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search:',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: colorScheme.outline),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: colorScheme.outline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: colorScheme.primary, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 16),

          // Table
          CustomTable(
            columns: [
              DataColumn(
                label: Text(
                  '#',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'REFERENCE',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'FROM ACCOUNT',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'TO ACCOUNT',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'AMOUNT',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'STATUS',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'REQUESTED BY',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'ACTIONS',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
            rows: transfers.isEmpty
                ? []
                : transfers.map((transfer) {
                    return DataRow(
                      cells: [
                        DataCell(Text(transfer['id'].toString())),
                        DataCell(Text(transfer['reference'] ?? '')),
                        DataCell(Text(transfer['fromAccount'] ?? '')),
                        DataCell(Text(transfer['toAccount'] ?? '')),
                        DataCell(Text(transfer['amount'] ?? '')),
                        DataCell(Text(transfer['status'] ?? '')),
                        DataCell(Text(transfer['requestedBy'] ?? '')),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility, size: 18),
                                onPressed: () {},
                                tooltip: 'View',
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 18),
                                onPressed: () {},
                                tooltip: 'Edit',
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            minTableWidth: 1100,
          ),
          
          if (transfers.isEmpty) ...[
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transfers found',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],

          if (transfers.isNotEmpty) ...[
            const SizedBox(height: 16),
            // Pagination
            isSmallScreen
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Showing ${currentPage * rowsPerPage + 1} to ${((currentPage + 1) * rowsPerPage).clamp(0, transfers.length)} of ${transfers.length} entries',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildPaginationControls(context, colorScheme),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Showing ${currentPage * rowsPerPage + 1} to ${((currentPage + 1) * rowsPerPage).clamp(0, transfers.length)} of ${transfers.length} entries',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      _buildPaginationControls(context, colorScheme),
                    ],
                  ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaginationControls(BuildContext context, ColorScheme colorScheme) {
    final totalPages = (transfers.length / rowsPerPage).ceil();
    final theme = Theme.of(context);
    
    // Generate page numbers to display (max 3 pages)
    List<int> pageNumbers = [];
    if (totalPages <= 3) {
      pageNumbers = List.generate(totalPages, (index) => index);
    } else {
      if (currentPage == 0) {
        pageNumbers = [0, 1, 2];
      } else if (currentPage == totalPages - 1) {
        pageNumbers = [totalPages - 3, totalPages - 2, totalPages - 1];
      } else {
        pageNumbers = [currentPage - 1, currentPage, currentPage + 1];
      }
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.end,
      children: [
        IconButton(
          onPressed: currentPage > 0 ? () => gotoPage(currentPage - 1) : null,
          icon: const Icon(Icons.arrow_back_ios, size: 16),
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: colorScheme.outline),
            ),
          ),
        ),
        ...pageNumbers.map((pageIndex) {
          final isActive = pageIndex == currentPage;
          return InkWell(
            onTap: () => gotoPage(pageIndex),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? colorScheme.primary : null,
                border: Border.all(
                  color: isActive ? colorScheme.primary : colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${pageIndex + 1}',
                style: TextStyle(
                  color: isActive ? Colors.white : colorScheme.onSurface,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
        IconButton(
          onPressed: currentPage < totalPages - 1 ? () => gotoPage(currentPage + 1) : null,
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: colorScheme.outline),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<int>(
            value: totalPages,
            underline: const SizedBox(),
            items: List.generate(totalPages, (index) => index + 1).map((value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value'),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                gotoPage(value - 1);
              }
            },
          ),
        ),
        Text(
          'page',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
