import 'dart:async';
import 'package:dio/dio.dart';
import '../models/transfer_models/transfer_enums.dart';
import '../models/transfer_models/transfer_model.dart';
import '../models/transfer_models/transfer_request.dart';
import 'api_client.dart';

class AccountTransferService {
  final ApiClient _apiClient = ApiClient();
  static const _maxRetries = 1;
  static const _retryDelay = Duration(seconds: 1);
  
  AccountTransferService() {
    _apiClient.initialize();
  }

  Future<Transfer> createTransfer(CreateAccountTransferRequest request) async {
    try {
      request.validate();

      final idempotencyKey = DateTime.now().millisecondsSinceEpoch.toString();
      final response = await _retryWithBackoff(
        () => _apiClient.post(
          '/transfers',
          data: request.toJson(),
          options: Options(
            headers: {
              'Idempotency-Key': idempotencyKey,
              'X-Request-Source': 'create-transfer-page',
            },
          ),
        ),
        maxRetries: _maxRetries,
        delay: _retryDelay,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('transfer')) {
          return Transfer.fromJson(data['transfer']);
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to create transfer: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw Exception('Error creating transfer: ${e.toString()}');
    }
  }

  Future<Transfer> getTransfer(String transferId) async {
    try {
      final response = await _apiClient.get('/transfers/$transferId');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('transfer')) {
          return Transfer.fromJson(data['transfer']);
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to get transfer: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting transfer: ${e.toString()}');
    }
  }

  Future<void> cancelTransfer(String transferId, String userId, String reason) async {
    try {
      final response = await _apiClient.post(
        '/transfers/$transferId/cancel',
        data: {
          'transfer_id': transferId,
          'user_id': userId,
          'reason': reason,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to cancel transfer: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error cancelling transfer: ${e.toString()}');
    }
  }

  Future<T> _retryWithBackoff<T>(
    Future<T> Function() operation, {
    int maxRetries = 1,
    Duration delay = const Duration(seconds: 1),
  }) async {
    int attempts = 0;
    while (true) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        if (attempts > maxRetries || e is ValidationException) {
          rethrow;
        }
        await Future.delayed(delay * attempts);
      }
    }
  }
}
