class ExpenseNote {
  final String id;
  final String sNo;
  final String projectName;
  final String vendorName;
  final double invoiceValue;
  final String status;
  final String createdDate;
  final String nextApprover;
  final String department;
  final String description;
  final String requestedBy;

  ExpenseNote({
    required this.id,
    required this.sNo,
    required this.projectName,
    required this.vendorName,
    required this.invoiceValue,
    required this.status,
    required this.createdDate,
    required this.nextApprover,
    required this.department,
    required this.description,
    required this.requestedBy,
  });

  factory ExpenseNote.fromJson(Map<String, dynamic> json) {
    return ExpenseNote(
      id: json['id'] ?? '',
      sNo: json['sNo'] ?? '',
      projectName: json['projectName'] ?? '',
      vendorName: json['vendorName'] ?? '',
      invoiceValue: double.tryParse(json['invoiceValue']?.toString().replaceAll(',', '') ?? '0') ?? 0.0,
      status: json['status'] ?? '',
      createdDate: json['date'] ?? '',
      nextApprover: json['nextApprover'] ?? '',
      department: json['department'] ?? '',
      description: json['description'] ?? '',
      requestedBy: json['requestedBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sNo': sNo,
      'projectName': projectName,
      'vendorName': vendorName,
      'invoiceValue': invoiceValue.toString(),
      'status': status,
      'date': createdDate,
      'nextApprover': nextApprover,
      'department': department,
      'description': description,
      'requestedBy': requestedBy,
    };
  }
}

// Legacy GreenNote class for backward compatibility
class GreenNote {
  final String id;
  final String sNo;
  final String projectName;
  final String vendorName;
  final String invoiceValue;
  final String status;
  final String date;
  final String nextApprover;
  final String department;
  final String description;
  final String requestedBy;

  GreenNote({
    required this.id,
    required this.sNo,
    required this.projectName,
    required this.vendorName,
    required this.invoiceValue,
    required this.status,
    required this.date,
    required this.nextApprover,
    required this.department,
    required this.description,
    required this.requestedBy,
  });

  factory GreenNote.fromJson(Map<String, dynamic> json) {
    return GreenNote(
      id: json['id'] ?? '',
      sNo: json['sNo'] ?? '',
      projectName: json['projectName'] ?? '',
      vendorName: json['vendorName'] ?? '',
      invoiceValue: json['invoiceValue'] ?? '',
      status: json['status'] ?? '',
      date: json['date'] ?? '',
      nextApprover: json['nextApprover'] ?? '',
      department: json['department'] ?? '',
      description: json['description'] ?? '',
      requestedBy: json['requestedBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sNo': sNo,
      'projectName': projectName,
      'vendorName': vendorName,
      'invoiceValue': invoiceValue,
      'status': status,
      'date': date,
      'nextApprover': nextApprover,
      'department': department,
      'description': description,
      'requestedBy': requestedBy,
    };
  }
}
