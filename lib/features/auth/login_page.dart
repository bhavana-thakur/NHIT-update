import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppv_components/core/auth_service.dart';
import 'package:ppv_components/core/role_manager.dart';
import 'package:ppv_components/core/app_routes.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  final _auth = AuthService();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
  
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    try {
      final res = await _auth.login(
        login: _loginController.text.trim(),
        password: _passwordController.text,
        tenantId: '123e4567-e89b-12d3-a456-426614174000',
        orgId: '6552f16c-7832-4ebb-b052-eb9741f31d22',
      );
      final role = (res['role'] ?? res['roleName'] ?? 'USER').toString();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login successful'),
          backgroundColor: Colors.green,
        ),
      );
      RoleManager.redirectByRole(context, role);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome', style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('Sign in to continue', style: TextStyle(color: cs.onSurfaceVariant)),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _loginController,
                      decoration: const InputDecoration(prefixIcon: Icon(Icons.person), labelText: 'Email or Username'),
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(prefixIcon: Icon(Icons.lock), labelText: 'Password'),
                      validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _loading ? null : _submit,
                        icon: const Icon(Icons.login),
                        label: _loading ? const Text('Signing in...') : const Text('Sign In'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => context.push(AppRoutes.forgotPassword),
                          child: const Text('Forgot Password?'),
                        ),
                        TextButton(
                          onPressed: () => context.push(AppRoutes.registration),
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: Divider(color: cs.outline)),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text('OR')),
                        Expanded(child: Divider(color: cs.outline)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _loading ? null : () {/* initiate Google SSO placeholder */},
                            icon: const Icon(Icons.g_mobiledata),
                            label: const Text('Sign in with Google'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _loading ? null : () {/* initiate Microsoft SSO placeholder */},
                            icon: const Icon(Icons.cloud),
                            label: const Text('Sign in with Microsoft'),
                          ),
                        ),
                      ],
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
