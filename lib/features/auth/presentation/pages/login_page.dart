import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/state/view_state.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
          AuthLoginRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is ViewSuccess) {
              context.goNamed(RouteNames.home);
            }
          },
          builder: (context, state) {
            final bool isLoading = state.isLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    Text(
                      AppStrings.appName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 40),
                    AuthTextField(
                      controller: _emailController,
                      label: AppStrings.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          (value == null || value.isEmpty) ? 'Email is required' : null,
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _passwordController,
                      label: AppStrings.password,
                      obscureText: true,
                      validator: (value) =>
                          (value == null || value.isEmpty) ? 'Password is required' : null,
                    ),
                    if (state is ViewError) ...[
                      const SizedBox(height: 16),
                      Text(
                        failureMessage(state.failure),
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: AppStrings.loginButton,
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _submit,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
