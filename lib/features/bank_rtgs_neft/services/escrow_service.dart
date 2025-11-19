import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ppv_components/features/bank_rtgs_neft/models/bank_models/escrow_account_model.dart';
import 'package:ppv_components/features/bank_rtgs_neft/data/bank_dummydata/escrow_accounts_dummy.dart';

class EscrowService {
  static const String baseUrl = 'https://api.example.com'; // Replace with your actual API URL
  
  // Singleton pattern
  static final EscrowService _instance = EscrowService._internal();
  factory EscrowService() => _instance;
  EscrowService._internal();

  // Create a new escrow account
  Future<bool> createEscrowAccount({
    required String accountName,
    required String accountNumber,
    required String bankName,
    required String branchName,
    required String ifscCode,
    required String accountType,
    required double initialBalance,
    required String description,
    required List<String> signatories,
  }) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // For demo purposes, we'll simulate a successful API call
      // In real implementation, replace this with actual HTTP request
      /*
      final response = await http.post(
        Uri.parse('$baseUrl/escrow-accounts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN_HERE',
        },
        body: jsonEncode({
          'account_name': accountName,
          'account_number': accountNumber,
          'bank_name': bankName,
          'branch_name': branchName,
          'ifsc_code': ifscCode,
          'account_type': accountType,
          'initial_balance': initialBalance,
          'description': description,
          'signatories': signatories,
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to create escrow account: ${response.statusCode}');
      }
      */
      
      // Simulate successful creation by adding to dummy data
      final newAccount = EscrowAccount(
        accountName: accountName,
        accountNumber: accountNumber,
        bank: bankName,
        type: accountType,
        status: 'Active',
        balance: '₹${initialBalance.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
      );
      
      // Add to dummy data for demo
      escrowAccountsDummyData.add(newAccount);
      
      return true;
    } catch (e) {
      print('Error creating escrow account: $e');
      return false;
    }
  }

  // Get all escrow accounts
  Future<List<EscrowAccount>> getAllEscrowAccounts() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // For demo purposes, return dummy data
      // In real implementation, replace this with actual HTTP request
      /*
      final response = await http.get(
        Uri.parse('$baseUrl/escrow-accounts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN_HERE',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => EscrowAccount.fromMap(json)).toList();
      } else {
        throw Exception('Failed to fetch escrow accounts: ${response.statusCode}');
      }
      */
      
      return List<EscrowAccount>.from(escrowAccountsDummyData);
    } catch (e) {
      print('Error fetching escrow accounts: $e');
      return [];
    }
  }
}
