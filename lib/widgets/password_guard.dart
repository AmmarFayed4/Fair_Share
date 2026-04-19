// lib/widgets/password_guard.dart
import 'package:flutter/material.dart';
import '../services/password_service.dart';
import 'package:fair_share/l10n/app_localizations.dart';

class PasswordGuard extends StatefulWidget {
  final Widget child;
  const PasswordGuard({super.key, required this.child});

  @override
  State<PasswordGuard> createState() => _PasswordGuardState();
}

class _PasswordGuardState extends State<PasswordGuard> {
  final _controller = TextEditingController();
  String? _error;
  bool _unlocked = false;

  Future<void> _check() async {
    final correct = await PasswordService.checkPassword(_controller.text);
    if (correct) {
      setState(() {
        _unlocked = true;
        _error = null;
      });
    } else {
      setState(() => _error = AppLocalizations.of(context)!.incorrectPassword);
    }
  }

  Widget _buildPasswordPrompt(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              loc.enterPasswordTitle,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: loc.passwordHint,
                hintStyle: const TextStyle(color: Colors.white54),
                errorText: _error,
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: (_) => _check(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _check,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
              ),
              child: Text(loc.unlockLabel),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If unlocked, just show the protected content
    if (_unlocked) {
      return widget.child;
    }

    final prompt = _buildPasswordPrompt(context);

    // Detect if we're already inside a Scaffold
    final hasScaffold =
        context.findAncestorWidgetOfExactType<Scaffold>() != null;

    if (hasScaffold) {
      // Inline mode (e.g., inside a tab)
      return prompt;
    } else {
      // Standalone mode (e.g., pushed from settings)
      return Scaffold(backgroundColor: const Color(0xFF042a50), body: prompt);
    }
  }
}
