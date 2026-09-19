import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

const bg = Color(0xFFF6F8FA);
const card = Color(0xFFFFFFFF);
const card2 = Color(0xFFF1F5F7);
const green = Color(0xFF00E0A8);
const greenDark = Color(0xFF00A980);
const white = Color(0xFF17212B);
const muted = Color(0xFF66727D);
const gold = Color(0xFFFFC857);

// ============================================================
// LANGUAGE / LOCALIZATION
// ============================================================

final ValueNotifier<String> appLanguage = ValueNotifier<String>('English');

const Map<String, String> _urdu = {
  'Your Luck. Your Moment.': 'آپ کی قسمت، آپ کا موقع۔',
  'Welcome to LUCKIVA': 'LUCKIVA میں خوش آمدید',
  'Your account is ready.': 'آپ کا اکاؤنٹ تیار ہے۔',
  'Draw Update': 'ڈرا اپ ڈیٹ',
  'New draw information is available.': 'نئی ڈرا معلومات دستیاب ہیں۔',
  'Results Published': 'نتائج شائع ہو گئے ہیں۔',
  'Latest results are now available.': 'تازہ ترین نتائج دستیاب ہیں۔',
  'New notification received.': 'نئی اطلاع موصول ہوئی ہے۔',
  'LUCKIVA EXPERIENCE': 'LUCKIVA تجربہ',
  'Discover upcoming draws, prizes and transparent results in one place.':
      'آنے والے ڈراز، انعامات اور شفاف نتائج ایک ہی جگہ دیکھیں۔',
  'Explore Draws': 'ڈراز دیکھیں',
  'Featured': 'نمایاں',
  'Top Prize': 'سب سے بڑا انعام',
  'Clear Info': 'واضح معلومات',
  'Featured Draws': 'نمایاں ڈراز',
  'View all': 'سب دیکھیں',
  'How LUCKIVA Works': 'LUCKIVA کیسے کام کرتا ہے',
  'Explore': 'دیکھیں',
  'Choose': 'منتخب کریں',
  'Results': 'نتائج',
  'Transparency First': 'شفافیت سب سے پہلے',
  'Clear draw information, published results and a professional user experience.':
      'واضح ڈرا معلومات، شائع شدہ نتائج اور بہترین صارف تجربہ۔',
  'Choose a LUCKIVA draw experience.': 'اپنی LUCKIVA ڈرا کا انتخاب کریں۔',
  'Special Draw': 'خصوصی ڈرا',
  'Published result examples for the prototype.': 'نمونہ نتائج۔',
  'Guest User': 'مہمان صارف',
  'Create an account to continue': 'جاری رکھنے کے لیے اکاؤنٹ بنائیں',
  'Login / Create Account': 'لاگ اِن / اکاؤنٹ بنائیں',
  'Notifications': 'اطلاعات',
  'Trust & Transparency': 'اعتماد اور شفافیت',
  'Help & Support': 'مدد اور سپورٹ',
  'About LUCKIVA': 'LUCKIVA کے بارے میں',
  'Logout': 'لاگ آؤٹ',
  'Language': 'زبان',
  'English': 'English',
  'Urdu': 'اردو',
  'No notifications': 'کوئی اطلاع نہیں',
  'Draw Details': 'ڈرا کی تفصیلات',
  'Payment Method': 'ادائیگی کا طریقہ',
  'Continue - Prototype': 'جاری رکھیں - پروٹوٹائپ',
  'QR Code': 'QR کوڈ',
  'Order Summary': 'آرڈر کا خلاصہ',
  'Screenshot added': 'اسکرین شاٹ شامل ہو گیا',
  'Payment Screenshot': 'ادائیگی کا اسکرین شاٹ',
  'Prototype attachment selected': 'پروٹوٹائپ اٹیچمنٹ منتخب ہے',
  'Add a payment screenshot': 'ادائیگی کا اسکرین شاٹ شامل کریں',
  'Prototype Payment Successful': 'پروٹوٹائپ ادائیگی کامیاب',
  'Transaction ID': 'ٹرانزیکشن آئی ڈی',
  'Back to Home': 'ہوم پر واپس جائیں',
  'Email and password are required.': 'ای میل اور پاس ورڈ ضروری ہیں۔',
  'Please enter your name.': 'براہِ کرم اپنا نام درج کریں۔',
  'Password must be at least 6 characters.':
      'پاس ورڈ کم از کم 6 حروف کا ہونا چاہیے۔',
  'Account created successfully.': 'اکاؤنٹ کامیابی سے بن گیا۔',
  'Welcome back!': 'دوبارہ خوش آمدید!',
  'This email is already registered.': 'یہ ای میل پہلے سے رجسٹرڈ ہے۔',
  'Please enter a valid email address.': 'براہِ کرم درست ای میل درج کریں۔',
  'Password is too weak.': 'پاس ورڈ بہت کمزور ہے۔',
  'No account found with this email.': 'اس ای میل سے کوئی اکاؤنٹ نہیں ملا۔',
  'Email or password is incorrect.': 'ای میل یا پاس ورڈ غلط ہے۔',
  'Too many attempts. Please try again later.':
      'بہت زیادہ کوششیں ہوئیں۔ بعد میں دوبارہ کوشش کریں۔',
  'Authentication failed.': 'تصدیق ناکام ہو گئی۔',
  'Something went wrong. Please try again.':
      'کچھ غلط ہو گیا۔ دوبارہ کوشش کریں۔',
  'Enter your email first.': 'پہلے اپنی ای میل درج کریں۔',
  'Password reset email sent. Check your inbox.':
      'پاس ورڈ ری سیٹ ای میل بھیج دی گئی ہے۔ اپنا ان باکس چیک کریں۔',
  'Unable to send reset email.': 'ری سیٹ ای میل نہیں بھیجی جا سکی۔',
  'Welcome Back': 'دوبارہ خوش آمدید',
  'Create Account': 'اکاؤنٹ بنائیں',
  'Create your LUCKIVA account': 'اپنا LUCKIVA اکاؤنٹ بنائیں',
  'Sign in to LUCKIVA': 'LUCKIVA میں لاگ اِن کریں',
  'Join the LUCKIVA experience': 'LUCKIVA کا حصہ بنیں',
  'Access your account securely': 'اپنے اکاؤنٹ تک محفوظ رسائی حاصل کریں',
  'Full Name': 'پورا نام',
  'Your name': 'آپ کا نام',
  'Email': 'ای میل',
  'Password': 'پاس ورڈ',
  'Minimum 6 characters': 'کم از کم 6 حروف',
  'Forgot password?': 'پاس ورڈ بھول گئے؟',
  'Login': 'لاگ اِن',
  'Already have an account? Login': 'پہلے سے اکاؤنٹ ہے؟ لاگ اِن کریں',
  'New here? Create an account': 'نئے ہیں؟ اکاؤنٹ بنائیں',
  'Home': 'ہوم',
  'Draws': 'ڈراز',
};

String t(String key) => appLanguage.value == 'Urdu' ? (_urdu[key] ?? key) : key;

void setAppLanguage(String language) {
  appLanguage.value = language;
}

class AppNotificationItem {
  final String title;
  final String body;
  final DateTime time;

  const AppNotificationItem({
    required this.title,
    required this.body,
    required this.time,
  });
}

class NotificationStore extends ChangeNotifier {
  NotificationStore._();
  static final NotificationStore instance = NotificationStore._();

  final List<AppNotificationItem> _items = [
    AppNotificationItem(
      title: 'Welcome to LUCKIVA',
      body: 'Your account is ready.',
      time: DateTime(2026, 9, 7),
    ),
    AppNotificationItem(
      title: 'Draw Update',
      body: 'New draw information is available.',
      time: DateTime(2026, 9, 7),
    ),
    AppNotificationItem(
      title: 'Results Published',
      body: 'Latest results are now available.',
      time: DateTime(2026, 9, 7),
    ),
  ];

  List<AppNotificationItem> get items => List.unmodifiable(_items);

  void add(String title, String body) {
    _items.insert(
      0,
      AppNotificationItem(title: title, body: body, time: DateTime.now()),
    );
    notifyListeners();
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('FCM BACKGROUND: ${message.notification?.title}');
}

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final title =
        message.notification?.title ?? message.data['title'] ?? 'LUCKIVA';
    final body =
        message.notification?.body ??
        message.data['body'] ??
        'New notification received.';
    NotificationStore.instance.add(title, body);
    debugPrint('FCM MESSAGE RECEIVED: $title');
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    final title =
        message.notification?.title ?? message.data['title'] ?? 'LUCKIVA';
    final body =
        message.notification?.body ??
        message.data['body'] ??
        'Notification opened.';
    NotificationStore.instance.add(title, body);
    appNavigatorKey.currentState?.push(
      MaterialPageRoute<void>(builder: (_) => const NotificationsPage()),
    );
  });

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  final token = await FirebaseMessaging.instance.getToken();
  debugPrint('FCM TOKEN: $token');

  runApp(const WinmaxApp());

  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    final title =
        initialMessage.notification?.title ??
        initialMessage.data['title'] ??
        'LUCKIVA';
    final body =
        initialMessage.notification?.body ??
        initialMessage.data['body'] ??
        'Notification opened.';
    NotificationStore.instance.add(title, body);
  }
}

class WinmaxApp extends StatelessWidget {
  const WinmaxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: appLanguage,
      builder: (context, language, _) {
        return MaterialApp(
          navigatorKey: appNavigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'LUCKIVA',
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: bg,
            colorScheme: ColorScheme.fromSeed(
              seedColor: green,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            fontFamily: 'Arial',
          ),
          home: AuthGate(key: ValueKey(language)),
        );
      },
    );
  }
}

// ============================================================
// AUTH GATE
// ============================================================

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        return const MainNavigation();
      },
    );
  }
}

// ============================================================
// SPLASH
// ============================================================

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.confirmation_num_rounded, color: green, size: 64),
            SizedBox(height: 18),
            Text(
              'LUCKIVA',
              style: TextStyle(
                color: white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 8),
            Text(
              t('Your Luck. Your Moment.'),
              style: TextStyle(color: muted, fontSize: 13),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2, color: green),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// MAIN NAVIGATION
// ============================================================

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;

  final pages = const [HomePage(), DrawsPage(), ResultsPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        backgroundColor: Colors.white,
        indicatorColor: green.withOpacity(.15),
        onDestinationSelected: (value) {
          setState(() => index = value);
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: t('Home'),
          ),
          NavigationDestination(
            icon: Icon(Icons.confirmation_num_outlined),
            selectedIcon: Icon(Icons.confirmation_num_rounded),
            label: t('Draws'),
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events_rounded),
            label: t('Results'),
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: t('Profile'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HOME
// ============================================================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: green.withOpacity(.12),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: green.withOpacity(.25)),
                    ),
                    child: const Icon(
                      Icons.confirmation_num_rounded,
                      color: green,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LUCKIVA',
                          style: TextStyle(
                            color: white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          t('Your Luck. Your Moment.'),
                          style: TextStyle(color: muted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  ListenableBuilder(
                    listenable: NotificationStore.instance,
                    builder: (context, _) {
                      final count = NotificationStore.instance.items.length;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            tooltip: 'Notifications',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const NotificationsPage(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              color: white,
                            ),
                          ),
                          if (count > 0)
                            Positioned(
                              right: 4,
                              top: 3,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  count > 9 ? '9+' : '$count',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // HERO
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                constraints: const BoxConstraints(minHeight: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFE8FFF7), Color(0xFFF8FFFC)],
                  ),
                  border: Border.all(color: green.withOpacity(.20)),
                  boxShadow: [
                    BoxShadow(
                      color: green.withOpacity(.07),
                      blurRadius: 35,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -45,
                      top: -45,
                      child: Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: green.withOpacity(.08),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 28,
                      top: 35,
                      child: Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF2F0),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: green.withOpacity(.25)),
                        ),
                        child: const Icon(
                          Icons.emoji_events_rounded,
                          color: gold,
                          size: 48,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 25, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: green.withOpacity(.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'LUCKIVA EXPERIENCE',
                              style: TextStyle(
                                color: green,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          const SizedBox(
                            width: 220,
                            child: Text(
                              'Your Luck. Your Moment.',
                              style: TextStyle(
                                color: white,
                                fontSize: 31,
                                height: 1.12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const SizedBox(
                            width: 260,
                            child: Text(
                              'Discover upcoming draws, prizes and transparent results in one place.',
                              style: TextStyle(
                                color: muted,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const DrawsPageStandalone(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.arrow_forward_rounded,
                                size: 19,
                              ),
                              label: const Text(
                                'Explore Draws',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: green,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // STATS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Row(
                children: const [
                  Expanded(
                    child: StatCard(
                      value: '3',
                      label: 'Featured',
                      icon: Icons.auto_awesome_rounded,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      value: '100K',
                      label: 'Top Prize',
                      icon: Icons.workspace_premium_rounded,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      value: '100%',
                      label: 'Clear Info',
                      icon: Icons.verified_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // FEATURED
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Featured Draws',
              action: 'View all',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DrawsPageStandalone(),
                  ),
                );
              },
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  DrawCard(
                    title: 'LUCKIVA Mega Draw',
                    prize: 'Rs. 100,000',
                    entry: 'Rs. 20 Entry',
                    icon: Icons.emoji_events_rounded,
                    highlighted: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DrawDetailsPage(
                            title: 'LUCKIVA Mega Draw',
                            prize: 'Rs. 100,000',
                            entry: 'Rs. 20',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  DrawCard(
                    title: 'LUCKIVA Lucky Draw',
                    prize: 'Rs. 25,000',
                    entry: 'Rs. 5 Entry',
                    icon: Icons.stars_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DrawDetailsPage(
                            title: 'LUCKIVA Lucky Draw',
                            prize: 'Rs. 25,000',
                            entry: 'Rs. 5',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // HOW IT WORKS
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'How LUCKIVA Works',
              action: null,
              onTap: null,
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  Expanded(
                    child: StepCard(
                      number: '01',
                      title: 'Explore',
                      icon: Icons.search_rounded,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: StepCard(
                      number: '02',
                      title: 'Choose',
                      icon: Icons.touch_app_rounded,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: StepCard(
                      number: '03',
                      title: 'Results',
                      icon: Icons.emoji_events_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // TRUST
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.black.withOpacity(.06)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.shield_rounded, color: green, size: 30),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transparency First',
                            style: TextStyle(
                              color: white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Clear draw information, published results and a professional user experience.',
                            style: TextStyle(
                              color: muted,
                              fontSize: 12,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// STAT CARD
// ============================================================

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(.05)),
      ),
      child: Column(
        children: [
          Icon(icon, color: green, size: 20),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              color: white,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: muted, fontSize: 9),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SECTION HEADER
// ============================================================

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onTap;

  const SectionHeader({
    super.key,
    required this.title,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              t(title),
              style: const TextStyle(
                color: white,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          if (action != null)
            GestureDetector(
              onTap: onTap,
              child: const Text(
                'View all',
                style: TextStyle(
                  color: green,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// DRAW CARD
// ============================================================

class DrawCard extends StatefulWidget {
  final String title;
  final String prize;
  final String entry;
  final IconData icon;
  final bool highlighted;
  final VoidCallback onTap;
  final DrawCountdownType countdownType;

  const DrawCard({
    super.key,
    required this.title,
    required this.prize,
    required this.entry,
    required this.icon,
    required this.onTap,
    this.countdownType = DrawCountdownType.daily,
    this.highlighted = false,
  });

  @override
  State<DrawCard> createState() => _DrawCardState();
}

enum DrawCountdownType { daily, weekly, monthly, sixMonth }

class _DrawCardState extends State<DrawCard> {
  late Timer _timer;
  late Duration _remaining;
  bool _pulse = false;
  double _coinAngle = 0.0;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _pulse = !_pulse;
          _coinAngle += 0.22;
          _updateRemaining();
        });
      }
    });
  }

  DateTime _nextDrawTime() {
    final now = DateTime.now();

    switch (widget.countdownType) {
      case DrawCountdownType.daily:
        return DateTime(now.year, now.month, now.day + 1);
      case DrawCountdownType.weekly:
        final daysUntilMonday = (DateTime.monday - now.weekday + 7) % 7;
        final days = daysUntilMonday == 0 ? 7 : daysUntilMonday;
        return DateTime(now.year, now.month, now.day + days);
      case DrawCountdownType.monthly:
        return now.month == 12
            ? DateTime(now.year + 1, 1, 1)
            : DateTime(now.year, now.month + 1, 1);
      case DrawCountdownType.sixMonth:
        final nextMonth = now.month <= 6 ? 7 : 1;
        final nextYear = now.month <= 6 ? now.year : now.year + 1;
        return DateTime(nextYear, nextMonth, 1);
    }
  }

  void _updateRemaining() {
    final d = _nextDrawTime().difference(DateTime.now());
    _remaining = d.isNegative ? Duration.zero : d;
  }

  String _formatCountdown(Duration d) {
    final days = d.inDays;
    final h = d.inHours.remainder(24).toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return days > 0 ? '${days}d ${h}h ${m}m ${s}s' : '${h}h ${m}m ${s}s';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          gradient: widget.highlighted
              ? LinearGradient(colors: [green.withOpacity(.14), card])
              : null,
          color: widget.highlighted ? null : card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: widget.highlighted
                ? green.withOpacity(.22)
                : Colors.black.withOpacity(.05),
          ),
        ),
        child: Stack(
          children: [
            // Soft floating decorative coins — visual only.
            Positioned(
              right: 34,
              top: 7,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..translate(0.0, _pulse ? -3.0 : 3.0)
                  ..rotateY(_coinAngle),
                child: _coinDecoration(size: 18),
              ),
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..translate(0.0, _pulse ? 3.0 : -3.0)
                  ..rotateY(-_coinAngle * 0.7),
                child: _coinDecoration(size: 14),
              ),
            ),
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 650),
                  width: _pulse ? 59 : 55,
                  height: _pulse ? 59 : 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.highlighted
                          ? [Color(0xFFFFE8A3), Color(0xFFFFC857)]
                          : [Color(0xFFEFFFF8), Color(0xFFDDF8EE)],
                    ),
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(
                      color: widget.highlighted
                          ? gold.withOpacity(.45)
                          : green.withOpacity(.22),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (widget.highlighted ? gold : green).withOpacity(
                          _pulse ? .20 : .08,
                        ),
                        blurRadius: _pulse ? 16 : 7,
                        spreadRadius: _pulse ? 2 : 0,
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.highlighted ? Color(0xFF9A6A00) : greenDark,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.prize,
                        style: const TextStyle(
                          color: greenDark,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.entry,
                        style: const TextStyle(color: muted, fontSize: 11),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            color: gold,
                            size: 14,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              _formatCountdown(_remaining),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFFB47A00),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: muted,
                  size: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _coinDecoration({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF2B8), Color(0xFFFFC857), Color(0xFFD99A16)],
        ),
        border: Border.all(color: Color(0xFFE0A92B), width: 1),
        boxShadow: [
          BoxShadow(
            color: gold.withOpacity(.20),
            blurRadius: 7,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.monetization_on_rounded,
          size: size * .62,
          color: Color(0xFF9A6A00),
        ),
      ),
    );
  }
}

// ============================================================
// STEP CARD
// ============================================================

class StepCard extends StatelessWidget {
  final String number;
  final String title;
  final IconData icon;

  const StepCard({
    super.key,
    required this.number,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              color: green,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Icon(icon, color: white, size: 22),
          const SizedBox(height: 8),
          Text(
            t(title),
            style: const TextStyle(
              color: white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DRAWS PAGE
// ============================================================

class DrawsPageStandalone extends StatelessWidget {
  const DrawsPageStandalone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(child: DrawsPageContent()),
    );
  }
}

class DrawsPage extends StatelessWidget {
  const DrawsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: DrawsPageContent());
  }
}

class DrawsPageContent extends StatelessWidget {
  const DrawsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 22, 20, 8),
            child: Text(
              'Explore Draws',
              style: TextStyle(
                color: white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Text(
              'Choose a LUCKIVA draw experience.',
              style: TextStyle(color: muted, fontSize: 13),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              DrawCard(
                title: 'LUCKIVA Daily Draw',
                prize: 'Rs. 25,000',
                entry: 'Rs. 1 Entry',
                icon: Icons.today_rounded,
                countdownType: DrawCountdownType.daily,
                highlighted: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DrawDetailsPage(
                        title: 'LUCKIVA Daily Draw',
                        prize: 'Rs. 25,000',
                        entry: 'Rs. 1',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              DrawCard(
                title: 'LUCKIVA Weekly Draw',
                prize: 'Rs. 100,000',
                entry: 'Rs. 5 Entry',
                icon: Icons.calendar_view_week_rounded,
                countdownType: DrawCountdownType.weekly,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DrawDetailsPage(
                        title: 'LUCKIVA Weekly Draw',
                        prize: 'Rs. 100,000',
                        entry: 'Rs. 5',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              DrawCard(
                title: 'LUCKIVA Monthly Draw',
                prize: 'Rs. 1,000,000',
                entry: 'Rs. 100 Entry',
                icon: Icons.calendar_month_rounded,
                countdownType: DrawCountdownType.monthly,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DrawDetailsPage(
                        title: 'LUCKIVA Monthly Draw',
                        prize: 'Rs. 1,000,000',
                        entry: 'Rs. 100',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              DrawCard(
                title: 'LUCKIVA 6-Month Special',
                prize: 'Rs. 10,000,000',
                entry: 'Special Draw',
                icon: Icons.workspace_premium_rounded,
                countdownType: DrawCountdownType.sixMonth,
                highlighted: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DrawDetailsPage(
                        title: 'LUCKIVA 6-Month Special',
                        prize: 'Rs. 10,000,000',
                        entry: 'Special Draw',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
            ]),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// RESULTS
// ============================================================

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final results = [
      ('LUCKIVA Mega Draw', 'Rs. 100,000', 'WINNER #10482'),
      ('LUCKIVA Lucky Draw', 'Rs. 25,000', 'WINNER #8391'),
      ('LUCKIVA Mini Draw', 'Rs. 10,000', 'WINNER #4418'),
    ];

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 22, 20, 6),
              child: Text(
                'Results',
                style: TextStyle(
                  color: white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                t('Published result examples for the prototype.'),
                style: TextStyle(color: muted, fontSize: 13),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = results[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: gold.withOpacity(.10),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.emoji_events_rounded,
                          color: gold,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t(item.$1),
                              style: const TextStyle(
                                color: white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              item.$2,
                              style: const TextStyle(
                                color: green,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.$3,
                              style: const TextStyle(
                                color: muted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.verified_rounded, color: green),
                    ],
                  ),
                );
              }, childCount: results.length),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PROFILE
// ============================================================

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return _profileGuest(context);
    }

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data();
        final name =
            data?['name']?.toString() ?? user.displayName ?? 'LUCKIVA User';
        final email = data?['email']?.toString() ?? user.email ?? 'No email';

        return _profileContent(context, user, name, email);
      },
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ValueListenableBuilder<String>(
            valueListenable: appLanguage,
            builder: (context, language, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.language_rounded),
                    title: Text(t('Language')),
                  ),
                  RadioListTile<String>(
                    value: 'English',
                    groupValue: language,
                    title: Text(t('English')),
                    onChanged: (value) {
                      if (value != null) setAppLanguage(value);
                      Navigator.pop(sheetContext);
                    },
                  ),
                  RadioListTile<String>(
                    value: 'Urdu',
                    groupValue: language,
                    title: Text(t('Urdu')),
                    onChanged: (value) {
                      if (value != null) setAppLanguage(value);
                      Navigator.pop(sheetContext);
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _profileGuest(BuildContext context) {
    return _profileContent(
      context,
      null,
      'Guest User',
      'Create an account to continue',
    );
  }

  Widget _profileContent(
    BuildContext context,
    User? user,
    String name,
    String email,
  ) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [green.withOpacity(.15), card],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: green.withOpacity(.15)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: green.withOpacity(.15),
                      child: const Icon(
                        Icons.person_rounded,
                        color: green,
                        size: 31,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: muted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (user == null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Login / Create Account',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 15)),
          SliverToBoxAdapter(
            child: ProfileMenu(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsPage()),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: ProfileMenu(
              icon: Icons.shield_outlined,
              title: 'Trust & Transparency',
              onTap: () {},
            ),
          ),
          SliverToBoxAdapter(
            child: ProfileMenu(
              icon: Icons.help_outline_rounded,
              title: 'Help & Support',
              onTap: () {},
            ),
          ),
          SliverToBoxAdapter(
            child: ProfileMenu(
              icon: Icons.info_outline_rounded,
              title: 'About LUCKIVA',
              onTap: () {},
            ),
          ),
          SliverToBoxAdapter(
            child: ProfileMenu(
              icon: Icons.language_rounded,
              title: 'Language',
              onTap: () => _showLanguagePicker(context),
            ),
          ),
          if (user != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Logout'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: BorderSide(color: Colors.redAccent.withOpacity(.3)),
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// PROFILE MENU
// ============================================================
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: white,
        title: Text(
          t('Notifications'),
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListenableBuilder(
        listenable: NotificationStore.instance,
        builder: (context, _) {
          final items = NotificationStore.instance.items;
          if (items.isEmpty) {
            return const Center(
              child: Text('No notifications', style: TextStyle(color: muted)),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: green.withOpacity(.12)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0x2200E0A8),
                      child: Icon(Icons.notifications_rounded, color: green),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t(item.title),
                            style: const TextStyle(
                              color: white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            t(item.body),
                            style: const TextStyle(color: muted, height: 1.35),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileMenu({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListTile(
        onTap: onTap,
        tileColor: card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        leading: Icon(icon, color: green),
        title: Text(
          title,
          style: const TextStyle(color: white, fontWeight: FontWeight.w700),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: muted,
          size: 14,
        ),
      ),
    );
  }
}

// ============================================================
// DRAW DETAILS
// ============================================================

class DrawDetailsPage extends StatelessWidget {
  final String title;
  final String prize;
  final String entry;

  const DrawDetailsPage({
    super.key,
    required this.title,
    required this.prize,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: white,
        title: const Text('Draw Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [green.withOpacity(.18), card],
                ),
              ),
              child: const Center(
                child: Icon(Icons.emoji_events_rounded, color: gold, size: 78),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              t(title),
              style: const TextStyle(
                color: white,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              prize,
              style: const TextStyle(
                color: green,
                fontSize: 31,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Entry information: $entry',
              style: const TextStyle(color: muted, fontSize: 14),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PrototypeCheckoutPage(title: title, entry: entry),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// PROTOTYPE CONFIRMATION
// ============================================================

class PrototypeCheckoutPage extends StatefulWidget {
  final String title;
  final String entry;

  const PrototypeCheckoutPage({
    super.key,
    required this.title,
    required this.entry,
  });

  @override
  State<PrototypeCheckoutPage> createState() => _PrototypeCheckoutPageState();
}

class _PrototypeCheckoutPageState extends State<PrototypeCheckoutPage> {
  String selectedMethod = 'Easypaisa';
  bool screenshotAdded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: white,
        title: Text(
          t('Checkout'),
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t('Payment Method'),
                style: TextStyle(
                  color: white,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 18),
              _paymentMethod('Easypaisa', Icons.account_balance_wallet_rounded),
              _paymentMethod('JazzCash', Icons.wallet_rounded),
              _paymentMethod('Bank Transfer', Icons.account_balance_rounded),

              _paymentMethod('Card', Icons.credit_card_rounded),
              const SizedBox(height: 14),
              if (selectedMethod == 'Easypaisa' ||
                  selectedMethod == 'JazzCash' ||
                  selectedMethod == 'Bank Transfer')
                _prototypeQrBox(),
              const SizedBox(height: 14),
              _orderSummary(),
              const SizedBox(height: 14),
              _screenshotBox(),
              const SizedBox(height: 14),

              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PrototypeConfirmationPage(title: widget.title),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: const Text(
                    'Continue - Prototype',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentMethod(String name, IconData icon) {
    final selected = selectedMethod == name;
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = name),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: selected ? green : Colors.black.withOpacity(.06),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? green : muted),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                t(name),
                style: const TextStyle(
                  color: white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? green : muted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _prototypeQrBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: green.withOpacity(.12)),
      ),
      child: Column(
        children: [
          const Text(
            'QR Code',
            style: TextStyle(
              color: white,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: 190,
            height: 190,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Image.asset('assets/qr.png', fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }

  Widget _orderSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: green.withOpacity(.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              color: white,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            widget.title,
            style: const TextStyle(color: white, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 7),
          Text(
            t('Entry: ${widget.entry}'),
            style: const TextStyle(color: muted),
          ),
          const SizedBox(height: 7),
          Text(
            t('Method: $selectedMethod'),
            style: const TextStyle(color: muted),
          ),
        ],
      ),
    );
  }

  Widget _screenshotBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: green.withOpacity(.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              screenshotAdded ? Icons.check_rounded : Icons.upload_file_rounded,
              color: green,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  screenshotAdded ? 'Screenshot added' : 'Payment Screenshot',
                  style: const TextStyle(
                    color: white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  screenshotAdded
                      ? 'Prototype attachment selected'
                      : 'Add a payment screenshot',
                  style: const TextStyle(color: muted, fontSize: 11),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => setState(() => screenshotAdded = true),
            child: Text(screenshotAdded ? 'Added' : 'Add'),
          ),
        ],
      ),
    );
  }
}

class PrototypeConfirmationPage extends StatelessWidget {
  final String title;

  const PrototypeConfirmationPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final prototypeId = DateTime.now().millisecondsSinceEpoch.toString();
    final transactionId = 'PROTOTYPE-TXN-$prototypeId';
    final ticketId = 'WM-PROTOTYPE-$prototypeId';

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: white,
        title: Text(
          t('Prototype Ticket'),
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: green.withOpacity(.14)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: green.withOpacity(.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: green,
                      size: 45,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Prototype Payment Successful',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: muted, fontSize: 13),
                  ),
                  const SizedBox(height: 22),

                  _infoRow('Transaction ID', transactionId),
                  const SizedBox(height: 12),
                  _infoRow('Prototype Ticket', ticketId),

                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: gold.withOpacity(.08),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      'Prototype mode: this is a prototype transaction and prototype ticket. No real payment was processed.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: muted, fontSize: 11, height: 1.4),
                    ),
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Back to Home',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: muted, fontSize: 11)),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// LOGIN / SIGNUP
// ============================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isSignup = false;
  bool loading = false;
  bool obscure = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage(t('Email and password are required.'));
      return;
    }

    if (isSignup && name.isEmpty) {
      showMessage(t('Please enter your name.'));
      return;
    }

    if (password.length < 6) {
      showMessage(t('Password must be at least 6 characters.'));
      return;
    }

    setState(() => loading = true);

    try {
      if (isSignup) {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        final user = credential.user;

        if (user != null) {
          await user.updateDisplayName(name);

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
                'uid': user.uid,
                'name': name,
                'email': email,
                'createdAt': FieldValue.serverTimestamp(),
              }, SetOptions(merge: true));
        }

        if (!mounted) return;

        showMessage(t('Account created successfully.'));
        Navigator.pop(context);
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (!mounted) return;

        showMessage(t('Welcome back!'));
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = t('This email is already registered.');
          break;

        case 'invalid-email':
          message = t('Please enter a valid email address.');
          break;

        case 'weak-password':
          message = t('Password is too weak.');
          break;

        case 'user-not-found':
          message = t('No account found with this email.');
          break;

        case 'wrong-password':
        case 'invalid-credential':
          message = t('Email or password is incorrect.');
          break;

        case 'too-many-requests':
          message = t('Too many attempts. Please try again later.');
          break;

        default:
          message = e.message ?? t('Authentication failed.');
      }

      showMessage(message);
    } catch (e) {
      showMessage(t('Something went wrong. Please try again.'));
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Future<void> resetPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showMessage(t('Enter your email first.'));
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      showMessage(t('Password reset email sent. Check your inbox.'));
    } on FirebaseAuthException catch (e) {
      showMessage(e.message ?? t('Unable to send reset email.'));
    }
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: white,
        title: Text(isSignup ? t('Create Account') : t('Welcome Back')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: green.withOpacity(.10),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: green.withOpacity(.20)),
                  ),
                  child: const Icon(
                    Icons.confirmation_num_rounded,
                    color: green,
                    size: 39,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: Text(
                  isSignup
                      ? t('Create your LUCKIVA account')
                      : t('Sign in to LUCKIVA'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  isSignup
                      ? t('Join the LUCKIVA experience')
                      : t('Access your account securely'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: muted, fontSize: 13),
                ),
              ),
              const SizedBox(height: 30),

              if (isSignup) ...[
                Text(
                  t('Full Name'),
                  style: TextStyle(color: white, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                AppInput(
                  controller: nameController,
                  hint: t('Your name'),
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 18),
              ],

              Text(
                t('Email'),
                style: TextStyle(color: white, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              AppInput(
                controller: emailController,
                hint: 'you@example.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 18),

              Text(
                t('Password'),
                style: TextStyle(color: white, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              AppInput(
                controller: passwordController,
                hint: t('Minimum 6 characters'),
                icon: Icons.lock_outline_rounded,
                obscureText: obscure,
                suffix: IconButton(
                  onPressed: () {
                    setState(() => obscure = !obscure);
                  },
                  icon: Icon(
                    obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: muted,
                  ),
                ),
              ),

              if (!isSignup)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: resetPassword,
                    child: Text(
                      t('Forgot password?'),
                      style: TextStyle(color: green),
                    ),
                  ),
                ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: loading ? null : submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: green.withOpacity(.35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : Text(
                          isSignup ? t('Create Account') : t('Login'),
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                ),
              ),

              const SizedBox(height: 18),

              Center(
                child: TextButton(
                  onPressed: loading
                      ? null
                      : () {
                          setState(() {
                            isSignup = !isSignup;
                          });
                        },
                  child: Text(
                    isSignup
                        ? t('Already have an account? Login')
                        : t('New here? Create an account'),
                    style: const TextStyle(
                      color: green,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// INPUT
// ============================================================

class AppInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;

  const AppInput({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: white, fontSize: 14),
      decoration: InputDecoration(
        hintText: t(hint),
        hintStyle: const TextStyle(color: muted, fontSize: 13),
        prefixIcon: Icon(icon, color: muted),
        suffixIcon: suffix,
        filled: true,
        fillColor: card,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 17,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.black.withOpacity(.05)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: green),
        ),
      ),
    );
  }
}
