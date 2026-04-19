import 'package:flutter/material.dart';
import 'package:fair_share/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:fair_share/providers/locale_provider.dart';
import '../widgets/password_guard.dart';
import '../services/password_service.dart';

void showSettingsMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF063a70),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.language, color: Colors.white),
            title: Text(
              AppLocalizations.of(context)!.changeLanguage,
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              showLanguageDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.white),
            title: Text(
              AppLocalizations.of(context)!.changePassword,
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PasswordGuard(child: const ChangePasswordFormScreen()),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}

void showLanguageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.changeLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('العربية'),
              onTap: () {
                Navigator.pop(context);
                setLocale(context, const Locale('ar'));
              },
            ),
            ListTile(
              title: const Text('English'),
              onTap: () {
                Navigator.pop(context);
                setLocale(context, const Locale('en'));
              },
            ),
          ],
        ),
      );
    },
  );
}

class ChangePasswordFormScreen extends StatefulWidget {
  const ChangePasswordFormScreen({super.key});

  @override
  State<ChangePasswordFormScreen> createState() =>
      _ChangePasswordFormScreenState();
}

class _ChangePasswordFormScreenState extends State<ChangePasswordFormScreen> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF042a50),
      appBar: AppBar(
        title: Text(loc.changePassword),
        backgroundColor: const Color(0xFF021a30),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: loc.passwordHint),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: loc.confirmPasswordHint),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final newPassword = newPasswordController.text;
                final confirmPassword = confirmPasswordController.text;

                if (newPassword != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.passwordMismatchError)),
                  );
                } else if (newPassword.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.passwordEmptyError)),
                  );
                } else {
                  await PasswordService.setPassword(newPassword);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(loc.passwordUpdated)));
                }
              },
              child: Text(loc.saveLabel),
            ),
          ],
        ),
      ),
    );
  }
}

void setLocale(BuildContext context, Locale locale) {
  Provider.of<LocaleProvider>(context, listen: false).setLocale(locale);
}
