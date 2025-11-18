import 'package:flutter/material.dart';
import 'package:ppv_components/features/bank_rtgs_neft/models/bank_models/escrow_account_model.dart';
import 'package:ppv_components/features/bank_rtgs_neft/data/bank_dummydata/escrow_accounts_dummy.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/escrow_accounts_page.dart';

class BankMainPage extends StatefulWidget {
  const BankMainPage({super.key});

  @override
  State<BankMainPage> createState() => _BankMainPageState();
}

class _BankMainPageState extends State<BankMainPage> {
  // Escrow accounts list
  List<EscrowAccount> escrowAccounts = List<EscrowAccount>.from(
    escrowAccountsDummyData,
  );

  @override
  Widget build(BuildContext context) {
    return EscrowAccountsPage(
      escrowAccounts: escrowAccounts,
    );
  }
}
