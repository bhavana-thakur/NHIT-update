import 'package:flutter/material.dart';
import 'package:ppv_components/common_widgets/button/primary_button.dart';
import 'package:ppv_components/common_widgets/button/secondary_button.dart';
import 'package:ppv_components/features/expense/models/expense_model.dart';

class EditExpenseNoteContent extends StatefulWidget {
  final ExpenseNote note;
  final List<String> departmentOptions;
  final Function(ExpenseNote) onSave;
  final VoidCallback onCancel;

  const EditExpenseNoteContent({
    super.key,
    required this.note,
    required this.departmentOptions,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<EditExpenseNoteContent> createState() => _EditExpenseNoteContentState();
}

class _EditExpenseNoteContentState extends State<EditExpenseNoteContent> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _projectController;
  late TextEditingController _vendorController;
  late TextEditingController _amountController;
  late TextEditingController _requestedByController;
  late TextEditingController _nextApproverController;
  late TextEditingController _descriptionController;

  final List<String> _statusOptions = const ['Pending', 'Approved', 'Rejected', 'Draft', 'Cancelled'];
  String? _selectedDepartment;
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _projectController = TextEditingController(text: widget.note.projectName);
    _vendorController = TextEditingController(text: widget.note.vendorName);
    _amountController = TextEditingController(text: widget.note.invoiceValue.toStringAsFixed(2));
    _requestedByController = TextEditingController(text: widget.note.requestedBy);
    _nextApproverController = TextEditingController(text: widget.note.nextApprover);
    _descriptionController = TextEditingController(text: widget.note.description);
    _selectedDepartment = widget.note.department.isEmpty ? null : widget.note.department;
    _selectedStatus = widget.note.status;
  }

  @override
  void dispose() {
    _projectController.dispose();
    _vendorController.dispose();
    _amountController.dispose();
    _requestedByController.dispose();
    _nextApproverController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final sanitizedAmount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? widget.note.invoiceValue;

    final updatedNote = ExpenseNote(
      id: widget.note.id,
      sNo: widget.note.sNo,
      projectName: _projectController.text.trim(),
      vendorName: _vendorController.text.trim(),
      invoiceValue: sanitizedAmount,
      status: _selectedStatus,
      createdDate: widget.note.createdDate,
      nextApprover: _nextApproverController.text.trim(),
      department: _selectedDepartment ?? widget.note.department,
      description: _descriptionController.text.trim(),
      requestedBy: _requestedByController.text.trim(),
    );

    widget.onSave(updatedNote);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(colorScheme, theme),
              const SizedBox(height: 16),
              _buildFormCard(colorScheme, theme),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SecondaryButton(
                      label: 'Cancel',
                      onPressed: widget.onCancel,
                    ),
                    const SizedBox(width: 12),
                    PrimaryButton(
                      label: 'Save Changes',
                      onPressed: _saveNote,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.5), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.edit, size: 24, color: colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Expense Note',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Update expense note details and information',
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

  Widget _buildFormCard(ColorScheme colorScheme, ThemeData theme) {
    final departmentItems = widget.departmentOptions.toSet().toList()
      ..sort();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.5), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Note Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTwoColumnRow([
            _buildTextField('Project Name', _projectController),
            _buildTextField('Vendor Name', _vendorController),
          ]),
          const SizedBox(height: 16),
          _buildTwoColumnRow([
            _buildTextField('Invoice Amount', _amountController, keyboardType: TextInputType.number),
            _buildDropdownField(
              label: 'Status',
              value: _selectedStatus,
              items: _statusOptions,
              onChanged: (value) => setState(() => _selectedStatus = value ?? _selectedStatus),
            ),
          ]),
          const SizedBox(height: 16),
          _buildTwoColumnRow([
            _buildDropdownField(
              label: 'Department',
              value: _selectedDepartment,
              items: departmentItems,
              onChanged: (value) => setState(() => _selectedDepartment = value),
              hintText: 'Select department',
            ),
            _buildTextField('Requested By', _requestedByController),
          ]),
          const SizedBox(height: 16),
          _buildTwoColumnRow([
            _buildTextField('Next Approver', _nextApproverController),
            _buildTextField('Description', _descriptionController, maxLines: 2),
          ]),
        ],
      ),
    );
  }

  Widget _buildTwoColumnRow(List<Widget> children) {
    return Row(
      children: [
        for (int i = 0; i < children.length; i++) ...[
          Expanded(child: children[i]),
          if (i != children.length - 1) const SizedBox(width: 16),
        ],
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? hintText,
  }) {
    final dropdownItems = items.isEmpty ? <String>[] : items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value?.isEmpty == true ? null : value,
          items: dropdownItems
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (value) {
            if ((value == null || value.isEmpty) && hintText == null) {
              return 'Please select $label';
            }
            return null;
          },
        ),
      ],
    );
  }
}
