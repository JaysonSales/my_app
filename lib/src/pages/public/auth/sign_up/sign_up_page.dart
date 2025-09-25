import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/src/provider/core/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:my_app/src/provider/messaging/alert_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  Future<void> _handleSignUp() async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please check errors before signing up"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final formData = _formKey.currentState!.value;
    final userProvider = Provider.of<UserProvider>(context);

    final email = formData['email']?.toString().trim();
    final password = formData['password']?.toString();

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(email ?? '')) {
      AlertProvider.error("Invalid email address");

      return;
    }

    if ((password ?? '').length < 6) {
      AlertProvider.error("Password must be at least 6 characters");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await userProvider.register(
        email: email!,
        password: password!,
        firstName: formData['firstName'],
        lastName: formData['lastName'],
        middleName: formData['middleName'],
        birthDate: formData['birthDate'],
        location: formData['location'],
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sign up successful!"),
          backgroundColor: Colors.green,
        ),
      );

      context.go('/');
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: code=${e.code}, message=${e.message}');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sign up failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'email',
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                ]),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'password',
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(6),
                ]),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'confirm_password',
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (val) {
                  final password =
                      _formKey.currentState?.fields['password']?.value;
                  if (val == null || val.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (val != password) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'firstName',
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'middleName',
                decoration: const InputDecoration(
                  labelText: 'Middle Name (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'lastName',
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              FormBuilderDateTimePicker(
                name: 'birthDate',
                inputType: InputType.date,
                decoration: const InputDecoration(
                  labelText: 'Birthdate',
                  border: OutlineInputBorder(),
                ),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'location',
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _handleSignUp,
                      child: const Text('Sign Up'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
