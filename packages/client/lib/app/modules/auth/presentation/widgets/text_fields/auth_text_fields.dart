import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/modules/auth/auth.dart';
export 'auth_text_fields_store.dart';
export 'fields_to_show.dart';

class AuthTextFields extends HookWidget {
  final AuthTextFieldsStore store;
  final bool showWidget;

  const AuthTextFields({
    super.key,
    required this.store,
    required this.showWidget,
  });

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isPassword,
    required String? errorText,
    required bool hasError,
    required Function(String) validator,
    VoidCallback? onToggleObscured,
    bool? isObscured,
    bool? enabled,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: hasError ? Colors.red : Colors.white,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              controller: controller,
              enabled: enabled,
              onChanged: validator,
              style: const TextStyle(color: Colors.white),
              obscureText: isPassword ? (isObscured ?? true) : false,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white54),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                border: InputBorder.none,
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          isObscured ?? true
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white54,
                        ),
                        onPressed: onToggleObscured,
                      )
                    : null,
              ),
            ),
          ),
          if (hasError && errorText != null)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 4.0),
              child: Text(
                errorText,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12.0,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();
    return Observer(
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          top: screenSize.height * .0,
          bottom: useScaledSize(
            baseValue: .15,
            screenSize: screenSize,
            bumpPerHundredth: .0001,
          ),
        ),
        child: Column(
          children: List.generate(store.fieldsToShow.length, (index) {
            final field = store.fieldsToShow[index];
            final controller = store.controllers[index];
            switch (field) {
              case FieldsToShow.email:
                return _buildTextField(
                  controller: controller,
                  hint: 'Email',
                  isPassword: false,
                  errorText: store.emailErrorText,
                  hasError: store.emailHasError,
                  enabled: showWidget,
                  validator: store.onEmailChanged,
                );
              case FieldsToShow.password:
                return _buildTextField(
                  controller: controller,
                  hint: 'Password',
                  isPassword: true,
                  errorText: store.passwordErrorText,
                  hasError: store.passwordHasError,
                  onToggleObscured: () => store.toggleIsObscured(),
                  isObscured: store.isObscured,
                  enabled: showWidget,
                  validator: store.onPasswordChanged,
                );
              case FieldsToShow.fullName:
                return _buildTextField(
                  controller: controller,
                  hint: 'Full Name',
                  isPassword: false,
                  errorText: store.fullNameErrorText,
                  hasError: store.fullNameHasError,
                  enabled: showWidget,
                  validator: store.onFullNameChanged,
                );
              default:
                return const SizedBox.shrink();
            }
          }),
        ),
      ),
    );
  }
}
