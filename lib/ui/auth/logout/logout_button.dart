import 'package:transactions/ui/auth/logout/logout_viewmodel.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
    required LogoutViewModel viewModel,
    this.colorScheme,
  }) : _viewModel = viewModel;

  final LogoutViewModel _viewModel;
  final ColorScheme? colorScheme;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(Icons.logout),
      onPressed: () {
        _viewModel.logout.execute();
      },
      style: ButtonStyle(
        foregroundColor: WidgetStateColor.resolveWith(
          (_) =>
              colorScheme?.onPrimaryContainer ??
              ColorScheme.of(context).onPrimaryContainer,
        ),
      ),
      label: Text(
        "Logout",
        style: TextStyle(fontSize: TextTheme.of(context).bodyLarge?.fontSize),
      ),
    );
  }
}
