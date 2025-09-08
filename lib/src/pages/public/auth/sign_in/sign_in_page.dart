import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/src/service/core/auth_service.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    final user = await authService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (user != null) {
        context.go('/home', extra: user);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
      appBar: AppBar(title: const Text('Sign In')),
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
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 24.0),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(onPressed: _login, child: const Text('Sign In')),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.go('/signup');
                },
                child: const Text("Don't have an account? Sign Up"),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.go('/home');
                },
                child: const Text("try to bypass to /home"),
              ),
              TextButton(
                onPressed: () {
                  context.go('/random_link_to_404');
                },
                child: const Text("random link to 404"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
