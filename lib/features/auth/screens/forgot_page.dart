import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _emailCtl.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _sending = true);
    // simulate network delay - replace with real API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _sending = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password reset link sent (mock)')),
    );

    // Optionally navigate back to login
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const double wideBreakpoint = 900;
    const double cardMaxWidth = 520;
    const double compactMax = 420;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >= wideBreakpoint;

          Widget buildCard(double maxWidth, EdgeInsets padding) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Container(
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: cs.outline, width: 1.2),
                  boxShadow: [BoxShadow(color: cs.shadow.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                padding: padding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Reset your password', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: cs.onSurface)),
                    const SizedBox(height: 8),
                    Text('Enter your account email and we will send a reset link.',
                        style: TextStyle(color: cs.onSurface.withValues(alpha: 0.8))),
                    const SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _emailCtl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            margin: const EdgeInsets.only(left: 8, right: 6),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: cs.surfaceContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(Icons.email_outlined, size: 18, color: cs.onSurface),
                          ),
                          hintText: 'Email',
                          filled: true,
                          fillColor: cs.surfaceContainer,
                          border: const OutlineInputBorder(borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Enter email';
                          final re = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!re.hasMatch(v)) return 'Enter valid email';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.tonal(
                            onPressed: _sending ? null : () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: _sending ? null : _sendReset,
                            style: FilledButton.styleFrom(
                              backgroundColor: cs.primary,
                              foregroundColor: cs.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: _sending
                                ? SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: cs.onPrimary))
                                : const Text('Send Link'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: cs.onSurface.withValues(alpha: 0.85)),
                          children: [
                            const TextSpan(text: 'Remembered your password? '),
                            TextSpan(
                              text: 'Sign in',
                              style: TextStyle(decoration: TextDecoration.underline, color: cs.primary, fontWeight: FontWeight.w600),
                              recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushReplacementNamed(context, '/login'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // WIDE: center (no scroll)
          if (isWide) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.06, vertical: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildCard(cardMaxWidth, const EdgeInsets.symmetric(horizontal: 24, vertical: 20)),
                  ],
                ),
              ),
            );
          }

          // NARROW: scrollable and keyboard-aware
          final viewInsets = MediaQuery.of(context).viewInsets.bottom;
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 20 + viewInsets),
            child: Column(
              children: [
                const SizedBox(height: 12),
                buildCard(compactMax, const EdgeInsets.symmetric(horizontal: 18, vertical: 18)),
                const SizedBox(height: 12),
              ],
            ),
          );
        }),
      ),
    );
  }
}
