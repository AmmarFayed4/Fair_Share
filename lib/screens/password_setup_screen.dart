// lib/screens/password_setup_screen.dart
import 'package:fair_share/main.dart';
import 'package:flutter/material.dart';
import '../services/password_service.dart';
import 'package:fair_share/l10n/app_localizations.dart';

class PasswordSetupScreen extends StatefulWidget {
  const PasswordSetupScreen({super.key});

  @override
  State<PasswordSetupScreen> createState() => _PasswordSetupScreenState();
}

class _PasswordSetupScreenState extends State<PasswordSetupScreen> {
  final _controller = TextEditingController();
  final _confirmController = TextEditingController();
  String? _error;

  Future<void> _savePassword() async {
    final loc = AppLocalizations.of(context)!;
    if (_controller.text.isEmpty || _confirmController.text.isEmpty) {
      setState(() => _error = loc.passwordEmptyError);
      return;
    }
    if (_controller.text != _confirmController.text) {
      setState(() => _error = loc.passwordMismatchError);
      return;
    }
    await PasswordService.setPassword(_controller.text);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF042a50),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF063a70),
            borderRadius: BorderRadius.circular(12),
          ),
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                loc.setPasswordTitle,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: loc.passwordHint,
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirmController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: loc.confirmPasswordHint,
                  hintStyle: const TextStyle(color: Colors.white54),
                  errorText: _error,
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _savePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                ),
                child: Text(loc.saveLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
