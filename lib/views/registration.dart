import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:craftingrecipes/helpers/account_auth.dart';
import 'package:craftingrecipes/helpers/constants.dart';
import 'package:craftingrecipes/helpers/device_info.dart';
import 'package:craftingrecipes/helpers/environment.dart';
import 'package:craftingrecipes/helpers/localstorage/supabase_to_drift.dart';
import 'package:craftingrecipes/helpers/navigation.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/views/code_scanner.dart';
import 'package:craftingrecipes/views/login.dart';
import 'package:craftingrecipes/views/second_homepage.dart';
import 'package:craftingrecipes/widgets/auth_form_layout.dart';

import 'package:craftingrecipes/objects/registration_input.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final accountNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final hostCodeController = TextEditingController();
  InputFields? scannerResponse;
  bool scanning = false;
  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmation = true;

  Future<void> validateForm() async {
    final l = Languages.of(context)!;
    final accountName = accountNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmation = confirmPasswordController.text;
    final hostCode = hostCodeController.text.trim();

    if (accountName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmation.isEmpty ||
        hostCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.fillAllFields)),
      );
      return;
    }
    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.passwordTooShort)),
      );
      return;
    }
    if (password != confirmation) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.passwordsDoNotMatch)),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      if (!await SupabaseToDrift.hostCodeIsValid(hostCode)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.invalidHostCode)),
        );
        return;
      }

      if (await SupabaseToDrift.accountNameIsRegistered(accountName)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.accountNameAlreadyExists)),
        );
        return;
      }

      final authResponse = await supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: kIsWeb ? null : Environment.authCallbackURL,
        data: {
          Const.accountName.key: accountName,
          Const.hostCode.key: hostCode,
        },
      );
      final authUser = authResponse.user;
      if (authUser == null) {
        throw const AuthException('Supabase did not create an Auth user.');
      }

      if (authResponse.session == null) {
        await AccountAuth.clearLocalIdentity();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.verifyEmailBeforeLogin)),
        );
        Navigator.of(context).pushAndRemoveUntil(
          appPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
        return;
      }

      final activated = await AccountAuth.activateCurrentUser();
      if (!activated) throw StateError(l.accountNotLinked);

      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        appPageRoute(builder: (context) => const SecondHomePage()),
        (route) => false,
      );
    } on AuthException catch (e) {
      try {
        await AccountAuth.signOut();
      } catch (_) {}
      if (!mounted) return;
      final alreadyRegistered =
          e.message.toLowerCase().contains('already registered');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            alreadyRegistered ? l.emailAlreadyExists : l.registrationFailed,
          ),
        ),
      );
      logger.e("Could not create Auth user: ${e.message}");
    } catch (e) {
      try {
        await AccountAuth.signOut();
      } catch (_) {}
      if (!mounted) return;
      final errorText = e.toString();
      final message =
          errorText.contains("23505") && errorText.contains("account_name")
              ? l.accountNameAlreadyExists
              : l.registrationFailed;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      logger.e("Could not complete profile registration: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    accountNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    hostCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final canScan = kIsWeb || DeviceInfo.isDevice() || DeviceInfo.isMacOS();
    return AuthFormLayout(
      title: l.createAccount,
      icon: Icons.person_add_outlined,
      form: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: accountNameController,
              autofillHints: const [AutofillHints.newUsername],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: l.accountName,
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: l.email,
                prefixIcon: const Icon(Icons.email_outlined),
                filled: true,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: obscurePassword,
              autofillHints: const [AutofillHints.newPassword],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: l.password,
                prefixIcon: const Icon(Icons.lock_outline),
                filled: true,
                suffixIcon: IconButton(
                  tooltip: obscurePassword ? l.showPassword : l.hidePassword,
                  onPressed: () {
                    setState(() => obscurePassword = !obscurePassword);
                  },
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: obscureConfirmation,
              autofillHints: const [AutofillHints.newPassword],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: l.confirmPassword,
                prefixIcon: const Icon(Icons.lock_reset_outlined),
                filled: true,
                suffixIcon: IconButton(
                  tooltip:
                      obscureConfirmation ? l.showPassword : l.hidePassword,
                  onPressed: () {
                    setState(
                      () => obscureConfirmation = !obscureConfirmation,
                    );
                  },
                  icon: Icon(
                    obscureConfirmation
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: hostCodeController,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => validateForm(),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: l.hostCode,
                prefixIcon: const Icon(Icons.key_outlined),
                filled: true,
                suffixIcon: canScan
                    ? IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        tooltip: l.scanner,
                        onPressed: isLoading ? null : _scanRegistrationCode,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: isLoading ? null : validateForm,
                icon: isLoading
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.person_add_outlined),
                label: Text(l.createAccount),
              ),
            ),
          ],
        ),
      ),
      secondaryAction: TextButton.icon(
        onPressed: isLoading
            ? null
            : () {
                Navigator.pushReplacement(
                  context,
                  appPageRoute(builder: (context) => const LoginPage()),
                );
              },
        icon: const Icon(Icons.login),
        label: Text(l.alreadyHaveAccount),
      ),
    );
  }

  Future<void> _scanRegistrationCode() async {
    final l = Languages.of(context)!;
    scannerResponse = await Navigator.of(context).push(
      appPageRoute(
        builder: (context) => CodeScanner(
          onDetect: (capture) {
            if (scanning) return;
            scanning = true;
            final List<Barcode> barcodes = capture.barcodes;
            final barcode = barcodes.firstOrNull;
            if (barcode == null) {
              logger.w('No barcodes found.');
              return;
            }
            debugPrint(
              'Barcode found! (REGISTRATION) ${barcode.rawValue}',
            );
            try {
              final Map<String, dynamic> response =
                  json.decode(barcode.rawValue!);
              final String? accountName = response[Const.accountName.key];
              final String? email = response[Const.email.key];
              final String? hostCode = response[Const.hostCode.key];
              if (accountName == null || email == null || hostCode == null) {
                throw Exception();
              }

              if (mounted) {
                Navigator.pop(
                  context,
                  InputFields(
                    accountName: accountName,
                    email: email,
                    hostCode: hostCode,
                  ),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l.invalidScannedCode)),
                );
                Navigator.pop(context);
              }
            }
          },
        ),
        fullScreenSwipeBack: true,
      ),
    );
    if (!mounted) return;
    setState(() {
      if (scannerResponse != null) {
        accountNameController.text = scannerResponse!.accountName;
        emailController.text = scannerResponse!.email;
        hostCodeController.text = scannerResponse!.hostCode;
      }
      Future.delayed(const Duration(seconds: 3), () {
        scanning = false;
      });

      logger.i("Scanner response: $scannerResponse");
    });
  }
}
