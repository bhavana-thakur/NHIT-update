import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ppv_components/core/app_routes.dart';

class RoleManager {
  static void redirectByRole(BuildContext context, String role) {
    if (role.toUpperCase() == 'SUPER_ADMIN') {
      context.go(AppRoutes.dashboard);
    } else {
      context.go(AppRoutes.home);
    }
  }
}
