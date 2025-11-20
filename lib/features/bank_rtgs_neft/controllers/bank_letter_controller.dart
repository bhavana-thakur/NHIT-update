import 'package:flutter/material.dart';
import '../services/bank_letter_service.dart';

class BankLetterController {
  final BankLetterService _service = BankLetterService();

  Future<bool> createTransferLetter({
    required String transferId,
    required String bankName,
    required String branchName,
    required String bankAddress,
    required String subject,
    required String content,
    required String saveAsStatus,
    String? createdById,
  }) async {
    try {
      await _service.createTransferLetter(
        transferId: transferId,
        bankName: bankName,
        branchName: branchName,
        bankAddress: bankAddress,
        subject: subject,
        content: content,
        saveAsStatus: saveAsStatus,
        createdById: createdById,
      );
      return true;
    } catch (e) {
      debugPrint('Error creating transfer letter: $e');
      return false;
    }
  }

  Future<bool> createGeneralLetter({
    required String bankName,
    required String branchName,
    required String bankAddress,
    required String subject,
    required String content,
    required String saveAsStatus,
    String? createdById,
  }) async {
    try {
      await _service.createGeneralLetter(
        bankName: bankName,
        branchName: branchName,
        bankAddress: bankAddress,
        subject: subject,
        content: content,
        saveAsStatus: saveAsStatus,
        createdById: createdById,
      );
      return true;
    } catch (e) {
      debugPrint('Error creating general letter: $e');
      return false;
    }
  }

  Future<bool> createPaymentLetter({
    required String paymentReference,
    required String bankName,
    required String branchName,
    required String bankAddress,
    required String subject,
    required String content,
    required String saveAsStatus,
    String? createdById,
  }) async {
    try {
      await _service.createPaymentLetter(
        paymentReference: paymentReference,
        bankName: bankName,
        branchName: branchName,
        bankAddress: bankAddress,
        subject: subject,
        content: content,
        saveAsStatus: saveAsStatus,
        createdById: createdById,
      );
      return true;
    } catch (e) {
      debugPrint('Error creating payment letter: $e');
      return false;
    }
  }

  String getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return error.toString();
  }
}
