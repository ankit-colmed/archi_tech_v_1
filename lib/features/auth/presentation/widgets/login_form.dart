import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/button_widgets.dart';
import '../../../../core/widgets/input_widgets.dart';
import '../../../../core/widgets/spacing_widgets.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Login form widget
class LoginForm extends StatefulWidget {
  final bool isIOSStyle;

  const LoginForm({
    super.key,
    this.isIOSStyle = false,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailRequired;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return AppStrings.emailInvalid;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value.length < 6) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state.isLoading;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email field
              EmailTextField(
                controller: _emailController,
                label: AppStrings.email,
                hint: AppStrings.emailHint,
                focusNode: _emailFocusNode,
                textInputAction: TextInputAction.next,
                enabled: !isLoading,
                validator: _validateEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
              ),

              const VerticalSpace.m(),

              // Password field
              PasswordTextField(
                controller: _passwordController,
                label: AppStrings.password,
                hint: AppStrings.passwordHint,
                focusNode: _passwordFocusNode,
                textInputAction: TextInputAction.done,
                enabled: !isLoading,
                validator: _validatePassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onSubmitted: (_) => _onLogin(),
              ),

              const VerticalSpace.s(),

              // Forgot password link
              Align(
                alignment: Alignment.centerRight,
                child: AppTextButton(
                  text: AppStrings.forgotPassword,
                  onPressed: isLoading ? null : () {
                    // TODO: Implement forgot password
                  },
                ),
              ),

              const VerticalSpace.l(),

              // Login button
              widget.isIOSStyle
                  ? _buildIOSLoginButton(isLoading)
                  : PrimaryButton(
                      text: AppStrings.login,
                      onPressed: isLoading ? null : _onLogin,
                      isLoading: isLoading,
                    ),

              const VerticalSpace.l(),

              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    AppStrings.dontHaveAccount,
                    style: TextStyle(
                      fontSize: AppDimensions.fontM,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppTextButton(
                    text: AppStrings.signUp,
                    onPressed: isLoading ? null : () {
                      // TODO: Implement sign up navigation
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIOSLoginButton(bool isLoading) {
    return GestureDetector(
      onTap: isLoading ? null : _onLogin,
      child: Container(
        height: AppDimensions.buttonHeightL,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primary.withBlue(255),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  AppStrings.login,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
        ),
      ),
    );
  }
}
