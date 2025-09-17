import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/src/provider/core/auth_provider.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = await authProvider.login(email, password);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (user != null) {
          context.go('/home', extra: user);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Welcome, ${user.fullName}!'),
                duration: const Duration(seconds: 3),
              ),
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid email or password'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } on Exception catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
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
