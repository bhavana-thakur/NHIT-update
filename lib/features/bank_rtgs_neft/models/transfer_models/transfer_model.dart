import 'transfer_enums.dart';
import 'transfer_leg.dart';

class Transfer {
  final String transferId;
  final String transferReference;
  final TransferType transferType;
  final TransferMode transferMode;
  final double totalAmount;
  final String purpose;
  final String remarks;
  final TransferStatus status;
  final String requestedById;
  final String? approvedById;
  final DateTime? approvedAt;
  final DateTime? completedAt;
  final String? bankLetterReference;
  final String? bankLetterStatus;
  final DateTime? bankLetterGeneratedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TransferLeg> transferLegs;
  final SimpleUser? requestedBy;
  final SimpleUser? approver;

  Transfer({
    required this.transferId,
    required this.transferReference,
    required this.transferType,
    required this.transferMode,
    required this.totalAmount,
    required this.purpose,
    required this.remarks,
    required this.status,
    required this.requestedById,
    this.approvedById,
    this.approvedAt,
    this.completedAt,
    this.bankLetterReference,
    this.bankLetterStatus,
    this.bankLetterGeneratedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.transferLegs,
    this.requestedBy,
    this.approver,
  });

  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(
      transferId: json['transfer_id'] as String,
      transferReference: json['transfer_reference'] as String,
      transferType: TransferType.fromString(json['transfer_type'] as String),
      transferMode: TransferMode.fromString(json['transfer_mode'] as String),
      totalAmount: (json['total_amount'] as num).toDouble(),
      purpose: json['purpose'] as String,
      remarks: json['remarks'] as String,
      status: TransferStatus.fromString(json['status'] as String),
      requestedById: json['requested_by_id'] as String,
      approvedById: json['approved_by_id'] as String?,
      approvedAt: json['approved_at'] != null ? DateTime.fromMillisecondsSinceEpoch(json['approved_at']['seconds'] * 1000) : null,
      completedAt: json['completed_at'] != null ? DateTime.fromMillisecondsSinceEpoch(json['completed_at']['seconds'] * 1000) : null,
      bankLetterReference: json['bank_letter_reference'] as String?,
      bankLetterStatus: json['bank_letter_status'] as String?,
      bankLetterGeneratedAt: json['bank_letter_generated_at'] != null ? DateTime.fromMillisecondsSinceEpoch(json['bank_letter_generated_at']['seconds'] * 1000) : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']['seconds'] * 1000),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updated_at']['seconds'] * 1000),
      transferLegs: (json['transfer_legs'] as List<dynamic>?)?.map((e) => TransferLeg.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      requestedBy: json['requested_by'] != null ? SimpleUser.fromJson(json['requested_by'] as Map<String, dynamic>) : null,
      approver: json['approver'] != null ? SimpleUser.fromJson(json['approver'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'transfer_id': transferId,
    'transfer_reference': transferReference,
    'transfer_type': transferType.value,
    'transfer_mode': transferMode.value,
    'total_amount': totalAmount,
    'purpose': purpose,
    'remarks': remarks,
    'status': status.value,
    'requested_by_id': requestedById,
    if (approvedById != null) 'approved_by_id': approvedById,
    if (approvedAt != null) 'approved_at': {'seconds': approvedAt!.millisecondsSinceEpoch ~/ 1000},
    if (completedAt != null) 'completed_at': {'seconds': completedAt!.millisecondsSinceEpoch ~/ 1000},
    if (bankLetterReference != null) 'bank_letter_reference': bankLetterReference,
    if (bankLetterStatus != null) 'bank_letter_status': bankLetterStatus,
    if (bankLetterGeneratedAt != null) 'bank_letter_generated_at': {'seconds': bankLetterGeneratedAt!.millisecondsSinceEpoch ~/ 1000},
    'created_at': {'seconds': createdAt.millisecondsSinceEpoch ~/ 1000},
    'updated_at': {'seconds': updatedAt.millisecondsSinceEpoch ~/ 1000},
    'transfer_legs': transferLegs.map((e) => e.toJson()).toList(),
    if (requestedBy != null) 'requested_by': requestedBy!.toJson(),
    if (approver != null) 'approver': approver!.toJson(),
  };

  String get displayText {
    if (transferLegs.isEmpty) return transferReference;

    final firstLeg = transferLegs.first;
    final sourceAccount = firstLeg.sourceAccount;
    final destinationText = firstLeg.destinationAccount?.accountName ?? firstLeg.destinationVendor?.name ?? 'Unknown';

    return '$transferReference - ${sourceAccount?.accountName ?? 'Unknown'} → $destinationText (₹$totalAmount)';
  }
}
