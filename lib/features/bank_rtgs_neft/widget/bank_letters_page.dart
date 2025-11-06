import 'package:flutter/material.dart';
import 'package:ppv_components/common_widgets/button/primary_button.dart';
import 'package:ppv_components/common_widgets/button/outlined_button.dart';
import 'package:ppv_components/common_widgets/custom_table.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/escrow_accounts_page.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/account_transfers_page.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/create_bank_letter_page.dart';

class BankLettersPage extends StatefulWidget {
  const BankLettersPage({super.key});

  @override
  State<BankLettersPage> createState() => _BankLettersPageState();
}

class _BankLettersPageState extends State<BankLettersPage> {
  int rowsPerPage = 25;
  int currentPage = 0;
  String searchQuery = '';
  
  // Mock data - replace with actual data
  final List<Map<String, dynamic>> letters = [];

  @override
  void initState() {
    super.initState();
  }

  void changeRowsPerPage(int? value) {
    if (value != null) {
      setState(() {
        rowsPerPage = value;
        currentPage = 0;
      });
    }
  }

  void gotoPage(int page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

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
                  Icons.description,
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
                      'All Bank Letters',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage and track all bank correspondence',
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
                      builder: (context) => const CreateBankLetterPage(),
                    ),
                  );
                },
                icon: Icons.add,
                label: 'New Letter',
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
                      builder: (context) => const AccountTransfersPage(),
                    ),
                  );
                },
                icon: Icons.swap_horiz,
                label: 'Transfers',
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
        'icon': Icons.description,
        'label': 'Total Letters',
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
        'icon': Icons.send,
        'label': 'Sent Letters',
        'value': '0',
        'color': Colors.green,
      },
      {
        'icon': Icons.drafts,
        'label': 'Draft Letters',
        'value': '0',
        'color': Colors.grey,
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
                child: Icon(
                  icon,
                  size: 18,
                  color: color,
                ),
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
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'All Bank Letters',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              if (!isSmallScreen) ...[
                OutlineButton(
                  onPressed: () {},
                  icon: Icons.filter_list,
                  label: 'Filter',
                ),
                const SizedBox(width: 12),
                OutlineButton(
                  onPressed: () {},
                  icon: Icons.refresh,
                  label: 'Refresh',
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Manage and track bank correspondence',
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
                  'TYPE',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'SUBJECT',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'BANK',
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
                  'CREATED BY',
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
            rows: letters.isEmpty
                ? []
                : letters.map((letter) {
                    return DataRow(
                      cells: [
                        DataCell(Text(letter['id'].toString())),
                        DataCell(Text(letter['reference'] ?? '')),
                        DataCell(Text(letter['type'] ?? '')),
                        DataCell(Text(letter['subject'] ?? '')),
                        DataCell(Text(letter['bank'] ?? '')),
                        DataCell(Text(letter['status'] ?? '')),
                        DataCell(Text(letter['createdBy'] ?? '')),
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
            minTableWidth: 1200,
          ),
          
          if (letters.isEmpty) ...[
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
                    'No bank letters found',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],

          if (letters.isNotEmpty) ...[
            const SizedBox(height: 16),
            // Pagination
            isSmallScreen
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Showing ${currentPage * rowsPerPage + 1} to ${((currentPage + 1) * rowsPerPage).clamp(0, letters.length)} of ${letters.length} entries',
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
                        'Showing ${currentPage * rowsPerPage + 1} to ${((currentPage + 1) * rowsPerPage).clamp(0, letters.length)} of ${letters.length} entries',
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
    final totalPages = (letters.length / rowsPerPage).ceil();
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
        OutlinedButton(
          onPressed: currentPage > 0 ? () => gotoPage(currentPage - 1) : null,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            side: BorderSide(color: colorScheme.outline),
          ),
          child: const Text('Previous'),
        ),
        OutlinedButton(
          onPressed: currentPage < totalPages - 1 ? () => gotoPage(currentPage + 1) : null,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            side: BorderSide(color: colorScheme.outline),
          ),
          child: const Text('Next'),
        ),
      ],
    );
  }
}
