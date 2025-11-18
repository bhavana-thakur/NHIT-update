import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ppv_components/core/api_client.dart';
import 'package:ppv_components/core/secure_storage.dart';

class AuthService {
  final ApiClient _api;
  final bool _useMockAuth = true; // Set to false when backend is ready
  
  // Mock user database
  static final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': '1',
      'name': 'Super Admin',
      'email': 'admin@example.com',
      'login': 'admin',
      'password': 'admin123',
      'role': 'SUPER_ADMIN',
      'tenantId': '123e4567-e89b-12d3-a456-426614174000',
      'orgId': '6552f16c-7832-4ebb-b052-eb9741f31d22',
    },
    {
      'id': '2',
      'name': 'Regular User',
      'email': 'user@example.com',
      'login': 'user',
      'password': 'user123',
      'role': 'USER',
      'tenantId': '123e4567-e89b-12d3-a456-426614174000',
      'orgId': '6552f16c-7832-4ebb-b052-eb9741f31d22',
    },
  ];
  
  AuthService({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  // Temporary storage for registration data
  static Map<String, dynamic>? _pendingRegistration;

  Future<void> storeRegistrationData({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    _pendingRegistration = {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  Map<String, dynamic>? getPendingRegistration() {
    return _pendingRegistration;
  }

  void clearPendingRegistration() {
    _pendingRegistration = null;
  }

  Future<Map<String, dynamic>> createOrganizationWithAdmin({
    required String orgName,
    required String orgCode,
    required String orgDescription,
    required String adminName,
    required String adminEmail,
    required String adminPassword,
  }) async {
    if (_useMockAuth) {
      // Mock organization creation
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
      
      // Check if organization code already exists
      final existingOrg = _mockUsers.any((u) => u['orgCode'] == orgCode);
      if (existingOrg) {
        throw Exception('Organization code already exists');
      }
      
      // Create new super admin user with organization
      final newAdmin = {
        'id': '${_mockUsers.length + 1}',
        'name': adminName,
        'email': adminEmail,
        'login': adminEmail.split('@')[0],
        'password': adminPassword,
        'role': 'SUPER_ADMIN',
        'tenantId': '123e4567-e89b-12d3-a456-426614174000',
        'orgId': '6552f16c-7832-4ebb-b052-eb9741f31d22',
        'orgName': orgName,
        'orgCode': orgCode,
        'orgDescription': orgDescription,
      };
      
      // Add to mock database
      _mockUsers.add(newAdmin);
      
      return {
        'success': true,
        'organization': {
          'name': orgName,
          'code': orgCode,
          'description': orgDescription,
        },
        'admin': newAdmin,
        'message': 'Organization and Super Admin created successfully',
      };
    }
    
    // Real API organization creation (when backend is ready)
    final payload = {
      'name': orgName,
      'code': orgCode,
      'description': orgDescription,
      'super_admin': {
        'name': adminName,
        'email': adminEmail,
        'password': adminPassword,
      },
    };
    final http.Response res = await _api.post('/organizations', body: jsonEncode(payload));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = ApiClient.decode(res.body);
      return data;
    }
    throw Exception('Organization creation failed: ${res.statusCode} ${res.body}');
  }

  Future<Map<String, dynamic>> login({
    required String login,
    required String password,
    required String tenantId,
    required String orgId,
  }) async {
    if (_useMockAuth) {
      // Mock authentication
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      
      final user = _mockUsers.firstWhere(
        (u) => (u['login'] == login || u['email'] == login) && u['password'] == password,
        orElse: () => {},
      );
      
      if (user.isEmpty) {
        throw Exception('Invalid credentials');
      }
      
      final token = 'mock_token_${user['id']}_${DateTime.now().millisecondsSinceEpoch}';
      final role = user['role'].toString();
      final tenant = user['tenantId'].toString();
      final org = user['orgId'].toString();
      
      await SecureStorage.write(SecureStorage.keyToken, token);
      await SecureStorage.write(SecureStorage.keyRole, role);
      await SecureStorage.write(SecureStorage.keyTenantId, tenant);
      await SecureStorage.write(SecureStorage.keyOrgId, org);
      
      return {
        'token': token,
        'role': role,
        'roleName': role,
        'tenantId': tenant,
        'orgId': org,
        'user': user,
      };
    }
    
    // Real API authentication (when backend is ready)
    final payload = {
      'login': login,
      'password': password,
      'tenant_id': tenantId,
      'org_id': orgId,
    };
    final res = await _api.post('/auth/login', body: ApiClient.encode(payload));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = ApiClient.decode(res.body);
      final token = data['token']?.toString() ?? '';
      final role = (data['role'] ?? data['roleName'] ?? 'USER').toString();
      final tenant = data['tenantId']?.toString() ?? tenantId;
      final org = data['orgId']?.toString() ?? orgId;
      if (token.isNotEmpty) {
        await SecureStorage.write(SecureStorage.keyToken, token);
      }
      await SecureStorage.write(SecureStorage.keyRole, role);
      await SecureStorage.write(SecureStorage.keyTenantId, tenant);
      await SecureStorage.write(SecureStorage.keyOrgId, org);
      return data;
    }
    throw Exception('Login failed: ${res.statusCode} ${res.body}');
  }

  Future<void> logout() async {
    await SecureStorage.clear();
  }

  Future<void> forgotPassword(String email) async {
    if (_useMockAuth) {
      // Mock forgot password
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      
      final userExists = _mockUsers.any((u) => u['email'] == email);
      if (!userExists) {
        throw Exception('Email not found');
      }
      
      // In mock mode, we just simulate success
      return;
    }
    
    // Real API forgot password (when backend is ready)
    final payload = {'email': email};
    final res = await _api.post('/auth/forgot-password', body: jsonEncode(payload));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Request failed: ${res.statusCode}');
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role, // SUPER_ADMIN or USER
    String? orgName,
  }) async {
    if (_useMockAuth) {
      // Mock registration
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      
      // Check if email already exists
      final existingUser = _mockUsers.any((u) => u['email'] == email);
      if (existingUser) {
        throw Exception('Email already exists');
      }
      
      // Create new user
      final newUser = {
        'id': '${_mockUsers.length + 1}',
        'name': name,
        'email': email,
        'login': email.split('@')[0], // Use email prefix as login
        'password': password,
        'role': role,
        'tenantId': '123e4567-e89b-12d3-a456-426614174000',
        'orgId': '6552f16c-7832-4ebb-b052-eb9741f31d22',
        'organizationName': orgName,
      };
      
      // Add to mock database
      _mockUsers.add(newUser);
      
      // For USER role, auto-login after registration
      if (role.toUpperCase() == 'USER') {
        final token = 'mock_token_${newUser['id']}_${DateTime.now().millisecondsSinceEpoch}';
        await SecureStorage.write(SecureStorage.keyToken, token);
        await SecureStorage.write(SecureStorage.keyRole, role);
        await SecureStorage.write(SecureStorage.keyTenantId, newUser['tenantId'].toString());
        await SecureStorage.write(SecureStorage.keyOrgId, newUser['orgId'].toString());
      }
      
      return {
        'success': true,
        'user': newUser,
        'message': 'Registration successful',
      };
    }
    
    // Real API registration (when backend is ready)
    final payload = {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      if (orgName != null) 'organizationName': orgName,
    };
    final http.Response res = await _api.post('/auth/register', body: jsonEncode(payload));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = ApiClient.decode(res.body);
      if (role.toUpperCase() == 'USER') {
        final token = data['token']?.toString() ?? '';
        if (token.isNotEmpty) {
          await SecureStorage.write(SecureStorage.keyToken, token);
        }
        await SecureStorage.write(SecureStorage.keyRole, 'USER');
      }
      return data;
    }
    throw Exception('Register failed: ${res.statusCode} ${res.body}');
  }
}
