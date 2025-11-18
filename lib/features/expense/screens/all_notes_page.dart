import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ppv_components/features/expense/data/expense_mockdb.dart';
import 'package:ppv_components/features/expense/models/expense_model.dart';

class AllNotesPage extends StatefulWidget {
  const AllNotesPage({Key? key}) : super(key: key);

  @override
  State<AllNotesPage> createState() => _AllNotesPageState();
}

class _AllNotesPageState extends State<AllNotesPage> with SingleTickerProviderStateMixin {
  // Controllers
  late TextEditingController searchController;
  late TabController _tabController;

  // State variables
  int currentPage = 0;
  int rowsPerPage = 10;
  int selectedTabIndex = 0;
  
  // Data lists
  List<ExpenseNote> allNotes = [];
  List<ExpenseNote> filteredNotes = [];
  List<ExpenseNote> paginatedNotes = [];

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _tabController = TabController(length: 5, vsync: this);
    
    // Initialize with dummy data
    allNotes = List<ExpenseNote>.from(expenseNotesDummyData);
    filteredNotes = List<ExpenseNote>.from(allNotes);
    _updatePagination();
    
    // Add listener to tab changes
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      _filterNotes();
    }
  }

  void _updatePagination() {
    final start = currentPage * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, filteredNotes.length);
    setState(() {
      paginatedNotes = filteredNotes.sublist(
        start, 
        end < filteredNotes.length ? end : filteredNotes.length
      );
    });
  }

  void _filterNotes() {
    final searchTerm = searchController.text.toLowerCase();
    
    // Apply tab filter
    if (_tabController.index == 0) {
      filteredNotes = List<ExpenseNote>.from(allNotes);
    } else {
      final status = _getStatusForTab(_tabController.index);
      filteredNotes = allNotes.where((note) => 
        note.status.toLowerCase() == status.toLowerCase()
      ).toList();
    }

    // Apply search filter
    if (searchTerm.isNotEmpty) {
      filteredNotes = filteredNotes.where((note) {
        return note.projectName.toLowerCase().contains(searchTerm) ||
               note.vendorName.toLowerCase().contains(searchTerm) ||
               note.invoiceValue.toString().contains(searchTerm) ||
               note.description.toLowerCase().contains(searchTerm);
      }).toList();
    }

    // Reset to first page when filters change
    currentPage = 0;
    _updatePagination();
  }

  String _getStatusForTab(int tabIndex) {
    switch (tabIndex) {
      case 1: return 'Pending';
      case 2: return 'Approved';
      case 3: return 'Rejected';
      case 4: return 'Draft';
      default: return '';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'draft':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  void changeRowsPerPage(int? value) {
    if (value != null && mounted) {
      setState(() {
        rowsPerPage = value;
        currentPage = 0;
        _updatePagination();
      });
    }
  }

  void _goToPage(int page) {
    if (mounted) {
      setState(() {
        currentPage = page;
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

  // View dialog for note details
  Future<void> _showViewDialog(ExpenseNote note) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Note Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Project', note.projectName),
              _buildDetailRow('Vendor', note.vendorName),
              _buildDetailRow('Amount', '\$${note.invoiceValue.toStringAsFixed(2)}'),
              _buildDetailRow('Date', note.createdDate),
              _buildDetailRow('Status', note.status, isStatus: true),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Helper method to build detail rows in the view dialog
  Widget _buildDetailRow(String label, String value, {bool isStatus = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: isStatus
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(value).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(
                        color: _getStatusColor(value),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : Text(value),
          ),
        ],
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.receipt_long,
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
                  'All Expense Notes',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage and track expense note requests and approvals',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.go('/expense/create-note');
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Create Expense Note'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableSection(BuildContext context, BoxConstraints constraints) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabs and Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Tabs
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleButtons(
                      isSelected: List.generate(5, (index) => index == selectedTabIndex),
                      onPressed: (index) {
                        setState(() {
                          selectedTabIndex = index;
                          _tabController.index = index;
                          currentPage = 0;
                          _filterNotes();
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      constraints: const BoxConstraints(
                        minHeight: 40,
                        minWidth: 100,
                      ),
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('All Notes'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Pending'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Approved'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Rejected'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Draft'),
                        ),
                      ],
                    ),
                  ),
                ),

                // Search Bar
                Container(
                  width: constraints.maxWidth > 600 ? 300 : 200,
                  height: 40,
                  margin: const EdgeInsets.only(left: 16),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      filled: true,
                      fillColor: colorScheme.surface,
                    ),
                    onChanged: (value) {
                      setState(() {
                        currentPage = 0;
                        _filterNotes();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Table
          if (filteredNotes.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notes found',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth > 1200
                      ? constraints.maxWidth - 32
                      : 1200,
                ),
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('#')),
                    DataColumn(label: Text('PROJECT')),
                    DataColumn(label: Text('VENDOR')),
                    DataColumn(label: Text('AMOUNT')),
                    DataColumn(label: Text('DATE')),
                    DataColumn(label: Text('STATUS')),
                    DataColumn(label: Text('ACTIONS')),
                  ],
                  rows: List<DataRow>.generate(
                    paginatedNotes.length,
                    (index) {
                      final note = paginatedNotes[index];
                      final statusColor = _getStatusColor(note.status);

                      return DataRow(
                        cells: [
                          DataCell(Text('${index + 1}')),
                          DataCell(Text(note.projectName)),
                          DataCell(Text(note.vendorName)),
                          DataCell(Text('\$${note.invoiceValue.toStringAsFixed(2)}')),
                          DataCell(Text(note.createdDate)),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                note.status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.visibility_outlined, size: 20),
                                  onPressed: () => _showViewDialog(note),
                                  tooltip: 'View',
                                  color: colorScheme.primary,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 20),
                                  onPressed: () {
                                    // Handle edit
                                  },
                                  tooltip: 'Edit',
                                  color: colorScheme.primary,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 20),
                                  onPressed: () {
                                    // Handle delete
                                  },
                                  tooltip: 'Delete',
                                  color: colorScheme.error,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),

          // Pagination
          if (filteredNotes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Showing ${currentPage * rowsPerPage + 1} to ${currentPage * rowsPerPage + paginatedNotes.length} of ${filteredNotes.length} entries',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Rows per page:',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<int>(
                        value: rowsPerPage,
                        items: [5, 10, 25, 50].map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        onChanged: changeRowsPerPage,
                        underline: Container(
                          height: 1,
                          color: colorScheme.outlineVariant,
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: currentPage == 0
                            ? null
                            : () {
                                setState(() {
                                  currentPage--;
                                  _updatePagination();
                                });
                              },
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${currentPage + 1} of ${(filteredNotes.length / rowsPerPage).ceil()}',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: (currentPage + 1) * rowsPerPage >= filteredNotes.length
                            ? null
                            : () {
                                setState(() {
                                  currentPage++;
                                  _updatePagination();
                                });
                              },
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, BoxConstraints constraints) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final totalNotes = allNotes.length;
    final pendingNotes = allNotes.where((note) => note.status.toLowerCase() == 'pending').length;
    final approvedNotes = allNotes.where((note) => note.status.toLowerCase() == 'approved').length;
    final draftNotes = allNotes.where((note) => note.status.toLowerCase() == 'draft').length;

    final isSmallScreen = constraints.maxWidth < 600;
    final isMediumScreen = constraints.maxWidth < 900;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isSmallScreen ? 2 : (isMediumScreen ? 2 : 4),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isSmallScreen ? 1.5 : (isMediumScreen ? 1.8 : 2.2),
      children: [
        _buildStatCard(
          context: context,
          icon: Icons.receipt,
          label: 'Total Notes',
          value: totalNotes.toString(),
          color: colorScheme.primary,
        ),
        _buildStatCard(
          context: context,
          icon: Icons.pending_actions,
          label: 'Pending Approval',
          value: pendingNotes.toString(),
          color: Colors.orange,
        ),
        _buildStatCard(
          context: context,
          icon: Icons.check_circle,
          label: 'Approved',
          value: approvedNotes.toString(),
          color: Colors.green,
        ),
        _buildStatCard(
          context: context,
          icon: Icons.drafts,
          label: 'Draft Notes',
          value: draftNotes.toString(),
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(constraints.maxWidth < 900 ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeader(context, constraints),
                const SizedBox(height: 24),
                
                // Stats Cards
                _buildStatsCards(context, constraints),
                const SizedBox(height: 24),
                
                // Table Section
                _buildTableSection(context, constraints),
              ],
            ),
          );
        },
      ),
    );
  }
}
