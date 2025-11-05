import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();

  bool _obscure = true;
  bool _loading = false;
  late TapGestureRecognizer _signupRecognizer;

  @override
  void initState() {
    super.initState();
    _signupRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pushReplacementNamed(context, '/signup');
      };
  }

  @override
  void dispose() {
    _signupRecognizer.dispose();
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  Future<void> _onSignIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Signed in (mock)')),
    );
    // navigate to app home...
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController ctl,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    final cs = Theme.of(context).colorScheme;
    return TextFormField(
      controller: ctl,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Container(
          margin: const EdgeInsets.only(left: 8, right: 6),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: cs.surfaceContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 18, color: cs.onSurface),
        ),
        hintText: hint,
        suffixIcon: suffix,
        filled: true,
        fillColor: cs.surfaceContainer,
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const double wideBreakpoint = 900;
    const double cardMaxWidth = 420;
    const double compactCardMax = 360;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >= wideBreakpoint;

          Widget buildCard(double maxWidth, EdgeInsets padding) {
            final double smallGap = constraints.maxWidth < 420 ? 8 : 12;

            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Container(
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: cs.outline, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: cs.shadow.withValues(alpha:0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sign In',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface),
                    ),
                    SizedBox(height: smallGap),
                    Text(
                      'Enter your email and password to sign in',
                      style: TextStyle(
                          fontSize: 13,
                          color: cs.onSurface.withValues(alpha:0.75)),
                    ),
                    SizedBox(height: smallGap),
                    Divider(color: cs.outline, height: 18),
                    SizedBox(height: smallGap),

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                            hint: 'Email Address',
                            icon: Icons.email_outlined,
                            ctl: _emailCtl,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Enter email';
                              final re = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                              if (!re.hasMatch(v)) return 'Enter valid email';
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            hint: 'Password',
                            icon: Icons.lock,
                            ctl: _passCtl,
                            obscure: _obscure,
                            suffix: IconButton(
                              icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Enter password';
                              if (v.length < 6) return 'Password too short';
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Navigator.pushNamed(context, '/forgot'),
                              child: const Text('Forgot password?'),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Sign In Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _onSignIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cs.primary,
                                foregroundColor: cs.onPrimary,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: _loading
                                  ? SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: cs.onPrimary))
                                  : Text('Sign In',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: cs.onPrimary)),
                            ),
                          ),

                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // footer with link to signup
          Widget footer = Padding(
            padding: const EdgeInsets.only(top: 14.0),
            child: Center(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: cs.onSurface.withValues(alpha:0.85)),
                  children: [
                    const TextSpan(text: 'Don’t have an account? '),
                    TextSpan(
                      text: 'Sign up',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          color: cs.primary),
                      recognizer: _signupRecognizer,
                    ),
                  ],
                ),
              ),
            ),
          );

          // WIDE: Center card with no vertical scroll
          if (isWide) {
            final padding = EdgeInsets.symmetric(
                horizontal: constraints.maxWidth * 0.06, vertical: 28.0);
            return Center(
              child: Padding(
                padding: padding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildCard(cardMaxWidth,
                        const EdgeInsets.symmetric(horizontal: 22, vertical: 20)),
                    footer,
                  ],
                ),
              ),
            );
          }

          // NARROW: Scrollable + keyboard aware
          final viewInsets = MediaQuery.of(context).viewInsets.bottom;
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                16, 16, 16, 16 + viewInsets),
            child: Column(
              children: [
                const SizedBox(height: 12),
                buildCard(compactCardMax,
                    const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 18)),
                footer,
                const SizedBox(height: 8),
              ],
            ),
          );
        }),
      ),
    );
  }
}
