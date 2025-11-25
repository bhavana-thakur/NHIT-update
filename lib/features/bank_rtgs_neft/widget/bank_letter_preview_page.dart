import 'package:flutter/material.dart';
import 'package:ppv_components/common_widgets/button/primary_button.dart';
import 'package:ppv_components/common_widgets/button/secondary_button.dart';
import '../models/bank_models/bank_letter_form_data.dart';
import '../utils/pdf_generator.dart';

class BankLetterPreviewPage extends StatefulWidget {
  final BankLetterFormData formData;

  const BankLetterPreviewPage({super.key, required this.formData});

  @override
  State<BankLetterPreviewPage> createState() => _BankLetterPreviewPageState();
}

class _BankLetterPreviewPageState extends State<BankLetterPreviewPage> {
  bool _isSending = false;
  bool _isDownloading = false;

  Future<void> _sendLetter() async {
    setState(() {
      _isSending = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isSending = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Form sent successfully!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Navigate back after successful send
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _downloadPdf() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      await BankLetterPdfGenerator.generateAndDownloadPdf(widget.formData);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('PDF downloaded successfully!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, isSmallScreen),
              const SizedBox(height: 24),
              _buildPreviewSection(context, isSmallScreen),
              const SizedBox(height: 24),
              _buildActionButtons(context, isSmallScreen),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isSmallScreen) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.preview_outlined,
                  size: 28,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bank Letter Preview',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Review your bank letter before sending or downloading',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isSmallScreen) ...[
                const SizedBox(width: 16),
                SecondaryButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icons.arrow_back,
                  label: 'Back',
                ),
              ],
            ],
          ),
          if (isSmallScreen) ...[
            const SizedBox(height: 16),
            SecondaryButton(
              onPressed: () => Navigator.pop(context),
              icon: Icons.arrow_back,
              label: 'Back',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreviewSection(BuildContext context, bool isSmallScreen) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 20 : 32),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Letter Header
          Center(
            child: Column(
              children: [
                Text(
                  'BANK LETTER',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 3,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Date
          Align(
            alignment: Alignment.topRight,
            child: Text(
              'Date: ${widget.formData.date.day}/${widget.formData.date.month}/${widget.formData.date.year}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Bank Details
          Text(
            'To,',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text('The Manager,', style: theme.textTheme.bodyMedium),
          Text(
            widget.formData.bankName,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(widget.formData.branchName, style: theme.textTheme.bodyMedium),
          Text(widget.formData.bankAddress, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 24),

          // Subject
          RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              children: [
                TextSpan(
                  text: 'Subject: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: widget.formData.subject,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Salutation
          Text('Dear Sir/Madam,', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 16),

          // Content
          Text(
            widget.formData.content,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 24),

          // Account Details Box
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account Details:',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailRow('Account Holder Name:', widget.formData.accountHolderName),
                const SizedBox(height: 8),
                _buildDetailRow('Account Number:', widget.formData.accountNumber),
                const SizedBox(height: 8),
                _buildDetailRow('IFSC Code:', widget.formData.ifscCode),
                const SizedBox(height: 8),
                _buildDetailRow('Bank:', widget.formData.bankName),
                const SizedBox(height: 8),
                _buildDetailRow('Branch:', widget.formData.branchName),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Closing
          Text(
            'Thank you for your cooperation.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          Text('Yours faithfully,', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 40),

          // Signature
          Text(
            widget.formData.requestedBy,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(widget.formData.designation, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 180,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isSmallScreen) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline, width: 0.5),
      ),
      child: isSmallScreen
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PrimaryButton(
                  onPressed: _isSending ? null : _sendLetter,
                  icon: Icons.send,
                  label: _isSending ? 'Sending...' : 'Send',
                  isLoading: _isSending,
                ),
                const SizedBox(height: 12),
                SecondaryButton(
                  onPressed: _isDownloading ? null : _downloadPdf,
                  icon: Icons.download,
                  label: _isDownloading ? 'Downloading...' : 'Download PDF',
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SecondaryButton(
                  onPressed: _isDownloading ? null : _downloadPdf,
                  icon: Icons.download,
                  label: _isDownloading ? 'Downloading...' : 'Download PDF',
                ),
                const SizedBox(width: 12),
                PrimaryButton(
                  onPressed: _isSending ? null : _sendLetter,
                  icon: Icons.send,
                  label: _isSending ? 'Sending...' : 'Send',
                  isLoading: _isSending,
                ),
              ],
            ),
    );
  }
}
