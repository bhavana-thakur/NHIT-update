import 'package:flutter/material.dart';
import 'package:ppv_components/common_widgets/button/primary_button.dart';
import 'package:ppv_components/common_widgets/button/outlined_button.dart';
import 'package:ppv_components/common_widgets/custom_dropdown.dart';

class CreateExternalTransferForm extends StatefulWidget {
  final VoidCallback onCancel;
  final List<String> sourceAccounts;
  final List<Map<String, dynamic>> paymentMethods;

  const CreateExternalTransferForm({
    super.key,
    required this.onCancel,
    required this.sourceAccounts,
    required this.paymentMethods,
  });

  @override
  State<CreateExternalTransferForm> createState() => _CreateExternalTransferFormState();
}

class _CreateExternalTransferFormState extends State<CreateExternalTransferForm> {
  final _formKey = GlobalKey<FormState>();
  String? selectedPaymentMethod;
  String? hoveredPaymentMethod;

  // Form controllers
  final _transferAmountController = TextEditingController(text: '0.00');
  final _beneficiaryNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _branchNameController = TextEditingController();
  final _purposeController = TextEditingController();
  final _remarksController = TextEditingController();
  final _upiIdController = TextEditingController();

  // Dropdown values
  String? selectedSourceAccount;

  @override
  void dispose() {
    _transferAmountController.dispose();
    _beneficiaryNameController.dispose();
    _accountNumberController.dispose();
    _ifscCodeController.dispose();
    _bankNameController.dispose();
    _branchNameController.dispose();
    _purposeController.dispose();
    _remarksController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  void _incrementAmount(TextEditingController controller, {double step = 0.01}) {
    final currentValue = double.tryParse(controller.text) ?? 0.0;
    final newValue = currentValue + step;
    controller.text = newValue.toStringAsFixed(2);
    setState(() {});
  }

  void _decrementAmount(TextEditingController controller, {double step = 0.01}) {
    final currentValue = double.tryParse(controller.text) ?? 0.0;
    final newValue = (currentValue - step).clamp(0.0, double.infinity);
    controller.text = newValue.toStringAsFixed(2);
    setState(() {});
  }

  void _createTransfer() {
    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Creating External Transfer - $selectedPaymentMethod...'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Payment Method Label
          Row(
            children: [
              Text(
                'Payment Method',
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

          // Payment Method Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = 280.0;
              final spacing = 16.0;
              final availableWidth = constraints.maxWidth;
              final cardsPerRow = (availableWidth / (cardWidth + spacing)).floor();

              if (cardsPerRow >= 4) {
                return Wrap(
                  spacing: spacing,
                  runSpacing: 16,
                  children: widget.paymentMethods.map((method) {
                    return SizedBox(
                      width: cardWidth,
                      child: _buildPaymentMethodCard(
                        context,
                        method: method['method'],
                        icon: method['icon'],
                        color: method['color'],
                        description: method['description'],
                        minAmount: method['minAmount'],
                      ),
                    );
                  }).toList(),
                );
              } else if (cardsPerRow >= 2) {
                return Wrap(
                  spacing: spacing,
                  runSpacing: 16,
                  children: widget.paymentMethods.map((method) {
                    return SizedBox(
                      width: (availableWidth - spacing) / 2,
                      child: _buildPaymentMethodCard(
                        context,
                        method: method['method'],
                        icon: method['icon'],
                        color: method['color'],
                        description: method['description'],
                        minAmount: method['minAmount'],
                      ),
                    );
                  }).toList(),
                );
              } else {
                return Column(
                  children: widget.paymentMethods.map((method) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildPaymentMethodCard(
                        context,
                        method: method['method'],
                        icon: method['icon'],
                        color: method['color'],
                        description: method['description'],
                        minAmount: method['minAmount'],
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),

          if (selectedPaymentMethod != null) ...[
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
                onPressed: widget.onCancel,
                icon: Icons.cancel_outlined,
                label: 'Cancel',
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                onPressed: _createTransfer,
                icon: Icons.check_circle_outline,
                label: 'Create Transfer',
              ),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlineButton(
                onPressed: widget.onCancel,
                icon: Icons.cancel_outlined,
                label: 'Cancel',
              ),
              const SizedBox(width: 12),
              PrimaryButton(
                onPressed: _createTransfer,
                icon: Icons.check_circle_outline,
                label: 'Create Transfer',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(
      BuildContext context, {
        required String method,
        required IconData icon,
        required Color color,
        required String description,
        required String minAmount,
      }) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isSelected = selectedPaymentMethod == method;
    final isHovered = hoveredPaymentMethod == method;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hoveredPaymentMethod = method;
        });
      },
      onExit: (_) {
        setState(() {
          hoveredPaymentMethod = null;
        });
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedPaymentMethod = method;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          transform: Matrix4.identity()
            ..translate(0.0, isHovered ? -8.0 : 0.0)
            ..scale(isHovered ? 1.03 : 1.0),
          height: 200,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
              colors: [
                color.withOpacity(0.15),
                colorScheme.surface,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : null,
            color: !isSelected ? colorScheme.surface : null,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected || isHovered ? color : colorScheme.outline,
              width: isSelected ? 2.5 : (isHovered ? 2 : 1),
            ),
            boxShadow: isHovered || isSelected
                ? [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: isSelected ? 20 : 12,
                spreadRadius: isSelected ? 2 : 0,
                offset: Offset(0, isHovered ? 8 : 4),
              ),
            ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(isSelected ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 36,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                method,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? color : colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: color.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  minAmount,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicFormFields(BuildContext context, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdownField(
          label: 'Source Account',
          value: selectedSourceAccount,
          items: widget.sourceAccounts,
          isRequired: true,
          onChanged: (value) {
            setState(() {
              selectedSourceAccount = value;
            });
          },
        ),
        const SizedBox(height: 16),

        // UPI specific fields
        if (selectedPaymentMethod == 'UPI') ...[
          _buildTextField(
            label: 'UPI ID',
            hint: 'Enter UPI ID (e.g., username@upi)',
            controller: _upiIdController,
            isRequired: true,
          ),
          const SizedBox(height: 16),
        ],

        // Bank transfer specific fields
        if (selectedPaymentMethod != 'UPI') ...[
          _buildTextField(
            label: 'Beneficiary Name',
            hint: 'Enter beneficiary name',
            controller: _beneficiaryNameController,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          isSmallScreen
              ? Column(
            children: [
              _buildTextField(
                label: 'Account Number',
                hint: 'Enter account number',
                controller: _accountNumberController,
                isRequired: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'IFSC Code',
                hint: 'Enter IFSC code',
                controller: _ifscCodeController,
                isRequired: true,
              ),
            ],
          )
              : Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Account Number',
                  hint: 'Enter account number',
                  controller: _accountNumberController,
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  label: 'IFSC Code',
                  hint: 'Enter IFSC code',
                  controller: _ifscCodeController,
                  isRequired: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
        ],

        _buildAmountStepperField(
          controller: _transferAmountController,
          label: 'Transfer Amount (₹)',
        ),
        const SizedBox(height: 16),
        isSmallScreen
            ? Column(
          children: [
            _buildTextField(
              label: 'Purpose',
              hint: 'Enter transfer purpose',
              controller: _purposeController,
              isRequired: true,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Remarks',
              hint: 'Enter additional remarks (optional)',
              controller: _remarksController,
              maxLines: 3,
            ),
          ],
        )
            : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTextField(
                label: 'Purpose',
                hint: 'Enter transfer purpose',
                controller: _purposeController,
                isRequired: true,
                maxLines: 3,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                label: 'Remarks',
                hint: 'Enter additional remarks (optional)',
                controller: _remarksController,
                maxLines: 3,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmountStepperField({
    required TextEditingController controller,
    String? label,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label ?? 'Amount (₹)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            filled: true,
            fillColor: colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            suffixIcon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 20,
                    icon: Icon(
                      Icons.arrow_drop_up,
                      color: colorScheme.primary,
                    ),
                    onPressed: () => _incrementAmount(controller, step: 0.01),
                    tooltip: 'Increase',
                  ),
                ),
                SizedBox(
                  height: 24,
                  width: 24,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 20,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: colorScheme.primary,
                    ),
                    onPressed: () => _decrementAmount(controller, step: 0.01),
                    tooltip: 'Decrease',
                  ),
                ),
              ],
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Amount is required';
            }
            return null;
          },
          onChanged: (_) => setState(() {}),
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
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.5),
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 14,
            ),
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
