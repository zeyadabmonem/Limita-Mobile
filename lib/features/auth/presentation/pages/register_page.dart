import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/state/view_state.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/register_usecase.dart';
import '../bloc/register_bloc.dart';
import '../widgets/auth_text_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => sl<RegisterBloc>(),
        child: const _RegisterView(),
      );
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<RegisterBloc>().register(RegisterParams(
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          password: _passwordController.text,
        ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: BlocConsumer<RegisterBloc, ViewState<UserEntity>>(
            listener: (context, state) {
              if (state is ViewSuccess<UserEntity>) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Account created. Please sign in.')),
                );
                context.goNamed(RouteNames.login);
              }
            },
            builder: (context, state) {
              final isLoading = state.isLoading;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(AppStrings.createAccount,
                          style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: 8),
                      Text('Create an account to get started.',
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 32),
                      AuthTextField(
                          controller: _fullNameController,
                          label: AppStrings.fullName,
                          textInputAction: TextInputAction.next,
                          validator: _fullNameValidator),
                      const SizedBox(height: 16),
                      AuthTextField(
                          controller: _emailController,
                          label: AppStrings.email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          validator: _emailValidator),
                      const SizedBox(height: 16),
                      AuthTextField(
                          controller: _phoneController,
                          label: AppStrings.phoneNumber,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.telephoneNumber],
                          validator: _phoneValidator),
                      const SizedBox(height: 16),
                      AuthTextField(
                        controller: _passwordController,
                        label: AppStrings.password,
                        obscureText: !_passwordVisible,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.newPassword],
                        validator: _passwordValidator,
                        suffixIcon: IconButton(
                          icon: Icon(_passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(
                              () => _passwordVisible = !_passwordVisible),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        controller: _confirmPasswordController,
                        label: AppStrings.confirmPassword,
                        obscureText: !_confirmPasswordVisible,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        validator: _confirmPasswordValidator,
                        suffixIcon: IconButton(
                          icon: Icon(_confirmPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(() =>
                              _confirmPasswordVisible =
                                  !_confirmPasswordVisible),
                        ),
                      ),
                      if (state is ViewError<UserEntity>) ...[
                        const SizedBox(height: 16),
                        Text(failureMessage(state.failure),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error)),
                      ],
                      const SizedBox(height: 24),
                      PrimaryButton(
                          label: AppStrings.registerButton,
                          isLoading: isLoading,
                          onPressed: isLoading ? null : _submit),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(AppStrings.haveAccount),
                            TextButton(
                                onPressed: isLoading
                                    ? null
                                    : () => context.goNamed(RouteNames.login),
                                child: const Text(AppStrings.loginButton)),
                          ]),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );

  String? _fullNameValidator(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Full name is required.';
    return name.length <= 150
        ? null
        : 'Full name must be at most 150 characters.';
  }

  String? _emailValidator(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required.';
    if (email.length > 256) return 'Email must be at most 256 characters.';
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
        ? null
        : 'Enter a valid email address.';
  }

  String? _phoneValidator(String? value) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) return 'Phone number is required.';
    if (phone.length > 20) return 'Phone number must be at most 20 characters.';
    return RegExp(r'^[0-9+() -]+$').hasMatch(phone)
        ? null
        : 'Enter a valid phone number.';
  }

  String? _passwordValidator(String? value) => (value ?? '').length >= 8
      ? null
      : 'Password must be at least 8 characters.';

  String? _confirmPasswordValidator(String? value) =>
      value == _passwordController.text ? null : 'Passwords do not match.';
}
