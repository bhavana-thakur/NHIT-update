import 'package:flutter/material.dart';
import 'package:ppv_components/common_widgets/button/primary_button.dart';
import 'package:ppv_components/common_widgets/button/outlined_button.dart';
import 'package:ppv_components/common_widgets/custom_dropdown.dart';

class CreateTransferPage extends StatefulWidget {
  const CreateTransferPage({super.key});

  @override
  State<CreateTransferPage> createState() => _CreateTransferPageState();
}

class _CreateTransferPageState extends State<CreateTransferPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedTransferType;
  String? selectedTransferMode;
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
  
  // Dynamic lists for multiple accounts
  List<Map<String, dynamic>> sourceAccounts = [];
  List<Map<String, dynamic>> destinationAccounts = [];

  @override
  void dispose() {
    _transferAmountController.dispose();
    _purposeController.dispose();
    _remarksController.dispose();
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

            // Transfer Type Cards
            isSmallScreen
                ? Column(
                    children: transferTypes.map((type) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildTransferTypeCard(
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
                    children: transferTypes.map((type) {
                      return Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _buildTransferTypeCard(
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

            // Transfer Mode Section (only show if transfer type is selected)
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
              isSmallScreen
                  ? Column(
                      children: transferModes.map((mode) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildTransferModeCard(
                            context,
                            mode: mode['mode'],
                            icon: mode['icon'],
                            color: mode['color'],
                            description: mode['description'],
                          ),
                        );
                      }).toList(),
                    )
                  : Row(
                      children: transferModes.map((mode) {
                        return Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: _buildTransferModeCard(
                              context,
                              mode: mode['mode'],
                              icon: mode['icon'],
                              color: mode['color'],
                              description: mode['description'],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ],

            // Dynamic Form Fields based on selected transfer mode
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
                        onPressed: () => Navigator.pop(context),
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
      ),
    );
  }

  Widget _buildDynamicFormFields(BuildContext context, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // One to One Mode - Internal Transfer
        if (selectedTransferMode == 'One to One' && selectedTransferType == 'Internal Transfer') ...[
          _buildDropdownField(
            label: 'Source Account',
            value: selectedSourceAccount,
            items: ['Select source account'],
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
            items: ['Select destination account'],
            isRequired: true,
            onChanged: (value) {
              setState(() {
                selectedDestinationAccount = value;
              });
            },
          ),
        ],
        
        // One to Many Mode - Internal Transfer
        if (selectedTransferMode == 'One to Many' && selectedTransferType == 'Internal Transfer') ...[
          _buildDropdownField(
            label: 'Select source account',
            value: selectedSourceAccount,
            items: ['Select source account'],
            isRequired: false,
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
          // Destination accounts list
          ...List.generate(2, (index) {
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
                          value: null,
                          items: ['Select account'],
                          hint: 'Select account',
                          onChanged: (value) {},
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
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: '0.00',
                            prefixText: '₹  ',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      if (index == 0) const SizedBox(height: 32),
                      IconButton(
                        onPressed: () {},
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
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          OutlineButton(
            onPressed: () {
              // Add destination account logic
            },
            icon: Icons.add,
            label: 'Add Destination Account',
          ),
        ],
        
        // Many to Many Mode - Internal Transfer
        if (selectedTransferMode == 'Many to Many' && selectedTransferType == 'Internal Transfer') ...[
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
          // Source accounts list
          ...List.generate(1, (index) {
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
                          value: null,
                          items: ['Select account'],
                          hint: 'Select account',
                          onChanged: (value) {},
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
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: '0.00',
                            prefixText: '₹  ',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      if (index == 0) const SizedBox(height: 32),
                      const SizedBox(width: 48),
                    ],
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          OutlineButton(
            onPressed: () {
              // Add source account logic
            },
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
          // Destination accounts list
          ...List.generate(2, (index) {
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
                          value: null,
                          items: ['Select account'],
                          hint: 'Select account',
                          onChanged: (value) {},
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
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: '0.00',
                            prefixText: '₹  ',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      if (index == 0) const SizedBox(height: 32),
                      IconButton(
                        onPressed: () {},
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
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          OutlineButton(
            onPressed: () {
              // Add destination account logic
            },
            icon: Icons.add,
            label: 'Add Destination Account',
          ),
        ],
        
        // One to One Mode - External Transfer
        if (selectedTransferMode == 'One to One' && selectedTransferType == 'External Transfer') ...[
          _buildDropdownField(
            label: 'Source Account',
            value: selectedSourceAccount,
            items: ['Select source account'],
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
            items: ['Select vendor'],
            isRequired: true,
            onChanged: (value) {
              setState(() {
                selectedVendor = value;
              });
            },
          ),
        ],
        
        // One to Many Mode - External Transfer
        if (selectedTransferMode == 'One to Many' && selectedTransferType == 'External Transfer') ...[
          _buildDropdownField(
            label: 'Source Account',
            value: selectedSourceAccount,
            items: ['Select source account'],
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
                'Vendor',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          OutlineButton(
            onPressed: () {
              // Add vendor logic
            },
            icon: Icons.add,
            label: 'Add Vendor',
          ),
        ],
        
        // Many to Many Mode - External Transfer
        if (selectedTransferMode == 'Many to Many' && selectedTransferType == 'External Transfer') ...[
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
          const SizedBox(height: 8),
          OutlineButton(
            onPressed: () {
              // Add source account logic
            },
            icon: Icons.add,
            label: 'Add Source Account',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Vendor',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          OutlineButton(
            onPressed: () {
              // Add vendor logic
            },
            icon: Icons.add,
            label: 'Add Vendor',
          ),
        ],
        
        // Common fields for all modes
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Transfer Amount',
          hint: '0.00',
          controller: _transferAmountController,
          isRequired: true,
          prefixText: '₹  ',
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
    final isSelected = selectedTransferType == type;
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
            selectedTransferType = type;
            // Reset transfer mode when changing transfer type
            selectedTransferMode = null;
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

  Widget _buildTransferModeCard(
    BuildContext context, {
    required String mode,
    required IconData icon,
    required Color color,
    required String description,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isSelected = selectedTransferMode == mode;
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
            selectedTransferMode = mode;
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
                  color: color.withValues(alpha: 0.1),
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
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
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

  void _createTransfer() {
    if (selectedTransferType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a transfer type'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedTransferMode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a transfer mode'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Creating $selectedTransferType - $selectedTransferMode...'),
          backgroundColor: Colors.green,
        ),
      );
      // Add your transfer creation logic here
    }
  }
}
