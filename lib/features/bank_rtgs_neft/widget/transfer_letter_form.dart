import 'package:flutter/material.dart';
import 'package:ppv_components/common_widgets/button/primary_button.dart';
import 'package:ppv_components/common_widgets/button/secondary_button.dart';
import 'package:ppv_components/common_widgets/custom_dropdown.dart';
import '../controllers/bank_letter_controller.dart';
import '../models/transfer_models/transfer_enums.dart';
import '../models/transfer_models/transfer_model.dart';
import '../models/transfer_models/transfer_leg.dart';

class CreateTransferLetterForm extends StatefulWidget {
  final VoidCallback onCancel;

  const CreateTransferLetterForm({
    super.key,
    required this.onCancel,
  });

  @override
  State<CreateTransferLetterForm> createState() => _CreateTransferLetterFormState();
}

class _CreateTransferLetterFormState extends State<CreateTransferLetterForm> {
  final _formKey = GlobalKey<FormState>();
  String selectedStatus = 'Draft';
  final Map<String, String> _statusMap = {
    'Draft': 'LETTER_STATUS_DRAFT',
    'Pending Approval': 'LETTER_STATUS_PENDING_APPROVAL',
    'Approved': 'LETTER_STATUS_APPROVED',
    'Sent': 'LETTER_STATUS_SENT',
    'Acknowledged': 'LETTER_STATUS_ACKNOWLEDGED',
  };
  final BankLetterController _bankLetterController = BankLetterController();
  bool _isSubmitting = false;

  // Form controllers
  Transfer? selectedTransfer;
  final List<Transfer> availableTransfers = [
    Transfer(
      transferId: '1',
      transferReference: 'TR001',
      transferType: TransferType.internal,
      transferMode: TransferMode.oneToOne,
      totalAmount: 10000.00,
      purpose: 'Salary Transfer',
      remarks: 'Monthly salary payment',
      status: TransferStatus.approved,
      requestedById: '123e4567-e89b-12d3-a456-426614174000',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      transferLegs: [
        TransferLeg(
          id: '1-1',
          transferId: '1',
          sourceAccountId: 'ACC001',
          destinationAccountId: 'ACC002',
          amount: 10000.00,
          sourceAccount: SimpleEscrowAccount(
            id: 'ACC001',
            accountNumber: '1234567890',
            accountName: 'Main Account',
          ),
          destinationAccount: SimpleEscrowAccount(
            id: 'ACC002',
            accountNumber: '0987654321',
            accountName: 'Salary Account',
          ),
        ),
      ],
    ),
    Transfer(
      transferId: '2',
      transferReference: 'TR002',
      transferType: TransferType.external,
      transferMode: TransferMode.oneToMany,
      totalAmount: 25000.00,
      purpose: 'Vendor Payment',
      remarks: 'Payment for services',
      status: TransferStatus.completed,
      requestedById: '123e4567-e89b-12d3-a456-426614174000',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      transferLegs: [
        TransferLeg(
          id: '2-1',
          transferId: '2',
          sourceAccountId: 'ACC003',
          destinationVendorId: 'VEN001',
          amount: 25000.00,
          sourceAccount: SimpleEscrowAccount(
            id: 'ACC003',
            accountNumber: '5555666677',
            accountName: 'Project Account',
          ),
          destinationVendor: SimpleVendor(
            id: 'VEN001',
            name: 'ABC Suppliers',
            code: 'ABC001',
          ),
        ),
      ],
    ),
  ];
  final _bankNameController = TextEditingController();
  final _branchNameController = TextEditingController();
  final _bankAddressController = TextEditingController();
  final _subjectController = TextEditingController();
  final _letterContentController = TextEditingController();

  @override
  void dispose() {
    _bankNameController.dispose();
    _branchNameController.dispose();
    _bankAddressController.dispose();
    _subjectController.dispose();
    _letterContentController.dispose();
    super.dispose();
  }

  void _loadTemplate() {
    setState(() {
      _subjectController.text = 'Request for Fund Transfer - {transfer_reference}';
      _letterContentController.text = '''Dear Sir/Madam,

We request you to kindly process the following fund transfer from our account:

Transfer Details:
- Transfer Reference: {transfer_reference}
- From Account: {from_account_name} ({from_account_number})
- To Account: {to_account_name} ({to_account_number})
- Amount: ₹{transfer_amount}
- Purpose: {transfer_purpose}

Please process this transfer at your earliest convenience and confirm the same.

Thank you for your cooperation.

Yours faithfully,
{creator_name}
{creator_designation}''';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Template loaded for Transfer Letter'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _previewLetter() {
    if (!_formKey.currentState!.validate() || selectedTransfer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete required fields and select a transfer to preview.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final transfer = selectedTransfer!;
    final subject = _subjectController.text.trim().isEmpty
        ? 'No subject provided'
        : _subjectController.text.trim();
    final content = _letterContentController.text.trim().isEmpty
        ? 'No letter content provided yet.'
        : _letterContentController.text.trim();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        final colorScheme = theme.colorScheme;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: 24 + MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Transfer Letter Preview',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Transfer Reference: ${transfer.transferReference}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Status: $selectedStatus',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          content,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          onPressed: _downloadLetterPdf,
                          icon: Icons.picture_as_pdf_outlined,
                          label: 'Download PDF',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          onPressed: () {
                            Navigator.of(sheetContext).pop();
                            _createLetter();
                          },
                          icon: Icons.send,
                          label: 'Create Letter',
                          isLoading: _isSubmitting,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _downloadLetterPdf() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Generating PDF for download...'),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  Future<void> _createLetter() async {
    if (!_formKey.currentState!.validate() || selectedTransfer == null) {
      return;
    }

    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    final messenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);

    messenger.showSnackBar(
      const SnackBar(
        content: Text('Creating Transfer Letter...'),
        backgroundColor: Colors.green,
      ),
    );

    try {
      final saveAsStatus = _statusMap[selectedStatus] ?? 'LETTER_STATUS_DRAFT';

      final success = await _bankLetterController.createTransferLetter(
        transferId: selectedTransfer!.transferId,
        bankName: _bankNameController.text.trim(),
        branchName: _branchNameController.text.trim(),
        bankAddress: _bankAddressController.text.trim(),
        subject: _subjectController.text.trim(),
        content: _letterContentController.text.trim(),
        saveAsStatus: saveAsStatus,
      );

      if (!mounted) return;

      messenger.hideCurrentSnackBar();

      if (success) {
        messenger.showSnackBar(
          SnackBar(
            content: const Text('Transfer letter created successfully'),
            backgroundColor: theme.colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        messenger.showSnackBar(
          SnackBar(
            content: const Text('Failed to create transfer letter. Please try again.'),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text('Error: ${_bankLetterController.getErrorMessage(e)}'),
          backgroundColor: theme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
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
          _buildDropdownField(
            label: 'Select Transfer',
            value: selectedTransfer?.displayText,
            items: availableTransfers.map((t) => t.displayText).toList(),
            isRequired: true,
            onChanged: (value) {
              setState(() {
                selectedTransfer = availableTransfers.firstWhere(
                  (t) => t.displayText == value,
                  orElse: () => availableTransfers.first,
                );
              });
            },
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
            'Available placeholders: [transfer_reference], [from_account_name], [to_account_name], [transfer_amount], [creator_name]',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),

          _buildDropdownField(
            label: 'Status',
            value: selectedStatus,
            items: const [
              'Draft',
              'Pending Approval',
              'Approved',
              'Sent',
              'Acknowledged',
            ],
            isRequired: true,
            onChanged: (value) {
              setState(() {
                selectedStatus = value ?? 'Draft';
              });
            },
          ),
          const SizedBox(height: 32),

          // Action Buttons
          if (isSmallScreen) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SecondaryButton(
                  onPressed: widget.onCancel,
                  icon: Icons.cancel_outlined,
                  label: 'Cancel',
                ),
                const SizedBox(height: 12),
                SecondaryButton(
                  onPressed: _previewLetter,
                  icon: Icons.visibility_outlined,
                  label: 'Preview Letter',
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  onPressed: _createLetter,
                  icon: Icons.send,
                  label: 'Create Letter',
                  isLoading: _isSubmitting,
                ),
              ],
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SecondaryButton(
                  onPressed: widget.onCancel,
                  icon: Icons.cancel_outlined,
                  label: 'Cancel',
                ),
                const SizedBox(width: 12),
                SecondaryButton(
                  onPressed: _previewLetter,
                  icon: Icons.visibility_outlined,
                  label: 'Preview Letter',
                ),
                const SizedBox(width: 12),
                PrimaryButton(
                  onPressed: _createLetter,
                  icon: Icons.send,
                  label: 'Create Letter',
                  isLoading: _isSubmitting,
                ),
              ],
            ),
          ],
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
    required String? value,
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
