// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:ppv_components/app/layout.dart';
//
// // Import only the pages that actually exist in your project
// import 'package:ppv_components/features/activity/screen/activity_main_page.dart';
// import 'package:ppv_components/features/bank_rtgs_neft/widget/external_transfer_form.dart';
// import 'package:ppv_components/features/department/screen/department_main_page.dart';
// import 'package:ppv_components/features/designation/screen/designation_main_page.dart';
// import 'package:ppv_components/features/reimbursement/widget/create_reimbursement_form.dart';
// import 'package:ppv_components/features/reimbursement/widget/reimbursement_table_page.dart';
// import 'package:ppv_components/features/roles/screens/roles_main_page.dart';
// import 'package:ppv_components/features/user/screens/user_main_page.dart';
// import 'package:ppv_components/features/vendor/screen/vendor_main_page.dart';
// import 'package:ppv_components/features/approval_management/screens/approval_rules_page.dart';
// import 'package:ppv_components/features/approval_management/screens/approval_rules_management_page.dart';
// import 'package:ppv_components/features/bank_rtgs_neft/widget/escrow_accounts_page.dart';
// import 'package:ppv_components/features/bank_rtgs_neft/widget/create_escrow_account_page.dart';
// import 'package:ppv_components/features/bank_rtgs_neft/widget/account_transfers_page.dart';
// import 'package:ppv_components/features/bank_rtgs_neft/widget/create_transfer_page.dart';
// import 'package:ppv_components/features/bank_rtgs_neft/widget/bank_letters_page.dart';
// import 'package:ppv_components/features/bank_rtgs_neft/widget/create_bank_letter_page.dart';
// import 'package:ppv_components/features/bank_rtgs_neft/data/bank_dummydata/escrow_accounts_dummy.dart';
// import 'package:ppv_components/features/expense/screens/all_notes_page.dart';
// import 'package:ppv_components/features/expense/screens/create_note_page.dart';
// import 'package:ppv_components/features/approval_management/screens/create_approval_rule_page.dart';
// // Auth & core pages
// import 'package:ppv_components/features/auth/login_page.dart';
// import 'package:ppv_components/features/auth/signup_page.dart';
// import 'package:ppv_components/features/auth/create_organization_page.dart';
// import 'package:ppv_components/features/auth/forgot_password_page.dart';
// import 'package:ppv_components/features/dashboard/super_admin_dashboard.dart';
// import 'package:ppv_components/features/home/home_page.dart';
//
// // Placeholder widget for pages that don't exist yet
// class PlaceholderPage extends StatelessWidget {
//   final String title;
//   const PlaceholderPage({super.key, required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(title)),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.construction, size: 100, color: Colors.grey),
//             SizedBox(height: 20),
//             Text(
//               '$title Page',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'This page is under construction',
//               style: TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// final GoRouter router = GoRouter(
//   initialLocation: '/login',
//   routes: [
//     // Public auth routes (outside shell)
//     GoRoute(
//       path: '/login',
//       builder: (context, state) => const LoginPage(),
//     ),
//     GoRoute(
//       path: '/registration',
//       builder: (context, state) => const RegistrationPage(),
//     ),
//     GoRoute(
//       path: '/create-organization',
//       builder: (context, state) => const CreateOrganizationPage(),
//     ),
//     GoRoute(
//       path: '/forgot-password',
//       builder: (context, state) => const ForgotPasswordPage(),
//     ),
//     GoRoute(
//       path: '/home',
//       builder: (context, state) => const HomePage(),
//     ),
//     ShellRoute(
//       builder: (context, state, child) => LayoutPage(child: child),
//       routes: [
//         // DASHBOARD
//         GoRoute(
//           path: '/dashboard',
//           builder: (context, state) => const SuperAdminDashboard(),
//         ),
//
//         // EXPENSE
//         GoRoute(
//           path: '/expense/create-note',
//           builder: (context, state) => const CreateNotePage(),
//         ),
//         GoRoute(
//           path: '/expense/all-notes',
//           builder: (context, state) => const AllNotesPage(),
//         ),
//
//         // APPROVAL RULES
//         // Approval Rules Management
//         GoRoute(
//           path: '/approval-rules',
//           builder: (context, state) => const ApprovalRulesPage(),
//         ),
//         GoRoute(
//           path: '/approval-rules/green_note',
//           builder: (context, state) => const ApprovalRulesManagementPage(ruleType: 'green_note'),
//         ),
//         GoRoute(
//           path: '/approval-rules/green_note/create',
//           builder: (context, state) => const CreateApprovalRulePage(ruleType: 'green_note'),
//         ),
//         GoRoute(
//           path: '/approval-rules/payment_note',
//           builder: (context, state) => const ApprovalRulesManagementPage(ruleType: 'payment_note'),
//         ),
//         GoRoute(
//           path: '/approval-rules/payment_note/create',
//           builder: (context, state) => const CreateApprovalRulePage(ruleType: 'payment_note'),
//         ),
//         GoRoute(
//           path: '/approval-rules/reimbursement_note',
//           builder: (context, state) => const ApprovalRulesManagementPage(ruleType: 'reimbursement_note'),
//         ),
//         GoRoute(
//           path: '/approval-rules/reimbursement_note/create',
//           builder: (context, state) => const CreateApprovalRulePage(ruleType: 'reimbursement_note'),
//         ),
//
//
//         // Escrow Banking System
//         GoRoute(
//           path: '/escrow-accounts',
//           builder: (context, state) => EscrowAccountsPage(
//             escrowAccounts: escrowAccountsDummyData,
//           ),
//         ),
//         GoRoute(
//           path: '/escrow-accounts/create',
//           builder: (context, state) => const CreateEscrowAccountPage(),
//         ),
//         GoRoute(
//           path: '/escrow/account-transfers',
//           builder: (context, state) => const AccountTransfersPage(),
//         ),
//         GoRoute(
//           path: '/escrow/create',
//           builder: (context, state) => const CreateTransferPage(),
//         ),
//         GoRoute(
//           path: '/escrow/bank-letter',
//           builder: (context, state) => const BankLettersPage(),
//         ),
//         GoRoute(
//           path: '/escrow/bank-letter/create',
//           builder: (context, state) => const CreateBankLetterPage(),
//         ),
//
//         // Travel & Reimbursement
//         GoRoute(
//           path: '/reimbursement-note/create',
//           builder: (context, state) => const ReimbursementForm(),
//         ),
//         GoRoute(
//           path: '/reimbursement-note',
//           builder: (context, state) => const ReimbursementTablePage(),
//         ),
//
//         // MANAGEMENT
//         // User Management
//         GoRoute(
//           path: '/users',
//           builder: (context, state) => const UserMainPage(),
//         ),
//         GoRoute(
//           path: '/users/create',
//           builder: (context, state) => const PlaceholderPage(title: 'Create User'),
//         ),
//
//         // Role Management
//         GoRoute(
//           path: '/roles',
//           builder: (context, state) => const RoleMainPage(),
//         ),
//         GoRoute(
//           path: '/roles/create',
//           builder: (context, state) => const PlaceholderPage(title: 'Create Role'),
//         ),
//
//         // Departments
//         GoRoute(
//           path: '/department',
//           builder: (context, state) => const DepartmentMainPage(),
//         ),
//         GoRoute(
//           path: '/department/create',
//           builder: (context, state) => const PlaceholderPage(title: 'Create Department'),
//         ),
//
//         // Designations
//         GoRoute(
//           path: '/designations',
//           builder: (context, state) => const DesignationMainPage(),
//         ),
//         GoRoute(
//           path: '/designations/create',
//           builder: (context, state) => const PlaceholderPage(title: 'Create Designation'),
//         ),
//
//         // Vendor Management
//         GoRoute(
//           path: '/vendors',
//           builder: (context, state) => const VendorMainPage(),
//         ),
//         GoRoute(
//           path: '/vendors/create',
//           builder: (context, state) => const PlaceholderPage(title: 'Create Vendor'),
//         ),
//
//         // Organization Management
//         GoRoute(
//           path: '/organizations',
//           builder: (context, state) => const PlaceholderPage(title: 'All Organizations'),
//         ),
//         GoRoute(
//           path: '/organization/create',
//           builder: (context, state) => const PlaceholderPage(title: 'Create Organization'),
//         ),
//
//         // ACTIVITY & REPORTS
//         // Activity
//         GoRoute(
//           path: '/activity',
//           builder: (context, state) => const ActivityMainPage(),
//         ),
//         GoRoute(
//           path: '/login-history',
//           builder: (context, state) => const ExternalTransferPage(),
//         ),
//       ],
//     ),
//   ],
// );






//bypass auth



import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ppv_components/app/layout.dart';

// Import only the pages that actually exist in your project
import 'package:ppv_components/features/activity/screen/activity_main_page.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/external_transfer_form.dart';
import 'package:ppv_components/features/department/screen/department_main_page.dart';
import 'package:ppv_components/features/designation/screen/designation_main_page.dart';
import 'package:ppv_components/features/reimbursement/widget/create_reimbursement_form.dart';
import 'package:ppv_components/features/reimbursement/widget/reimbursement_table_page.dart';
import 'package:ppv_components/features/roles/screens/roles_main_page.dart';
import 'package:ppv_components/features/user/screens/user_main_page.dart';
import 'package:ppv_components/features/vendor/screen/vendor_main_page.dart';
import 'package:ppv_components/features/approval_management/screens/approval_rules_page.dart';
import 'package:ppv_components/features/approval_management/screens/approval_rules_management_page.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/escrow_accounts_page.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/create_escrow_account_page.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/account_transfers_page.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/create_transfer_page.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/bank_letters_page.dart';
import 'package:ppv_components/features/bank_rtgs_neft/widget/create_bank_letter_page.dart';
import 'package:ppv_components/features/bank_rtgs_neft/data/bank_dummydata/escrow_accounts_dummy.dart';
import 'package:ppv_components/features/expense/screens/all_notes_page.dart';
import 'package:ppv_components/features/expense/screens/create_note_page.dart';
import 'package:ppv_components/features/approval_management/screens/create_approval_rule_page.dart';
// Auth & core pages
import 'package:ppv_components/features/auth/login_page.dart';
import 'package:ppv_components/features/auth/signup_page.dart';
import 'package:ppv_components/features/auth/create_organization_page.dart';
import 'package:ppv_components/features/auth/forgot_password_page.dart';
import 'package:ppv_components/features/dashboard/super_admin_dashboard.dart';
import 'package:ppv_components/features/home/home_page.dart';

// Placeholder widget for pages that don't exist yet
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              '$title Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'This page is under construction',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

final GoRouter router = GoRouter(
  initialLocation: '/dashboard',  // changed from '/login'
  routes: [
    // Public auth routes (outside shell)
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/registration',
      builder: (context, state) => const RegistrationPage(),
    ),
    GoRoute(
      path: '/create-organization',
      builder: (context, state) => const CreateOrganizationPage(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    ShellRoute(
      builder: (context, state, child) => LayoutPage(child: child),
      routes: [
        // DASHBOARD
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const SuperAdminDashboard(),
        ),

        // EXPENSE
        GoRoute(
          path: '/expense/create-note',
          builder: (context, state) => const CreateNotePage(),
        ),
        GoRoute(
          path: '/expense/all-notes',
          builder: (context, state) => const AllNotesPage(),
        ),

        // APPROVAL RULES
        // Approval Rules Management
        GoRoute(
          path: '/approval-rules',
          builder: (context, state) => const ApprovalRulesPage(),
        ),
        GoRoute(
          path: '/approval-rules/green_note',
          builder: (context, state) => const ApprovalRulesManagementPage(ruleType: 'green_note'),
        ),
        GoRoute(
          path: '/approval-rules/green_note/create',
          builder: (context, state) => const CreateApprovalRulePage(ruleType: 'green_note'),
        ),
        GoRoute(
          path: '/approval-rules/payment_note',
          builder: (context, state) => const ApprovalRulesManagementPage(ruleType: 'payment_note'),
        ),
        GoRoute(
          path: '/approval-rules/payment_note/create',
          builder: (context, state) => const CreateApprovalRulePage(ruleType: 'payment_note'),
        ),
        GoRoute(
          path: '/approval-rules/reimbursement_note',
          builder: (context, state) => const ApprovalRulesManagementPage(ruleType: 'reimbursement_note'),
        ),
        GoRoute(
          path: '/approval-rules/reimbursement_note/create',
          builder: (context, state) => const CreateApprovalRulePage(ruleType: 'reimbursement_note'),
        ),


        // Escrow Banking System
        GoRoute(
          path: '/escrow-accounts',
          builder: (context, state) => EscrowAccountsPage(
            escrowAccounts: escrowAccountsDummyData,
          ),
        ),
        GoRoute(
          path: '/escrow-accounts/create',
          builder: (context, state) => const CreateEscrowAccountPage(),
        ),
        GoRoute(
          path: '/escrow/account-transfers',
          builder: (context, state) => const AccountTransfersPage(),
        ),
        GoRoute(
          path: '/escrow/create',
          builder: (context, state) => const CreateTransferPage(),
        ),
        GoRoute(
          path: '/escrow/bank-letter',
          builder: (context, state) => const BankLettersPage(),
        ),
        GoRoute(
          path: '/escrow/bank-letter/create',
          builder: (context, state) => const CreateBankLetterPage(),
        ),

        // Travel & Reimbursement
        GoRoute(
          path: '/reimbursement-note/create',
          builder: (context, state) => const ReimbursementForm(),
        ),
        GoRoute(
          path: '/reimbursement-note',
          builder: (context, state) => const ReimbursementTablePage(),
        ),

        // MANAGEMENT
        // User Management
        GoRoute(
          path: '/users',
          builder: (context, state) => const UserMainPage(),
        ),
        GoRoute(
          path: '/users/create',
          builder: (context, state) => const PlaceholderPage(title: 'Create User'),
        ),

        // Role Management
        GoRoute(
          path: '/roles',
          builder: (context, state) => const RoleMainPage(),
        ),
        GoRoute(
          path: '/roles/create',
          builder: (context, state) => const PlaceholderPage(title: 'Create Role'),
        ),

        // Departments
        GoRoute(
          path: '/department',
          builder: (context, state) => const DepartmentMainPage(),
        ),
        GoRoute(
          path: '/department/create',
          builder: (context, state) => const PlaceholderPage(title: 'Create Department'),
        ),

        // Designations
        GoRoute(
          path: '/designations',
          builder: (context, state) => const DesignationMainPage(),
        ),
        GoRoute(
          path: '/designations/create',
          builder: (context, state) => const PlaceholderPage(title: 'Create Designation'),
        ),

        // Vendor Management
        GoRoute(
          path: '/vendors',
          builder: (context, state) => const VendorMainPage(),
        ),
        GoRoute(
          path: '/vendors/create',
          builder: (context, state) => const PlaceholderPage(title: 'Create Vendor'),
        ),

        // Organization Management
        GoRoute(
          path: '/organizations',
          builder: (context, state) => const PlaceholderPage(title: 'All Organizations'),
        ),
        GoRoute(
          path: '/organization/create',
          builder: (context, state) => const PlaceholderPage(title: 'Create Organization'),
        ),

        // ACTIVITY & REPORTS
        // Activity
        GoRoute(
          path: '/activity',
          builder: (context, state) => const ActivityMainPage(),
        ),
        GoRoute(
          path: '/login-history',
          builder: (context, state) => const ExternalTransferPage(),
        ),
      ],
    ),
  ],
);
