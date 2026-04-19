import 'package:flutter/material.dart';
import 'sections/groups_section.dart';
import 'sections/schedule_section.dart';
import 'sections/user_section.dart';
import 'sections/usage_section.dart';
import 'package:fair_share/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:fair_share/providers/locale_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fair_share/l10n/app_localizations.dart';
import 'services/language_service.dart';
import 'services/password_service.dart';
import 'screens/starter_screen.dart';
import 'widgets/password_guard.dart';
import 'services/global_timer_watcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved locale or fallback to device locale
  Locale? savedLocale = await LanguageService.loadSavedLocale();
  savedLocale ??= WidgetsBinding.instance.platformDispatcher.locale;

  // Check if password exists
  final hasPassword = await PasswordService.hasPassword();

  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleProvider(savedLocale),
      child: MyApp(showStarter: !hasPassword),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool showStarter;
  const MyApp({super.key, required this.showStarter});

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context).locale;

    return MaterialApp(
      title: 'Fair Share',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF042a50),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF021a30),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF021a30),
          selectedItemColor: Colors.lightBlue,
          unselectedItemColor: Colors.white70,
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF063a60),
          elevation: 2,
          margin: EdgeInsets.zero,
        ),
      ),
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: showStarter
          ? const StarterScreen()
          : Stack(children: const [MainScreen(), GlobalTimerWatcher()]),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1; // Default to User section (index 1)

  late final List<Widget> _screens = [
    const PasswordGuard(child: GroupsSection()), // Protected
    const UserSection(),
    const ScheduleSection(),
    const UsageSection(),
    const GlobalTimerWatcher(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        backgroundColor: const Color(0xFF021a30),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showSettingsMenu(context); // Change Password is guarded inside
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF021a30),
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.group),
            label: AppLocalizations.of(context)!.navGroups,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.navUser,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: AppLocalizations.of(context)!.navSchedule,
          ),
        ],
      ),
    );
  }
}
