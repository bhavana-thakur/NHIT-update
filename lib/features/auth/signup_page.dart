import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ppv_components/core/auth_service.dart';
import 'package:ppv_components/core/app_routes.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  final _auth = AuthService();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    try {
      // Store registration data temporarily for organization creation
      await _auth.storeRegistrationData(
        name: _name.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
        role: 'SUPER_ADMIN',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Registration data saved. Please create organization.'),
          backgroundColor: Colors.green,
        ),
      );
      context.go(AppRoutes.createOrganization);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: $e'),
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
      appBar: AppBar(title: const Text('Super Admin Registration')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Fixed role display
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.admin_panel_settings, 
                               color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 12),
                          Text(
                            'Role: Super Admin',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(
                        labelText: 'Full Name', 
                        prefixIcon: Icon(Icons.person),
                        hintText: 'Admin User',
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(
                        labelText: 'Email', 
                        prefixIcon: Icon(Icons.email),
                        hintText: 'admin12@example.com',
                      ),
                      validator: (v) => (v == null || !v.contains('@')) ? 'Valid email required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password', 
                        prefixIcon: Icon(Icons.lock),
                        hintText: 'AdminPass@123',
                      ),
                      validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _loading ? null : _submit,
                        icon: const Icon(Icons.person_add),
                        label: Text(_loading ? 'Registering...' : 'Register'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.login),
                      child: const Text('Back to Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
