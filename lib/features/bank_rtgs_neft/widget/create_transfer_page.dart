import 'package:flutter/material.dart';
import 'package:ppv_components/common_widgets/button/primary_button.dart';
import 'package:ppv_components/common_widgets/button/outlined_button.dart';
import 'package:ppv_components/common_widgets/custom_dropdown.dart';
import '../models/transfer_models/transfer_enums.dart';
import '../models/transfer_models/transfer_request.dart';
import '../services/account_transfer_service.dart';

class CreateTransferPage extends StatefulWidget {
  const CreateTransferPage({super.key});

  @override
  State<CreateTransferPage> createState() => _CreateTransferPageState();
}

class _CreateTransferPageState extends State<CreateTransferPage> {
  final _formKey = GlobalKey<FormState>();
  final AccountTransferService _transferService = AccountTransferService();
  bool _isSubmitting = false;

  TransferType selectedTransferType = TransferType.internal;
  TransferMode selectedTransferMode = TransferMode.oneToOne;

  TransferMode _getModeFromString(String mode) {
    switch (mode) {
      case 'ONE_TO_ONE':
        return TransferMode.oneToOne;
      case 'ONE_TO_MANY':
        return TransferMode.oneToMany;
      case 'MANY_TO_ONE':
        return TransferMode.manyToOne;
      case 'MANY_TO_MANY':
        return TransferMode.manyToMany;
      default:
        return TransferMode.oneToOne;
    }
  }
  String? hoveredTransferType;
  String? hoveredTransferMode;

  // Form controllers
  final _transferAmountController = TextEditingController();
  final _purposeController = TextEditingController();
  final _remarksController = TextEditingController();

  // Dropdown values
  String? selectedSourceAccount;
  String? selectedDestinationAccount;
  String? selectedVendor;

  // Lists for multiple accounts/vendors
  final List<TransferSourceInput> sources = [];
  final List<TransferDestinationInput> destinations = [];
  List<Map<String, dynamic>> sourceAccounts = [];
  List<Map<String, dynamic>> destinationAccounts = [];

  // Dynamic lists for External Transfer vendors
  List<Map<String, dynamic>> vendorRows = [];

  // Mock account data - replace with actual data
  final List<String> availableAccounts = [
    'Main Account - ACC001',
    'Savings Account - ACC002',
    'Business Account - ACC003',
    'Project Account - ACC004',
  ];

  final List<String> availableVendors = [
    'Vendor A - VEN001',
    'Vendor B - VEN002',
    'Vendor C - VEN003',
  ];

  void _addSourceAccount() {
    if (selectedSourceAccount == null || _transferAmountController.text.isEmpty) return;

    final amount = double.tryParse(_transferAmountController.text);
    if (amount == null || amount <= 0) return;

    setState(() {
      sources.add(TransferSourceInput(
        sourceAccountId: selectedSourceAccount!,
        amount: amount,
      ));
      selectedSourceAccount = null;
      _transferAmountController.clear();
    });
  }

  void _removeSourceAccount(int index) {
    setState(() {
      sourceAccounts[index]['amount'].dispose();
      sourceAccounts.removeAt(index);
    });
  }

  void _addDestinationAccount() {
    if (_transferAmountController.text.isEmpty) return;

    final amount = double.tryParse(_transferAmountController.text);
    if (amount == null || amount <= 0) return;

    setState(() {
      if (selectedTransferType == TransferType.internal && selectedDestinationAccount != null) {
        destinations.add(TransferDestinationInput(
          destinationAccountId: selectedDestinationAccount,
          amount: amount,
        ));
        selectedDestinationAccount = null;
      } else if (selectedTransferType == TransferType.external && selectedVendor != null) {
        destinations.add(TransferDestinationInput(
          destinationVendorId: selectedVendor,
          amount: amount,
        ));
        selectedVendor = null;
      }
      _transferAmountController.clear();
    });
  }

  void _removeDestinationAccount(int index) {
    setState(() {
      destinationAccounts[index]['amount'].dispose();
      destinationAccounts.removeAt(index);
    });
  }

  void _addVendorRow() {
    setState(() {
      vendorRows.add({
        'vendor': null,
        'amount': TextEditingController(text: '0.00'),
      });
    });
  }

  void _removeVendorRow(int index) {
    setState(() {
      vendorRows[index]['amount'].dispose();
      vendorRows.removeAt(index);
    });
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

  @override
  void dispose() {
    _transferAmountController.dispose();
    _purposeController.dispose();
    _remarksController.dispose();
    // Dispose dynamic controllers
    for (var account in sourceAccounts) {
      account['amount']?.dispose();
    }
    for (var account in destinationAccounts) {
      account['amount']?.dispose();
    }
    for (var vendor in vendorRows) {
      vendor['amount']?.dispose();
    }
    super.dispose();
  }

  final List<Map<String, dynamic>> transferTypes = [
    {
      'type': 'Internal Transfer',
      'icon': Icons.swap_horiz,
      'color': Colors.cyan,
      'description': 'Transfer between your escrow accounts',
    },
    {
      'type': 'External Transfer',
      'icon': Icons.send,
      'color': Colors.green,
      'description': 'Transfer to vendor accounts',
    },
  ];

  final List<Map<String, dynamic>> transferModes = [
    {
      'mode': 'One to One',
      'icon': Icons.arrow_forward,
      'color': Colors.blue,
      'description': 'Single account to single account',
    },
    {
      'mode': 'One to Many',
      'icon': Icons.account_tree,
      'color': Colors.orange,
      'description': 'Single account to multiple accounts',
    },
    {
      'mode': 'Many to Many',
      'icon': Icons.hub,
      'color': Colors.purple,
      'description': 'Multiple accounts to multiple accounts',
    },
  ];

  void _onTransferTypeChanged(String? value) {
    if (value == null) return;

    final type = value == 'INTERNAL' ? TransferType.internal : TransferType.external;

    setState(() {
      selectedTransferType = type;
      // Clear destinations when type changes
      destinations.clear();
      selectedDestinationAccount = null;
      selectedVendor = null;
    });
  }

  void _onTransferModeChanged(String? value) {
    if (value == null) return;

    final mode = _getModeFromString(value);

    setState(() {
      selectedTransferMode = mode;
      // Clear lists when mode changes
      sources.clear();
      destinations.clear();
      selectedSourceAccount = null;
      selectedDestinationAccount = null;
      selectedVendor = null;
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate() || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final request = CreateAccountTransferRequest(
        transferType: selectedTransferType ?? TransferType.internal,
        transferMode: selectedTransferMode ?? TransferMode.oneToOne,
        purpose: _purposeController.text,
        remarks: _remarksController.text,
        requestedById: '123e4567-e89b-12d3-a456-426614174000', // TODO: Get from auth
        sources: sources,
        destinations: destinations,
      );

      final transfer = await _transferService.createTransfer(request);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transfer created successfully: ${transfer.transferReference}'),
          backgroundColor: Colors.green,
        ),
      );

      // TODO: Navigate to transfer details or list
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
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
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.swap_horiz,
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
                      'Create Transfer',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Transfer funds between accounts or to vendors',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
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
                  label: 'Back to Transfers',
                ),
              ],
            ],
          ),
          if (isSmallScreen) ...[
            const SizedBox(height: 16),
            OutlineButton(
              onPressed: () => Navigator.pop(context),
              icon: Icons.arrow_back,
              label: 'Back to Transfers',
            ),
          ],
        ],
      ),
    );
  }

  // Stepper field widget for decimal amounts (matching payment screen style)
  Widget _buildAmountStepperField({
    required TextEditingController controller,
    String? label,
    Color? accentColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveAccentColor = accentColor ?? colorScheme.primary;

    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label ?? 'Amount (₹)',
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
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
                  color: effectiveAccentColor,
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
                  color: effectiveAccentColor,
                ),
                onPressed: () => _decrementAmount(controller, step: 0.01),
                tooltip: 'Decrease',
              ),
            ),
          ],
        ),
      ),
      onChanged: (value) {
        setState(() {
          // Add your logic here
        });
      },
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
                  'Transfer Details',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Transfer Type Label
            Row(
              children: [
                Text(
                  'Transfer Type',
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

            // Transfer Type Cards - Responsive layout
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = 340.0;
                final spacing = 16.0;
                final availableWidth = constraints.maxWidth;
                final cardsPerRow = (availableWidth / (cardWidth + spacing)).floor();

                if (cardsPerRow >= 2) {
                  return Wrap(
                    spacing: spacing,
                    runSpacing: 16,
                    children: transferTypes.map((type) {
                      return SizedBox(
                        width: cardWidth,
                        child: _buildTransferTypeCard(
                          context,
                          type: type['type'],
                          icon: type['icon'],
                          color: type['color'],
                          description: type['description'],
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: transferTypes.map((type) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildTransferTypeCard(
                          context,
                          type: type['type'],
                          icon: type['icon'],
                          color: type['color'],
                          description: type['description'],
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),

            // Transfer Mode Section
            if (selectedTransferType != null) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    'Transfer Mode',
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

              // Transfer Mode Cards
              LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth = 340.0;
                  final spacing = 16.0;
                  final availableWidth = constraints.maxWidth;
                  final cardsPerRow = (availableWidth / (cardWidth + spacing)).floor();

                  if (cardsPerRow >= 3) {
                    return Wrap(
                      spacing: spacing,
                      runSpacing: 16,
                      children: transferModes.map((mode) {
                        return SizedBox(
                          width: cardWidth,
                          child: _buildTransferModeCard(
                            context,
                            mode: mode['mode'],
                            icon: mode['icon'],
                            color: mode['color'],
                            description: mode['description'],
                          ),
                        );
                      }).toList(),
                    );
                  } else if (cardsPerRow == 2) {
                    return Wrap(
                      spacing: spacing,
                      runSpacing: 16,
                      children: transferModes.map((mode) {
                        return SizedBox(
                          width: cardWidth,
                          child: _buildTransferModeCard(
                            context,
                            mode: mode['mode'],
                            icon: mode['icon'],
                            color: mode['color'],
                            description: mode['description'],
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: transferModes.map((mode) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildTransferModeCard(
                            context,
                            mode: mode['mode'],
                            icon: mode['icon'],
                            color: mode['color'],
                            description: mode['description'],
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],

            // Dynamic Form Fields
            if (selectedTransferMode != null) ...[
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
                PrimaryButton(
                  onPressed: _handleSubmit,
                  icon: Icons.check_circle_outline,
                  label: 'Create Transfer',
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
                PrimaryButton(
                  onPressed: _handleSubmit,
                  icon: Icons.check_circle_outline,
                  label: 'Create Transfer',
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
        // One to One Mode - Internal Transfer
        if (selectedTransferMode == TransferMode.oneToOne && selectedTransferType == TransferType.internal) ...[
          _buildDropdownField(
            label: 'Source Account',
            value: selectedSourceAccount,
            items: availableAccounts,
            isRequired: true,
            onChanged: (value) {
              setState(() {
                selectedSourceAccount = value;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'Destination Account',
            value: selectedDestinationAccount,
            items: availableAccounts,
            isRequired: true,
            onChanged: (value) {
              setState(() {
                selectedDestinationAccount = value;
              });
            },
          ),
        ],

        // One to Many Mode - Internal Transfer
        if (selectedTransferMode == TransferMode.oneToMany && selectedTransferType == TransferType.internal) ...[
          _buildDropdownField(
            label: 'Source Account',
            value: selectedSourceAccount,
            items: availableAccounts,
            isRequired: true,
            onChanged: (value) {
              setState(() {
                selectedSourceAccount = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Destination Accounts',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          if (destinationAccounts.isNotEmpty)
            ...List.generate(destinationAccounts.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Destination Account',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          CustomDropdown(
                            value: destinationAccounts[index]['account'],
                            items: availableAccounts,
                            hint: 'Select account',
                            onChanged: (value) {
                              setState(() {
                                destinationAccounts[index]['account'] = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Amount',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          _buildAmountStepperField(
                            controller: destinationAccounts[index]['amount'],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      children: [
                        if (index == 0) const SizedBox(height: 32),
                        IconButton(
                          onPressed: () => _removeDestinationAccount(index),
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.red,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 8),
          OutlineButton(
            onPressed: _addDestinationAccount,
            icon: Icons.add,
            label: 'Add Destination Account',
          ),
        ],

        // Many to Many Mode - Internal Transfer
        if (selectedTransferMode == TransferMode.manyToMany && selectedTransferType == TransferType.internal) ...[
          Row(
            children: [
              Text(
                'Source Accounts',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          if (sourceAccounts.isNotEmpty)
            ...List.generate(sourceAccounts.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Source Account',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          CustomDropdown(
                            value: sourceAccounts[index]['account'],
                            items: availableAccounts,
                            hint: 'Select account',
                            onChanged: (value) {
                              setState(() {
                                sourceAccounts[index]['account'] = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Amount',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          _buildAmountStepperField(
                            controller: sourceAccounts[index]['amount'],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      children: [
                        if (index == 0) const SizedBox(height: 32),
                        IconButton(
                          onPressed: () => _removeSourceAccount(index),
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.red,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 8),
          OutlineButton(
            onPressed: _addSourceAccount,
            icon: Icons.add,
            label: 'Add Source Account',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Destination Accounts',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          if (destinationAccounts.isNotEmpty)
            ...List.generate(destinationAccounts.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Destination Account',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          CustomDropdown(
                            value: destinationAccounts[index]['account'],
                            items: availableAccounts,
                            hint: 'Select account',
                            onChanged: (value) {
                              setState(() {
                                destinationAccounts[index]['account'] = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Amount',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          _buildAmountStepperField(
                            controller: destinationAccounts[index]['amount'],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      children: [
                        if (index == 0) const SizedBox(height: 32),
                        IconButton(
                          onPressed: () => _removeDestinationAccount(index),
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.red,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 8),
          OutlineButton(
            onPressed: _addDestinationAccount,
            icon: Icons.add,
            label: 'Add Destination Account',
          ),
        ],

        // One to One Mode - External Transfer
        if (selectedTransferMode == TransferMode.oneToOne && selectedTransferType == TransferType.external) ...[
          _buildDropdownField(
            label: 'Source Account',
            value: selectedSourceAccount,
            items: availableAccounts,
            isRequired: true,
            onChanged: (value) {
              setState(() {
                selectedSourceAccount = value;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'Vendor',
            value: selectedVendor,
            items: availableVendors,
            isRequired: true,
            onChanged: (value) {
              setState(() {
                selectedVendor = value;
              });
            },
          ),
        ],

        // One to Many Mode - External Transfer
        if (selectedTransferMode == TransferMode.oneToMany && selectedTransferType == TransferType.external) ...[
          _buildDropdownField(
            label: 'Source Account',
            value: selectedSourceAccount,
            items: availableAccounts,
            isRequired: true,
            onChanged: (value) {
              setState(() {
                selectedSourceAccount = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Vendors',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          if (vendorRows.isNotEmpty)
            ...List.generate(vendorRows.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Vendor',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          CustomDropdown(
                            value: vendorRows[index]['vendor'],
                            items: availableVendors,
                            hint: 'Select vendor',
                            onChanged: (value) {
                              setState(() {
                                vendorRows[index]['vendor'] = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Amount',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          _buildAmountStepperField(
                            controller: vendorRows[index]['amount'],
                            accentColor: Colors.green,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      children: [
                        if (index == 0) const SizedBox(height: 32),
                        IconButton(
                          onPressed: () => _removeVendorRow(index),
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.red,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 8),
          OutlineButton(
            onPressed: _addVendorRow,
            icon: Icons.add,
            label: 'Add Vendor',
          ),
        ],

        // Many to Many Mode - External Transfer
        if (selectedTransferMode == TransferMode.manyToMany && selectedTransferType == TransferType.external) ...[
          Row(
            children: [
              Text(
                'Source Accounts',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          if (sourceAccounts.isNotEmpty)
            ...List.generate(sourceAccounts.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Source Account',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          CustomDropdown(
                            value: sourceAccounts[index]['account'],
                            items: availableAccounts,
                            hint: 'Select account',
                            onChanged: (value) {
                              setState(() {
                                sourceAccounts[index]['account'] = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Amount',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          _buildAmountStepperField(
                            controller: sourceAccounts[index]['amount'],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      children: [
                        if (index == 0) const SizedBox(height: 32),
                        IconButton(
                          onPressed: () => _removeSourceAccount(index),
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.red,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 8),
          OutlineButton(
            onPressed: _addSourceAccount,
            icon: Icons.add,
            label: 'Add Source Account',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Vendors',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          if (vendorRows.isNotEmpty)
            ...List.generate(vendorRows.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Vendor',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          CustomDropdown(
                            value: vendorRows[index]['vendor'],
                            items: availableVendors,
                            hint: 'Select vendor',
                            onChanged: (value) {
                              setState(() {
                                vendorRows[index]['vendor'] = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Amount',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          _buildAmountStepperField(
                            controller: vendorRows[index]['amount'],
                            accentColor: Colors.green,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      children: [
                        if (index == 0) const SizedBox(height: 32),
                        IconButton(
                          onPressed: () => _removeVendorRow(index),
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.red,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 8),
          OutlineButton(
            onPressed: _addVendorRow,
            icon: Icons.add,
            label: 'Add Vendor',
          ),
        ],

        // Common fields for all modes
        const SizedBox(height: 16),
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

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isRequired = false,
    int maxLines = 1,
    String? prefixText,
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
          keyboardType: prefixText != null ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefixText,
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

  Widget _buildTransferTypeCard(
      BuildContext context, {
        required String type,
        required IconData icon,
        required Color color,
        required String description,
      }) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final transferType = type == 'Internal Transfer' ? TransferType.internal : TransferType.external;
    final isSelected = selectedTransferType == transferType;
    final isHovered = hoveredTransferType == type;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hoveredTransferType = type;
        });
      },
      onExit: (_) {
        setState(() {
          hoveredTransferType = null;
        });
      },
      child: InkWell(
        onTap: () {
          setState(() {
            selectedTransferType = transferType;
            selectedTransferMode = TransferMode.oneToOne;
            // Clear all dynamic lists
            sourceAccounts.clear();
            destinationAccounts.clear();
            vendorRows.clear();
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 208,
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
                  color: color.withOpacity(0.1),
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
                  color: colorScheme.onSurface.withOpacity(0.7),
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

  Widget _buildTransferModeCard(
      BuildContext context, {
        required String mode,
        required IconData icon,
        required Color color,
        required String description,
      }) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final modeValue = mode.replaceAll(' to ', '_TO_').toUpperCase();
    final transferMode = _getModeFromString(modeValue);
    final isSelected = selectedTransferMode == transferMode;
    final isHovered = hoveredTransferMode == mode;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hoveredTransferMode = mode;
        });
      },
      onExit: (_) {
        setState(() {
          hoveredTransferMode = null;
        });
      },
      child: InkWell(
        onTap: () {
          setState(() {
            selectedTransferMode = transferMode;
            sourceAccounts.clear();
            destinationAccounts.clear();
            vendorRows.clear();
            selectedSourceAccount = null;
            selectedDestinationAccount = null;
            selectedVendor = null;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 182,
          padding: const EdgeInsets.all(16),
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: color,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                mode,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 11,
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
}
