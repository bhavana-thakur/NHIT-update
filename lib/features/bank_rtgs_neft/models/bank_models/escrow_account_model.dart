class EscrowAccount {
  final String accountName;
  final String accountNumber;
  final String bank;
  final String type;
  final String status;
  final String balance;

  EscrowAccount({
    required this.accountName,
    required this.accountNumber,
    required this.bank,
    required this.type,
    required this.status,
    required this.balance,
  });

  factory EscrowAccount.fromMap(Map<String, dynamic> m) => EscrowAccount(
        accountName: m['account_name'] ?? '',
        accountNumber: m['account_number'] ?? '',
        bank: m['bank'] ?? '',
        type: m['type'] ?? '',
        status: m['status'] ?? '',
        balance: m['balance'] ?? '',
      );
}
