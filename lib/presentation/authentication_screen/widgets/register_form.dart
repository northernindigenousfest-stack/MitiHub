import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this import

import '../../../core/app_export.dart';

class RegisterForm extends StatefulWidget {
  final Function(
          String email, String password, String confirmPassword, String role)
      onRegister;
  final bool isLoading;

  const RegisterForm({
    Key? key,
    required this.onRegister,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isFormValid = false;
  String _selectedRole = 'Guardian';

  final List<String> _roles = ['Guardian', 'School', 'Admin'];

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _isValidEmail(_emailController.text) &&
        _passwordController.text.length >= 6 &&
        _passwordController.text == _confirmPasswordController.text;

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email); // Add missing $ at the end
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email Field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email',
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.0),
                child: CustomIconWidget(
                  iconName: 'email',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!_isValidEmail(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 2.h),

          // Password Field
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.0),
                child: CustomIconWidget(
                  iconName: 'lock',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                icon: CustomIconWidget(
                  iconName:
                      _isPasswordVisible ? 'visibility_off' : 'visibility',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 2.h),

          // Confirm Password Field
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: !_isConfirmPasswordVisible,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Confirm your password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.0),
                child: CustomIconWidget(
                  iconName: 'lock',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
                icon: CustomIconWidget(
                  iconName: _isConfirmPasswordVisible
                      ? 'visibility_off'
                      : 'visibility',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(height: 2.h),

          // Role Selection
          Text(
            'Select Role',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedRole,
                isExpanded: true,
                icon: CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                items: _roles.map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: role == 'Guardian'
                              ? 'person'
                              : role == 'School'
                                  ? 'school'
                                  : 'admin_panel_settings',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Text(
                          role,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedRole = newValue;
                    });
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 3.h),

          // Register Button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: _isFormValid && !widget.isLoading
                  ? () {
                      if (_formKey.currentState!.validate()) {
                        widget.onRegister(
                          _emailController.text.trim(),
                          _passwordController.text,
                          _confirmPasswordController.text,
                          _selectedRole,
                        );
                      }
                    }
                  : null,
              child: widget.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Create Account',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}