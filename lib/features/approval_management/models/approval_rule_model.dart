class ApprovalRule {
  final String id;
  final String ruleName;
  final String amountRange;
  final int approvers;
  final int levels;
  final String created;
  final String status;

  ApprovalRule({
    required this.id,
    required this.ruleName,
    required this.amountRange,
    required this.approvers,
    required this.levels,
    required this.created,
    required this.status,
  });

  factory ApprovalRule.fromMap(Map<String, dynamic> m) => ApprovalRule(
        id: m['id'].toString(),
        ruleName: m['rule_name'] ?? '',
        amountRange: m['amount_range'] ?? '',
        approvers: m['approvers'] ?? 0,
        levels: m['levels'] ?? 0,
        created: m['created'] ?? '',
        status: m['status'] ?? 'Inactive',
      );
}
