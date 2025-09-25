import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/src/provider/core/user_provider.dart';
import 'package:my_app/src/provider/messaging/alert_provider.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isLoading = false;
  bool _initialized = false;
  bool _isPasswordVisible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final extras = GoRouterState.of(context).extra as Map<String, dynamic>?;
      _emailController = TextEditingController(
        text: extras?['email']?.toString() ?? 'jayson.sales.r@gmail.com',
      );
      _passwordController = TextEditingController(
        text: extras?['password']?.toString() ?? 'kahitano',
      );
      _initialized = true;
    }
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(email)) {
      AlertProvider.error('Please enter a valid email address');
      return;
    }

    if (password.isEmpty) {
      AlertProvider.error('Please enter your password');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.login(email: email, password: password);

      int retries = 0;
      while (!userProvider.isLoggedIn && retries < 10) {
        await Future.delayed(const Duration(milliseconds: 100));
        retries++;
      }

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (userProvider.isLoggedIn) {
        final user = userProvider.userProfile!;
        AlertProvider.success('Welcome, ${user.fullName}!');
      } else {
        AlertProvider.error('Invalid email or password');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      AlertProvider.error(e.toString());
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(onPressed: _login, child: const Text('Sign In')),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/signup'),
                child: const Text("Don't have an account? Sign Up"),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/calculator'),
                child: const Text("try to bypass to private pages"),
              ),
              TextButton(
                onPressed: () => context.go('/random_link_to_404'),
                child: const Text("random link to 404"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
