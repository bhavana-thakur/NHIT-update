import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ppv_components/common_widgets/button/primary_button.dart';
import 'package:ppv_components/common_widgets/button/outlined_button.dart';
import 'package:ppv_components/common_widgets/custom_table.dart';
import 'package:ppv_components/common_widgets/pagination.dart';
import 'package:ppv_components/common_widgets/badge.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/%20edit_transfer_content.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/bank_letters_page.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/escrow_accounts_page.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/create_transfer_page.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/create_bank_letter_page.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/create_escrow_account_page.dart';
import 'package:ppv_components/features/bank_rtgs_neft/models/bank_models/account_transfer_model.dart';
import 'package:ppv_components/features/bank_rtgs_neft/data/bank_dummydata/account_transfer_dummy.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/view_transfer_detail.dart';

class AccountTransfersPage extends StatefulWidget {
  const AccountTransfersPage({super.key});

  @override
  State<AccountTransfersPage> createState() => _AccountTransfersPageState();
}

class _AccountTransfersPageState extends State<AccountTransfersPage> {
  int rowsPerPage = 10;
  int currentPage = 0;
  String searchQuery = '';
  String? statusFilter;

  // Hover states for stat cards and quick action buttons
  int? _hoveredCardIndex;
  int? _hoveredButtonIndex;

  // Edit and View mode state
  bool _isEditMode = false;
  bool _isViewMode = false;
  AccountTransfer? _transferToEdit;

  late List<AccountTransfer> filteredTransfers;
  late List<AccountTransfer> paginatedTransfers;
  late List<AccountTransfer> allTransfers;

  // Data for CreateTransferPage
  final List<String> sourceAccounts = [
    'Main Account - ACC001',
    'Savings Account - ACC002',
    'Business Account - ACC003',
    'Project Account - ACC004',
  ];

  final List<String> destinationAccounts = [
    'Main Account - ACC001',
    'Savings Account - ACC002',
    'Business Account - ACC003',
    'Project Account - ACC004',
  ];

  final List<Map<String, dynamic>> transferTypes = [
    {
      'type': 'Internal Transfer',
      'icon': Icons.swap_horiz,
      'color': Colors.cyan,
      'description': 'Transfer between your own accounts',
    },
    {
      'type': 'External Transfer',
      'icon': Icons.send,
      'color': Colors.purple,
      'description': 'Transfer to external beneficiaries',
    },
  ];

  final List<Map<String, dynamic>> transferModes = [
    {
      'mode': 'One to One',
      'icon': Icons.arrow_forward,
      'color': Colors.blue,
      'description': 'Single account to single account',
    },
    {
      'mode': 'One to Many',
      'icon': Icons.account_tree,
      'color': Colors.orange,
      'description': 'Single account to multiple accounts',
    },
    {
      'mode': 'Many to Many',
      'icon': Icons.hub,
      'color': Colors.purple,
      'description': 'Multiple accounts to multiple accounts',
    },
  ];

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'method': 'RTGS',
      'icon': Icons.account_balance,
      'color': Colors.blue,
      'description': 'Real Time Gross Settlement',
      'minAmount': '₹2,00,000',
    },
    {
      'method': 'NEFT',
      'icon': Icons.swap_horiz,
      'color': Colors.green,
      'description': 'National Electronic Funds Transfer',
      'minAmount': 'No minimum',
    },
    {
      'method': 'IMPS',
      'icon': Icons.flash_on,
      'color': Colors.orange,
      'description': 'Immediate Payment Service',
      'minAmount': 'No minimum',
    },
    {
      'method': 'UPI',
      'icon': Icons.qr_code_2,
      'color': Colors.purple,
      'description': 'Unified Payments Interface',
      'minAmount': 'No minimum',
    },
  ];

  @override
  void initState() {
    super.initState();
    allTransfers = List<AccountTransfer>.from(accountTransferDummyData);
    filteredTransfers = allTransfers;
    _updatePagination();
  }

  void _updatePagination() {
    final start = currentPage * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, filteredTransfers.length);
    paginatedTransfers = filteredTransfers.sublist(start, end);
  }

  void changeRowsPerPage(int? value) {
    if (value != null) {
      setState(() {
        rowsPerPage = value;
        currentPage = 0;
        _updatePagination();
      });
    }
  }

  void gotoPage(int page) {
    setState(() {
      currentPage = page;
      _updatePagination();
    });
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      _applyFilters();
      currentPage = 0;
      _updatePagination();
    });
  }

  void _applyFilters() {
    filteredTransfers = allTransfers.where((transfer) {
      final matchesSearch = searchQuery.isEmpty ||
          transfer.reference.toLowerCase().contains(searchQuery) ||
          transfer.fromAccount.toLowerCase().contains(searchQuery) ||
          transfer.toAccount.toLowerCase().contains(searchQuery) ||
          transfer.status.toLowerCase().contains(searchQuery);

      final matchesStatus = statusFilter == null ||
          statusFilter == 'All' ||
          transfer.status == statusFilter;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  void _refreshData() {
    setState(() {
      statusFilter = null;
      searchQuery = '';
      filteredTransfers = allTransfers;
      currentPage = 0;
      _updatePagination();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Transfers'),
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
                    _applyFilters();
                    _updatePagination();
                  },
                ),
              ),
              ListTile(
                title: const Text('Completed'),
                leading: Radio<String>(
                  value: 'Completed',
                  groupValue: statusFilter,
                  onChanged: (value) {
                    setState(() {
                      statusFilter = value;
                    });
                    Navigator.pop(context);
                    _applyFilters();
                    _updatePagination();
                  },
                ),
              ),
              ListTile(
                title: const Text('Pending Approval'),
                leading: Radio<String>(
                  value: 'Pending Approval',
                  groupValue: statusFilter,
                  onChanged: (value) {
                    setState(() {
                      statusFilter = value;
                    });
                    Navigator.pop(context);
                    _applyFilters();
                    _updatePagination();
                  },
                ),
              ),
              ListTile(
                title: const Text('In Progress'),
                leading: Radio<String>(
                  value: 'In Progress',
                  groupValue: statusFilter,
                  onChanged: (value) {
                    setState(() {
                      statusFilter = value;
                    });
                    Navigator.pop(context);
                    _applyFilters();
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending approval':
        return Colors.orange;
      case 'in progress':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void onViewTransfer(AccountTransfer transfer) {
    setState(() {
      _isViewMode = true;
      _isEditMode = false;
      _transferToEdit = transfer;
    });
  }

  void onEditTransfer(AccountTransfer transfer) {
    setState(() {
      _isEditMode = true;
      _isViewMode = false;
      _transferToEdit = transfer;
    });
  }

  void _saveEditedTransfer(AccountTransfer updatedTransfer) {
    final index = allTransfers.indexWhere((t) => t.id == _transferToEdit!.id);
    if (index != -1) {
      setState(() {
        allTransfers[index] = updatedTransfer;
        _isEditMode = false;
        _isViewMode = false;
        _transferToEdit = null;
        _applyFilters();
        _updatePagination();
      });
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditMode = false;
      _isViewMode = false;
      _transferToEdit = null;
    });
  }

  Future<void> deleteTransfer(AccountTransfer transfer) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete transfer ${transfer.reference}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (shouldDelete == true) {
      setState(() {
        allTransfers.removeWhere((t) => t.id == transfer.id);
        _applyFilters();
        _updatePagination();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: _transferToEdit != null
          ? (_isEditMode
          ? EditTransferContent(
        transfer: _transferToEdit!,
        onSave: _saveEditedTransfer,
        onCancel: _cancelEdit,
      )
          : ViewTransferDetail(
        transfer: _transferToEdit!,
        onClose: _cancelEdit,
      ))
          : LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, constraints),
                  const SizedBox(height: 16),
                  _buildStatsCards(context, constraints),
                  const SizedBox(height: 16),
                  _buildQuickActions(context, constraints),
                  const SizedBox(height: 16),
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
                      builder: (context) => const EscrowAccountsPage(),
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
        'value': '${allTransfers.length}',
        'color': Colors.blue,
      },
      {
        'icon': Icons.pending_actions,
        'label': 'Pending Approval',
        'value': '${allTransfers.where((t) => t.status == "Pending Approval").length}',
        'color': Colors.orange,
      },
      {
        'icon': Icons.check_circle,
        'label': 'Completed',
        'value': '${allTransfers.where((t) => t.status == "Completed").length}',
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
        childAspectRatio: crossAxisCount == 1 ? 4.0 : (crossAxisCount == 2 ? 2.5 : 2.2),
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return _buildStatCard(
          context,
          index: index,
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
        required int index,
        required IconData icon,
        required String label,
        required String value,
        required Color color,
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHovered ? colorScheme.primary : colorScheme.outline,
            width: isHovered ? 2.0 : 0.5,
          ),
          boxShadow: isHovered
              ? [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
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
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, BoxConstraints constraints) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isSmallScreen = constraints.maxWidth < 900;

    final quickActions = [
      {
        'icon': Icons.swap_horiz,
        'label': 'Internal Transfer',
        'color': Colors.blue,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTransferPage(),
            ),
          );
        },
      },
      {
        'icon': Icons.send,
        'label': 'External Transfer',
        'color': Colors.purple,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTransferPage(),
            ),
          );
        },
      },
      {
        'icon': Icons.description,
        'label': 'Bank Letter',
        'color': Colors.green,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateBankLetterPage(),
            ),
          );
        },
      },
      {
        'icon': Icons.add_circle_outline,
        'label': 'Add Account',
        'color': Colors.grey,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateEscrowAccountPage(),
            ),
          );
        },
      },
    ];

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
            children: quickActions.asMap().entries.map((entry) {
              final index = entry.key;
              final action = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: index < quickActions.length - 1 ? 12 : 0),
                child: _buildQuickActionButton(
                  context,
                  index: index,
                  icon: action['icon'] as IconData,
                  label: action['label'] as String,
                  color: action['color'] as Color,
                  onTap: action['onTap'] as VoidCallback,
                ),
              );
            }).toList(),
          )
              : Row(
            children: quickActions.asMap().entries.map((entry) {
              final index = entry.key;
              final action = entry.value;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index < quickActions.length - 1 ? 12 : 0),
                  child: _buildQuickActionButton(
                    context,
                    index: index,
                    icon: action['icon'] as IconData,
                    label: action['label'] as String,
                    color: action['color'] as Color,
                    onTap: action['onTap'] as VoidCallback,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
      BuildContext context, {
        required int index,
        required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onTap,
      }) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isHovered = _hoveredButtonIndex == index;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hoveredButtonIndex = index;
        });
      },
      onExit: (_) {
        setState(() {
          _hoveredButtonIndex = null;
        });
      },
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isHovered ? 0.7 : 1.0,
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
                  onPressed: _showFilterDialog,
                  icon: Icons.filter_list,
                  label: statusFilter == null ? 'Filter' : 'Filter: $statusFilter',
                ),
                const SizedBox(width: 8),
                OutlineButton(
                  onPressed: _refreshData,
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
                    onPressed: _showFilterDialog,
                    icon: Icons.filter_list,
                    label: statusFilter == null ? 'Filter' : 'Filter: $statusFilter',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlineButton(
                    onPressed: _refreshData,
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
            rows: paginatedTransfers.isEmpty
                ? []
                : paginatedTransfers.asMap().entries.map((entry) {
              final index = entry.key;
              final transfer = entry.value;
              return DataRow(
                cells: [
                  DataCell(Text('${currentPage * rowsPerPage + index + 1}')),
                  DataCell(Text(transfer.reference)),
                  DataCell(Text(transfer.fromAccount)),
                  DataCell(Text(transfer.toAccount)),
                  DataCell(Text(transfer.amount)),
                  DataCell(
                    BadgeChip(
                      label: transfer.status,
                      type: ChipType.status,
                      statusKey: transfer.status,
                      statusColorFunc: _getStatusColor,
                    ),
                  ),
                  DataCell(Text(transfer.requestedBy)),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility, size: 18),
                          onPressed: () => onViewTransfer(transfer),
                          tooltip: 'View',
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: () => onEditTransfer(transfer),
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 18),
                          onPressed: () => deleteTransfer(transfer),
                          tooltip: 'Delete',
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
            minTableWidth: 1100,
          ),
          if (paginatedTransfers.isEmpty) ...[
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
          if (filteredTransfers.isNotEmpty) ...[
            CustomPaginationBar(
              totalItems: filteredTransfers.length,
              currentPage: currentPage,
              rowsPerPage: rowsPerPage,
              onPageChanged: gotoPage,
              onRowsPerPageChanged: changeRowsPerPage,
              availableRowsPerPage: const [5, 10, 20, 50],
            ),
          ],
        ],
      ),
    );
  }
}
