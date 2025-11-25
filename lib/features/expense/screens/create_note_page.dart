import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ppv_components/common_widgets/button/primary_button.dart';
import 'package:ppv_components/common_widgets/button/secondary_button.dart';

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

class _InvoiceEntry {
  final TextEditingController invoiceNumberController = TextEditingController();
  final TextEditingController invoiceDateController = TextEditingController();
  final TextEditingController baseValueController = TextEditingController();
  final TextEditingController gstController = TextEditingController();
  final TextEditingController otherChargesController = TextEditingController();
  final TextEditingController totalValueController = TextEditingController(text: '0.00');
  final TextEditingController descriptionController = TextEditingController();

  void dispose() {
    invoiceNumberController.dispose();
    invoiceDateController.dispose();
    baseValueController.dispose();
    gstController.dispose();
    otherChargesController.dispose();
    totalValueController.dispose();
    descriptionController.dispose();
  }
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
      FormFieldConfig(
        label: 'Project Name',
        type: FormFieldType.dropdown,
        name: 'projectName',
        options: [
          'Abu Road',
          'Palanpur',
          'Vadodara',
          'Surat',
          'Rajkot',
          'Nanded',
          'Aurangabad',
          'Corporate Office Mumbai',
          'Corporate Office Delhi',
          'Other',
        ],
        validator: (value) =>
        value == null || value.isEmpty ? 'Project name required' : null,
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
        label: 'PO Number (if different from Order No.)',
        type: FormFieldType.text,
        name: 'poMemberDifferent',
        validator: (value) => null,
      ),
      FormFieldConfig(
        label: 'Work/Purchase Order Date',
        type: FormFieldType.date,
        name: 'workPoDate',
        validator: (value) =>
        value == null || value.isEmpty ? 'Date required' : null,
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
        readOnly: true,
      ),
      FormFieldConfig(
        label: 'Activity Type',
        type: FormFieldType.dropdown,
        name: 'activityType',
        options: ['Construction', 'Consultancy', 'Supply', 'Services', 'Other'],
        validator: (value) => null,
        readOnly: true,
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
      FormFieldConfig(
        label: 'Specify deviation (if any)',
        type: FormFieldType.text,
        name: 'deviationRemarks',
        validator: (value) => null,
        maxLines: 2,
      ),
      FormFieldConfig(
        label: 'Deviation Supporting Document',
        type: FormFieldType.text,
        name: 'deviationFile',
        validator: (value) => null,
        readOnly: true,
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
        label: 'Whether All Documents Required Submitted',
        type: FormFieldType.dropdown,
        name: 'documentsSubmitted',
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
  bool _multipleInvoicesEnabled = false;
  final List<_InvoiceEntry> _invoiceEntries = [];
  
  // Financial Details Controllers
  final Map<String, TextEditingController> _financialControllers = {
    'orderBaseValue': TextEditingController(),
    'orderOtherCharges': TextEditingController(),
    'orderGST': TextEditingController(),
    'totalAmount': TextEditingController(text: '0.00'),
    'invoiceNumber': TextEditingController(),
    'invoiceDate': TextEditingController(),
    'taxableValue': TextEditingController(),
    'addedGST': TextEditingController(),
    'invoiceOtherCharges': TextEditingController(),
    'invoiceValue': TextEditingController(text: '0.00'),
  };
  TextEditingController _finCtrl(String key) => _financialControllers[key]!;
  late final TextEditingController _budgetExpenditureController;
  late final TextEditingController _actualExpenditureController;
  late final TextEditingController _expenditureOverBudgetController;
  String _budgetStatus = '(On Budget)';
  Color _budgetStatusColor = Colors.grey;

  PlatformFile? _contractExtensionFile;
  PlatformFile? _deviationFile;
  PlatformFile? _hrAttachmentFile;

  void _resetForm() {
    _formKey.currentState?.reset();
    _formValues.clear();
    for (final controller in _controllers.values) {
      controller
        ..text = ''
        ..clear();
    }
    setState(() {
      _multipleInvoicesEnabled = false;
      _contractExtensionFile = null;
      _deviationFile = null;
      _hrAttachmentFile = null;
    });
  }

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

    _budgetExpenditureController = _controllers['budgetExpenditure']!;
    _actualExpenditureController = _controllers['actualExpenditure']!;
    _expenditureOverBudgetController = _controllers['expenditureOverBudget']!;
    _expenditureOverBudgetController.text = '0.00';
    
    // Add listeners for real-time calculations
    _financialControllers['orderBaseValue']!.addListener(_calculateTotalAmount);
    _financialControllers['orderOtherCharges']!.addListener(_calculateTotalAmount);
    _financialControllers['orderGST']!.addListener(_calculateTotalAmount);

    _financialControllers['taxableValue']!.addListener(_calculateInvoiceValue);
    _financialControllers['addedGST']!.addListener(_calculateInvoiceValue);
    _financialControllers['invoiceOtherCharges']!.addListener(_calculateInvoiceValue);

    _budgetExpenditureController.addListener(_calculateBudgetDifference);
    _actualExpenditureController.addListener(_calculateBudgetDifference);
  }

  Widget _buildHrDepartmentContent(
    BuildContext context,
    FormSection section,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Future<void> pickHrAttachment() async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'doc', 'docx', 'xls', 'xlsx'],
      );
      if (result != null && result.files.isNotEmpty) {
        final picked = result.files.first;
        setState(() {
          _hrAttachmentFile = picked;
          _controllers['hrAttachment']?.text = picked.name;
        });
      }
    }

    Widget buildField(String name) {
      final config = _getFieldConfig(section, name);
      if (config == null) return const SizedBox.shrink();
      return _buildFormField(context, config);
    }

    Widget attachmentPicker() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attachment (if any)',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: pickHrAttachment,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Choose File',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _hrAttachmentFile?.name ?? 'No file chosen',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'PDF, DOC, XLS max 10MB',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      );
    }

    List<Widget> withSpacing(List<Widget> children) {
      return [
        for (int i = 0; i < children.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == children.length - 1 ? 0 : 16),
            child: children[i],
          ),
      ];
    }

    final leftColumn = withSpacing([
      buildField('documentsVerified'),
      buildField('documentsDiscrepancy'),
      buildField('hrRemarks'),
      buildField('auditorRemarks'),
    ]);

    final rightColumn = withSpacing([
      buildField('documentsSubmitted'),
      buildField('amountRetained'),
      attachmentPicker(),
    ]);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 900;
        if (isSmallScreen) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...leftColumn,
              const SizedBox(height: 16),
              ...rightColumn,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: leftColumn,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rightColumn,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContractExtensionContent(
    BuildContext context,
    FormSection section,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Future<void> selectFile(String controllerKey, ValueSetter<PlatformFile?> setter) async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'doc', 'docx', 'xls', 'xlsx'],
      );
      if (result != null && result.files.isNotEmpty) {
        final picked = result.files.first;
        setState(() {
          setter(picked);
          _controllers[controllerKey]?.text = picked.name;
        });
      }
    }

    Widget buildField(String name) {
      final config = _getFieldConfig(section, name);
      if (config == null) return const SizedBox.shrink();
      return SizedBox(width: double.infinity, child: _buildFormField(context, config));
    }

    Widget buildFilePicker({
      required String controllerKey,
      required String label,
      required PlatformFile? file,
      required ValueSetter<PlatformFile?> setter,
      String? helperText,
    }) {
      return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => selectFile(controllerKey, setter),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Choose File',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        file?.name ?? 'No file chosen',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (helperText != null) ...[
              const SizedBox(height: 6),
              Text(
                helperText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ],
        ),
      );
    }

    Widget buildColumn(List<Widget> widgets) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < widgets.length; i++) ...[
            if (i != 0) const SizedBox(height: 16),
            widgets[i],
          ],
        ],
      );
    }

    final leftColumnWidgets = [
      buildField('contractExtension'),
      buildFilePicker(
        controllerKey: 'milestoneFile',
        label: 'Upload supporting document (contract extension)',
        file: _contractExtensionFile,
        setter: (file) => _contractExtensionFile = file,
        helperText:
            'Upload supporting document if extension is Yes (PDF, DOC, XLS max 10MB)',
      ),
      buildField('expenseWithinContract'),
      buildField('deviationRemarks'),
    ];

    final rightColumnWidgets = [
      buildField('milestoneAchieved'),
      buildField('milestoneRemarks'),
      buildField('paymentWithDeviation'),
      buildFilePicker(
        controllerKey: 'deviationFile',
        label: 'Upload supporting document (deviation)',
        file: _deviationFile,
        setter: (file) => _deviationFile = file,
        helperText:
            'Upload supporting document if deviations is Yes (PDF, DOC, XLS max 10MB)',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 900;

        if (isSmallScreen) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildColumn(leftColumnWidgets),
              const SizedBox(height: 16),
              buildColumn(rightColumnWidgets),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: buildColumn(leftColumnWidgets)),
            const SizedBox(width: 24),
            Expanded(child: buildColumn(rightColumnWidgets)),
          ],
        );
      },
    );
  }

  Widget _buildContractDetailsContent(
    BuildContext context,
    FormSection section,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const contractFields = [
      'contractStartDate',
      'appointedDate',
      'appointedEndDate',
    ];
    const supplyFields = [
      'supplyStartDate',
      'supplyEndDate',
      'contractCompleted',
    ];

    Widget buildColumn(String title, List<String> fieldNames) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(fieldNames.length, (index) {
              final name = fieldNames[index];
              final fieldConfig = _getFieldConfig(section, name);
              if (fieldConfig == null) return const SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.only(bottom: index == fieldNames.length - 1 ? 0 : 16),
                child: _buildFormField(context, fieldConfig),
              );
            }),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 900;
        if (isSmallScreen) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildColumn('Contract Period', contractFields),
              const SizedBox(height: 16),
              buildColumn('Supply Period', supplyFields),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: buildColumn('Contract Period', contractFields)),
            const SizedBox(width: 32),
            Expanded(child: buildColumn('Supply Period', supplyFields)),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    for (final entry in _invoiceEntries) {
      entry.dispose();
    }
    for (final controller in _financialControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
  
  void _calculateTotalAmount() {
    final baseValue = double.tryParse(_financialControllers['orderBaseValue']?.text.replaceAll(',', '') ?? '') ?? 0.0;
    final otherCharges = double.tryParse(_financialControllers['orderOtherCharges']?.text.replaceAll(',', '') ?? '') ?? 0.0;
    final gst = double.tryParse(_financialControllers['orderGST']?.text.replaceAll(',', '') ?? '') ?? 0.0;
    final total = baseValue + otherCharges + gst;
    _financialControllers['totalAmount']?.text = total.toStringAsFixed(2);
  }
  
  void _calculateInvoiceValue() {
    final taxableValue = double.tryParse(_financialControllers['taxableValue']?.text.replaceAll(',', '') ?? '') ?? 0.0;
    final gst = double.tryParse(_financialControllers['addedGST']?.text.replaceAll(',', '') ?? '') ?? 0.0;
    final otherCharges = double.tryParse(_financialControllers['invoiceOtherCharges']?.text.replaceAll(',', '') ?? '') ?? 0.0;
    final invoiceTotal = taxableValue + gst + otherCharges;
    _financialControllers['invoiceValue']?.text = invoiceTotal.toStringAsFixed(2);
  }

  void _calculateBudgetDifference() {
    if (!mounted) return;

    final budgetExpenditure = double.tryParse(_budgetExpenditureController.text.replaceAll(',', '')) ?? 0.0;
    final actualExpenditure = double.tryParse(_actualExpenditureController.text.replaceAll(',', '')) ?? 0.0;
    final difference = actualExpenditure - budgetExpenditure;

    _expenditureOverBudgetController.text = difference.abs().toStringAsFixed(2);

    setState(() {
      if (difference > 0) {
        _budgetStatus = '(Over Budget)';
        _budgetStatusColor = Colors.red;
      } else if (difference < 0) {
        _budgetStatus = '(Under Budget)';
        _budgetStatusColor = Colors.green;
      } else {
        _budgetStatus = '(On Budget)';
        _budgetStatusColor = Colors.grey;
      }
    });
  }

  void _adjustBudgetValue(TextEditingController controller, double delta) {
    final current = double.tryParse(controller.text) ?? 0.0;
    double nextValue = current + delta;
    if (nextValue < 0) nextValue = 0;
    controller.text = nextValue.toStringAsFixed(2);
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
                ...List.generate(expenseFormSections.length, (index) {
                  final section = expenseFormSections[index];
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
              child: section.title == 'Financial Details'
                  ? _buildFinancialDetailsContent(context, section)
                  : section.title == 'Budget Information'
                      ? _buildBudgetInformationSection(context)
                      : section.title == 'Contract Details'
                      ? _buildContractDetailsContent(context, section)
                      : section.title == 'Contract Extension & Compliance'
                          ? _buildContractExtensionContent(context, section)
                          : section.title == 'HR Department (Optional)'
                              ? _buildHrDepartmentContent(context, section)
                              : LayoutBuilder(
                          builder: (context, constraints) {
                            final isSmallScreen = constraints.maxWidth < 720;
                            final fieldWidth = isSmallScreen
                                ? constraints.maxWidth
                                : (constraints.maxWidth - 24) / 2;

                            return Wrap(
                              spacing: 24,
                              runSpacing: 16,
                              children: section.fields.map((field) {
                                return SizedBox(
                                  width: fieldWidth,
                                  child: _buildFormField(context, field),
                                );
                              }).toList(),
                            );
                          },
                        ),
            ),
        ],
      ),
    );
  }

  Widget _buildFinancialDetailsContent(
    BuildContext context,
    FormSection section,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget buildOrderAmountColumn() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Amount',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            _buildCalculatedTextField('Base Value', _finCtrl('orderBaseValue'), false),
            const SizedBox(height: 16),
            _buildCalculatedTextField('Other Charges', _finCtrl('orderOtherCharges'), false),
            const SizedBox(height: 16),
            _buildCalculatedTextField('GST on Above', _finCtrl('orderGST'), false),
            const SizedBox(height: 16),
            _buildCalculatedTextField('Total Amount', _finCtrl('totalAmount'), true),
          ],
        ),
      );
    }

    Widget buildInvoiceDetailsColumn() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice Details',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            _buildCalculatedTextField('Invoice Number', _finCtrl('invoiceNumber'), false),
            const SizedBox(height: 16),
            _buildDateField('Invoice Date', _finCtrl('invoiceDate')),
            const SizedBox(height: 16),
            _buildCalculatedTextField('Taxable Value', _finCtrl('taxableValue'), false),
            const SizedBox(height: 16),
            _buildCalculatedTextField('Add: GST on Above', _finCtrl('addedGST'), false),
            const SizedBox(height: 16),
            _buildCalculatedTextField('Invoice Other Charges', _finCtrl('invoiceOtherCharges'), false),
            const SizedBox(height: 16),
            _buildCalculatedTextField('Invoice Value', _finCtrl('invoiceValue'), true),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 900;
        if (isSmallScreen) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildOrderAmountColumn(),
              const SizedBox(height: 16),
              buildInvoiceDetailsColumn(),
              const SizedBox(height: 16),
              _buildMultipleInvoicesCard(context),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: buildOrderAmountColumn()),
                const SizedBox(width: 32),
                Expanded(child: buildInvoiceDetailsColumn()),
              ],
            ),
            const SizedBox(height: 16),
            _buildMultipleInvoicesCard(context),
          ],
        );
      },
    );
  }
  
  Widget _buildBudgetInformationSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    Widget buildEditableBudgetField(String label, TextEditingController controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 18,
                        icon: const Icon(Icons.keyboard_arrow_up),
                        onPressed: () => _adjustBudgetValue(controller, 0.01),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 18,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onPressed: () => _adjustBudgetValue(controller, -0.01),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget buildReadOnlyDifferenceField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expenditure over Budget',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _expenditureOverBudgetController.text,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _budgetStatus,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _budgetStatusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.pie_chart_outline, color: colorScheme.primary, size: 18),
            const SizedBox(width: 8),
            Text(
              'Budget Information',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isSmall = constraints.maxWidth < 720;
            if (isSmall) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildEditableBudgetField('Budget Expenditure', _budgetExpenditureController),
                  const SizedBox(height: 16),
                  buildEditableBudgetField('Actual Expenditure', _actualExpenditureController),
                  const SizedBox(height: 16),
                  buildReadOnlyDifferenceField(),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: buildEditableBudgetField('Budget Expenditure', _budgetExpenditureController)),
                const SizedBox(width: 16),
                Expanded(child: buildEditableBudgetField('Actual Expenditure', _actualExpenditureController)),
                const SizedBox(width: 16),
                Expanded(child: buildReadOnlyDifferenceField()),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildCalculatedTextField(String label, TextEditingController controller, bool isReadOnly) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: isReadOnly,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: isReadOnly ? null : [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: InputDecoration(
            filled: true,
            fillColor: isReadOnly 
                ? colorScheme.surfaceContainerHighest.withOpacity(0.5)
                : colorScheme.surface,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: isReadOnly ? null : (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter $label';
            }
            final number = double.tryParse(value);
            if (number == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
      ],
    );
  }
  
  Widget _buildDateField(String label, TextEditingController controller) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: colorScheme.surface,
            suffixIcon: Icon(Icons.calendar_today, size: 18, color: colorScheme.primary),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              controller.text = '${date.day}/${date.month}/${date.year}';
            }
          },
        ),
      ],
    );
  }
  

  FormFieldConfig? _getFieldConfig(FormSection section, String fieldName) {
    try {
      return section.fields.firstWhere((field) => field.name == fieldName);
    } catch (_) {
      return null;
    }
  }

  Widget _buildMultipleInvoicesCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(Icons.new_releases_outlined, color: colorScheme.primary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'New Feature! You can now add multiple invoices to a single expense note.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.receipt_long, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Multiple Invoices (Optional)',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _multipleInvoicesEnabled,
                      onChanged: (value) {
                        setState(() {
                          _multipleInvoicesEnabled = value;
                        });
                      },
                      activeColor: colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Toggle this switch to add multiple invoice entries for this expense note.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 16),
                if (_multipleInvoicesEnabled) _buildInvoiceEntriesList(context) else _buildSingleInvoiceSummary(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceEntriesList(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        ...List.generate(_invoiceEntries.length, (index) {
          final invoiceEntry = _invoiceEntries[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Invoice Entry ${index + 1}',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (_invoiceEntries.length > 1)
                      IconButton(
                        tooltip: 'Remove invoice entry',
                        onPressed: () {
                          setState(() {
                            _invoiceEntries.removeAt(index).dispose();
                          });
                        },
                        icon: Icon(Icons.close, color: colorScheme.error),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isSmallScreen = constraints.maxWidth < 720;
                    final fieldWidth = isSmallScreen
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 24) / 2;
                    return Wrap(
                      spacing: 24,
                      runSpacing: 16,
                      children: [
                        _buildInvoiceTextField(context, 'Invoice Number *', invoiceEntry.invoiceNumberController, fieldWidth),
                        _buildInvoiceDateField(context, invoiceEntry.invoiceDateController, fieldWidth),
                        _buildInvoiceTextField(context, 'Base Value (₹)', invoiceEntry.baseValueController, fieldWidth),
                        _buildInvoiceTextField(context, 'GST (₹)', invoiceEntry.gstController, fieldWidth),
                        _buildInvoiceTextField(context, 'Other Charges (₹)', invoiceEntry.otherChargesController, fieldWidth),
                        _buildInvoiceTextField(context, 'Total Value (₹)', invoiceEntry.totalValueController, fieldWidth, readOnly: true),
                        SizedBox(
                          width: fieldWidth,
                          child: TextFormField(
                            controller: invoiceEntry.descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description (Optional)',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        }).toList(),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                _invoiceEntries.add(_InvoiceEntry());
              });
            },
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Add Invoice Entry'),
          ),
        ),
        const SizedBox(height: 16),
        _buildInvoiceTotals(context),
      ],
    );
  }

  Widget _buildInvoiceTextField(
    BuildContext context,
    String label,
    TextEditingController controller,
    double width, {
    bool readOnly = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildInvoiceDateField(BuildContext context, TextEditingController controller, double width) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Invoice Date *',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
          ),
          suffixIcon: Icon(Icons.calendar_today, size: 18, color: colorScheme.onSurface.withOpacity(0.6)),
        ),
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (date != null) {
            final formattedDate = '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
            controller.text = formattedDate;
          }
        },
      ),
    );
  }

  Widget _buildInvoiceTotals(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Invoice Value', style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                Text('0.00', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total GST', style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                Text('0.00', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleInvoiceSummary(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Multiple invoices disabled', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            'Enable the toggle above if you need to capture separate invoice entries for this note.',
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
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
        return IgnorePointer(
          ignoring: field.readOnly ?? false,
          child: Opacity(
            opacity: (field.readOnly ?? false) ? 0.6 : 1.0,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: field.label,
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
                filled: true,
                fillColor: (field.readOnly ?? false) 
                    ? colorScheme.surfaceContainerHighest.withOpacity(0.5)
                    : colorScheme.surface,
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
              onChanged: (field.readOnly ?? false) ? null : (value) {
                setState(() {
                  _formValues[field.name] = value;
                });
              },
            ),
          ),
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

    Widget buildResetButton() {
      return SecondaryButton(
        label: 'Reset',
        onPressed: _resetForm,
      );
    }

    Widget buildCancelButton() {
      return SecondaryButton(
        label: 'Cancel',
        backgroundColor: colorScheme.error.withOpacity(0.08),
        onPressed: () => Navigator.of(context).maybePop(),
      );
    }

    Widget buildCreateButton() {
      return PrimaryButton(
        label: 'Create Green Note',
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Green Note created successfully'),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                backgroundColor: colorScheme.primary,
              ),
            );
          }
        },
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildResetButton(),
          const SizedBox(width: 12),
          buildCancelButton(),
          const SizedBox(width: 12),
          buildCreateButton(),
        ],
      ),
    );
  }
}
