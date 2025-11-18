import 'package:flutter/material.dart';
import 'package:ppv_components/common_widgets/button/primary_button.dart';
import 'package:ppv_components/common_widgets/button/secondary_button.dart';
import 'package:ppv_components/common_widgets/custom_dropdown.dart';

class CreatePaymentLetterForm extends StatefulWidget {
  final VoidCallback onCancel;

  const CreatePaymentLetterForm({
    super.key,
    required this.onCancel,
  });

  @override
  State<CreatePaymentLetterForm> createState() => _CreatePaymentLetterFormState();
}

class _CreatePaymentLetterFormState extends State<CreatePaymentLetterForm> {
  final _formKey = GlobalKey<FormState>();
  String selectedStatus = 'Draft';

  // Form controllers
  final _paymentReferenceController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _branchNameController = TextEditingController();
  final _bankAddressController = TextEditingController();
  final _subjectController = TextEditingController();
  final _letterContentController = TextEditingController();

  @override
  void dispose() {
    _paymentReferenceController.dispose();
    _bankNameController.dispose();
    _branchNameController.dispose();
    _bankAddressController.dispose();
    _subjectController.dispose();
    _letterContentController.dispose();
    super.dispose();
  }

  void _loadTemplate() {
    setState(() {
      _subjectController.text = 'Request for Payment Authorization - {payment_reference}';
      _letterContentController.text = '''Dear Sir/Madam,

We request you to kindly process the following payment from our account:

Payment Details:
- Payment Reference: {payment_reference}
- Account: {account_name} ({account_number})
- Beneficiary: {beneficiary_name}
- Amount: ₹{payment_amount}
- Purpose: {payment_purpose}

Please process this payment and provide confirmation.

Thank you for your cooperation.

Yours faithfully,
{creator_name}
{creator_designation}''';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Template loaded for Payment Letter'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _previewLetter() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preview: Payment Letter'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _createLetter() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Creating Payment Letter...'),
          backgroundColor: Colors.green,
        ),
      );
      // Add your letter creation logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: 'Payment Reference',
            hint: 'Enter payment reference',
            controller: _paymentReferenceController,
            isRequired: true,
          ),
          const SizedBox(height: 16),

          // Common Fields
          isSmallScreen
              ? Column(
            children: [
              _buildTextField(
                label: 'Bank Name',
                hint: 'Enter bank name',
                controller: _bankNameController,
                isRequired: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Branch Name',
                hint: 'Enter branch name',
                controller: _branchNameController,
                isRequired: true,
              ),
            ],
          )
              : Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Bank Name',
                  hint: 'Enter bank name',
                  controller: _bankNameController,
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  label: 'Branch Name',
                  hint: 'Enter branch name',
                  controller: _branchNameController,
                  isRequired: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildTextField(
            label: 'Bank Address',
            hint: 'Enter bank address (optional)',
            controller: _bankAddressController,
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Subject',
                  hint: 'Enter letter subject',
                  controller: _subjectController,
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 16),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SecondaryButton(
                  onPressed: _loadTemplate,
                  icon: Icons.file_download_outlined,
                  label: 'Load Template',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildTextField(
            label: 'Letter Content',
            hint: 'Enter letter content',
            controller: _letterContentController,
            isRequired: true,
            maxLines: 8,
          ),
          const SizedBox(height: 8),

          Text(
            'Available placeholders: [payment_reference], [account_name], [beneficiary_name], [payment_amount], [creator_name]',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),

          _buildDropdownField(
            label: 'Status',
            value: selectedStatus,
            items: ['Draft', 'Submit for Approval'],
            isRequired: true,
            onChanged: (value) {
              setState(() {
                selectedStatus = value ?? 'Draft';
              });
            },
          ),
          const SizedBox(height: 32),

          // Action Buttons
          isSmallScreen
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SecondaryButton(
                onPressed: widget.onCancel,
                icon: Icons.cancel_outlined,
                label: 'Cancel',
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                onPressed: _createLetter,
                icon: Icons.send,
                label: 'Submit Letter',
              ),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SecondaryButton(
                onPressed: widget.onCancel,
                icon: Icons.cancel_outlined,
                label: 'Cancel',
              ),
              const SizedBox(width: 12),
              SecondaryButton(
                onPressed: _createLetter,
                icon: Icons.send,
                label: 'Submit Letter',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isRequired = false,
    int maxLines = 1,
    String? helperText,
    bool enabled = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            hintStyle: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 14,
            ),
            filled: !enabled,
            fillColor: enabled ? null : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ),
          validator: isRequired
              ? (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          }
              : null,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool isRequired = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        CustomDropdown(
          value: value,
          items: items,
          hint: 'Select $label',
          onChanged: onChanged,
        ),
      ],
    );
  }
}
