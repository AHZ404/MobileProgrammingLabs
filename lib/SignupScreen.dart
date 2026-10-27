import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'Validators.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;

  const SignupScreen({
    super.key,
    this.onToggleTheme,
  });

  @override
  State<SignupScreen> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      context.go('/welcome', extra: nameController.text.trim());
    }
  }

  InputDecoration buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nameController,
                decoration: buildInputDecoration('Name'),
                validator: Validators.validateName,
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: buildInputDecoration('Email'),
                validator: Validators.validateEmail,
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: buildInputDecoration('Phone'),
                validator: Validators.validatePhone,
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: submitForm,
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}