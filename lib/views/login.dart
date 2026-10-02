import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:craftingrecipes/helpers/account_auth.dart';
import 'package:craftingrecipes/helpers/environment.dart';
import 'package:craftingrecipes/helpers/navigation.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/views/registration.dart';
import 'package:craftingrecipes/views/second_homepage.dart';
import 'package:craftingrecipes/widgets/auth_form_layout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool isResendingConfirmation = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final l = Languages.of(context)!;
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.enterEmailAndPassword)),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final activated = await AccountAuth.activateCurrentUser();
      if (!activated) {
        await AccountAuth.signOut();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.accountNotLinked)),
        );
        return;
      }

      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        appPageRoute(builder: (context) => const SecondHomePage()),
        (route) => false,
      );
    } on AuthException catch (e) {
      logger.w("Authentication failed: ${e.message}");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.invalidEmailOrPassword)),
      );
    } catch (e) {
      try {
        await AccountAuth.signOut();
      } catch (_) {}
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.couldNotLogIn)),
      );
      logger.e("Could not log in: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> resendConfirmationEmail() async {
    final l = Languages.of(context)!;
    final email = emailController.text.trim();
    final isValidEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);

    if (!isValidEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.enterValidEmail)),
      );
      return;
    }

    setState(() => isResendingConfirmation = true);
    try {
      await supabase.auth.resend(
        type: OtpType.signup,
        email: email,
        emailRedirectTo: kIsWeb ? null : Environment.authCallbackURL,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.confirmationEmailSent)),
      );
    } on AuthException catch (e) {
      logger.w("Could not resend confirmation email: ${e.message}");
      if (!mounted) return;
      final normalizedMessage = e.message.toLowerCase();
      final isRateLimited = normalizedMessage.contains('rate limit') ||
          normalizedMessage.contains('security purposes') ||
          normalizedMessage.contains('seconds');
      final isAlreadyConfirmed =
          normalizedMessage.contains('already confirmed');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isAlreadyConfirmed
                ? l.emailAlreadyConfirmed
                : isRateLimited
                    ? l.confirmationEmailRateLimited
                    : l.confirmationEmailCouldNotBeSent,
          ),
        ),
      );
    } catch (e) {
      logger.e("Could not resend confirmation email: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.confirmationEmailCouldNotBeSent)),
      );
    } finally {
      if (mounted) setState(() => isResendingConfirmation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return AuthFormLayout(
      title: l.login,
      icon: Icons.login,
      form: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l.email,
                prefixIcon: const Icon(Icons.email_outlined),
                filled: true,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: obscurePassword,
              autofillHints: const [AutofillHints.password],
              textInputAction: TextInputAction.done,
              onSubmitted: isLoading ? null : (_) => login(),
              decoration: InputDecoration(
                labelText: l.password,
                prefixIcon: const Icon(Icons.lock_outline),
                filled: true,
                border: const OutlineInputBorder(),
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
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                key: const Key("Login"),
                onPressed: isLoading ? null : login,
                icon: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.login),
                label: Text(l.login),
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: isLoading || isResendingConfirmation
                  ? null
                  : resendConfirmationEmail,
              icon: isResendingConfirmation
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.mark_email_unread_outlined),
              label: Text(l.resendConfirmationEmail),
            ),
          ],
        ),
      ),
      secondaryAction: TextButton.icon(
        key: const Key("Back to Registration Page"),
        onPressed: () async {
          await AccountAuth.signOut();
          if (!context.mounted) return;
          Navigator.pushReplacement(
            context,
            appReversePageRoute(
              builder: (context) => const RegistrationPage(),
            ),
          );
        },
        icon: const Icon(Icons.person_add_outlined),
        label: Text(l.createAccount),
      ),
    );
  }
}
