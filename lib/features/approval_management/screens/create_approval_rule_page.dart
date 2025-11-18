import 'package:flutter/material.dart';
import 'package:ppv_components/common_widgets/button/primary_button.dart';
import 'package:ppv_components/common_widgets/button/secondary_button.dart';
import 'package:ppv_components/common_widgets/button/outlined_button.dart';

class CreateApprovalRulePage extends StatefulWidget {
  final String ruleType; // 'green_note', 'payment_note', 'reimbursement_note', 'bank_letter'

  const CreateApprovalRulePage({
    super.key,
    required this.ruleType,
  });

  @override
  State<CreateApprovalRulePage> createState() => _CreateApprovalRulePageState();
}

class _CreateApprovalRulePageState extends State<CreateApprovalRulePage> {
  final _formKey = GlobalKey<FormState>();
  final _ruleNameController = TextEditingController();
  final _minAmountController = TextEditingController();
  final _maxAmountController = TextEditingController();
  final _testAmountController = TextEditingController();

  String? selectedDepartment;
  String? selectedProject;
  String? selectedTemplate;
  List<ApproverItem> approvers = [];

  // Department list
  final List<String> departments = [
    'Operations',
    'HR & Admin',
    'ITS',
    'EHS',
    'Finance & Accounts',
    'Secretarial',
    'Procurement',
    'I & A',
    'HR & Admin (Corporate)',
    'IT',
    'Concurrent/Internal Audit / Corp Communication',
    'HR & Admin (Admin HO)',
    'Traffic & Revenue',
    'Legal and Profession',
    'Civil & Maintenance',
  ];

  // Approver list
  final List<Map<String, String>> approversList = [
    {'name': 'Admin User', 'email': 'admin@test.com'},
    {'name': 'Admin', 'email': 'admin@agetnada.com'},
    {'name': 'Kushal Vats', 'email': 'kvats69@gmail.com'},
    {'name': 'Deepak Kumar', 'email': 'deepakkumar@nhit.co.in'},
    {'name': 'Mahesh Yadav', 'email': 'maheshyadav@nhit.co.in'},
    {'name': 'Jatindra Nath Khadanga', 'email': 'jatindrakhadanga@nhit.co.in'},
    {'name': 'Priyabrata Ghosh', 'email': 'priyabrataghosh@nhit.co.in'},
    {'name': 'Naveen Kumar', 'email': 'naveenkumar@nhit.co.in'},
    {'name': 'Pawan Kumar (Consultant)', 'email': 'pawankumar@nhit.co.in'},
    {'name': 'Concurrent Auditor', 'email': 'paymentaudit@nhit.co.in'},
    {'name': 'Mathew George', 'email': 'cfo.nhim@nhit.co.in'},
    {'name': 'Rakshit Jain', 'email': 'md.nhim@nhit.co.in'},
    {'name': 'Shailendrasinh Rajput', 'email': 'shailendrasinh@nhit.co.in'},
  ];

  // Template options
  final List<Map<String, String>> templates = [
    {
      'name': 'Basic Approval – Single level approval for small amounts',
      'value': 'basic',
    },
    {
      'name': 'Standard Approval – Two level approval for medium amounts',
      'value': 'standard',
    },
    {
      'name': 'Complex Approval – Multi-level approval for large amounts',
      'value': 'complex',
    },
    {
      'name': 'Basic Expense Approval – Department head approval for small expenses',
      'value': 'basic_expense',
    },
    {
      'name': 'Standard Expense Approval – Department head + Finance approval',
      'value': 'standard_expense',
    },
  ];

  @override
  void dispose() {
    _ruleNameController.dispose();
    _minAmountController.dispose();
    _maxAmountController.dispose();
    _testAmountController.dispose();
    super.dispose();
  }

  String get ruleTypeTitle {
    switch (widget.ruleType) {
      case 'green_note':
        return 'Green Note (Expense)';
      case 'payment_note':
        return 'Payment Note';
      case 'reimbursement_note':
        return 'Reimbursement Note';
      case 'bank_letter':
        return 'Bank Letter';
      default:
        return 'Approval Rule';
    }
  }

  void _addApprover() {
    setState(() {
      approvers.add(ApproverItem(
        approver: null,
        level: approvers.length + 1,
        amount: 0.0,
      ));
    });
  }

  void _removeApprover(int index) {
    setState(() {
      approvers.removeAt(index);
      // Reorder levels
      for (int i = 0; i < approvers.length; i++) {
        approvers[i] = approvers[i].copyWith(level: i + 1);
      }
    });
  }

  void _incrementAmount(TextEditingController controller, {double step = 0.25}) {
    final currentValue = double.tryParse(controller.text) ?? 0.0;
    final newValue = currentValue + step;
    controller.text = newValue.toStringAsFixed(2);
    setState(() {});
  }

  void _decrementAmount(TextEditingController controller, {double step = 0.25}) {
    final currentValue = double.tryParse(controller.text) ?? 0.0;
    final newValue = (currentValue - step).clamp(0.0, double.infinity);
    controller.text = newValue.toStringAsFixed(2);
    setState(() {});
  }

  void _testRule() {
    if (_testAmountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount to test')),
      );
      return;
    }
    // Test logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Testing approval rule...')),
    );
  }

  void _preview() {
    // Preview logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preview approval rule...')),
    );
  }

  void _createRule() {
    if (_formKey.currentState?.validate() ?? false) {
      // Create rule logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Approval rule created successfully!')),
      );
      Navigator.pop(context);
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
                  // Header Section (Create Escrow Page Style)
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
                  color: colorScheme.primary.withOpacity(0.1),
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
                      'Create Approval Rule',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Create new approval rule for $ruleTypeTitle',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
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
            label: 'Back to Rules',
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
                  'Create Approval Rule',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Create new approval rule for $ruleTypeTitle',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          OutlineButton(
            onPressed: () => Navigator.pop(context),
            icon: Icons.arrow_back,
            label: 'Back to Rules',
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(BuildContext context, BoxConstraints constraints) {
    final colorScheme = Theme.of(context).colorScheme;
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
            // Quick Start Templates Section
            _buildQuickStartSection(context),
            const SizedBox(height: 24),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column - Rule Configuration
                Expanded(
                  flex: 2,
                  child: _buildRuleConfiguration(context),
                ),
                const SizedBox(width: 24),

                // Right Column - Approval Workflow
                Expanded(
                  flex: 3,
                  child: _buildApprovalWorkflow(context),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Bottom Action Buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStartSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.flash_on,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Quick Start Templates',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'for $ruleTypeTitle',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Choose a template to get started quickly, then customize as needed.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedTemplate,
                  decoration: InputDecoration(
                    labelText: 'Select a template...',
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                  ),
                  items: templates
                      .map((template) => DropdownMenuItem(
                    value: template['value'],
                    child: Text(
                      template['name']!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTemplate = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              SecondaryButton(
                label: 'Help',
                icon: Icons.help_outline,
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              SecondaryButton(
                label: 'Test Rule',
                icon: Icons.play_arrow,
                onPressed: _testRule,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Custom Stepper Field with VERTICAL arrows (matching Image 1)
  Widget _buildStepperField({
    required TextEditingController controller,
    required String label,
    String? hintText,
    String? helperText,
    bool isRequired = false,
    double step = 0.25,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outline),
          ),
          child: Row(
            children: [
              // Text Input Field
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: hintText ?? '0.00',
                    prefixText: '₹ ',
                    helperText: helperText,
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: isRequired
                      ? (value) {
                    if (value == null || value.isEmpty) {
                      return '$label is required';
                    }
                    return null;
                  }
                      : null,
                  onChanged: (_) => setState(() {}),
                ),
              ),

              // Vertical Stepper Arrows Container (MATCHING IMAGE 1)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: colorScheme.outline, width: 1),
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(11),
                    bottomRight: Radius.circular(11),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Up Arrow (Increment)
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _incrementAmount(controller, step: step),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(11),
                        ),
                        child: Container(
                          width: 36,
                          height: 24,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            size: 18,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                    // Horizontal Divider
                    Container(
                      width: 36,
                      height: 1,
                      color: colorScheme.outline,
                    ),
                    // Down Arrow (Decrement)
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _decrementAmount(controller, step: step),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(11),
                        ),
                        child: Container(
                          width: 36,
                          height: 24,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            size: 18,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRuleConfiguration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.settings,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Rule Configuration',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Rule Name
          Text(
            'Rule Name',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _ruleNameController,
            decoration: InputDecoration(
              hintText: 'e.g., Standard Payment Approval',
              hintStyle: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              helperText: 'Optional: Give your rule a descriptive name',
              filled: true,
              fillColor: colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Department
          Text(
            'Department *',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedDepartment,
            decoration: InputDecoration(
              hintText: 'Select Department',
              helperText: 'Required: Rules must be scoped to a department',
              helperStyle: TextStyle(color: colorScheme.error),
              filled: true,
              fillColor: colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
            ),
            items: departments
                .map((dept) => DropdownMenuItem(
              value: dept,
              child: Text(dept),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedDepartment = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Department is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Project
          Text(
            'Project *',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedProject,
            decoration: InputDecoration(
              hintText: 'Select Project',
              helperText: 'Required: Rules must be scoped to a project',
              helperStyle: TextStyle(color: colorScheme.error),
              filled: true,
              fillColor: colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
            ),
            items: ['Project Alpha', 'Project Beta', 'Project Gamma']
                .map((project) => DropdownMenuItem(
              value: project,
              child: Text(project),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedProject = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Project is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Minimum Amount - Vertical Stepper Field
          _buildStepperField(
            controller: _minAmountController,
            label: 'Minimum Amount *',
            hintText: '0.00',
            helperText: 'Minimum ${widget.ruleType.replaceAll('_', ' ')} amount for this rule',
            isRequired: true,
            step: 0.25,
          ),
          const SizedBox(height: 24),

          // Maximum Amount - Vertical Stepper Field
          _buildStepperField(
            controller: _maxAmountController,
            label: 'Maximum Amount',
            hintText: 'Leave empty for no limit',
            helperText: 'Leave empty for "above minimum amount"',
            isRequired: false,
            step: 0.25,
          ),
          const SizedBox(height: 24),

          // Test This Rule - Vertical Stepper Field
          Text(
            'Test This Rule',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.outline),
                  ),
                  child: Row(
                    children: [
                      // Text Input Field
                      Expanded(
                        child: TextFormField(
                          controller: _testAmountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            hintText: 'Enter amount to test',
                            prefixText: '₹ ',
                            filled: false,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),

                      // Vertical Stepper Arrows Container
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: colorScheme.outline, width: 1),
                          ),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(11),
                            bottomRight: Radius.circular(11),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Up Arrow (Increment)
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _incrementAmount(_testAmountController, step: 0.25),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(11),
                                ),
                                child: Container(
                                  width: 36,
                                  height: 24,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.keyboard_arrow_up,
                                    size: 18,
                                    color: colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ),
                            // Horizontal Divider
                            Container(
                              width: 36,
                              height: 1,
                              color: colorScheme.outline,
                            ),
                            // Down Arrow (Decrement)
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _decrementAmount(_testAmountController, step: 0.25),
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(11),
                                ),
                                child: Container(
                                  width: 36,
                                  height: 24,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 18,
                                    color: colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SecondaryButton(
                label: 'Test',
                onPressed: _testRule,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalWorkflow(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Approval Workflow',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
              PrimaryButton(
                label: 'Add Approver',
                icon: Icons.add,
                backgroundColor: Colors.green,
                onPressed: _addApprover,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Approvers List
          if (approvers.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.person_add_outlined,
                      size: 48,
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No approvers added yet',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Click "Add Approver" to start building your approval workflow',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ...approvers.asMap().entries.map((entry) {
              final index = entry.key;
              final approver = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildApproverCard(context, approver, index),
              );
            }),

          const SizedBox(height: 24),

          // Approval Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Approval Summary',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add approvers to see the approval flow summary',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApproverCard(BuildContext context, ApproverItem approver, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Level ${approver.level}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.close, size: 18, color: colorScheme.error),
                onPressed: () => _removeApprover(index),
                tooltip: 'Remove Approver',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Approver',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: approvers[index].approver,
                      isExpanded: true,
                      decoration: InputDecoration(
                        hintText: 'Select Approver',
                        filled: true,
                        fillColor: colorScheme.surfaceContainer,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                      ),
                      selectedItemBuilder: (BuildContext context) {
                        return approversList.map<Widget>((approver) {
                          return Text(
                            '${approver['name']} (${approver['email']})',
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                            ),
                          );
                        }).toList();
                      },
                      items: approversList
                          .map((approver) => DropdownMenuItem(
                        value: approver['email'],
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                approver['name']!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                approver['email']!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                                  fontSize: 11,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          approvers[index] = approvers[index].copyWith(approver: value);
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '0.00',
                        prefixText: '₹ ',
                        filled: true,
                        fillColor: colorScheme.surfaceContainer,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlineButton(
            label: 'Cancel',
            icon: Icons.close,
            onPressed: () => Navigator.pop(context),
          ),
          Row(
            children: [
              SecondaryButton(
                label: 'Preview',
                icon: Icons.visibility,
                onPressed: _preview,
              ),
              const SizedBox(width: 12),
              PrimaryButton(
                label: 'Create Approval Rule',
                icon: Icons.check,
                onPressed: _createRule,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ApproverItem {
  final String? approver;
  final int level;
  final double amount;

  ApproverItem({
    required this.approver,
    required this.level,
    required this.amount,
  });

  ApproverItem copyWith({
    String? approver,
    int? level,
    double? amount,
  }) {
    return ApproverItem(
      approver: approver ?? this.approver,
      level: level ?? this.level,
      amount: amount ?? this.amount,
    );
  }
}
