import 'package:flutter/material.dart';
import 'package:ppv_components/common_widgets/button/primary_button.dart';
import 'package:ppv_components/common_widgets/button/outlined_button.dart';
import 'package:ppv_components/common_widgets/custom_dropdown.dart';

class CreateBankLetterPage extends StatefulWidget {
  const CreateBankLetterPage({super.key});

  @override
  State<CreateBankLetterPage> createState() => _CreateBankLetterPageState();
}

class _CreateBankLetterPageState extends State<CreateBankLetterPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedLetterType;
  String? hoveredLetterType;
  String selectedStatus = 'Draft';
  
  // Form controllers
  final _transferController = TextEditingController();
  final _paymentReferenceController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _branchNameController = TextEditingController();
  final _bankAddressController = TextEditingController();
  final _subjectController = TextEditingController();
  final _letterContentController = TextEditingController();

  @override
  void dispose() {
    _transferController.dispose();
    _paymentReferenceController.dispose();
    _bankNameController.dispose();
    _branchNameController.dispose();
    _bankAddressController.dispose();
    _subjectController.dispose();
    _letterContentController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> letterTypes = [
    {
      'type': 'Transfer Letter',
      'icon': Icons.swap_horiz,
      'color': Colors.cyan,
      'description': 'For fund transfers between accounts',
    },
    {
      'type': 'Payment Letter',
      'icon': Icons.payment,
      'color': Colors.green,
      'description': 'For payment authorizations',
    },
    {
      'type': 'General Letter',
      'icon': Icons.description,
      'color': Colors.orange,
      'description': 'For general banking requests',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  _buildHeader(context, constraints),
                  const SizedBox(height: 24),
                  
                  // Form Section
                  _buildFormSection(context, constraints),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, BoxConstraints constraints) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isSmallScreen = constraints.maxWidth < 900;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline,
          width: 0.5,
        ),
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
                  Icons.add_circle_outline,
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
                      'Create Bank Letter',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Generate professional bank letters for transfers and payments',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isSmallScreen) ...[
                const SizedBox(width: 16),
                OutlineButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icons.arrow_back,
                  label: 'Back',
                ),
              ],
            ],
          ),
          if (isSmallScreen) ...[
            const SizedBox(height: 16),
            OutlineButton(
              onPressed: () => Navigator.pop(context),
              icon: Icons.arrow_back,
              label: 'Back',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFormSection(BuildContext context, BoxConstraints constraints) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isSmallScreen = constraints.maxWidth < 900;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline,
          width: 0.5,
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Row(
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Letter Details',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Letter Type Label
            Row(
              children: [
                Text(
                  'Letter Type',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Letter Type Cards
            isSmallScreen
                ? Column(
                    children: letterTypes.map((type) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildLetterTypeCard(
                          context,
                          type: type['type'],
                          icon: type['icon'],
                          color: type['color'],
                          description: type['description'],
                        ),
                      );
                    }).toList(),
                  )
                : Row(
                    children: letterTypes.map((type) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _buildLetterTypeCard(
                            context,
                            type: type['type'],
                            icon: type['icon'],
                            color: type['color'],
                            description: type['description'],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

            // Dynamic Form Fields based on selected letter type
            if (selectedLetterType != null) ...[
              const SizedBox(height: 24),
              _buildDynamicFormFields(context, isSmallScreen),
            ],

            const SizedBox(height: 32),

            // Action Buttons
            isSmallScreen
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OutlineButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icons.cancel_outlined,
                        label: 'Cancel',
                      ),
                      const SizedBox(height: 12),
                      OutlineButton(
                        onPressed: _previewLetter,
                        icon: Icons.visibility_outlined,
                        label: 'Preview',
                      ),
                      const SizedBox(height: 12),
                      PrimaryButton(
                        onPressed: _createLetter,
                        icon: Icons.check_circle_outline,
                        label: 'Create Letter',
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlineButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icons.cancel_outlined,
                        label: 'Cancel',
                      ),
                      const SizedBox(width: 12),
                      OutlineButton(
                        onPressed: _previewLetter,
                        icon: Icons.visibility_outlined,
                        label: 'Preview',
                      ),
                      const SizedBox(width: 12),
                      PrimaryButton(
                        onPressed: _createLetter,
                        icon: Icons.check_circle_outline,
                        label: 'Create Letter',
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicFormFields(BuildContext context, bool isSmallScreen) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Transfer Letter Fields
        if (selectedLetterType == 'Transfer Letter') ...[
          _buildTextField(
            label: 'Select Transfer',
            hint: 'Select a transfer',
            controller: _transferController,
            isRequired: true,
            helperText: 'Select an approved transfer to generate letter for',
          ),
          const SizedBox(height: 16),
        ],
        
        // Payment Letter Fields
        if (selectedLetterType == 'Payment Letter') ...[
          _buildTextField(
            label: 'Payment Reference',
            hint: '',
            controller: _paymentReferenceController,
            isRequired: true,
          ),
          const SizedBox(height: 16),
        ],
        
        // Common Fields for all letter types
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
          children: [
            Expanded(
              child: _buildTextField(
                label: 'Subject',
                hint: 'Enter letter subject',
                controller: _subjectController,
                isRequired: true,
              ),
            ),
            const SizedBox(width: 12),
            OutlineButton(
              onPressed: _loadTemplate,
              icon: Icons.file_download_outlined,
              label: 'Load Template',
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
          items: ['Draft', 'Submit for Approval'],
          isRequired: true,
          onChanged: (value) {
            setState(() {
              selectedStatus = value ?? 'Draft';
            });
          },
        ),
      ],
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

  Widget _buildLetterTypeCard(
    BuildContext context, {
    required String type,
    required IconData icon,
    required Color color,
    required String description,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isSelected = selectedLetterType == type;
    final isHovered = hoveredLetterType == type;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hoveredLetterType = type;
        });
      },
      onExit: (_) {
        setState(() {
          hoveredLetterType = null;
        });
      },
      child: InkWell(
        onTap: () {
          setState(() {
            selectedLetterType = type;
            // Clear form fields when switching letter types
            _subjectController.clear();
            _letterContentController.clear();
            _transferController.clear();
            _paymentReferenceController.clear();
            _bankNameController.clear();
            _branchNameController.clear();
            _bankAddressController.clear();
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 180,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected || isHovered ? colorScheme.primary : colorScheme.outline,
              width: isSelected || isHovered ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                type,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadTemplate() {
    if (selectedLetterType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a letter type first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      if (selectedLetterType == 'Transfer Letter') {
        // Transfer Letter Template
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
      } else if (selectedLetterType == 'Payment Letter') {
        // Payment Letter Template
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
      } else if (selectedLetterType == 'General Letter') {
        // General Letter Template
        _subjectController.text = 'Request for Banking Assistance';
        _letterContentController.text = '''Dear Sir/Madam,

We are writing to request your assistance with the following matter:

[Please describe your request here]

We would appreciate your prompt attention to this matter.

Thank you for your cooperation.

Yours faithfully,
{creator_name}
{creator_designation}''';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Template loaded for $selectedLetterType'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _previewLetter() {
    if (selectedLetterType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a letter type'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Preview: $selectedLetterType'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _createLetter() {
    if (selectedLetterType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a letter type'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Creating $selectedLetterType...'),
          backgroundColor: Colors.green,
        ),
      );
      // Add your letter creation logic here
    }
  }
}
