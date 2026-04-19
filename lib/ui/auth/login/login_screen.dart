import 'package:transactions/ui/auth/login/login_viewmodel.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required LoginViewModel viewModel})
    : _viewModel = viewModel;

  final LoginViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  "Finanztransaktionsverwaltungssystem",
                  style: TextTheme.of(context).displayLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  "yo",
                  style: TextTheme.of(context).headlineSmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                FilledButton.icon(
                  onPressed: () {
                    _viewModel.login.execute();
                  },
                  style: FilledButton.styleFrom(
                    textStyle: TextTheme.of(context).titleLarge,
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                  ),
                  icon: Icon(Icons.login),
                  label: Padding(
                    padding: EdgeInsetsGeometry.only(left: 5),
                    child: Text("Login"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
