import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppv_components/common_widgets/button/primary_button.dart';
import 'package:ppv_components/common_widgets/button/outlined_button.dart';

class CreateEscrowAccountPage extends StatefulWidget {
  const CreateEscrowAccountPage({super.key});

  @override
  State<CreateEscrowAccountPage> createState() => _CreateEscrowAccountPageState();
}

class _CreateEscrowAccountPageState extends State<CreateEscrowAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _accountNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _branchNameController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _initialBalanceController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String? selectedAccountType;
  List<String> signatories = [''];
  
  final List<String> accountTypes = [
    'Current Account',
    'Savings Account',
    'Escrow Account',
    'Trust Account',
  ];

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _branchNameController.dispose();
    _ifscCodeController.dispose();
    _initialBalanceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addSignatory() {
    setState(() {
      signatories.add('');
    });
  }

  void _removeSignatory(int index) {
    if (signatories.length > 1) {
      setState(() {
        signatories.removeAt(index);
      });
    }
  }

  void _createAccount() {
    if (_formKey.currentState!.validate()) {
      // Handle account creation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escrow account created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

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
                  const SizedBox(height: 16),
                  
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
    final isSmallScreen = constraints.maxWidth < 600;

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
      child: isSmallScreen
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.add_circle_outline,
                        size: 24,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Escrow Account',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Add a new escrow account to your inventory',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                OutlineButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icons.arrow_back,
                  label: 'Back to Accounts',
                ),
              ],
            )
          : Row(
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
                        'Create Escrow Account',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Add a new escrow account to your inventory',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                OutlineButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icons.arrow_back,
                  label: 'Back to Accounts',
                ),
              ],
            ),
    );
  }

  Widget _buildFormSection(BuildContext context, BoxConstraints constraints) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isSmallScreen = constraints.maxWidth < 600;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(22),
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
            // Section Title with Badges
            Row(
              children: [
                Icon(
                  Icons.account_balance,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Account Details',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Account Name and Account Number Row
            isSmallScreen
                ? Column(
                    children: [
                      _buildTextField(
                        controller: _accountNameController,
                        label: 'Account Name',
                        hint: 'Enter account name',
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter account name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _accountNumberController,
                        label: 'Account Number',
                        hint: 'Enter account number',
                        isRequired: true,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter account number';
                          }
                          return null;
                        },
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _accountNameController,
                          label: 'Account Name',
                          hint: 'Enter account name',
                          isRequired: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter account name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _accountNumberController,
                          label: 'Account Number',
                          hint: 'Enter account number',
                          isRequired: true,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter account number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 16),

            // Bank Name and Branch Name Row
            isSmallScreen
                ? Column(
                    children: [
                      _buildTextField(
                        controller: _bankNameController,
                        label: 'Bank Name',
                        hint: 'Enter bank name',
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter bank name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _branchNameController,
                        label: 'Branch Name',
                        hint: 'Enter branch name',
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter branch name';
                          }
                          return null;
                        },
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _bankNameController,
                          label: 'Bank Name',
                          hint: 'Enter bank name',
                          isRequired: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter bank name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _branchNameController,
                          label: 'Branch Name',
                          hint: 'Enter branch name',
                          isRequired: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter branch name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 16),

            // IFSC Code and Account Type Row
            isSmallScreen
                ? Column(
                    children: [
                      _buildTextField(
                        controller: _ifscCodeController,
                        label: 'IFSC Code',
                        hint: 'ENTER IFSC CODE',
                        isRequired: true,
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter IFSC code';
                          }
                          if (value.length != 11) {
                            return 'IFSC code must be 11 characters';
                          }
                          // IFSC format: First 4 chars alphabets, 5th char is 0, last 6 chars alphanumeric
                          final ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
                          if (!ifscRegex.hasMatch(value)) {
                            return 'Invalid IFSC code format';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDropdown(
                        label: 'Account Type',
                        hint: 'Select account type',
                        value: selectedAccountType,
                        items: accountTypes,
                        isRequired: true,
                        onChanged: (value) {
                          setState(() {
                            selectedAccountType = value;
                          });
                        },
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _ifscCodeController,
                          label: 'IFSC Code',
                          hint: 'ENTER IFSC CODE',
                          isRequired: true,
                          textCapitalization: TextCapitalization.characters,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter IFSC code';
                            }
                            if (value.length != 11) {
                              return 'IFSC code must be 11 characters';
                            }
                            // IFSC format: First 4 chars alphabets, 5th char is 0, last 6 chars alphanumeric
                            final ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
                            if (!ifscRegex.hasMatch(value)) {
                              return 'Invalid IFSC code format';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDropdown(
                          label: 'Account Type',
                          hint: 'Select account type',
                          value: selectedAccountType,
                          items: accountTypes,
                          isRequired: true,
                          onChanged: (value) {
                            setState(() {
                              selectedAccountType = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 16),

            // Initial Balance
            _buildTextField(
              controller: _initialBalanceController,
              label: 'Initial Balance',
              hint: '0.00',
              isRequired: true,
              keyboardType: TextInputType.number,
              prefixText: '₹  ',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter initial balance';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Enter account description (optional)',
              maxLines: 4,
            ),
            const SizedBox(height: 24),

            // Authorized Signatories Section
            Text(
              'Authorized Signatories',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            // Signatories List
            ...List.generate(signatories.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter signatory name',
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
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    if (signatories.length > 1) ...[
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () => _removeSignatory(index),
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),

            // Add Signatory Button
            OutlineButton(
              onPressed: _addSignatory,
              icon: Icons.add,
              label: 'Add Signatory',
            ),
            const SizedBox(height: 32),

            // Action Buttons
            isSmallScreen
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PrimaryButton(
                        onPressed: _createAccount,
                        icon: Icons.check_circle_outline,
                        label: 'Create Account',
                      ),
                      const SizedBox(height: 12),
                      OutlineButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icons.close,
                        label: 'Cancel',
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlineButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icons.close,
                        label: 'Cancel',
                      ),
                      const SizedBox(width: 12),
                      PrimaryButton(
                        onPressed: _createAccount,
                        icon: Icons.check_circle_outline,
                        label: 'Create Account',
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isRequired = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? prefixText,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefixText,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 14 : 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    bool isRequired = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(
            hint,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select $label';
                  }
                  return null;
                }
              : null,
          decoration: InputDecoration(
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
