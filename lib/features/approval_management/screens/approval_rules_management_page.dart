import 'package:flutter/material.dart';
import 'package:ppv_components/common_widgets/button/primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:ppv_components/features/approval_management/models/approval_rule_model.dart';
import 'package:ppv_components/features/approval_management/data/approval_rule_dummy.dart';
import 'package:ppv_components/features/approval_management/widgets/approval_rules_table.dart';

class ApprovalRulesManagementPage extends StatefulWidget {
  final String ruleType; // 'green_note', 'payment_note', 'reimbursement_note', 'bank_letter'

  const ApprovalRulesManagementPage({super.key, required this.ruleType});

  @override
  State<ApprovalRulesManagementPage> createState() =>
      _ApprovalRulesManagementPageState();
}

class _ApprovalRulesManagementPageState
    extends State<ApprovalRulesManagementPage> {
  List<ApprovalRule> allRules = List<ApprovalRule>.from(approvalRulesDummyData);
  TextEditingController testAmountController = TextEditingController();

  String get ruleTypeTitleShort {
    switch (widget.ruleType) {
      case 'green_note':
        return 'Expense note';
      case 'payment_note':
        return 'Payment note';
      case 'reimbursement_note':
        return 'Reimbursement note';
      case 'bank_letter':
        return 'Bank letter';
      default:
        return 'Approval';
    }
  }

  // Calculate statistics
  int get totalRules => allRules.length;
  int get activeRules => allRules.where((r) => r.status == 'Active').length;
  int get inactiveRules => allRules.where((r) => r.status == 'Inactive').length;
  double get avgApprovers => allRules.isEmpty
      ? 0
      : allRules.map((r) => r.approvers).reduce((a, b) => a + b) /
            allRules.length;

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
                  // Header Section (Create Escrow Page Style)
                  _buildHeader(context, constraints),
                  const SizedBox(height: 24),

                  // Action Buttons Row
                  Row(
                    children: [
                      Text(
                        'Test Amount',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 250,
                        child: TextField(
                          controller: testAmountController,
                          decoration: InputDecoration(
                            hintText: 'Enter amount to test',
                            prefixText: '₹  ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      PrimaryButton(
                        label: 'Test Rules',
                        icon: Icons.check_circle,
                        onPressed: () {},
                        backgroundColor: Colors.green,
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Text(
                          'Enter an amount to see which rule applies',
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Table Section (Bank Letter Page Style)
                  SizedBox(
                    height: 600,
                    child: ApprovalRulesTable(
                      rulesData: allRules,
                      title: 'Approval Rules for ${ruleTypeTitleShort[0].toUpperCase()}${ruleTypeTitleShort.substring(1)}',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        child: const Icon(Icons.help_outline, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, BoxConstraints constraints) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isSmallScreen = constraints.maxWidth < 600;

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
      child: isSmallScreen
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.rule_folder,
                        size: 24,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Approval Rules - ${ruleTypeTitleShort[0].toUpperCase()}${ruleTypeTitleShort.substring(1)}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Manage approval rules and workflows for ${ruleTypeTitleShort}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  label: 'Create New Rule',
                  icon: Icons.add_circle,
                  onPressed: () {
                    final type = widget.ruleType;
                    context.go('/approval-rules/$type/create');
                  },
                  backgroundColor: Colors.green,
                ),
              ],
            )
          : Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.rule_folder,
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
                        'Approval Rules - ${ruleTypeTitleShort[0].toUpperCase()}${ruleTypeTitleShort.substring(1)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manage approval rules and workflows for ${ruleTypeTitleShort}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                PrimaryButton(
                  label: 'Create New Rule',
                  icon: Icons.add_circle,
                  onPressed: () {
                    final type = widget.ruleType;
                    context.go('/approval-rules/$type/create');
                  },
                  backgroundColor: Colors.green,
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    testAmountController.dispose();
    super.dispose();
  }
}
