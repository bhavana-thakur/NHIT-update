import 'package:flutter/material.dart';
import 'package:ppv_components/common_widgets/button/primary_button.dart';

// Form Section Model
class FormSection {
  final String title;
  final IconData icon;
  final List<FormFieldConfig> fields;

  FormSection({
    required this.title,
    required this.icon,
    required this.fields,
  });
}

// Form Field Configuration
class FormFieldConfig {
  final String label;
  final String name;
  final FormFieldType type;
  final List<String>? options;
  final String? Function(String?)? validator;
  final bool? readOnly;
  final int? maxLines;

  FormFieldConfig({
    required this.label,
    required this.name,
    required this.type,
    this.options,
    this.validator,
    this.readOnly,
    this.maxLines,
  });
}

enum FormFieldType {
  text,
  dropdown,
  date,
  file,
}

// All Form Sections with Data
final List<FormSection> expenseFormSections = [
  FormSection(
    title: 'Basic Information',
    icon: Icons.info_outline,
    fields: [
      FormFieldConfig(
        label: 'Approval For',
        type: FormFieldType.dropdown,
        name: 'approvalFor',
        options: ['Invoice', 'Advance', 'Adhoc'],
        validator: (value) =>
        value == null || value.isEmpty ? 'Approval type required' : null,
      ),
    ],
  ),
  FormSection(
    title: 'Project Details',
    icon: Icons.folder_outlined,
    fields: [
      FormFieldConfig(
        label: 'User Department',
        type: FormFieldType.dropdown,
        name: 'userDepartment',
        options: [
          'Operations',
          'HR & Admin',
          'ITS, EHS',
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
        ],
        validator: (value) =>
        value == null || value.isEmpty ? 'Department required' : null,
      ),
      FormFieldConfig(
        label: 'Work/Purchase Order No.',
        type: FormFieldType.text,
        name: 'workPoNo',
        validator: (value) =>
        value == null || value.isEmpty ? 'PO number required' : null,
      ),
      FormFieldConfig(
        label: 'Work/Purchase Order Date',
        type: FormFieldType.date,
        name: 'workPoDate',
        validator: (value) =>
        value == null || value.isEmpty ? 'Date required' : null,
      ),
      FormFieldConfig(
        label: 'PO Member of different from Order No.',
        type: FormFieldType.text,
        name: 'poMemberDifferent',
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Expense Category',
        type: FormFieldType.dropdown,
        name: 'expenseCategory',
        options: ['Select Expense Category', 'Capital Expenditure', 'Operational Expenditure', 'Maintenance'],
        validator: (value) => null,
      ),
    ],
  ),
  FormSection(
    title: 'Financial Details',
    icon: Icons.account_balance_wallet_outlined,
    fields: [
      FormFieldConfig(
        label: 'Base Value',
        type: FormFieldType.text,
        name: 'orderBaseValue',
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Invoice Number',
        type: FormFieldType.text,
        name: 'invoiceNumber',
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Other Charges',
        type: FormFieldType.text,
        name: 'orderOtherCharges',
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Invoice Date',
        type: FormFieldType.date,
        name: 'invoiceDate',
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'GST on Above',
        type: FormFieldType.text,
        name: 'orderGST',
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Taxable Value',
        type: FormFieldType.text,
        name: 'taxableValue',
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Total Amount',
        type: FormFieldType.text,
        name: 'totalAmount',
        validator: (value) => null,
        readOnly: true,
      ),
      FormFieldConfig(
        label: 'Add: GST on above',
        type: FormFieldType.text,
        name: 'addedGST',
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Invoice Other Charges',
        type: FormFieldType.text,
        name: 'invoiceOtherCharges',
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Invoice Value',
        type: FormFieldType.text,
        name: 'invoiceValue',
        validator: (value) => null,
      ),
    ],
  ),
  FormSection(
    title: 'Supplier & Classification',
    icon: Icons.business_outlined,
    fields: [
      FormFieldConfig(
        label: 'Type of Supplier',
        type: FormFieldType.dropdown,
        name: 'supplierType',
        options: ['MSE', 'Non-MSE', 'Other'],
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Name of Supplier',
        type: FormFieldType.dropdown,
        name: 'supplierName',
        options: [
          'Select',
          'National Highways Invit Project Managers',
          'Surya Cartridge Solution',
          'Other',
        ],
        validator: (value) =>
        value == null || value.isEmpty ? 'Supplier required' : null,
      ),
      FormFieldConfig(
        label: 'MSME Classification',
        type: FormFieldType.dropdown,
        name: 'msmeClassification',
        options: ['N/A', 'MSE', 'Micro', 'Small', 'Medium'],
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Activity Type',
        type: FormFieldType.dropdown,
        name: 'activityType',
        options: ['Construction', 'Consultancy', 'Supply', 'Services', 'Other'],
        validator: (value) => null,
      ),
    ],
  ),
  FormSection(
    title: 'Contract Details',
    icon: Icons.description_outlined,
    fields: [
      FormFieldConfig(
        label: 'Contract Period Start Date',
        type: FormFieldType.date,
        name: 'contractStartDate',
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Contract Period End Date',
        type: FormFieldType.date,
        name: 'contractEndDate',
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Appointed Start Date',
        type: FormFieldType.date,
        name: 'appointedDate',
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'End Date',
        type: FormFieldType.date,
        name: 'appointedEndDate',
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Contract Period Completed',
        type: FormFieldType.dropdown,
        name: 'contractCompleted',
        options: ['Yes', 'No'],
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Period of Supply Start Date',
        type: FormFieldType.date,
        name: 'supplyStartDate',
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'End Date',
        type: FormFieldType.date,
        name: 'supplyEndDate',
        validator: (value) => null,
      ),
    ],
  ),
  FormSection(
    title: 'Additional Information',
    icon: Icons.add_circle_outline,
    fields: [
      FormFieldConfig(
        label: 'Protest Note Raised',
        type: FormFieldType.dropdown,
        name: 'protestNote',
        options: ['Select', 'Yes', 'No'],
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Choose File (No file chosen)',
        type: FormFieldType.text,
        name: 'protestNoteFile',
        validator: (value) => null,
        readOnly: true,
      ),
      FormFieldConfig(
        label: 'Brief of Goods / Services',
        type: FormFieldType.text,
        name: 'goodsBrief',
        validator: (value) => null,
        maxLines: 3,
      ),
      FormFieldConfig(
        label: 'Delayed damages',
        type: FormFieldType.text,
        name: 'delayedDamages',
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Select Nature of Expenses',
        type: FormFieldType.dropdown,
        name: 'natureOfExpenses',
        options: ['Construction', 'Consultancy', 'Legal', 'Administrative', 'Other'],
        validator: (value) => null,
      ),
    ],
  ),
  FormSection(
    title: 'Budget Information',
    icon: Icons.pie_chart_outline,
    fields: [
      FormFieldConfig(
        label: 'Budget Expenditure',
        type: FormFieldType.text,
        name: 'budgetExpenditure',
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Actual Expenditure',
        type: FormFieldType.text,
        name: 'actualExpenditure',
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Expenditure over Budget',
        type: FormFieldType.text,
        name: 'expenditureOverBudget',
        validator: (value) => null,
        readOnly: true,
      ),
    ],
  ),
  FormSection(
    title: 'Contract Extension & Compliance',
    icon: Icons.fact_check_outlined,
    fields: [
      FormFieldConfig(
        label: 'Extension of contract period executed',
        type: FormFieldType.dropdown,
        name: 'contractExtension',
        options: ['Select', 'Yes', 'No'],
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Milestone Status - Achieved?',
        type: FormFieldType.dropdown,
        name: 'milestoneAchieved',
        options: ['Yes', 'No'],
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Milestone Remarks (if any)',
        type: FormFieldType.text,
        name: 'milestoneRemarks',
        validator: (value) => null,
        maxLines: 2,
      ),
      FormFieldConfig(
        label: 'Choose File',
        type: FormFieldType.text,
        name: 'milestoneFile',
        validator: (value) => null,
        readOnly: true,
      ),
      FormFieldConfig(
        label: 'Expense Amount within contract',
        type: FormFieldType.dropdown,
        name: 'expenseWithinContract',
        options: ['Yes', 'No'],
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'If payment approved with Deviation',
        type: FormFieldType.dropdown,
        name: 'paymentWithDeviation',
        options: ['Yes', 'No'],
        validator: (value) => null,
      ),
    ],
  ),
  FormSection(
    title: 'HR Department (Optional)',
    icon: Icons.people_outline,
    fields: [
      FormFieldConfig(
        label: 'Documents Verified for Period of Workman/Supply',
        type: FormFieldType.dropdown,
        name: 'documentsVerified',
        options: ['Select', 'Yes', 'No'],
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Documents Discrepancy',
        type: FormFieldType.text,
        name: 'documentsDiscrepancy',
        validator: (value) => null,
        maxLines: 2,
      ),
      FormFieldConfig(
        label: 'Amount to be Retained for Non-Submission/Non-Compliance',
        type: FormFieldType.text,
        name: 'amountRetained',
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Remarks (If any)',
        type: FormFieldType.text,
        name: 'hrRemarks',
        validator: (value) => null,
        maxLines: 3,
      ),
      FormFieldConfig(
        label: 'Attachment (If any)',
        type: FormFieldType.text,
        name: 'hrAttachment',
        validator: (value) => null,
        readOnly: true,
      ),
      FormFieldConfig(
        label: 'Auditor Remarks (If any)',
        type: FormFieldType.text,
        name: 'auditorRemarks',
        validator: (value) => null,
        maxLines: 3,
      ),
    ],
  ),
];

// Main Page Widget
class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final Map<String, dynamic> _formValues = {};
  final Map<String, TextEditingController> _controllers = {};
  final _formKey = GlobalKey<FormState>();
  final Map<int, bool> _expandedSections = {};

  @override
  void initState() {
    super.initState();
    // Initialize all sections as expanded
    for (int i = 0; i < expenseFormSections.length; i++) {
      _expandedSections[i] = true;
    }

    // Initialize controllers for all fields
    for (var section in expenseFormSections) {
      for (var field in section.fields) {
        _controllers[field.name] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeader(context),
                const SizedBox(height: 16),

                // Form Sections
                ...expenseFormSections.asMap().entries.map((entry) {
                  final index = entry.key;
                  final section = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildFormSection(context, section, index),
                  );
                }),

                // Action Buttons
                _buildActionButtons(context),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.note_add,
              size: 24,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Green Note',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Fill in the details to create a new expense note',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(BuildContext context, FormSection section, int sectionIndex) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isExpanded = _expandedSections[sectionIndex] ?? true;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Section Header
          InkWell(
            onTap: () {
              setState(() {
                _expandedSections[sectionIndex] = !isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Icon(
                    section.icon,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      section.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ),

          // Section Content
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: section.fields.map((field) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildFormField(context, field),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFormField(BuildContext context, FormFieldConfig field) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    switch (field.type) {
      case FormFieldType.text:
        return TextFormField(
          controller: _controllers[field.name],
          decoration: InputDecoration(
            labelText: field.label,
            labelStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
            filled: true,
            fillColor: colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          readOnly: field.readOnly ?? false,
          maxLines: field.maxLines ?? 1,
          validator: field.validator,
          onChanged: (value) {
            setState(() {
              _formValues[field.name] = value;
            });
          },
        );

      case FormFieldType.dropdown:
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: field.label,
            labelStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
            filled: true,
            fillColor: colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          items: field.options?.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: theme.textTheme.bodyMedium,
              ),
            );
          }).toList(),
          validator: field.validator,
          onChanged: (value) {
            setState(() {
              _formValues[field.name] = value;
            });
          },
        );

      case FormFieldType.date:
        return TextFormField(
          controller: _controllers[field.name],
          decoration: InputDecoration(
            labelText: field.label,
            labelStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
            filled: true,
            fillColor: colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            suffixIcon: Icon(
              Icons.calendar_today,
              size: 18,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          readOnly: true,
          validator: field.validator,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              final formattedDate = '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
              setState(() {
                _formValues[field.name] = formattedDate;
                _controllers[field.name]?.text = formattedDate;
              });
            }
          },
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildActionButtons(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                // Save draft logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Draft saved successfully'),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: colorScheme.secondary,
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: colorScheme.outline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Save Draft'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Green Note submitted successfully'),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: colorScheme.primary,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Submit'),
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton(
            onPressed: () {
              // Cancel/Close logic
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              side: BorderSide(color: colorScheme.error),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Icon(Icons.close, color: colorScheme.error, size: 20),
          ),
        ],
      ),
    );
  }
}
