import 'package:flutter/material.dart';
import 'package:ppv_components/common_widgets/custom_table.dart';
import 'package:ppv_components/features/approval_management/models/approval_rule_model.dart';

class ApprovalRulesTable extends StatefulWidget {
  final List<ApprovalRule> rulesData;
  final String? title;

  const ApprovalRulesTable({
    super.key,
    required this.rulesData,
    this.title,
  });

  @override
  State<ApprovalRulesTable> createState() => _ApprovalRulesTableState();
}

class _ApprovalRulesTableState extends State<ApprovalRulesTable> {
  int rowsPerPage = 25;
  int currentPage = 0;
  late List<ApprovalRule> paginatedRules;

  @override
  void initState() {
    super.initState();
    _updatePagination();
  }

  @override
  void didUpdateWidget(covariant ApprovalRulesTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updatePagination();
  }

  void _updatePagination() {
    final start = currentPage * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, widget.rulesData.length);
    setState(() {
      paginatedRules = widget.rulesData.sublist(start, end);
      final totalPages = (widget.rulesData.length / rowsPerPage).ceil();
      if (currentPage >= totalPages && totalPages > 0) {
        currentPage = totalPages - 1;
        paginatedRules = widget.rulesData.sublist(start, end);
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final columns = [
      DataColumn(
        label: Text('RULE NAME',
            style: TextStyle(
                color: colorScheme.onSurface, fontWeight: FontWeight.bold)),
      ),
      DataColumn(
        label: Text('AMOUNT RANGE',
            style: TextStyle(
                color: colorScheme.onSurface, fontWeight: FontWeight.bold)),
      ),
      DataColumn(
        label: Text('APPROVERS',
            style: TextStyle(
                color: colorScheme.onSurface, fontWeight: FontWeight.bold)),
      ),
      DataColumn(
        label: Text('LEVELS',
            style: TextStyle(
                color: colorScheme.onSurface, fontWeight: FontWeight.bold)),
      ),
      DataColumn(
        label: Text('CREATED',
            style: TextStyle(
                color: colorScheme.onSurface, fontWeight: FontWeight.bold)),
      ),
      DataColumn(
        label: Text('STATUS',
            style: TextStyle(
                color: colorScheme.onSurface, fontWeight: FontWeight.bold)),
      ),
      DataColumn(
        label: Text('ACTIONS',
            style: TextStyle(
                color: colorScheme.onSurface, fontWeight: FontWeight.bold)),
      ),
    ];

    final rows = paginatedRules.map((rule) {
      return DataRow(
        cells: [
          DataCell(
            Text(
              rule.ruleName,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          DataCell(
            Text(rule.amountRange,
                style: TextStyle(color: colorScheme.onSurface)),
          ),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${rule.approvers} Approvers',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${rule.levels} Levels',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          DataCell(
            Text(rule.created, style: TextStyle(color: colorScheme.onSurface)),
          ),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: rule.status == 'Active'
                    ? Colors.green.withValues(alpha: 0.2)
                    : Colors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                rule.status,
                style: TextStyle(
                  fontSize: 12,
                  color: rule.status == 'Active' ? Colors.green : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.visibility,
                      size: 18, color: colorScheme.primary),
                  onPressed: () {},
                  tooltip: 'View',
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: colorScheme.outline),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.edit, size: 18, color: Colors.green),
                  onPressed: () {},
                  tooltip: 'Edit',
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: colorScheme.outline),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(Icons.copy,
                      size: 18, color: colorScheme.onSurfaceVariant),
                  onPressed: () {},
                  tooltip: 'Copy',
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: colorScheme.outline),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  onPressed: () {},
                  tooltip: 'Delete',
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: colorScheme.outline),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.table_chart, size: 20, color: colorScheme.onSurface),
              const SizedBox(width: 8),
              Text(
                widget.title ?? 'Approval Rules',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Icon(Icons.refresh, size: 20, color: colorScheme.onSurfaceVariant),
            ],
          ),
          const SizedBox(height: 16),

          // Table
          Expanded(
            child: CustomTable(
              columns: columns,
              rows: rows,
              minTableWidth: 1200,
            ),
          ),

          // Pagination
          _paginationBar(context),
        ],
      ),
    );
  }

  Widget _paginationBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final totalPages = (widget.rulesData.length / rowsPerPage).ceil();
    final start = currentPage * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, widget.rulesData.length);

    int windowSize = 3;
    int startWindow = 0;
    int endWindow = totalPages;

    if (totalPages > windowSize) {
      if (currentPage <= 1) {
        startWindow = 0;
        endWindow = windowSize;
      } else if (currentPage >= totalPages - 2) {
        startWindow = totalPages - windowSize;
        endWindow = totalPages;
      } else {
        startWindow = currentPage - 1;
        endWindow = currentPage + 2;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Showing ${widget.rulesData.isEmpty ? 0 : start + 1} to $end of ${widget.rulesData.length} entries",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Row(
            children: [
              TextButton(
                onPressed:
                    currentPage > 0 ? () => gotoPage(currentPage - 1) : null,
                child: const Text('Previous'),
              ),
              for (int i = startWindow; i < endWindow; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: i == currentPage
                          ? colorScheme.primary
                          : colorScheme.surfaceContainer,
                      foregroundColor: i == currentPage
                          ? Colors.white
                          : colorScheme.onSurface,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      minimumSize: const Size(40, 40),
                    ),
                    onPressed: () => gotoPage(i),
                    child: Text('${i + 1}'),
                  ),
                ),
              TextButton(
                onPressed: currentPage < totalPages - 1
                    ? () => gotoPage(currentPage + 1)
                    : null,
                child: const Text('Next'),
              ),
              const SizedBox(width: 20),
              DropdownButton<int>(
                value: rowsPerPage,
                items: [10, 25, 50, 100]
                    .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                    .toList(),
                onChanged: changeRowsPerPage,
                style: Theme.of(context).textTheme.bodyMedium,
                underline: const SizedBox(),
              ),
              const SizedBox(width: 8),
              Text("/ page", style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
