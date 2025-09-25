import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/snack_bar.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showForm = true;
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login() {
    String username = _usernameController.text;
    String password = _passwordController.text;
    final authCubit = context.read<AuthCubit>();

    if (username.isNotEmpty && password.isNotEmpty) {
      authCubit.login(_usernameController.text, _passwordController.text);
    } else {
      showAppSnackBar(
        context,
        'Please enter both email and password',
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          showForm = !showForm;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (showForm) ...[
                      Container(
                        width: 350, // fixed width for the card
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 12,
                              spreadRadius: 2,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //Text
                            Text(
                              'Please Sign in',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                                letterSpacing: 1.2,
                                shadows: [
                                  Shadow(
                                    blurRadius: 4,
                                    color: Colors.black26,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: 16),
                            // username
                            SizedBox(
                              width: 300,
                              child: Mytextfield(
                                hintText: 'Username',
                                obscureText: false,
                                controller: _usernameController,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // password
                            SizedBox(
                              width: 300,
                              child: Mytextfield(
                                hintText: 'Password',
                                obscureText: true,
                                controller: _passwordController,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // login button
                            SizedBox(
                              width: 300,
                              child: MyButton(
                                text: 'Login',
                                onTap: () {
                                  login();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
