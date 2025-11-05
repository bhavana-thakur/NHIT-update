import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  final _confirmCtl = TextEditingController();

  bool _acceptTerms = false;
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtl.dispose();
    _emailCtl.dispose();
    _passCtl.dispose();
    _confirmCtl.dispose();
    super.dispose();
  }

  Future<void> _onSignUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please accept Terms & Privacy')));
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signed up (mock)')));
    // Optionally navigate to login automatically:
    // Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController ctl,
    bool obscure = false,
    String? Function(String?)? validator,
    Widget? suffix,
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
            color: cs.surfaceVariant.withOpacity(0.06),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 18, color: cs.onSurface),
        ),
        hintText: hint,
        suffixIcon: suffix,
        filled: true,
        fillColor: cs.surfaceVariant.withOpacity(0.03),
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const double wideBreakpoint = 900;
    const double cardMaxWidth = 520;
    const double compactCardMax = 420;

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
                ),
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Sign Up', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: cs.onSurface)),
                    SizedBox(height: smallGap),
                    Text('Please fill in this form to create an account!',
                        style: TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(0.75))),
                    SizedBox(height: smallGap),
                    Divider(color: cs.outline, height: 18),
                    SizedBox(height: smallGap),
                    Center(child: Text('Register with your email', style: TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(0.7)))),
                    SizedBox(height: smallGap),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                            hint: 'Username',
                            icon: Icons.person,
                            ctl: _nameCtl,
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter username' : null,
                          ),
                          const SizedBox(height: 12),
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
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Enter password';
                              if (v.length < 6) return 'Password too short';
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            hint: 'Confirm Password',
                            icon: Icons.lock,
                            ctl: _confirmCtl,
                            obscure: true,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Confirm password';
                              if (v != _passCtl.text) return 'Passwords do not match';
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              children: [
                                SizedBox(
                                  width: 40,
                                  child: Checkbox(
                                    value: _acceptTerms,
                                    onChanged: (v) => setState(() => _acceptTerms = v ?? false),
                                    activeColor: cs.primary,
                                  ),
                                ),
                                SizedBox(
                                  width: constraints.maxWidth < 380 ? constraints.maxWidth - 120 : null,
                                  child: Text('I accept the Terms of Use & Privacy Policy',
                                      style: TextStyle(color: cs.onSurface.withOpacity(0.85), fontSize: 13)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _onSignUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cs.primary,
                                foregroundColor: cs.onPrimary,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: _loading
                                  ? SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: cs.onPrimary))
                                  : Text('Sign Up', style: TextStyle(fontWeight: FontWeight.w600, color: cs.onPrimary)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          }

          // footer with link -> NAVIGATES to /login
          Widget footer = Padding(
            padding: const EdgeInsets.only(top: 14.0),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Already have an account? ', style: TextStyle(color: cs.onSurface.withOpacity(0.85))),
                  TextButton(
                    onPressed: () {
                      // FLUTTER: navigate to the named route '/login'
                      Navigator.pushNamed(context, '/login');
                      // If you want to replace signup so user can't go back:
                      // Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text('Login here', style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );

          // WIDE layout
          if (isWide) {
            final padding = EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.06, vertical: 28.0);
            return Center(
              child: Padding(
                padding: padding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildCard(cardMaxWidth, const EdgeInsets.symmetric(horizontal: 28, vertical: 22)),
                    footer,
                  ],
                ),
              ),
            );
          }

          // NARROW layout: scrolling + keyboard aware
          final viewInsets = MediaQuery.of(context).viewInsets.bottom;
          final horizontalPad = 16.0;
          final topBottomPad = 16.0;
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(horizontalPad, topBottomPad, horizontalPad, topBottomPad + viewInsets),
            child: Column(
              children: [
                const SizedBox(height: 12),
                buildCard(compactCardMax, const EdgeInsets.symmetric(horizontal: 18, vertical: 18)),
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
