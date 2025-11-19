import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ppv_components/features/bank_rtgs_neft/models/bank_models/escrow_account_model.dart';
import 'package:ppv_components/common_widgets/custom_table.dart';
import 'package:ppv_components/common_widgets/pagination.dart';
import 'package:ppv_components/common_widgets/badge.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/create_escrow_account_page.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/account_transfers_page.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/escrow_accounts_edit_page.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/view_escrow_account_detail.dart';

class EscrowAccountsPage extends StatefulWidget {
  final List<EscrowAccount> escrowAccounts;

  const EscrowAccountsPage({
    super.key,
    required this.escrowAccounts,
  });

  @override
  State<EscrowAccountsPage> createState() => _EscrowAccountsPageState();
}

class _EscrowAccountsPageState extends State<EscrowAccountsPage> {
  int rowsPerPage = 10;
  int currentPage = 0;
  late List<EscrowAccount> paginatedAccounts;
  String? statusFilter;
  List<EscrowAccount> filteredAccounts = [];
  late List<EscrowAccount> allAccounts;
  int? _hoveredCardIndex;

  // Edit and View mode state
  bool _isEditMode = false;
  bool _isViewMode = false;
  EscrowAccount? _accountToEdit;

  @override
  void initState() {
    super.initState();
    allAccounts = List<EscrowAccount>.from(widget.escrowAccounts);
    filteredAccounts = allAccounts;
    _updatePagination();
  }

  @override
  void didUpdateWidget(covariant EscrowAccountsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    allAccounts = List<EscrowAccount>.from(widget.escrowAccounts);
    filteredAccounts = allAccounts;
    _applyFilter();
    _updatePagination();
  }

  void _updatePagination() {
    final start = currentPage * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, filteredAccounts.length);
    paginatedAccounts = filteredAccounts.sublist(start, end);
    final totalPages = (filteredAccounts.length / rowsPerPage).ceil();
    if (currentPage >= totalPages && totalPages > 0) {
      currentPage = totalPages - 1;
      final newStart = currentPage * rowsPerPage;
      final newEnd = (newStart + rowsPerPage).clamp(0, filteredAccounts.length);
      paginatedAccounts = filteredAccounts.sublist(newStart, newEnd);
    }
  }

  void _applyFilter() {
    if (statusFilter == null || statusFilter == 'All') {
      filteredAccounts = allAccounts;
    } else {
      filteredAccounts = allAccounts
          .where((account) => account.status == statusFilter)
          .toList();
    }
    currentPage = 0;
  }

  void _refreshData() {
    setState(() {
      statusFilter = null;
      filteredAccounts = allAccounts;
      currentPage = 0;
      _updatePagination();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Accounts'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('All'),
                leading: Radio<String?>(
                  value: null,
                  groupValue: statusFilter,
                  onChanged: (value) {
                    setState(() {
                      statusFilter = value;
                    });
                    Navigator.pop(context);
                    _applyFilter();
                    _updatePagination();
                  },
                ),
              ),
              ListTile(
                title: const Text('Active'),
                leading: Radio<String>(
                  value: 'Active',
                  groupValue: statusFilter,
                  onChanged: (value) {
                    setState(() {
                      statusFilter = value;
                    });
                    Navigator.pop(context);
                    _applyFilter();
                    _updatePagination();
                  },
                ),
              ),
              ListTile(
                title: const Text('Inactive'),
                leading: Radio<String>(
                  value: 'Inactive',
                  groupValue: statusFilter,
                  onChanged: (value) {
                    setState(() {
                      statusFilter = value;
                    });
                    Navigator.pop(context);
                    _applyFilter();
                    _updatePagination();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void changeRowsPerPage(int? value) {
    setState(() {
      rowsPerPage = value ?? 25;
      currentPage = 0;
      _updatePagination();
    });
  }

  void gotoPage(int page) {
    setState(() {
      currentPage = page;
      _updatePagination();
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void onViewAccount(EscrowAccount account) {
    setState(() {
      _isViewMode = true;
      _isEditMode = false;
      _accountToEdit = account;
    });
  }

  void onEditAccount(EscrowAccount account) {
    setState(() {
      _isEditMode = true;
      _isViewMode = false;
      _accountToEdit = account;
    });
  }

  void _saveEditedAccount(EscrowAccount updatedAccount) {
    final index = allAccounts.indexWhere((a) => a.accountNumber == _accountToEdit!.accountNumber);
    if (index != -1) {
      setState(() {
        allAccounts[index] = updatedAccount;
        _isEditMode = false;
        _isViewMode = false;
        _accountToEdit = null;
        _applyFilter();
        _updatePagination();
      });
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditMode = false;
      _isViewMode = false;
      _accountToEdit = null;
    });
  }

  Future<void> deleteAccount(EscrowAccount account) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${account.accountName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (shouldDelete == true) {
      setState(() {
        allAccounts.removeWhere((a) => a.accountNumber == account.accountNumber);
        _applyFilter();
        _updatePagination();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: _accountToEdit != null
          ? (_isEditMode
          ? EditEscrowAccountContent(
        account: _accountToEdit!,
        onSave: _saveEditedAccount,
        onCancel: _cancelEdit,
      )
          : ViewEscrowAccountDetail(
        account: _accountToEdit!,
        onClose: _cancelEdit,
      ))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildStatsCards(context),
              const SizedBox(height: 16),
              _buildTableSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.account_balance,
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
                  'Escrow Accounts',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your organization\'s escrow accounts and fund transfers',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              GoRouter.of(context).go('/escrow-accounts/create');
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Account'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountTransfersPage(),
                ),
              );
            },
            icon: Icon(Icons.swap_horiz, size: 18, color: colorScheme.primary),
            label: Text(
              'View Transfers',
              style: TextStyle(color: colorScheme.primary),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: colorScheme.primary),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            index: 0,
            icon: Icons.account_balance,
            iconColor: colorScheme.primary.withValues(alpha: 0.1),
            iconForeground: colorScheme.primary,
            label: 'Total Accounts',
            value: '${allAccounts.length}',
            badge: '${allAccounts.where((a) => a.status == "Active").length} Active',
            badgeColor: colorScheme.primary.withValues(alpha: 0.1),
            badgeTextColor: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            index: 1,
            icon: Icons.currency_rupee,
            iconColor: Colors.green.withValues(alpha: 0.1),
            iconForeground: Colors.green,
            label: 'Total Balance',
            value: '₹0.00',
            badge: '',
            badgeColor: Colors.transparent,
            badgeTextColor: Colors.transparent,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            index: 2,
            icon: Icons.wallet,
            iconColor: Colors.blue.withValues(alpha: 0.1),
            iconForeground: Colors.blue,
            label: 'Available Balance',
            value: '₹0.00',
            badge: '',
            badgeColor: Colors.transparent,
            badgeTextColor: Colors.transparent,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            index: 3,
            icon: Icons.trending_up,
            iconColor: Colors.orange.withValues(alpha: 0.1),
            iconForeground: Colors.orange,
            label: 'Active Accounts',
            value: '${allAccounts.where((a) => a.status == "Active").length}',
            badge: '',
            badgeColor: Colors.transparent,
            badgeTextColor: Colors.transparent,
          ),
        ),
      ],
    );
  }

  Widget _buildTableSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colorScheme.outline,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.grid_view,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'All Escrow Accounts',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _showFilterDialog,
                    icon: Icon(Icons.filter_list, size: 16, color: colorScheme.onSurface),
                    label: Text(
                      statusFilter == null ? 'Filter' : 'Filter: $statusFilter',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 13,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colorScheme.outline),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: _refreshData,
                    icon: Icon(Icons.refresh, size: 16, color: colorScheme.onSurface),
                    label: Text(
                      'Refresh',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 13,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colorScheme.outline),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Manage and monitor all escrow accounts',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          filteredAccounts.isEmpty
              ? _buildEmptyState(context)
              : _buildTable(context),
          if (filteredAccounts.isNotEmpty) _buildPagination(context),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_outlined,
              size: 64,
              color: colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No escrow accounts found',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Showing 0 to 0 of 0 entries',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, {
        required int index,
        required IconData icon,
        required Color iconColor,
        required Color iconForeground,
        required String label,
        required String value,
        required String badge,
        required Color badgeColor,
        required Color badgeTextColor,
      }) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isHovered = _hoveredCardIndex == index;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hoveredCardIndex = index;
        });
      },
      onExit: (_) {
        setState(() {
          _hoveredCardIndex = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(isHovered ? 1.02 : 1.0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHovered ? colorScheme.primary : colorScheme.outline,
            width: isHovered ? 1.5 : 0.5,
          ),
          boxShadow: isHovered
              ? [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconForeground, size: 24),
                ),
                const Spacer(),
                if (badge.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: badgeTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final columns = [
      DataColumn(
        label: Text('#', style: TextStyle(color: colorScheme.onSurface)),
      ),
      DataColumn(
        label: Text('Account Name', style: TextStyle(color: colorScheme.onSurface)),
      ),
      DataColumn(
        label: Text('Account Number', style: TextStyle(color: colorScheme.onSurface)),
      ),
      DataColumn(
        label: Text('Bank', style: TextStyle(color: colorScheme.onSurface)),
      ),
      DataColumn(
        label: Text('Type', style: TextStyle(color: colorScheme.onSurface)),
      ),
      DataColumn(
        label: Text('Status', style: TextStyle(color: colorScheme.onSurface)),
      ),
      DataColumn(
        label: Text('Balance', style: TextStyle(color: colorScheme.onSurface)),
      ),
      DataColumn(
        label: Text('Actions', style: TextStyle(color: colorScheme.onSurface)),
      ),
    ];

    final rows = paginatedAccounts.asMap().entries.map((entry) {
      final index = entry.key;
      final account = entry.value;
      return DataRow(
        cells: [
          DataCell(
            Text(
              '${currentPage * rowsPerPage + index + 1}',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          DataCell(
            Text(
              account.accountName,
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          DataCell(
            Text(
              account.accountNumber,
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          DataCell(
            Text(
              account.bank,
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          DataCell(
            Text(
              account.type,
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          DataCell(
            BadgeChip(
              label: account.status,
              type: ChipType.status,
              statusKey: account.status,
              statusColorFunc: _getStatusColor,
            ),
          ),
          DataCell(
            Text(
              account.balance,
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility, size: 18),
                  onPressed: () => onViewAccount(account),
                  tooltip: 'View',
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () => onEditAccount(account),
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18),
                  onPressed: () => deleteAccount(account),
                  tooltip: 'Delete',
                  color: Theme.of(context).colorScheme.error,
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();

    return CustomTable(
      columns: columns,
      rows: rows,
    );
  }

  Widget _buildPagination(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: CustomPaginationBar(
        totalItems: filteredAccounts.length,
        currentPage: currentPage,
        rowsPerPage: rowsPerPage,
        onPageChanged: gotoPage,
        onRowsPerPageChanged: changeRowsPerPage,
        availableRowsPerPage: const [5, 10, 20, 50],
      ),
    );
  }
}
