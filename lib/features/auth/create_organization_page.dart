import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ppv_components/core/auth_service.dart';
import 'package:ppv_components/core/app_routes.dart';

class CreateOrganizationPage extends StatefulWidget {
  const CreateOrganizationPage({super.key});

  @override
  State<CreateOrganizationPage> createState() => _CreateOrganizationPageState();
}

class _CreateOrganizationPageState extends State<CreateOrganizationPage> {
  final _formKey = GlobalKey<FormState>();
  final _orgName = TextEditingController();
  final _orgCode = TextEditingController();
  final _orgDescription = TextEditingController();
  final _adminName = TextEditingController();
  final _adminEmail = TextEditingController();
  final _adminPassword = TextEditingController();
  bool _loading = false;
  final _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _loadRegistrationData();
  }

  void _loadRegistrationData() {
    final pendingData = _auth.getPendingRegistration();
    if (pendingData != null) {
      _adminName.text = pendingData['name'] ?? '';
      _adminEmail.text = pendingData['email'] ?? '';
      _adminPassword.text = pendingData['password'] ?? '';
    } else {
      // If no pending registration, redirect to registration
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(AppRoutes.registration);
      });
    }
  }

  @override
  void dispose() {
    _orgName.dispose();
    _orgCode.dispose();
    _orgDescription.dispose();
    _adminName.dispose();
    _adminEmail.dispose();
    _adminPassword.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    try {
      await _auth.createOrganizationWithAdmin(
        orgName: _orgName.text.trim(),
        orgCode: _orgCode.text.trim().toUpperCase(),
        orgDescription: _orgDescription.text.trim(),
        adminName: _adminName.text.trim(),
        adminEmail: _adminEmail.text.trim(),
        adminPassword: _adminPassword.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Organization created successfully! Please login.'),
          backgroundColor: Colors.green,
        ),
      );
      _auth.clearPendingRegistration();
      context.go(AppRoutes.login);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Organization creation failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Organization'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.registration),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Organization Details',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _orgName,
                        decoration: const InputDecoration(
                          labelText: 'Organization Name',
                          prefixIcon: Icon(Icons.business),
                          hintText: 'My Company',
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _orgCode,
                        decoration: const InputDecoration(
                          labelText: 'Organization Code',
                          prefixIcon: Icon(Icons.code),
                          hintText: 'MYCOMPANY',
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                        onChanged: (value) {
                          _orgCode.text = value.toUpperCase();
                          _orgCode.selection = TextSelection.fromPosition(
                            TextPosition(offset: _orgCode.text.length),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _orgDescription,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          prefixIcon: Icon(Icons.description),
                          hintText: 'Test Organization',
                        ),
                        maxLines: 3,
                        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Super Admin Details',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceVariant
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withOpacity(0.5),
                          ),
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _adminName,
                              decoration: const InputDecoration(
                                labelText: 'Admin Name',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                              readOnly: true,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _adminEmail,
                              decoration: const InputDecoration(
                                labelText: 'Admin Email',
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(),
                              ),
                              readOnly: true,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _adminPassword,
                              decoration: const InputDecoration(
                                labelText: 'Admin Password',
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                              readOnly: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _loading ? null : _submit,
                          icon: const Icon(Icons.business_center),
                          label: Text(
                            _loading
                                ? 'Creating Organization...'
                                : 'Create Organization',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => context.go(AppRoutes.registration),
                          child: const Text('Back to Registration'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
