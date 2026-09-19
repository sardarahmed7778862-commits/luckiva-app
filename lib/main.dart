import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'firebase_options.dart';

const bg = Color(0xFF050B10);
const card = Color(0xFF0C171F);
const card2 = Color(0xFF111F28);
const green = Color(0xFF38E0B5);
const greenDark = Color(0xFF00B894);
const white = Color(0xFFF5FAF8);
const muted = Color(0xFF9BAEB0);
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
  'Payment Submitted Successfully': 'پروٹوٹائپ ادائیگی کامیاب',
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

// ============================================================
// LUCKIVA ADS
// ============================================================
// Android AdMob IDs created for the LUCKIVA app.
// Windows desktop is intentionally ignored because Google Mobile Ads
// is not supported there.
//
// Real AdMob IDs are configured here.
// Use only on an AdMob-compliant release/testing setup; do not click live ads during development.

const bool kUseTestAds = false;

const String _androidAdMobAppId = 'ca-app-pub-1794194304114047~7367236504';

const String _androidAppOpenAdUnitId = 'ca-app-pub-1794194304114047/3042646984';

const String _androidInterstitialAdUnitId =
    ''; // Create a new Interstitial unit in this LUCKIVA app.

const String _androidRewardedAdUnitId =
    ''; // Create a new Rewarded unit in this LUCKIVA app.

// Official Google test IDs (Android).
const String _testAppOpenAdUnitId = 'ca-app-pub-3940256099942544/9257395921';
const String _testInterstitialAdUnitId =
    'ca-app-pub-3940256099942544/1033173712';
const String _testRewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

String get _appOpenAdUnitId =>
    kUseTestAds ? _testAppOpenAdUnitId : _androidAppOpenAdUnitId;

String get _interstitialAdUnitId =>
    kUseTestAds ? _testInterstitialAdUnitId : _androidInterstitialAdUnitId;

String get _rewardedAdUnitId =>
    kUseTestAds ? _testRewardedAdUnitId : _androidRewardedAdUnitId;

class LuckivaAdService with WidgetsBindingObserver {
  LuckivaAdService._();
  static final LuckivaAdService instance = LuckivaAdService._();

  AppOpenAd? _appOpenAd;
  DateTime? _appOpenLoadedAt;
  bool _appOpenLoading = false;
  bool _appOpenShowing = false;

  InterstitialAd? _interstitialAd;
  bool _interstitialLoading = false;
  bool _interstitialShowing = false;
  DateTime? _lastInterstitialShown;

  bool _initialized = false;
  bool _firstResumeHandled = false;

  bool get _supported => Platform.isAndroid || Platform.isIOS;

  Future<void> initialize() async {
    if (!_supported || _initialized) return;

    _initialized = true;
    WidgetsBinding.instance.addObserver(this);

    try {
      await MobileAds.instance.initialize();
      _loadAppOpenAd();
      _loadInterstitialAd();

      // Give the splash/auth gate a moment to appear before the first
      // App Open ad, matching the intended "open app -> ad" experience.
      Future<void>.delayed(const Duration(seconds: 2), () {
        if (!_firstResumeHandled) {
          _firstResumeHandled = true;
          showAppOpenAd();
        }
      });
    } catch (e) {
      debugPrint('AdMob initialization skipped: $e');
    }
  }

  bool get _appOpenFresh {
    if (_appOpenAd == null || _appOpenLoadedAt == null) return false;
    return DateTime.now().difference(_appOpenLoadedAt!) <
        const Duration(hours: 4);
  }

  void _loadAppOpenAd() {
    if (!_supported || _appOpenLoading || _appOpenFresh) return;

    _appOpenLoading = true;
    AppOpenAd.load(
      adUnitId: _appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenLoading = false;
          _appOpenAd = ad;
          _appOpenLoadedAt = DateTime.now();
          debugPrint('LUCKIVA App Open ad loaded');
        },
        onAdFailedToLoad: (error) {
          _appOpenLoading = false;
          _appOpenAd = null;
          _appOpenLoadedAt = null;
          debugPrint('LUCKIVA App Open failed: $error');
        },
      ),
    );
  }

  void showAppOpenAd() {
    if (!_supported || _appOpenShowing || !_appOpenFresh) {
      _loadAppOpenAd();
      return;
    }

    final ad = _appOpenAd!;
    _appOpenAd = null;
    _appOpenLoadedAt = null;
    _appOpenShowing = true;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        debugPrint('LUCKIVA App Open ad shown');
      },
      onAdDismissedFullScreenContent: (ad) {
        _appOpenShowing = false;
        ad.dispose();
        _loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _appOpenShowing = false;
        ad.dispose();
        debugPrint('LUCKIVA App Open show failed: $error');
        _loadAppOpenAd();
      },
    );

    ad.show();
  }

  void _loadInterstitialAd() {
    if (_interstitialAdUnitId.isEmpty ||
        !_supported ||
        _interstitialLoading ||
        _interstitialAd != null) {
      return;
    }

    _interstitialLoading = true;
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialLoading = false;
          _interstitialAd = ad;
          debugPrint('LUCKIVA Interstitial ad loaded');
        },
        onAdFailedToLoad: (error) {
          _interstitialLoading = false;
          _interstitialAd = null;
          debugPrint('LUCKIVA Interstitial failed: $error');
        },
      ),
    );
  }

  // Shows an interstitial at a natural transition. When a live ad is still
  // loading, wait briefly so a fast tap does not skip the ad immediately.
  // A short timeout keeps navigation responsive when AdMob returns no-fill.
  Future<bool> maybeShowInterstitial() async {
    if (_interstitialAdUnitId.isEmpty || !_supported || _interstitialShowing) {
      return false;
    }

    final now = DateTime.now();
    if (_lastInterstitialShown != null &&
        now.difference(_lastInterstitialShown!) < const Duration(minutes: 3)) {
      return false;
    }

    var ad = _interstitialAd;
    if (ad == null) {
      _loadInterstitialAd();

      final deadline = DateTime.now().add(const Duration(seconds: 4));
      while (_interstitialAd == null &&
          _interstitialLoading &&
          DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
      ad = _interstitialAd;
      if (ad == null) return false;
    }

    _interstitialAd = null;
    _interstitialShowing = true;
    _lastInterstitialShown = DateTime.now();

    final completer = Completer<bool>();

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        debugPrint('LUCKIVA Interstitial shown');
      },
      onAdDismissedFullScreenContent: (ad) {
        _interstitialShowing = false;
        ad.dispose();
        _loadInterstitialAd();
        if (!completer.isCompleted) completer.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _interstitialShowing = false;
        ad.dispose();
        debugPrint('LUCKIVA Interstitial show failed: $error');
        _loadInterstitialAd();
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    ad.show();
    return completer.future;
  }

  // Optional Rewarded ad. The app can call this from any future
  // "Watch Ad & Get Reward" action without changing the ad setup.
  Future<bool> showRewardedAd({
    required FutureOr<void> Function() onReward,
  }) async {
    if (_rewardedAdUnitId.isEmpty || !_supported) return false;

    final completer = Completer<bool>();
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete(false);
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              debugPrint('LUCKIVA Rewarded show failed: $error');
              if (!completer.isCompleted) completer.complete(false);
            },
          );

          ad.show(
            onUserEarnedReward: (ad, reward) async {
              try {
                await onReward();
              } finally {
                if (!completer.isCompleted) completer.complete(true);
              }
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('LUCKIVA Rewarded failed: $error');
          if (!completer.isCompleted) completer.complete(false);
        },
      ),
    );

    return completer.future;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_supported) return;

    if (state == AppLifecycleState.resumed) {
      if (!_firstResumeHandled) {
        _firstResumeHandled = true;
        Future<void>.delayed(const Duration(seconds: 2), showAppOpenAd);
        return;
      }

      // Avoid showing an App Open ad immediately after an ad was just
      // displayed; preload instead and show on a later foreground.
      Future<void>.delayed(const Duration(milliseconds: 700), () {
        if (!_appOpenShowing) showAppOpenAd();
      });
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _appOpenAd?.dispose();
    _interstitialAd?.dispose();
    _appOpenAd = null;
    _interstitialAd = null;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase must be ready before AuthGate touches FirebaseAuth.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, st) {
    debugPrint('Firebase init failed: $e');
    debugPrintStack(stackTrace: st);
  }

  // FCM is optional for the desktop UI. Never block the UI on messaging.
  if (!Platform.isWindows) {
    try {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final title =
            message.notification?.title ?? message.data['title'] ?? 'LUCKIVA';
        final body =
            message.notification?.body ??
            message.data['body'] ??
            'New notification received.';
        NotificationStore.instance.add(title, body);
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
    } catch (e) {
      debugPrint('Firebase Messaging init skipped: $e');
    }
  }

  // AdMob runs only on Android/iOS; Windows remains unaffected.
  await LuckivaAdService.instance.initialize();

  runApp(const WinmaxApp());
}

const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://negligee-romp-negotiate.ngrok-free.dev',
);

const Map<String, String> apiRequestHeaders = {
  'ngrok-skip-browser-warning': 'true',
  'Accept': 'application/json',
};

// ============================================================
// REFERENCE UI IMAGES
// Embedded directly in Dart so no pubspec/assets edit is required.
// These are cropped from the supplied LUCKIVA reference design.
// ============================================================

const String _luckivaHeroBase64 =
    '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';
const String _luckivaDailyBase64 =
    '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';
const String _luckivaWeeklyBase64 =
    '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';
const String _luckivaMonthlyBase64 =
    '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';
const String _luckivaMegaBase64 =
    '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';

final Uint8List _luckivaHeroBytes = base64Decode(_luckivaHeroBase64);
final Uint8List _luckivaDailyBytes = base64Decode(_luckivaDailyBase64);
final Uint8List _luckivaWeeklyBytes = base64Decode(_luckivaWeeklyBase64);
final Uint8List _luckivaMonthlyBytes = base64Decode(_luckivaMonthlyBase64);
final Uint8List _luckivaMegaBytes = base64Decode(_luckivaMegaBase64);

// Premium LUCKIVA brand logo. Embedded so no pubspec asset change is required.
const String _luckivaLogoBase64 =
    'UklGRrhkAQBXRUJQVlA4WAoAAAAQAAAA/wEA/wEAQUxQSAmRAAAB7yckSPD/eGtEpN4TFiNJDiNJ2kiyUACzqL/AKLDn/hWI6P8E/Pv378J72QBuq6B+5mPRS/rntv4fx9hku77SFnvxYxX94X3frnoixuhS4j+U1NT73lvt7NImwP4rKdQOquodkmrnc+dvmQdEK0NV1WEt0GmP+DPwZgveqmyWNn1YcNmnSWb6Q293WVVr5aIVcM/pTHmMlLTNTB0/YPvNatfieAHXPiV18j0BRMKn+6BteTX7lORm2Aa4uwkwW4Drst+qqpWHa9MUXJekHGPYTkbXzsxmrgV6S1VrjbUWqLkmYJtGW3uQFDHxnF1V2c8C283cFIE0xgDZBjITWJukbaJTLGR7bA9ANki2pIjc2ccY231P1lpvubQjSbEJCCJCAtne5szMBB2ke6052GqLrY2bGRw3OyMiU1oR0mmumdI3rOuShN3cAE1GDOwn4nnWYJNWNrZk2Wqbz5J0Z1LCzpE11zpImVmu0s/gzPvOpI9MsY2Rz1xr3XcnpfRHtiWdAklIUloC9Wj/Bpuk+5YuSYAyvO1kOfTrJ8jMtflb2mROtdaP9S33yS3pVt+kV2bezc9Vn6TctcFJYm1z/llxig8C0MdNIdk2/kCj75l8AA5oT8nD6PMHtJoJI76wjUFrS2Nh/5Sx9V5L+2k/gaS1fKekMb7xwbctaXxCp8jMte51QGqsj6E25kGAtHJL295uH1z7t8zNEeoAScq1ZabT67YlDSk2qUISpykpvL4QOygZmWnfCx2rVEIbbEpJQtItRQgygsAm8pbS+8FuYhN95ob2iIC8L8yekq7rwgZu7VVVsiUR18Eh2dsdgQTYJ13Xlda5Kkr91YEt25Zkm91jXBdiWxdkNuMHoWak90sSR5lMdKS3pKwKfQQQdCFlNoIxruv6g7VUpT2bQdtZEqdjhqTRCBQrq6KkqNx0NzBpIyL4/KSFRqZBQpI2R9i2dB90AFbmF2oER4uZqBxS2LYk3XBLjMl1dWQacJMZNshA5K6ypGoi9PFybIMpbbAkbknikgBtSxWStCQpIr5gIGIiiesSSNnsXUWo9DEjxEE4ImKtJem6opFk2wcpQ98TGx+kt4pOGWpH40NRPwCGgbtRHnT3QfkFZS6ppJJyk7CaK25J1zWG+gA2yXOdlNZeyzMOEQGKuG+IyyHpubUjxY2eZ3srJGVKJe/RHuJ7PpWZEREiIoLIjKpMVgRZclVGC1QVZFUZoDKqip+rqKpIHKFSVKRCmVHeJJVtkKQogFtKuZGlIjMj03ZVRFVW02dGRFRVkFUVdxBR8TzPw/M8BBAJoGjeLfc3IosK9oIqCgKgKICoKqqijCw3T1VVRkS63gSupred27Gidh+rauqpiqqICFc9Tyq+rLVW1qf+S4TmW/VUpivCUVREs+aEWCsC84yI9ZRJDLZDdlUpNKOqisxMQ6V7ADsiAmBsKsi19JCBXVWxzcx635cx6De6EWkjMejLGLiqqt4VkuacWVX1vvwvVxuH58n6Tu0U1I9UFXUmIkJSA5/+Q6ABiFb78+RO+8kNUPzpaigQ2kYSJFWqO/xB99z+Q4iICcB2Pya7u/kNtDuzMbVVMKY12ZmF7gxYBXmrrTATOkE+awG5O+7wUQF63k42fvhHd9cfftCiBzciIE8PIFfN6idAMfFQs7UC6I+iqY9mFUB4iWJfuF/QU7WW60OgAiJoayvgiVw9oLWtHJztQ5GrAjzA3RZoUeXj8eRB1QJoCx7E3RdVfvDVXT1aPOAHYfNC/hRAN7aACN6qEQTqJhVRhWgVWgS0ScGigAICvBKzloqgLWgJCNi4sTwLSOEoiE3WVI2xpsbfaZqdbZvaatv67mlndtIkaY3WamOyqXa2s23StFWxqc0mtTOYmT691bSappkpmpm92c3d3U2SmQ1A2ySPm2xOo4BvSZIsSZJsC9lyrfX/X7rvl7l0GD2oukfWzA9ExATQjSRJkiSZHf88G1D59+zBETEBviVJsiRJsi0kn///5JX8oGrmHtXrAyJiAnzbtm3bbWNbpbY+xgR48f1u//+HxatvEZRIYM45em/lYUyAVHxBREyAJ0m2ZVuSJAnpPGZRjbqO+U8yAtRE+J3VePd/ZvcRRMQE+JYkyZIkybaQ1/9/89CDqqlH5czezxExAdyeb0OuyZnHPAYhJfI8nzMGw3wzJd9NkCpjcSQxKCft/povS6Vg6tmmImGbyX2K2YaS2XxzZrOxts1nzGM0U0pRDRFDEnIPE8n1cQ+GfBkGkXu+z5l73AyQ+GPzmO8238zX+wb7IvaR30+QfBn5utG0ndkZPSg5HrTy7bJYJgzWGk3TtIxY89hiDRnNl42FybKwbh8/6TvSbcZCzF/D+u/2g/UnfZHfbDJC8pk1rLE1DOb7ifbREiKJhiBkee4S2kNKJTSPzbIsy7cLC5ZlWQuTxVojzxNrehhD/mofFLnm7KLbjLXQ3Ps7X/ad/sv0qafm58i9S+g7ychCIiTmwTCYx2UtIj0cJIk0ESXFgeabsSepPDYyn5dlsiOb5ywz+XKxfLksGC3TiMw9C+umS9wyJB+TzOY8GDlbx32aLCb6J+ycnz8yZ0S0WOTrJEoTzOd8b615LqKFHg4Jjs+kh9BW9hBsko9Dzdl8HNOcWdi7fLf59uRxTZbleYjRmEw+NsiohYhgEtFor/ObNUuH0Nphi8wZ9IXIJ07HnxghhG45zSF6ikjls49lNk+D0ewpCBFVD/OcVBRZiHlss4+DU3a66xNrmkaG1t6mj8njlrYGYbIz7WNYlmVhaB25NyYRIemBItf6KudMQrRPcw9Ln/qELkBn/IF+6CBdQtJDRNRS+c6ih88Z2x2MYRF56gOnTmL2UZQEQ03OxzxXR8/mKPGwzTNUY6MfFinmbltzad3JosnBXCwXgowllS+zeLWkA9utdPgbdlu+zZmwREiukWsXOvLLXe7piJBSyqn06aP4oDqOvgi7v/55L5pNUrAhpel1zlG2XdapJp/bw9JLNjhOdV6dOk6ey+yZ53m2el+2wbKNc7Tde6+ta5trmwpOh7kbNoNOGU/q5yeaZZHUi6SYsVGpyGjYEDHnmO2StzfKWYRSCEHOmGdbPrWvvIzQcW2iaR1ZONRoE9JSy/J47yZrsSPM1hAWjp1ha1iWxZhpSR4XhyISNKtHQ7MMjWgTycLcltnaNpaVOJrdNgZLEU94X/nYQr7MuYY1mpxNRtM0WqaHscO7dxV7VxNhWRpNTL/gAL4yj3N2o3RpaauhJmGlMVnsTPtQtLGWmbWjhczWLAvFtNYYrXEGmTFVO3OnhXwuiUae14g0zN4dzCbG0lpy21qs+SyGuSKbdkzIty20WFlrGSbEjEyTBi3LEGNdmuFdZVq+DRpNyDSWcwufmNcRtKxFKmWRlawMRctdGMdx7axPtvlcNs44E9rlljV9gZbreWfHFmFP7mSLBhMRbQ2apjCzoocFO7uh5kxX0xVrjlzrQbkSc/bRsKZpXkwLwpiauCwNNcjXa8Fia1AEIWsKC5qz0QIXwK0X53mEqCWV+KimkQRnLcjMDqOYpY7PXdQ2jeRh5p6Rx4yyxiyLsoiNdl4219UirJFwtsnYa0HMhLWFHWNCnK1Nt6FFGLmuWvN5DGFDziyZrMsYFIvN3kmwJu3TdfS0zC0jgliaTM0ZLEIuHPSWPA8jxGcXqY+chXMWLWeS3HObqqOlD8Ogtfmsdu5guw2FY9HSYmsnsUUwdI5thjRILO1MS01GyezBMM2dNZSI3Pl8WmOz4lqdtXUMu2GFlHc1q7hYabR5Rr1btFYiMxMW2ozN25t6SYQoYkuuaQjEmbRxW+Z7ESXk+NRHS/bp9XIq4UB1pr1+/PUzp5+vmvd9z3DOvF7nvMrY/vn773vXeZ1OHWr33h1cc86PH0d17F7bpvN6hV9/33XO6/U63bstse29d7dyFq/1vmm22Qxlu+M0p5Otejlyxuzu3rnuPefnafpxXof7vveO9Nqf58/m7YXKpFeCKTzP/mQ96Wcz6ifTz/t6nufZlvdV70K9P6/617//28/Si+pHeZqWF0uuIjgat6LeWBzGIKqopeNTgvR6nRzEIsrZ6fXX6aqO7d6ZQvV6vYRdd+970Tmngmu7ze6G8zqdzZrPWadq7/f70qsX617N3djed13ajOiFkFZWto5hmorVq1bH2XxuG+PHOayO3HU3IZ49z2POrZHNgmjDeOqnZ8/zjpV6Grw1niEqef1Uhvff/v3nhY6fSga1ptABIpstvD2IUNpHqs+nD0Lr1c5CwVitaDt3jNI0WY01hrNXNExmwrnrepxZY5SwMc3QMlabsWl111jzeVDL+Q4OTQyaFkRDjXzWwozR8uV41BMPba6bjbA8WXpd20Oy9ZR5pkTGqJZzTG/pXUhpYe8kZ4tAIvq1hAwtOIOAgBQJBirCCGezNceYRtlmjEnWbMvi5z//8x3i2dP/6eDzGWPbsAxj7CMfooiPa9vMVpPX6RggiPApiA8kIVWSlCRJ9SO7o7qRUr3/kmpEn40tQ30+21b/43+WUvW+TO/r2fPM0EFnVqvNRkeM8l7lrEg+Q31n0wfyGC0LmkSAmFiASQiECkhmaLBsXjxtxho5N1j1r5+2y55VKMUORsn3XD+ZqoMONmbI9yznDAVkHGPJmEBEEWV7e1/MrdQxJOlNFKIPbbZJn2KOMpWqnw3qsWeuoQpDZDMV0ojlySh4IrKP5LEvXMNjPYSOaBGrWxjCwyQAKUgoiTFpt4W2FRSGZo1hXfTKfVbOj5i5JtGlYaRpn5C3wyxakzHfBiDgJxYljKTlDCEaVZr/Z0jKGJISWmo+uW6Gj5xT+VC0+ThfZyNW6W48BxRjEFWMREHJU8nBtupeniMkoUUNpQiJIalUKhtRqiom2zhbR+72/uf9vm/99L4VDGOuLWfO1nBz3LPb/zy9zetgEDTBvLBsrA0jaESQ5R7NnKHmy5rQotbEmCFo2EVZMl9uCGvbnF6vn69TP/71r1NoRY/j6O6+raXdq9NghEJBAf24cTIvI7pIO5NarVOVikWSqjHGCJ5Gqakyd3bb+9c/v/bufb29XO5zzXeWETnnHvksmvveDV3OeeAPhk62/QhyD1osjPzcNxS5pjXX2/Och+Xah3lkymab0+vnj+Ocf/9P//75etVIYpi2x/Xr116z57FogNB1+/xQADmra9+HiJo0x06HxMQiZFChMaRRsL1md1vGQizr07rp62/uBVnuaz2ty+usL7K872HX2Tzfufhy/53n5u2wV/Oa5fPM5yAMqlNVpUxtl4r0Wi1rtQ2CZFj5LAF4BjyUiCK1fObzBIZgEcBwjmkB7cEwyF/NH3aZaIe1vG/I85w9rOU+r9Ntx9+aHO2DXLsNLfaQzzkXi4k9YF59r+WXY2g+jj6+TMpAklSKrKALEYS2LWRHSvl6Yrk3Z0QHxKKyGKESC0DC2ZbAaeYPTl/8i/PD5sdLfjhMx2K3v5fTL/piXX7vk46zOZefzHUyZ7+Ya5++HUEgphJSRbVplqCA3LEoEEB5NyQLsrQ5PhNAQqjEqMGTInQXifSd+QdjvzPWFwy7RRHEHpqYa2t+3NGanFuXhdwzf7dPZAeL0B/Ylz40f7enPIZAkTNVJrKEhsbstq3R8qg8G+RsaQTHEjuAZBSF2xBpRdulikJ++7vsp/u+GYMeOsyvebBLqPn+aa69wWXkno/rt7NLjtFEzr6yy3wFOaf63Z6+PIUxKlSNFClc3faicbvDEIggQvfyXJAQqeUEpPbLViuXT3v3WvPW52s32OZP7+g499FCO9htmMflD7uduYcFa3SsY93msxXAY69NC5a/2I2OuFxzRua5wViW5Roxn/vq67DCQMa2VWV/2saosY2Cvv/8bS326/2ekSqIyted+vTmGkVyRqUlDkJdngDG3t3L+2y1EQUm9if+0ZyDmXNMx1+HjnvO/Ed3xl75232gT4l52SHPc93lx+gyyT+ZlCHk4XapVO2XfaT668uy7/ufPahEEBCgtRj3Li8jiBJ2kIQBXbimVtPyI/enmuyjvdmRh3kVy16eQ+75z9lP3TvOSPROEz3M837KzYTq7/1mkhCSSlKkG3r/WutCGxKRg05UPURHUHREtFAqaUGYbUQQcvI9/x1ORvuC+Xxbtxg/dIlc8x9eGNpv6TsJe2ryNC/HbrGGpPkvHTCkIARGD+eg3Lu1rESg4AF09JzHKGckzo5Y5xBgAXiIKAYMEH+xvvkc+Xvuucy9vM01j/XPIR1p/4puIjLnCAv5iR3BEPn7/ZEgpAsoiqQHwkC/Zrb5vEwjoqXDSSppR8kRdDovG+y5QDACAuT/T+xiR7uwv9EO5p5rp5x5DP1nsS4E4KwdYf8IXYTYgt3k5cgOw+S6hnTsu277I49jAqmSUBvtaPc9ZspOafJiJC0trR1OVQZku1RR+15p1zqmY788FUHlaHYijMZuubfbZ2gQxtiBgKyvBxa3Y9dYCoH4vkOHnEG+18P1dp2XebmPKnVcFlg9m2yfP0bxPtuet9kIbpsz/SMhaeG1dhapy07cPn/eUlX0mmveb2uFEECOBkKTboWYmZHUjjNDx3nThoCsz38fOIvjowB/gbynr2trsodh2B56yL3cO+UCCGoyfvXby2Zqta7bf76p0B/KXWe1hJCms6S11B5S2Tejc65OuxqQB4cDXNgliGEsivkM84cnhs7+wQC8YB/5xiemvqSPIUfsCM3n7XF5u0Pk3xZACNQoqi57IP1y7Y6msZIu11saUYtKCBRKt2IU5GGgWc5io44zlzHNRzC0p57IPiYIOLgunYldSaAJbQDmJ+/RMWfHY/4wzHOXM2+77B5yloQAZE8MaxLRzFLzj0bkfrRWWZAEhto0DQblR6zHbjfMMGe13dDDnwsg+IBs4RnZ/mybvB/0padC7u2CyDlUPudRAU+RqiIdVzpCzHLtcOISViIIdbCQkFJaWRHEnAQCnYjtXbrQrYS55tZvAs0E+QkE4kheAvNPUa4N0SGIfO+4d6ATMQSSKojpRjD0oQuOcCMuSylVYkSKXm3obgHjCQlxtrVBmHuTlRaGdhhj+1hkVe422WA5NgOcyMGOAJIJ+dJ30NfZRQRFUX7fnjsIBELI0ym1VqOdx9kBWVW9BEmtnTq8fv44XmfPQrndhHY2ijyWX7qR+b0gojW5T7DL3KWP3M1VAiexG2M/cjDuG2ADj+X3nH3cYygVQR2b7bIP2hq28jCnGpfLqLF9YDr79vo+24Hk6mQesRZqr6rXj5+vl5ciPe+HNN1AePs7/LRBo2voa6KF1pxZZsc5p7waZKwam7EoyNG2wp1tT+R7tK+gpylCzMv5bk5JtovTMvatKk8fnojr+tN/lvf90fKuC+48N1p1Vvtx1LVUu5XYkfC2vFuO0EJ+CGnQWgvmc64zFOiF4Mp2bOALAY7CR3LueO4v8jLsYX43DlxNJSZjL8Pqf73yRlog+5HWBDvHZ2cTRo2CYHjvD6GNONYEjUwm2MfnTb7dyS/5JwTI3PCZ+QM5e0rSkT+XXb1CQkglAdZ6V15oDdyooDmzUm35XCAqePpefwTd0QcPcuacn+eUjTyQ64GDsz0Quy0J4L38kT7Y7XnRX4yQ/c7ERwXBGkDwtbfeHfJPtqCpbqEtEk0rBnyf/HK0oAPrdobQYs49zRuNLubuyG7hvQAcxFfIcKv9U+xFzvzNWT3yOFhARhXx1PUIDtyJ1iRpK9k6YxO0WzR8p79czPN7e/Pzth1Xmc9yq5sYydlckbHXaBaLMnUUHoL1F9LXucv9N/t4txkYSCcgFtT+nKpw/ynvz0/2klNAlxKRpN2dyrL2YdvMpoPfg+BkHLst7Oglb5ssY7Y510X243eb5SvzXFmV9R205k9znwZFl3y9zM8CLCHHY0xl/3gZtW2v/y7vv/1n9bwv+E9ElpNM1I6tnTAZacUlESJghJx+4Klw+e/HXOfsbyB/JMYyPQCdyQZO8sh9/utgzlJ5GWbQX9HKzXAeY4Tax8+7+s//lJQEkcXKNUSEWCCQxBtqMIGMPfL7a/L1M02Oyl+BB+hjvWhhffif0/G3cnwQ785n/CcIvUDlh6cmNEIKNCaAt0k+FnPvGBDjkHX7OGsgX7mtfJ0ELtkdGwAO5GjH5LNljuuy/P/r4oDANTs1n637XxHwjCDstpcz/5KAZNghJtBPWs75veeEVpb98JHl3mHn8VgUkNVwIpbHmJfGA5L/CPwQm3El7O9CxQZp4nLvKYgWUhUCNTD8/Gft1d8C+xs5JuO2pvKuf4Cst/YeJh3L2dNdCBDAW3To37Al/Lw7UqyMzCkgGt+7RdSiNSB7qrI9b9r9b///W/IP/rBfaEvmyUl5qVkP0Y3F/JxJntvRE8Y75Oxf2PaEHbM+Tz+eB/HbV0WQt+e7hLysbcuo7ZLuNf/9P16t/pqyl1OI1VbksECAnBX6tPO7/QCRv3zzlbk08NSZa09ek+N6xNP5+WFkjK9fGkGQGOx2VoYgMCoJ1a2+1fJlW2Ev4/sLN/9RYT9lzXqhXy16gQ5auC43PfIZVQblvQVBfo9cM4KkwJAWKcsv27Mj5O+RUeznb9AA7+TcE7kfE7JeyFFv0IGeySP2wY0+Cm1FkiwxNhCtHTuU0po0YiUggnx3CFoZH6mAivXAfkZ2A0fxvNCHJnho5Ck/tszZ5GrID9CDD8AZHLSW5yIJVC2gocPnjG1DpCFCUkTTCrbv/vrxXwYYyA8g7cjYidAjOKEPTmznj3vJPQIm5y9MX9BPHf3KmIGVQSO2QjHvBaFiaitIrwkN+2p/aR47AjH0iF06mKNle2RxIJPHt0WRa8llr+gLX/j6hNYDVhLq4zabnvcGIY+dCvKJ5PIhTXu/2zi/Vt2Zf7BD8mhrZwV6iUxeaugmz5H/rjufN0geFsg7iOWzKuR3v6G7X//3QBL2pASfkDxdsJ1HN7j9KvYvXbYrsu+tEOK04OQr9M5YVoXWesg197kWoheB0CDwE87AI2f8qEsd0HwWSXj+TcXcvtw5/0+GXR5bSFTGaNHZYPzeU+dAf0V8jaP5kV+/g91e2wtCvm8CEoD36Edu55shla0oPZao5H0HRKESUJcYv9kxDs45Z/CUybZcHU1rLT4/LtvubNpTYowekF8Rq0JujP47P73S1vLdAFRVTKaS/wnWAxItEioIvTDy9cANeQ90hpBtuRrjBkdbEWgvIX/n57DBnvJWmsQBkO/C/FfhKB6N3dE3kkANCLBQ/U+ue2hNKKgKyJLvlH1b6QMYD3vFUYSAB2gy372d004dvDQHBB2vZdHR5T3aCBnEZZM+T87rIqGX6qXL50yZJLBvrTuQd9masju7WhvyqiBnG903f/xXHjgfc+ZhVNGDHPRIs6MhTejzyy3ZV06wpTKu107v+7aOdrOyUJlc9sMevK3K7XjQoJGDVTvRwty9t1tTbtYG5jFyzr2LQFubjqg6Nmzy88u7J7fLljzdXu3Xv368IwsxyFICg9bgIwHdcSfeln1p76AMvbWvyI6AqJWXizGE8uUuQOyLOlkv/PPu7SMnElJbTbv3faHJxxZrqYCgfKdubP8FNGirCwEN2lewB5eY9gsxriPrVTrksFz0GC3k7/nygYRQGvW2nIt8t4KkgbxVxFcd6UY86k+os7FMBeijyz4ew4BGTzuKcRYkeyg/dvJ1oxrhMfohgQ6dw8MySO8aYUFror1OBqaA5MGiIIjsPgP6kZPGN5w0Ounk4EMf97HYI3L2QXY795NH/Xvk6C6BcI4Jp1fL59Ay7bxeJdXXhvADBeTgO/KVy32KX771VIO5lxBwpSOIlm/7uCQuCOgJ8BA0+s327JBzKEMJKg1hF43kf/h3VXX7efWPGXqAXjlpOyIUvx3k+9hUNmvr6NxzT0dPm6KTsyGAp6BTjroQhwIIgWLUCrxv8vksFsv5978Pers2XflB5gHoGVdk2gqfJ+tCPrqBqJlysE8fl1yyhqbvrq1djQIQ8Bh0QqY35u0lnyFYGXjqJe0i00j9/DHsXm34wXK6V5ZPzbsTXrjme4DYdklWcxRXQ64hnpVlAY/RL6Uefg0jgPys1ro0YbF+nqGrOef75GY/REduC358wAhwB1dwZT7xgo7891syn5HFG/aBPe0pkCFJZe+aoGmaeL0o3UZ+oNztgTZwEgftTjA5usOeUJk3qCU8hwdakP+FWJWhBLgHrchm55BA8qcCoUbseV9aa/KxRf2IuBY/9lL8oJ84Kg+e++xLxB+YPdBy/014zBXZ9AD9wt0AJM/V9L4/Qdo6Wip7/WzAcf8hcjTDN8QDX9ecvRlQ58xmTj+ioC8JqFje58xjtRCAHcILeQNf6cQeSID85rnR//tvEWRaN504r7+6NLfjlPcpR2MocVf+5gA6M9jMZqgIyEWBXBHkYMuZH/YB5KIqyGqAwAFaAFyhY9Os3eY9ht/+ftj+j/8tSMt1Osr5ub17//UeX2/emz37RvTcXVns81fK/ET8E8NbQa4bRuhDdl7nZ/vn/9vWrPlyimrR+7v35M18K+MHu7HtbwS4JIvyN7rknkcC43QDubst7NfVpskYdWKcbe/br0K3AQbkR+lILsn1MJ4UWnpV5s6EXkCWZfmPkLlH9uNFwb19y6674z3TpsnnnJEzlNhX9wKZC8ShXR942N5pIIADWbYXCOiEnOwXvjo56c6jduB9jHUv15f7QJlX9Nbyyw5yNhnHfbmaxJ8e+36wrTwwbUdOxm9/3MOf4PbO1N7bGpb5ajo/rR+99psfbe3FO3HUYx2pAtRTY5eS+E3DkJMx77luoO9tN0wf+6hzevn/zWzQxwg7f3m/iv6ReFuuBmDSirwfAh4QcLAoRFyVlpzJzVjtNWd0ADwhPfS5mC86r/7r3RhGyPM5puMf70i4lI+N+yD62L4T0B0BuSp/oO/IV4biiZMSj+fbQ71+DTOPWWZ1GCv9E8nZDFyIJpcHZ12xHWcO+gQ0E52sqo7uymK/k88MBeR7xr2zPubsKtVDPnv36UL+UfsIuAZrMWnHQTv5EdAZLkCHZOiHiJWzAl5xC3ymnV2hO6CEp/CWA58oesgNkXzGzspr7+aX/RaAnEwWj8mZdZ2sHxEZNyBW7QhyV1zrqdve+wrgEbzjgDeWx2SjIrywFOfln7v94r90LkAclSQWY9kPUHXJwdzRk0JghxaFjH+iCzIID6DeAPDAenkN2XHeN/NYx+c5J37s79/J/qWrfjJjs6UmRwMXUL6qHPV7BgNiHh75o21FoM/DHhE/AjF1MNd+Q9C5GylxWHp187q/7jaG/LNRe4GHZBy78WYCuDBUjsvDuZD9TIdsDWkk39fOKkIoi+IKXRJ72h52h0iaUGJvY/6rRoSzALwSy7nlxyPjDRl7BB/6lwo94yNnR/ahQwh94QwjEpk4Y8uc/aKjpz4qLMTUSQsIxMmWANWPnVhV1sUdwCPilv8gGY90JC49KAR6AJF57fjcbzRzks/meGyz2fGHoT7kG5+vEHe90kQFhF1iX62sG8ivyl/c/kbW5rqZaz14Q8adQGSz0VyDOazBWsuSmruM7dbTvbdVicUAdSvOtjTvn0L++d2anP2H1DZnKM+uufb45Lobx5o2rRrV2ep9N9iO7alUiuJ2XA1cud6bZyCT/In8E54z9LPNjsEQ8tkAl8a2IJ1yJYn5XDNqpsUI7Zy13Atjc/aCyJNewyXvvMbpGMp1D4T8hb0E+yog2b+Ya8gfuqIyDD9PxunmwJrPj3HsjIfzsmmXyP+NsfXsuV+NgPxbciNGL852/GlAiBurcbkFOtAl5nFZNMg87+G8MfSvdM1cCnpKCBv0MzGUP8z+KvTU1/jeGHbBJWln2OoS0zTWhNlr6Picc4LtX7n7QaYhfOrausWbnoNA/sS8duj2mHPzhxvwhV1dkPVY7Lgfv4qGj9Ectny9Ib8W9Wu0AwnwUDJvrT25KKfzt/RBTzol9hF23FX5AB5qi/MtvGYbqcE81po/nDGPAkl4zGuyBsjbTnSN2rmeB+KPzLULPHTtCMJu77uiO6u7zfArQaw1q8O0Yeghr1MyN/CAPD0Bv2thD7a0GUgg0Fsn4/1eht10QQeu6MqY5Nw2V3WlztgGF3VmJ9vO/eeEM5ahrcR85pqcsduno7kbz4eAsps3oRMKMo+fjz9wN7oRwAWWzuQvBRq8KXhsOt9Du5CmPVirkzvkmnzO3nBj3fdQlO1cd5M3+7mfH+yPlrfmj1Vo0JE2Lvv5dfkc4WHnzjmv3td3Xv+BcCDTfAcQbFDtoN8849Kv93FNoJfOfK0vzEHsZn/zDQI8EbvSijvjPYwdg33VWnfnHPsqdJnrXmRTNoWM10WCGE9eZKhr/SnKV5bl5Yy8NjryNk5OfxUQIQdjP671ELQJy5cj1a+++H3+TJZlKL4lxuZtrnLzr/jh3Zi8Ngh6Ax0w/638pAfy65ZJi0ltc7R19NDH5zbWZVkAOZ8bOUvZHJpzTrbkXyAg/oZ9fG6bc7d86UZJf1SjqB8AR0GD39+ZtHZGT/Oax+u3eVd259pAALmBC+FBtj9juf4LTgL8IEdD8IC4Nna2+AbI6Vhur1Oxj2sTtt+efuB9k9fHXPdNRGY42J+fZTtcoIW8KLu2ICfdsecWJb5xXPaVMydPmbaQLLt0+8COXIcdM2fbT/ait5JuKfzxZeRRwL3PAJHDJvlJprkOkT3mstlge6kD0qE+QR+izmz6Od4BGuAOs9TS6YC69rrMNTZjfl7Lx2JE8dr/6It7T/v7ADkdU1kOo8N/IsvJ+3I8duOu+PFMg5sHbOGwO+s2ujj5Ynb68418zuLdoz0kcvD7LulyNrohqy7EvB2FzuWZeF1R2VQHD7rHWUfkdyfmjJE/7GhhCLrQMr9NTm95oZ3cOz9OZH0W8zjbLMCZHI6fNFyScYMe+xqnRyI+h+bHforQgiL5hK1vlnx6aSjeWdR7C2Qq38CBbMVVFYpm4JnfdmsYfRz5aQH/5qj4BQGRr771h/XDd6wlcl8xvyy64T05GvdkUcYX4p8vO30i9miB/UNsqrzcHyRnP7X3QZJfd2sHcgp4Ym9X80ZOAZmHjJ0A8Vdn4CvuDWW8Fss71mX/yUlvuBH9dk6wp560Jl9Ol+qyhqGCkMCtd0GgNSe7OxoIyFkX/uwIyEfWCwJiPpKvewvbPDsQRQ/dr0F+7WuX+Zyck2/XspnKfSjMp8h43fb29H4hoR0CB/6E9EA8rLo0DgEFZGl3zs3vyle45AWIz73Qh/tu5nNJddAW43273avADzIU63L24URa8IUmKMSlpxvJm/YQkHuAAGoO8IQd+V2GAsjtzizP+25nzPMyLViXZbHQUR2MwX8ic53d1CFAfF0Y5h0OCM/9qNCtHAzNU5mTxLgrQzk+r+FnLGPPSUV3Nq9hEybmvdnC5tpaNnrz/RiK4uwn3WBPAgTXBFrRkZcaCcQ8RFhvMhZAzsaiQKxH7iz60ZV0VNixGgIC8hXaAwGqpTZ+3HzO+UOaYTNMg6A6OiLMVxm7ETrWvXb5Uxk2m9+CPqthfHdc+7pbg33XALsC0iCSLWeXXEDWjZMBcbgTOvI5v+8pOccSRr3mGgymAviR9fzXumcf+9+CHy+4Q2wmFeCdWAwchbRz0w8QBBTz5z4B5Es7rvslHQabX488Js9jMD/uw4EHDsrxPDKMVgChIwHy9YJM5Wjg4A/nc//Mx/myMLPfZO4LclAdjN2QFEEv8rHMx8aw1hefY5j7/NolbrokgCtD9AE8tS9xV9ZbW8wjIDdjjP6BUQjSgZy/2sBbQOTW14XdzRny24mKVsu4kvU9m+t2EO3hOkfuNMCVPuOOcx5tYeglPx3BNWjN0WHJwR76CpZ/dVExRErH/PeV6y2kLtf6qTUfI5+1X3MOS5diZpu5BvO4MQgqpxVHwwb6oC9wgz5tCRCy2Iqfk5mkLIYHQDa3W2jYPzL3dH27qmTtbf0LFe8nJbSnsUztkDNst+TbMTOP+cycG4LsNwO5mke5qksH+8irfl4dEoT9G5+JvJWkkvLL/OqR5Q4ETvpO0KA8zyDmyyZjBF2S67KP6PY8kIOuLJdb28PZViSQX5dd6Y4xZwz7RwYZlCgyvwz2IoB3TsZ2o8pfxr7QIGayHddgkjDv3f66Q9CWPgRPzOXP1I8TQbqCRoj9iUeiXIMk6Bc7+lJRbMm92trXwVi3nvr42WwMeUzc5Ztzj2bUDzoGj/y1ctZPr4EsyuHpNsacM4ORCx76uI18DqKvX2XqSnsnA5em5VxfpNvracayaeo06+4pSOQz932d86c91A/VqTwiP3LQtn6d+zw7OdrRRX1TS2z2N39lo8eW75sfTw/mvqhy7i+fQRCVyr2QNTJ/GLedPfy7eY5+72Rvj932wQv3xIgISgT7aA8u9FvrI3R+lbz+hLlOS+e09msrUqVTck5CruXqRuyKLgnz3NHIU7JpEyS28ylH7eV5xi6lnN7oiAw5557yeXJtsNya4wsCroWYe64dg/Tz7BHb5vNp8fbtkASNUZD5J+V2rg7k0ZWD8Zf28Z2g8dLzfDymRNkYswt0ZeqsrcPB9Oa75OcZi7kuirZ90THfRc21ed5GG1M99i7oEbeujvwT8uvMowhe6QjGfK7kOvMfrjm57U7My3q6t2BZyARdupDnjbnPdR+15pnrDYZuBMg38IF4LTz3e4T6R1DGbJvttiVmf+dn3OBkR16fUCLnssM0X++YXc52lH2M/Kt6ZdznvPFgNni6J3ZMmE8Bz4QOyzY2s43JxebYPrzggk72vZG+2mZWmvwybb47ZrDLnHOfc/CCC4AX7OMd7AEgwKfejMFghyDgke8E22zGXFMI4yugSTNEWfYUXvDQQ4w/P69JRQxhZTFyr+acex8k5F+V6x3JPrR/AhLyb/nM7GKCnOzScR/m87yWc8l/UF71xmN00eV9SZBvdjq+nTNjvje7oXzd362qW37+3jzSjWhtHx0Jcy0ET1xDR+6jiygG1Vc9CMRJjyFeilxTPN5akOs2U/VVXs9rzpBf18hDwt4fHHL4CrG7I8+7SZIHlj+cz92GaaIv9PbHhi7XzbuQ66LGeR0h6NVz20HpV7cj/uFX1J0z7AVmksnJ3KPScXaQfA75upuMdc9z4pllQV/YaklojNE5J7872w/35KeF8M5y/y+eXNYIwA58L8gZwUbOTdZKD7t9zv7MbnrDNMg55jNfhg7z49Yhvyz/RzeypwB/4yfDaO5j2lZHPrfLsEGjIdOal/WGF9QfEOS6S0MHGZvHfTV/uAvpq3sP9Uruy3T5/jswzJdxeb432AZjWKOeNn/lHqDvIbo8vpvPmzx2t1r+dpCI3nWjI+89+/WHThz194wdczZ0SJR0ossym822eS67G4uZodn+6mUPVZh7t03Njq0ZWtwzZ0F/cAaR17kvXu2Z0Q8N3PtXFggguyF/PB/nyxglZ0e3H/UIMmzQMXirGNtgrbEDSUffDfPj/Oy91S49h8X2P6IjpxzMj2vtNl+OhYVPgyfyv929jnPDEIoZms8ztLN8WeypD3NPX32GoycFYt4D+cy1bT1mP9DXIIjFZjn7ytlFRyRn3tbDbP/rTnYbM8vjtmwP22WNm6Qd5afLmXsPoSPNvxvyDRw8HOCogQMnf3QHAvvI6iXPXfrIcW+Ybo5t81o/4t733eY65uO4TauQ90UdiZx5Gdqh+fYeEgTEuDt9ZCrIeIQD/5To9phTQlbzh4v5LnSs2BFNyWMd0G/grN70Is+bYRgN29rqeB4qZfK8DvSwMec8yn2ZxpO5t6+/PLsUeSzRhe4sz0lEJGdh832Xzd6Qs6FI8sZ8Hs1mbOfHnhiJ/GXHlx2GDdn1u/ObuYaAQOCKf8VrsEsRif1c15dptmPOQuRIZWOj/6kHtfeqgKOoowWFIB0eGMM8DuP4fhVEb/+jnXHUK6+OcOTgduBjOfOcL5vp8uPktSNyUctZJO/9yPL85W3bGIM1sRoM3d576jmBONsRXuqjWyC7jbxD4AvNxM/2+tpPrf24uXeZaeY6+dVRzXzDhXmd6KYinwtTMMy5PYVefEOdFcd3yPs5yT6v9kK+4+vKLunjdSSemmswc87sJOlh/tb2rp2T8uUko/ZxLc+DHt6UZY90nPYDstpK1+Qh+ca0Bcvf9gHUraESSh7YDCOP894fcDNfblpYHb/qEj11fOuBVhrJshyd3eLZdTEAZ39pPuN4Q38mR+dMp8w191n0ZW/zHhG80cso31wLq5N7nfm5pzcFaCKAe/8rpwk/gA36I/IZELSRsc37dANi7BaRKvpoutRhzroMhEYCRQA+gOCaS+lrBrHN98+513Pn03oQcKcDATGWoWe6dGuZnEMCRAD5O2/524bNfV/S19XSHZYQMmeomQ8aAEGA4gMIuoKDHejD0wz2Rah99Yf72LjeB4qHvfWn8pVfz50858L3djzmn5y3xUTkOkjYDZeWfeBuXh++HcTZN3b0Nd9z+mmhjXH8oAsCbY0+ZJpPCB1bjqAHcNYuY+jrLNzwY5h7lILVIpW8n0GWXOkHAqLLnox6WDQcdfP+4sfZMb82u++gA33Y4A/0jLydf7KnV0frHWOQ98M+WJjlj3USf2aeC83Zkmi7f2TuoUuDeTseON4+8uNMPy7tbwJ3/lQ/uZaOzY6qW6P5PsYOY4JkMaKcg1xD0crjLkWnOK+U8pmzHOL964ue7kNOdeNHK7Fj3Ozo9rWHZ6Me6UvOxxgKkldH3xHyWImmOXPms3zGukCvfB1FLI+9/DynoiRSNe69lT/chpBFl1rwkdy79Fls0BrbPjzTBeLR9IuzZUeUH1PQCB3s9tixopzrqCQMlT6O1iMCfmJ9s7Ftx49//Xj1CYV43XgPCvX0Y5PlXPiXtgSdezWPIigLzibvVSIuDzFCRhgkzD301kh+MI7O5+uv1znJY6RpZ7sf16HfOhy5RD8RdvGVPhoRLcSmn16KLoEPe3LfLcivnkAwgjVIHpdF/vm6sL6v7/XjyIE8Vtbshh2GQi+PKtMAqUlvdEhd2qnoyKMj4utnsUEfH8ogp6gylMVtlzMhn9Foe0+iZE2Wkq5m6KcGHVvUBQet9RbUOR3ks6Ew5td8dgwC8kfm7qAZEGf7AAcOTgv0DuUv5WpBEUQjP9vHZzFCRqZ5O+b/5mIzn6U8rw/tan3sZewyzH/oW318Rzyfmf1BTaJ4vVu3fL+vjutgfg/1MJhrMCjqhgBF1FpAz8W+NuyIfG4npafn2m153D7meWzb8yPeEgE/uYbdkEf97GI+97R5DKhRj7yXs6XLms/ow5i/zDWawS7XqCQ6xADiZJzXQ3MfY2YYepGMPW0ddo+vh20YO7Z8uvaogAxzzbMGdG+6g93uO3kohg29tqOHCkH+vJtbPwkZ8zn7IBdCiWEUtFa8WCvyOZvXoNv1Qsx3m3H2hc3v+5CrHkLW8zlksVd0ue8ymL/v2n23BHm9LuuW17l32cc9X+9G0iIQkPteOLnN524/njXPW8w322XYb+yQq3JYAHGUXxU/j3d7fmjv7eSHeQzTb/PX/fCe5B7grR4J8+NuPewc154KsWGn+d+t3Ihv7tmHhvVW/klBBUTA3rn2xfOcezjzXujhZWxfLe9F+Ys3f9rrGiRiuJvj+LN97NIFOS6bc90NlHHVO9Nf1Wgqydt9sd+Ye9Yuz4PQpRefu0i6yXI/58Z7HR1nt1XCwdx/yOuwv9ANg2vVRGXZSSDQ2rnNVQEcPOlhsIe9DZUGgryde5jc90QieKmCQuzIyyF86lMlgvgF5I/tl/uOdqZTVD7v+53OC7Pf7vN7MZdNmaocnO8BRJ3orSclQKbyYMa2Mde8Xv4yT3Od1xJsN2Pw+Sgi14EKRIDjHX2q5Jweyj3Rxfji3h2d4487/k/dFyjycGy/RQ/G1D6P5rvLdYS1rz6S++Qccy2ERB4HKyUEKfIX5788VtfEkLlNO/5b7ubf8KvigrfGY08/xjwfsssecj2eR4d8BcMwIs/lPq8luWboRoO2esTdzv4smTWtkG2hYW87NnQ7WAVtCOQZb7szIFx5NfZUL6gflZe72Hw91iTINWI2CNvMZxR52cecQcdddCHoy6piDNVLwy6tsp+Wg3Y1zWemZtBbx+PswNn4emR3rrLsnltzH3Z7jr9zFzTMY5ILE7M5d/l1krzu9nV2NGQaL+aev12nNbMog1PbHiS6/Tz7TVpb9ZIdQtCEgBYUj4Rt/tBf2V90ZJbNe87Nc5Lrjr77rsvG3syjAwKOqI2+a/l5297041rbYtE45+zyXiKl+urY0R+cboZb+8HkZLEY+5e/L89EdGX+tnKuvCbG5h5z37bNY+/6CDmniwMB+bZ33TXstl3OsW2388MdMwymv869d7PQlSKvs7du0OzgfoALzYBmRNd2XoLOEFeHHTtfBPMeuW4+gpG8R3UUkSjlcYcNvgFBD/VpyzYGu9l8tvNz2zWPmXbO2jYo13zvyM/59sTNfdVHrtHHhYOTPn7OLpqcHenvHi0IO3hYB0Ht4cd5Gcw85j7mX4+Lg/Xx46vNPTOP0Q67vuwYIortt295Oi8Xy5BH2W9rnrT32kb+5f3Ujfx6mXuued3LsCPvO7ab6eihuDik/UmCeUzT1GZf7Hie/1Dz4xOxGzm3IfOP1mc9Z8iRG2P2S4CDBurA3oKO/qhbMfJ7F4yxp+U+YbAdQCc6AqTfdhDTn8xpmDxHk7uerr301R+A/G7Y8Tg9sRp7QkIfaClab/EdDeXiRuirizCKIJp9dXy/h/Yg/2QcFQj98J0/bjdnaFqtFZP3etlHkWzsTx500mBiRyOPwYCecBCwhzHAka2cSb/I4bHsCDkrXaJKE8rHY6Ru9whjh90GQ/ZQBUUbFceF/RGhQvVldxXRapHGur6ewZzFYF47KvC7ozoT9fON41qFfbz2Suxvll3o2OQ75NmZId2UaK6VekF0bIOIPHY7Z85ZlzMgXhU2P+4JoWIv/5xWB0vodrrc9sUazK/pAQXIaSdDJ+u579gT0LVfHLOPWBN0bfsBQ1+k3EPpgkrke4w95DFih+XsoKCPD7xZft1dUasRq2zmm+v4057+UQcdKD8OCNoS/LFfWxvrKL9vDOrj9fGyGOY19x2hjntIhvyf2tdnDybL85nl4LIvwi77YVF9hEkLNbG9k3nsmF0GAUE7AR5Z/0x62hUQHOwtuV7e95uXUx8zm0GIdoQZmV4EAvot9sO+VuZsctNCzeY391Pkfe7VCBpFzU735jrsRrysf2M2ZnVos3q55ruHueexy3Y762IeI9eQcz6ji4D8fGZvz2GwM7UWlu17DB0j8+P87y6PPdhmtb06kn9zmkQjb7CHbl2SZJnnhzzepvyal00eYz/Ii17ZkWEve8miGRxkU7yNPRjDMPWxy3U3R+qCoBfycjt+L6idua6Md/RhI5cYczbAtUYJMs85w0blZRTK89hxhh2Rs0uEMBiD/JMq0EzYvio6NogJc+5yjGxYInx0L8Q+kA3yPd+bqxyUAD2V/2Lc9Iwu8k053mA9viWQ56DEhpw9IIrSxcOUc0l06HB7nsc+BPf8KNtuvnPuuOZ9M2aHwTAHGrpbzvVCmLNjfpejERe/6GPYC90YZ17gF+VqRAndinx9OQsGOXOPlt2yL4ScFghAl9Z3lH3Y2zn3tHl8Gau8Nzr+suSzbvuQowFdqofHmQnWh+jS6pozIz9Dj4gH/AQ06KuPaP7fBL04fxfkMy2vo2kme/lP5XrIZ9JbMKw09tFLG8fek2937Lb5zvcucrE6Jc21F0MQDs5XO0PMj3FYTivTfQSjMWw79Ka8DBnbbEEfkseOM4P5Sw9U92Y+Mz8vn2fhInuxZHfbad+QL3sAGr3vytDP7OGc1/5qf8gf0Ik4PN+hDwxarGXH/H1BriFn+XkkRzuw3DHrEkBtpYsZpajB+IPaNpvHzSjplNmxj2n3dGNdsU9+HvugnjgXDHISPzlnKISKGAv9RaIP5RrLy6qHHfv4n/mGW7+aq3K3nrrBRqD+2uHs191kNh8rBMX8sTcEPRarm+0WNvqgV15lsVN145rKZ6jmunndjkqKoi7J2eZ1+T1BXvXThc/CM7ttH+hedAfkx7lH9z3TBMOKisp/2QW5GWvMZ667BfVDdAja2yVCfkxy3dgegpzplDPXyVkIOfcQyLsKEOe7BdCRbvUh3bYK+FqZbZmvJwSZbv2JA9W9YacWu8yfB+gxcIFOXc7PnTvM3wfLt5coP81d8olXY+hOvs3YRKWBHE27hfsV82Um+e/dCYrjOWL4L/6XLn074NK2p/zHM2Mfe9oRpF1Wzs1ZXfYVGMf9iUxtI2cHVAawjMbTlc9s+wb6QOYvBR34ETcoNgOcgANd97Bf+gXZbsts4Q/bfzSbP+2gkog8hjzOPZ8CHulMnYowOciNzyqkAmWLkfS02rUvhi7zuV9+fdQY9vXZh4B+LPbFtWG3Mftpr8w/Wx7zet4H2W5yNu7bwPby6ZYEWUI8JDJ7+/3QV/9Rb7Qw1rXfnuMHpZnxy12uHejotkushemWs4f1Jo+Zs50MD1Xc7IaD1IXQvjKGZZaiOTukZd7DvgqGjn146H5A3Bz91gioB6aXnxzGniLtSBYd+W7QcKDLPeu4d9nTsNiPTRfuzncDAfVTbPNp7YToMkJWaqu7NZ/nzHfucrA37n/0lTOIYd9jc/aRYPlG3cx1b8GEkAj9cO9Vl8nZ5d6LZe4KiG+8+onFkEfDCASlgxrOijtfNt+GZbp0gnqkHffkO7/Lxbl3+wbmC/ZhzPvLJCRCl9j6g8dcd3mfP21FfrMPLczvKehwNtOyo7Pdpwx2jBnzGpBrT8awJuIOFl3CLs2+nmIdz/H1hjigmzm33XIdFOEDQX7MNd/lsR8YxI1VmfpGX990JD8XHKSTPqVZ26lmJkiuEyG/xntTuf4b0CBe71Yc3bzHXB8yCP0g5Jq3eV32xiDrreSkN96TuwOiESTNplfD9RnRcUZ+Lab2jiNowQt5A+I3uwKNepj7xo7vDhQsZx+NyGN+XVOoh1DHXt+TrO9jH6mYiBIT7+lnxptJ7/u+ZTNdhX39roAuHL78HNRPLPZxa5zXsQ3bx+gjnx3n2OXX3PO+V+QM3QKcBLKeI9+w3ZTVwLajY5ItkepGA7adly3zOJt7hPxfKCB/mx5i2S8E2/4dA2wWQ8/8nJ+32XYLKM6EPgIO7hdDx7v8Mzuv1XaXmeW+wjy28whGzv6qPT11NBLT17hR/KjM+8T0wo4u+hhjPo9c9eNnWd4MiqFLK/1A4IZLdaiSt8cRTDTMudDt3/ed53643C1Z/Ql0fI9Bf2Er8vLmugsQY9+LtYDAmbq0D3Vwb9jb2eHG1OY6L0cj+meO65lu193CK1HPxLB7DPqaHti6oZmA0E+MXT4DApSxD40NgTjp12aXebWT921yt9c9M7Xj94MxZ/9Kp87m/UNwq68A/OvOfcx3lkwm8u0Hrr0sNpJ3G31dCWjCbgs76IRr4VcWZRLGsAu73PdvhOfEn9Cxy7MqLpxVBIQkTwFmGPMeYM6+2GZmpuWagCALhvSMs8vQTxTIw7EU686+5/ukau/paU7S8pxkcuZZwDVXFBDSU5tLipjRg/KV1QoqZN0jP7pD7HZextY6PmVhW6ADOcG8V63c9QSoji7u9h0net13m95t5gV9EcxZ82NquLIcQMTVPSDf86ocztUA+4Ps0LxvmL89YPI9cdcT0pbixAXlxZ7mPC24ZbvZwvaqhz8dxMW4LvbSNOYvhfbUgUD8Rcx7B8PWv0HG2T5uZP8BsilfB+Ls0bdrpCnTxboavSBCM7pEJPG3RsYuPZ2dgSzmn8OezjA/d+xi7MXCBDc6sh7tdSXPHV/OgdvYTF+csVwXM/923ejpnD+XZnXkbOCHA/lz9st1PwHJyzF14VVZjm8c9kMcFPRQ/nqkZnDvr5Nz6mnkLESe7d7FeO0y7M3Z0fypS3/h39h26eHxBVzaDVz6YenM0dmYcGbo7797nXOOzyQoVP/zP+gBCRv5VtADBpN9bCxLk91+dLJo+Adg2S+/91hs7sM+e6I+3nl1MzYKpnH/Xj/6QtLcKzXoYvJtMNRXII8N5uzjd9mOnpqAO18fsHvX/TJ6mfdGgEuMMf94QR8PAR2RHvJjrLXca8rrSXhBzuyQeYCDX4yx5l+tS4BmR88ELgj9xD1sadpzjPn2kctJXE3OYshOkxnaxs75gtYucyafZ3ouyGdr/x0d/+ADIJ2JPdnTdvvuPTxgXy/76QyX816J1TzP1a3vzNwb8tc9MsJm3sfN+ri3j36bwBPQGgKdwRUZNqgdd+iQo2GG0GjMY6Po3vlYDtzSU5g8D2ssxzczHaPyOLTgyqsxbytBQBe+t8s8dqyPyd0Tu5+jIXNjtw18QZYFAezSvIYf5cGeCGhPuyxoTWd7WjM5C7tgSMvb7PoYepF7QJzvyPc8D/5iapJPbTpq9mCGrenKs92K+8ntfSyKL6xtHfmygiDy6ZgNauX52lFdIpQgqBM5x7AN3YrymMeQsfzOxcAz4z5+ZO41F/RS3NQB4kj1s6dhycyPrj2MBeer53Jmznzfa8RiHoP4xv05R8fvH0mAI/DH2iqGniOQx2Mo8879ouhPMw6sO9mZlX7rHl320ALVYwihQ0yDzm3+dGw/CcDAPWmlR5aD2BWa+AmgJd/4Jt8Gf6nI+6JxoxrtHVldO1/NHoJ9INf4W6PJy+2YX7vRSLZkBr7QjsS+fANk4QeV7epH2tsPy5qWxzdNy80JwzAVdKfDhX5uctVjUV8dzbmvPdADMj31ZhuxL+OQ8a8MHTUAD/jpSHioE0G3QR57I4ydszCaBVnuM8Vi/GYvBn0W2yL6QJDP+T3XMPcwIMBH3v2R/RCrfY7bgaDZ7VzXJlbT/JK15tYPFrOgyocqwvyBVZew9XFC/bTNd4hSx7U3ZCxPAkPipR6JsQuueMA/CBz40SNOjreggANXupwRNnOWtXcTs+Z1bvNYDiT53t/I6zkd+Vmt5NwXIco5zF92INaf+VUZK4dnMz/mB/kLYyxHc052lc8N0z04Gmsd5Mz3fQJ6T6FLhiDIvI8/zbXI5M9oQX6q7nRI7o/5VQDlZz0hR/M5ujvWDMutPMacL/Sim5/fLRRMfAQnz/10Rg6ztzV0gcCQ6Q5e08H1QPfwHhraw6INfK0TnVkfyBvLMkNHm4bmTJe3uw0FPORO35CIldl2HnvKjaE9Ob/GOaENvPVsHHYi4JEwxAhI8IODlzvOduSzke6vmmYxZ2W+7HJvi9nM6xh3oI1UX9zzqOBS5C+T7zBseshnjla3wMAbvkGXXhUwVsUtb1xdCvrM+4vP7O15jR3SfcicO3KdMXcHi7X1brshNCvlLxOxYy/fy395YOiFNqoIKMLAiOOzPu71QxfAmcpFOyK7rt18j3zWtuePTYc+YRdkzDzK0NnXDdW12kmITgzV8Ye7mQ6fSczVyZu98zx/7d7RXv5YuekK4IZu3uPBWnPvLRbTzlwL2bKLYHaToztfl87nPvdJ59tZXvM/3AbY/rNc95MuQ2/RR3/0FcgTsuvawQF+OrKj1cU7a5Flm6/TTOg22CBzl65Go9YKulkX5OyXYGYH0bGf5TPon1x+3ROudOYzr9lN5V85Z4s7aJlvR5TmXJfUcdbsdjNi7Np9T65Dlev29Tgy7ztyuRU70f7g7Xpa0BPOdNSZ97HGVxBwINCBwDe0pVY2bMMx3XctOVf0+rbVPymUc8ebQbzZN+8bOy9hbCNEXX6xFXbz48LeLO0S+pEM43YXFoKyawuNxlKnqguxGotj0MrnNQ2x9NItImKV3B6beY7iyfwykZ8z13ndpfdoIrdeR/JtaO9ml13yLODOZisvppPi9HkwM68nDa8v01Lmk7xTFv0Y2M67s/0Qgj3VA6Yj/9uBbOfe1MOOl9P0H+jCj+FA7vaU0cegpZ7O0N18vmt50y0hOSulS6FcQNl2x1slWrsU+b2S7zFJD56xW0ejCyIp544wLIS8kqGTV5MQwZVw68kQCvzG7r5STbZNJe9b9uj4Pl8qV4XW3p1c87fd8t6tIzL3oe9ufxkGkWuGMr21Yx8hIBk7+uXkyUjbmhG89of32Bcls6PjrvAz8l+W+0ch54A2/ICTh6PLvY92y5kHHbnKjqfmDJG5Jvsdka50kUd3dizsTOneJIh69vQ2P5/HbsiWtqE7Ybf3fro2dPl75Xf7QuZctzxGkKuseuU9v+bSUYEu5J8eVe97QonSn/WuF2tk24Ud4+oImsh27cg/GJvvJOovlF3fiAjpCHYRki4ReZRNebgHAY8ZkHEx/+leumBlluZzrc25i+fdOuAN8BOL7Ryesd+ikN8junXi29rUOzkjZ+6Xa44I+d/fMfiR80I838YfbvFBkFCvPbMZDGsZzH2oK/teqWjMZvuolGvl3IaOPEeAgu5QB8beEZHPQReqdOTs4pX29jE2bEMEcEFCCBCIfc91p4+K+tAXe8pyDb3v88zzGMw2RK4+dT1s3kNQ/jBER94KuPH+x89H7qEkb3M1Du52HyMiyFz+whjKYl4nm3yWVJJPMwbzddQ70S2ht0YU9jLLmXuhp/WueSZnX9nHPOYsoYf8b+62NpODQQZ4Kr12fz5b8zmfs+O7Qc7Ndsk3oF642eSbXgyNue7L6EAgCMiufoi6cvg2dNhNri2PsiC/KU141zYOdqCFflqeLwXz3DzuhlVHFDIERCzXezTL81rke/RwbzH+jAUazOOsekPHZ37PY77yldudQh5qFO/R7HNfmDCfbYYKd+iS+8gZ8xzLQe8NYxrmdf7DPgKOAtz4ydxHfs3LYPKVRenMRUFJoY8XztvGtCWa7PbjJoQxm1Od/TO5x8g1yD0AdRY/HEjOUGYY6mMbO3KGTAVZ7EJ4SbfPmW6558x8xTzTBWQoIsRpb/xiX21bLTFtRq867Z+bJC22obtnP78r0AKQUKnIZ15n8x2AICDIYty2iTeGYdvYXIO8lKc7gAOgbgD2Z4RtrnctNcFsO6r79meXDF0C3MufEUHuY9CLzXMI8rKjxRP5ca6552VAMhSa2A06sC5/srox5nvWdvK5Z2HtoXcJ8qhAe4AvyHfnLI9j7lVHMD28H7tybh8Mw46z22v5hiQDW2nlphD/1F3MrPqOrUwPZx1JnsdY1o8TQPKKfGM7lDDY7aySa2/O+hTUMdmVC/f5y3wv2wktXG5yOX/HE7vc1zYntGlsbZ18uxDS7drKcoNvNxCI7bytYF/3Ln8pi8Wryvl9vO6X/ui70JJ7sWgXwKdcEQ/Y08bOwZppu9u8fn5PC2F1hPhpifMJdqDLKn8vPyl391ftyKOBPPTvjdt3dvfXucbkdv/++PHXeRgjH8pjHmtWjwlXUC9CiD6GceVXvWO0THPPY64yPBAunffjSr/SCXFyM7Rf1/h5bMNw73vz+lfXDC3IGaJLXO4GGLfLkMfoZpux7U/ohR933HPmtbMEAlzp2NiZvuNKRe0BTjp33b2zXq9rDWtzh5+e5+u87VbHJJ6Pid1+drBeLwiiW/ubecxPHQWOlid56BfFWTzqsbnD7UWMcN12iigyQsfzPHju6W6D0E8OjtqgE80QYWXbfO5jt8ecvWgExt2AFvSAC7qlSwLNTtdSQJPSm22N3Vfly207PgZlQc6e+g9If8D3nPmHY73W1AlyeV53/M83OijLe+CCnHTrap4XG351Tj4z99rOD58JDUFW5Dloqxny+1Hy4/ZHrsnYkW4wkJNjO7Z5nb/uiRZi7IHV2A5AJ092Lr9vW9ZJU8Xs7vbXA+ZesPk/Pbp0G3O0HoJ40tFROS4Q41iUgzvCeDhA6FNttQC6gYw75k5QD+Xk5LasV0anU7Z5r5+x40/3JQT9EfnMjzP+tYhMPbCLC3ikBY9sJjn4u1vRBWELR0cV5GSeZb01b5YfrUk0d7z76esd9TXzKUDQn5A/s2GBODkul+Mf76eFw9IF3QPlZO4N2tjcrPXq0oXZzL0/zheFjC70BfF3Pq1LDyx/v8vt+PqA0Kmh/YH6xmk3Djt6NK8CcrWZVWZ92DD3nN0+y0yyD0FwT6A3skuDvhCCXaxv3JnX9nQSDwvZRCD8EGz29rZ76F9S6OvbJEeu6XYpZg/yB3MNMx3zX8qz7WKu/TbXnIngZ3e+M/Zr8rJ8J/KRu7501jUPyLv5LyeNGq1rDpPPzEHvb+kIimG2lXZ+sml00w1TC0GQu3Kz52Iqf6orLtyWaQ+c9QeB5MCRo3u39opuH1M7ndffvzpmrkHRGLn7ccOfeGzd2EF9SAQBL8jFYuwzseyJXhrpE+e9ARIg90P+MgRGu/+8ba9TLUnrZR2/Rtjpe4hmN/m2sd9bz+mQGwKyv48BigeCWPQF3JEHRRa94AFF/tD+SEA5eX9d2us0TWIH89tJyc8NvPSj85xT7s5X9gvCBfC9afrqN17Z9APin6K/iORk88tnrebLcuc8bLOZv3fQJfuJ644gAvDCp26BQCvyu4kd2EcDP+54wI0AGfqXnGF0ohwU2CZpJmLDXUfm2jyn9iVDL0G0IHQv5LHlT3fbB1ux/0t/nQxl1c/UlV35C3MtZ8yvHvi2izTToMtmO8djDEOW9fVogD/ARMn/tNAO+FPrshdwgDnDlSf9oe2Of3ht6xaZx+2Dl3WZOcdsGtSlBnUu+cZSPLjjdfSrfbSbGwEIuCSX7c59sYVGsIIrnlNH0J+Qx/Z31WztU8X0MfeKQgc25nPQdoEKoGNTVxa9xXpaziFVhHDNBvM5Z6wXgIAt4aWTktmTBeHA2boLY9WPLix7yexevE7s0O69vXlluTM2XE4+R+6DRH3MO9Xo7IT8uAujIkiWBQc/LwUoCRG/Bca0mxGAXGymKPPOLKt7j/Y1uXslsrtlBUXuvfnLG4a9FOdj6CW3ut2VJ/exK8M46WvruwjgnWVZjNsC/kJMA5lv9mesvWl9Veniq7LZNpR7LzdjKIdytLt8K4BJO37sYf5SvsnUja+/wtAgfNR7LxuAFwIPZLZgC6yHrrci+0eOKSS55uthjPx1QJ2YngIcufYYUwnIlWF+baMGAvo5ecaeYL7lb1WEuBiAe0DMi/U9/OX+WQeHPNeUPgxKnvtNLl/AwenDD7Hr4HKshnhC7nmj9eLPRFvx9UKMvcLOtUJHR8e6/3Hoh0LKx22GJHPfbb+NOwd4Cm+8+nEm511Zl6FvrMsN/ydGLIqAA+hMLB6ITXPW8Rnk8f2ftc6Pkucq8pjNvSNzzrVz5IjaUidjD4AvPNh+yqWx7cjfr7cAFxCVi0ETwZ1YFpDNlOd9/Be8+qE1pHh7y29zzj/fP+I6VuWoS/KmP1Mf8E7c9Eys4AYtnZw8zON9W3mtkSjyvv/63S7sh+7tHuuGr2Tgp89ZmUuvoD9CELdTPHcy8UPmHnQJLrQ0cpb6+aleZp53NOYt9OfE3JlnaOTryA3lZ/2JkDflqVyJ67sJIxnd5bPlu9X7zp92MVgzqgbuhGtyis4EcVCedUVAf6DPj4Z3mqy30wFdefDI95xhkGXfaMrZZSiKXSz3BovtSGt4Kk7F3IXLtrIup4VuDPuNu3G6pTgYTQTkF/e1hLUln8vzTttj8h1F/rBZAbQB3pA+F2NRXmy8L3FVIK476Z37xeFAH0F+ch4gbQqj9TDMPA+5J0rpD2gCAbSDuoIbdOdPpQtXE/QVuRUvyrw3muWBPsX5mAsI9NivMXasadoDSUae8xj2QrM3vbPeOgHeiEW3xENxvT9n9QTE5W54Y7/0cR0ysgyhnHvbR6W5VgEC9Yr8tgB57B5QW4ja1oPFO/GoEwX3gq7EWB7va5dzb7RFgkqn3p7Djnf7PSdAyv3YLyD+cONtQc7GX7QvnfJ882VzT8rzQA87OizXImx71QEd1HN1m2f50fn/+tiDwQB3/r1z6+mbb+rtf+3YbWPuWzvKNf/VeD9Z5jXoR/7L9o812X8T+yl/vYe6eap7G+roI933aaWHoRS9/+M57mO+N2tpyC87IWMfk7/2T+jruj/aVyP3/VW+94bY1x7e7HKXXyznFsVu4d4UMnImtEuXfM62wToJ2xd/aawfGuBC2Mb+oKcdHX++I0z+u2ua/Livct3t/+DuMAuK5vWBY3pImZblcx6DNUHI2+rTmQY+du8l5o7i9BrtyF9nf/J/7poYMfa/oX8hHs2v674PJVjmPuRxdMwO5NplxlwrqA6seyzP6KMAGjyetd/OHbF/JOyttb/JPn49u43+mR/zzMUqpGNmu+V8/3rVPcWE6mBBt+e0sJYPBPM2gPZcGvtTAB7RbepOHy897qMPY7667Gkd0zT3ocl9GbKv3PehS9ht/vkWOw534TGEodt9v+I4a/kya9vbQj3U/IMFjcgZexrXDo5cYP3w7QFdPBHrO7Iu0zLEZCVCa7c8xmJHE+RtmH8y01xzloaZs/UVTSIKyJZy/aM+U0/MBiGY935NOC12ozWLoGObRZMk5J7rPgLFYbfaETsaYTJ27dMBYEISbyaP8xh57AhZyzX3mM91TNPXbt0+h9QBG4t5DcIwJDl6tJs7sSpXKzm3W7B35t4xpMp1zoRhZoxWnhM6rglQZ0Ag8hPPk1cZ7rezLe23PsS62GWQ71B+rIc8hvmxyxiir7m/Ife57iNO22xE2CHrsSpXE5XhkutuuGwIatFuIp+5hzqWkP9FNz4DBDzmXmzuo8nkzCWYcxj0kWtfI0jOLrlOx47c557XHVWQOdtDTJs4W17kH5Dr5Xket1bmuck1z+0cMXZJghXLbzvQp2bL7SNsyX7bj/3FBMtX2gV7es9ffqPL50P7L3LLrbVbrrJpjsIBgnmxLXmyJ3SURdPDcmblmzByLEmKkl/2Adq5+RHDD3ioSZP9kdHy2m/sh47P9pLc+4U1cs5L+4kOI9btGgcn6zEXHNCAAJl3623uW2etfM41src/n5ByJqWjiL5KIojDzWzh2j6+gkt9zSeBe9+xXtDL/PDrMH005N4P/M3nXFNIJosxLUN3zFn70BggGyQP7ouGjrAfm2+GnK09kWRIR9LpKHTpFgIR83ZQwIR+cc0lu+SzUQAxFnBmH3n+BWOed4xhx5yRewt5bZ53CWGeo1sKItcQQMjR+bFkM2Sc0DGGPfz6o8uOMZ+jiTbXnIlOneojh45HmVaDqBaUg70FhiInA6ggFgUZzzki9lGQszWY6242mHPMMGhNXmY6fpzJmfseRAoiwS5f5WsYTlrZhdmOQVweLPf2w+vne1v5bqT3J2cUFUQUlcb8m1UXwL3PS4j8hznrKIixCsg0xgvlms9hx+tmOs6IeRyNnLsEzAHINwiQzSIdd7MnAQHkj2UsJ4QYe6ZB3nvVnz+VpY6gibnnmghCoczj+qOQX01a62N2+55+ypkaBNBgKIuBrpEWugzmvuxg0I3yeh7zPVZlHJAsR4KM0UMDQK42OdrS4ckZ2g87DPIxhNh02TEfk0Lnm6E7FeynzdxzrfQxHjbMPeWABg7keIRkDXs5dyKpkrMXjA507P/lggwDSPa7nHMdISBDW9hH/Aw9NOxGDCPXlOvMhoVKPlfM59lKB6Egcw65+3Eg8950hwhLrsOYN/d9yA4+AcjF0HEf5vc5c4/cdzu7nWNMZToYC734epgkUzFsx2MI+Lm6F/vY7T0vh9rIvZtDw2Y+ZkQIgjl3xOk9Kce+wzB/cz2wgTwZ0mWYvy+R8gs9PMspTNNuvbhnKl85LK/lBdsvdNsmP5v5bYi5zrZ5q1GIJcz7BD8CQiXfdQzbkGu3eY2YczEGiQHk2QgN88c7+CTSw6/9JMsDCVkvvajCyIEgh0X5emV7rkOH6/ab7d/8qz+P7bv0VrCZncnHrOXHggAqw/RFHw/lfUdEzsEw92ADAV9wCfPfloj8zT5kTw5HTDlzlxflN4dNCNuMjrosr8fmXEdEet03Mzkj53513VEcuPaVoUgMu30fM3g6+i32kEjk913ushnnIgQdWEy9ddCeuC40j0cEI2wd35bqMvdJM5ZWf+HWXr4xrJXnLpN/MFefuv8QdBmCyB+1i2zq5/SYEHX5/3U/XGcPc8890/oqhjrOmYZELPf9zf5TAH2CZqGPnxM7OvYGRYDAl+zpOdeQP8zjcuPuRSVnWB8f6C1d9kS3sBsba9Uj++IM75E511pk+c/v6Ni0yXM/XTt+3wEy95F+ir4m5M974WydueaMoEDuNvrNW4sFc98eCvsxKddIM0iIYa19ENbv3MiOlGuACCrrOzbb7OhIfpwdW66y7Ur4N64veZ+E/ibfs9gSdI6gJAgInqPqCUc9ncs993w7Pz+P1YfknI8x54z6hOax/QYEBMZ3ELsAMnfJnMO8Rqmv79mVgy6cznNoD5L6+HWX16dHUxQqd1Euh/duxvJetz598v7rYfL7Sc5dJovQjnmOvUBszr+527CvFNFP1zn62B9W/vCX+S87hER5VuR06EM86NIu3ah9dORl7H2N0q9svp1MWL4P7elyB3a5z/u89rWP/LEv9Qd//Iv9WeA5eZlTdtfHteLhBnkcgl3+sBSDfZEddMs58hz2lN+dtI/oi2rnP8x1l12GobceyvsP263+F3QloAuEjl2O7zbulfFeEBrTUe+sRVu+nbPc555SROYNXOu45uwiZxC362O+Zd/BPFbnv42jTcDBxXkMkMNBXE3u4ccz/74LXULuy2xsMMMOIxj7ZFF1K1Jy14HgYD2f+Wy9+P0e8j4QAd3Ybqb/nSEgYy/ciyQOx4vpppCb0cgXxlk+h2iuc5/L52gx5zZD9fPTLteUEiKEWFVw9D1nbCPXNNAt+/reDoqgfB353YA+strHHjqCQNCPxFAEUOVyEPHtCPRppnt9j4cqBQjypJ9rFqIIK1/OWTY8SzYz96H6Vz6GVLHoEijHcu0QfW72dW5AFUAZK4dlOX9wj6+ATEOQzejU2XBlU3BLcnOVsyF3WXXQkW9HrlG81mb2m8/+PK82X861wi5Cyrc+p/uFET38cdhlt1cVaACqJzYf7BeayNWIeibAU4dTQiVyPqBsXpH1FLkG+2CUCFt021yHYR7ny+jYvrBDJOhNZ1DyhzJ2ctRr29diV47v72S/DuU5AdnfLd8uybgjR1uXj7sxZ47W6nKfYEa7XHuIIApw64wGOySEnmI/TGRfY4Di6N18t49zxoHIky10ew8anQ0K2nudihcFF/CF3UoZLcy+EXI2mo8zthnKbAzltdz+QQg9nM4gugSU93PN9RjymLyes4d4NE7Wk+CJfpHNJwwhH5ekbvMe65M592zKdXNP0ADRMzuSFOYMQleU/N/YQce92wYvunPmHqudqqg4H0H+MLptj+K0l3ukMCjo+PXN75/necZbxzkkBIT+5/eEuebMGUTOACc9zJnrDPtf0CC6UCWl5bugDd3B4aDbu5846gcoqI5UyrXAhZawQ1GXLsuGjlQvsz3bEVXY2I69b3XZbdjGi+2G5K6AXA2RxxAdgBxM+Q/VNxYfSBl0CWRbbs459CUShAe+8S3O5xqQRdv4Xx6V+4iLyI+5ju1ozq0XxhApIQDBK48TIaLRdq7THziQr88EoRY5cw2gFQddea1uQIJcDKCOXfPn3XxJZEe+3ebLRB+bbbuFBil63Tckco1vnZs9yNkt43JNHfdKD4vJs4ORPw3ClVfDvAviBYuryX908qO7xXxuzPec43luo3WIsm7PUZ+xnsMwI88JFFNn+Z5z6EUF5MUGiFRYY5cWigDc6NZ5aSAE0IWgoE7JtZ9Fx7wumyEdtA1lGvro4hgl5G/veOlHbg5jzOtkXWB+jvKqTH1gOCaokvtscy0e3tjlRzne6G5eu2aTz4FvTWd2W+5Vmp/nGfl6JrY/S+U5KCqCYHRimHN+LKEL336ZOdPHLw6iSgxzHwqCgGMQz5nvQjhwxUGj9Xac6CGEK4gQMYybQtiCgszMULJdet96sd12Y1J9EQrn58sfDTnz60SKQpf8eR8z14ifzXUahhATIRBfZagoN/cROfOlDN2q/FJxhIKcNoIAFNwRmsjwYc6SPEdHXucDm9fMIEORDb1OX/UilD+NhAhp2B/lD+PXlzVnCwa1CEqWldu7kHtfXO0XLMv5AGLAvgBt6APz2jDL5Z3YDo12c7DNfDfUSRj2kP9uUiSY9jfvI6K/02UsTJ4bEcTQhcP1cub/QyPm7hSLR67d7uWs+fX6YJK+NWzC5j1Rl/1uco1QbPPfFyD6nccMwbS8D6RL0UMe0217qr2hDz0XEIQfuerGvrCn/lmQMG9ieQ5B32A+M8wuuVaurR8NIgqF+RfnFKEf2W0QO8KyLJu82df2lfvoCdq6J6HXgCAAub0x1EdHTHIb5LGvyp8uz/Na0kV+O88hCLP/7pQ/cWQ16F+G5pQXO36cYYRy32XYbEdSCepWewoggOSRXCOfkRG6GUt2medTKX21h/nxQ5fefEoSQwcei3KmcezELhs7UBTFp7ZdRlJT5tzHluv++099YJduYxuzyePMcxCbq95K4I76cdTyx4q3dstjtaRN3baWl8G2j/UqEbH53Favk+ueRAn5cTcicm3+xfkKEL8byZLRrDBXRbr1tzMGHdiT4A5FxfUR9tLo51sjnzwUY+b9xynf3cdnJ3b8ZWSCB+7zsuM6iDcgAsQfMkxMJbnWAcjj24Z8psuXLk0oEG2JK58d6xj7Y5Ezdtns2SD2FEsp5XmjktlHYxg259zcC/Rwtwsh4jNdCsPY3KMSJM/iW2eKLs+92x3NX5bNLtd8G78ccs19s9mcUx87WhOb5xL57bln/rgO1p4IwytFkABys56u+bkdg5DHRrsdS0+GIiXolS5h0KcNBJzl58D47XkcXcaKLsz37PiivjDYF/til8f9AV3u3e4Dd9oDA4QgF2t6yu/TokURQ6CBnxoEdOj3oJDrXm3PNY4qx8MIPNBD3Ros53LdJV2GsDPMdwd7uHYx3TLngE6IsVy7DcZmPobckMtRD8/bBTmbD/nhAIppx/oKplLqqFs1m25mzqAtwEF7I5C/MEgRYg3mWoxNsk7a02ZffpXPKbK6ZLji2ON8O3Dn1w1C7ubX7QVFQRrkbQQIqAJNqK1tog9jqE+Fst2Aqk9GhxlEcbLBdgsgBN3oubfvMclcJ9cNNS3p6cvyEKzbWZgOydV9Mf8nBj39ZR7X8T9fN4aC8vP5nDPi9TBO+hvRK/OPxhJ6yD6Uzx12C0Mh0J1r6zL/qqNOnYn+A2rEvqheCC40aGnbl31do9zrB5gxQxFBz4Q4LLu2tt46OlAwY990DO06MOwh19HR5XOIXMtuAbUDYg/JffllJ5tdenUxOCLkAWPO/DcUwBO/WpdEXu8I+fl5j/k6Zt5j9BAUJfYVVGwb8q48K9ANj71YG7qkJGfI6flcEb4T38CfarvFYLn3dObs5/XKuU/omTfX7RJMeQ7uvNoFcNS1oRd+t6CZHP1ieGTYJSCeTUARWewdGzXvU3wk7JuzvG+MOUPY2t52uaeckwmLB8uNuG6fs0FA0OBXFdqLbeNbI9S9fNBy35vrzGZ864UxV1Vw5pnRl42wT7AjUaUPZUTdplwHYQimkXO75BwihvgAtBa/HyHi70B8XSkGfblaztBxfp5t3q4LAjKOw2+7uW5zRicU8n1iwobJx7Qd7HjP9145mPQrgQDy40GA0A11DLvyeKBTw9x76BqbnrK/2+0aVFw0pG5FjKGc2xHa/MVQMnvXoKU+dSJIfjFnSADibwmgrjl7gs6lC5Gf52MBPTC7RL4u/PY219KgzbWDyKZgmHPI+yx02+Ua8lOX/EC4ddx7V/kTA/qAItcxCogrdRH9zJBCBdSlV0HAn9pt8zyPG1FCGMrmyzQxwY7PPHa0c1AQlyKSckEH+MKAI/Hje7Ff7kEA8dy1y99GIuAj3tkxBgjkxbA/me/t5cvlGhmZc7fZ9lrv/Log6djHfTkaX98LMZav/MUJ3hL6m48Zy+2vf7CX5erWjxND0yVnJCHWOr5fl6qPYQa5B/UO7hVz13xAs9iH8I57NRA80jEOOtQphv2qT4Li7PZ0/VIF6UDRV0a7NZi5hpTcK4vmvk+D3sd/HbmpnAz6iIADP+wIrQxBgwCJ+wc+hY7c+0D8gZHQyA32tZvdAAWknSi63QPwAnkMGuRaUGbd+oTZ2/qzHn6xBl9HDGVdNq4ZiGHEVy8o+xEOrhfgudD+rBRfB5vzPf906CMGvDFmY6K8zbWtd2tdPg7b4yf/7RB1oa0+rDA4buxHrAvSubMy9NAICEGuDvqjfA786MI87mOGoIX2CiEsd8Fj5wzHy/kY1MZCtzm39f6NsBtFXIxvo1gOEAgvbOcM8lOfae9kKEDtzQbB5+uo2iLzpyW6TJX5nB3zedOgMLaDguRziaeyw0yky8wYc7YyybdzbX3tCEO3IRoV0ca3qKUKYhgBeGts3ppLQUEDL3Q7EyQODmIcxTjGNRtj2IGU3Ls0AJywyms+owogTsYn0U1M26OOf0PiU8025hzmhehDPuNuPudcNjFE8nLbPO4jv+bXKtWxv5OO1Rj5MczZgdF+CrrNc4zJ2nFGF63t8rwsqMlgP8y5o3xuKrOvH1NH+Zw/ruNsl1Tk3puMCgcSwZyRTRubryPF+9ftYb4XRqLEruZ5zb3chw46hlSp931jsF/kPTH9ILPNXHOfLOygL4wdc857idCyZq29fBfEsOwjSMRmN5Zc9wfzIZLr3kKMalquSxgdQreCbLMdJfPLsSGTCCns1/U5GPk991xb/uvI2ZydSuxXQfpwH7Qm5Jpr6Pb4cXbkMeS6r3zGO81yrtHCyNm43ZdzBnNf9DDXtTebWMfnsHbLdSY0rQbzCdLxHHZYzhUlRscObTuYb+Z5V/lunpOPuQe1W+u2p0jkueT7veSemGs+55prXu4p7KIvZgQ5d8nn1Fjs8od53MfnvEbkPMaOv+24Npgfc4210DpU5OwpZ8hjwhdddG+lp4KIveebCel2poPWsfwnUx5D2WU31oTQcR+CLpjQQeiwB+Qcwg5mgh1GXpcw2R/dx3zuljEjyNGHsb+YRdhhM+wlZM6esndNo09I0otksFuuFzsaHe5evlzzOdi996G5FzoqIdaGXIsdERbrmKboKUl1Ybdrzj7ly7lOCB3zOJjWDvK5bDZzzTn31AVDFuzIYq2j+Z7Mr3MfuQxzX9Mx5BrNmb/suO8178iikpkFk1LOZE/LzBkk6X2igvl6uO9N81nkLJTYlmvHy5wJt6CU7yG8Sfm4DiI6yl+59nAfzHOIt9PBE2uwPG4+x/xh/np9/ZjHLr+GDpeh/8TUsuRgBheUVEKQt0MQsu1FMxtGQ9u9/2xpRkoySunt+m9HrummS6rlmkT2cU+SvxkdpepXZ0jr6XkdLalSzGyx2ay8drM9yGuyW0cn7Gi90W0PC5r9vx29LeR6YPnuoQhmawWtCeaf67aRys8biY5kLwgq7v2rDYNhDeZXL8ZCKdchUrEROq4tj3FL5Loj07T2sk9DjJQkjX16bKwl1nqYoWkhlGsQeZxGhnasobHNmCH5jBl5n2sQIWSux9jsA1Ep37M1P+eehSbXDc2YM5ViztagMefkDNn9OYzZPM+yu1eaz3wvZ9wSdEmtY/nsS/Z1b61pTfNruZbrmC4xn/PYxbyGZPVkVuQ5GGGuyzkzZlguHY579oXJNYQ8znU2drRIStplzHV9LTsa+bgEzb/EjOUolzErv+7NdvLdkdKuu5eN7Hi+MY8R8sf5ZUzTwoKWtbeIUrLmuiaTMz8c+wrR3mmIiIgdzePCLgb7CEFrxnqIef5pvsfMZ8jtPueOX7OY6bLc/6W1yMvcruXbfSi2dSbTx9fL3ntljX7YXIfozWPLftNxjmVaazJnfn27NvflnKyDvpo/wXKvQ6T5w9EYrGN54yLfrWG9CDHXkfkj0Wh2/GnmPpqcCwuhS+Q+G+kWGXYE8T7O/G6ave+PNPO5Sz6PyhlMEcq5Y0FLGIYhVlssZ28uO8QaxuT14+UYDOuCUGNSJUSksTAxRjafZxBCsEtohObwGXQxzNka8xpP65/AWpPr2oOOLwe55+UYdrBfvXY29hEVzH2fw9hlzDC0mQ3q4exosMuYM/d5zmQaso72EWwqerbJfViK2AXtA93ONkEqZ8TmvqDBMPSb1tuZM9dhN0R0zPsbfWBMf6WxDyxicw66jbHcQ/vKnMN9d85i5jOfY3u/mM05m0nWNrOpkhg7ojpkMzP7oYldtGkRLS17melHZg9G/68FGxkfu2HukZmlsUipnHPd8r0OG6RfoMuMUc58DmMISmb20dDaD3KOiY59hflcy2aRlZiXNWaGLqQ8T+yybeZXr2XzmC/H+31e0//zOEN+XeQ6Z4xhtsNeYtB8Lx9DY4dc+4GeuTf3QhijV4m2QZqPhUEXhpjsci+NeT2azTVCLzOPH/Zgue6SMzSGdWuXTLCPtnxsjBhSct1Il9CyDuw25+77R+S7SQCMs2Dqq8ehhy6vxzwvLHNO5G1s62i6hcg9hcbCmGEXDHJBiAoyZ++Zl8s1jBi7KHPu65yx02beZ+wjBZsdOcN8FyERth1zncc5Nx/KnlVErpfKc8lZCwEwkA5G2xEg4BsKSHBRI/pe2DHPe/EY4vg4WR86hjSyfAdBBBGzxFzIjut6yplQCEFE7AiLRm7nfObzB2zO+TXn/BlB5joij3k7bPN8I7IbEYK8jI68zTWQECNo4wYRyAMDEEBnAv3ONXKd911yBmvHIPSiaRaTPywh6NK8H/ZBt8hzHmMHKblmcg3mZ/M65nV26fi9ZGa+Q8ecObt8PWz9AWF62SDJtQe5vqMFkPBYZXIJ8r0SjDeGrS/6VigxIyU587zGMvNlTxprwj4iIshjFrans73QkN9HyrkGQ8s5/w1jL/eo/kKwec11HnPWN3Nd1g85J1+mmRlaFlSIMSSBQAAfdNcueYcPAMFrb8MJ+bKDTIwQxQedt7M264giZ85PWHkv8vUH/0TDkB9zzX070kNIffp8MghDTPM4j13mx/l18sdB4y/mxwQ9bP7ylrEt2r7gguaMIqEhiAQSJGi3ZAcTILzXwLr3uLs9sKd7KvNclCSUMfe5hx7um+v6CsrblCY218H6Wl/zOC/ruFZynTFocg57y9/8GIX62oNc57d5j+Q6kT8ewTD3DjVuZxSqTWMyKkAggOd2DAiQ8LYQ0Lu544vYNwiFiZwJspxjxC7X3rGW/3iuGdqYP/1h7vO8g0jOh5br/F3sp3vo4zX/ymMH8x/uZoY0usiYCImQPE4wBMJZuunaIt8pINLLursSkjD2kMce5myuizBCRdK75sf9gIktC+baQ8i9i47pIdWhBGNDsMx97Cf2cE0vUcp/YC/RsLcu0/HdX1iEmTLXKpE3tCN2GYsQCESwu7V2AuhbAYOxp57XKX9wVnnd8XWex9yfknzv696LJY+JsWP+eN0SFPl6WXM2WcLI84jBjo0d5nE+xzbb1/xFrvvaBeG2Y2ZHhI75Mc02EiXJg5bHsTwnpEvs1a56Dm/rKQiIR9OPTj2kh2lBpG7Yd4iCQQzyNhrWyC60mCC7yL6ChJF1e8xjua69MA0myHyZhtzX5R6R0cJStI3N0IIus0tPdgQ7tGjQGvOZvnZ0i23blgjlCFqoY9ReYMDYa61e+4eKb5yD4Sz3Wzl/vY7vDg2L6pOyyznRGyUpSjd0pKTcc+y4jhkMk+ecI4+xEnRRjHn1cgStd+dMH7APDZYz5XGY9zxHl9+XhbDOJ/miYnSYmZxpN4KLkFlvgkH6222t/tWvQ95FAEE87u78/Ncx9MBM7p0fTMMgX9abrroaG7Pl8qlt/zZmzHGf+wiVqgmWkcY+n+UcWjCzV9OcLW0w3TqwJtfqSChyb6kUQvWR/+l/SkyCFrssix2DEFywm25nlbM1m6E1QaxLxMLmPgzhzfvX22H95ldAvgsNzkN7/evlMZoR1sznmMe5J+lWSiQxjnPIPWdmMAvzbShngqylaWno36dhrqPj7SIYViYKMc9NF/kMubeK+h8ZI68l1yCIMAZzzhPK07IUQ5WZ66DJtwl5DHIN772+dEY97WV811kCru7dvkjMdUkE2e1lknMoDfK5i0yRWcQYknNHL16HnIvlrBDCjuVxTy3PC2tevg26jR2vjeZgHocdIzNMxJxjrsucQxJVa5rBSr4LJmzLD5N3M2fem5fXccmoYRmEvCFENL28t79+fCGP06AbttgLQZDPXYbZLiz5XhgrubU8bkI3qZrv/c+yCfJkiE0TI1gI03Tp/JozYs5ufSzfKfsw1ygJls/cR+OYIZcga1iDvlL5bXsXyXPkDCJvGH6+Pu1VIzGGNyUA0bh63bt//+sjj7n+O9zmp5Vc++4eHTmzS7ogD0O3+5xzJq+Zz9bTmpjmXBAtaMOTzeOI/Jrzf+beyGNHLGcMMX1ozFzHdhOJ/6nlPtejm3N9ZbqMyKsJujsHJPS3tWWMKiDgg8Gg049Xa/n0gQQChMbKNQix3q255tqSPkQk5Rpaw+hYps3IUJ9eisxItHrfHRki5JyWCD7G0P4HzTnkOWdHY5jQkUn22WKpEs1iUcHMvGbSkXO1w4EWa620Y+7bZYsuw9ybYIwORoRECIKwXqicfibffLBJvWqtuf+6gJxgc5bBQq69GGzItaLNMmPOnE3R0hBh/5RtDqOPhh1JtJyhiib3dGtk/M+s05S0cq5hsAsZEZeJXhALEdk298Uns4+Wb99orON1JtPE9sIGTzOX58yP28EIuYdIeCh6f62Rzo/X2Xceh6rXYR/5vAE8CNOCNPeWM2MzcxZRb+bL+TjCRc5SY2utkQWJMYZLKdZaSpZzdOQxGBXxSVFjznkYOdNlFiS1y1qWe4M83c5cZ+wSZLdKgxGx5PkjWGNrsRd5XEbLuR33vJI+j5TmuG6pzuusFn3DSnV+JD2fN0gIhOPbUeSaXJd7heTrMZp8LDJUCtbI/ciDsSM6LdOOewYlHW3oqElSWUbDfB49+GCQkpbNz3NdrOWaGeblnBlCT1iUsUKrSU9r7suEvJ17x687ci9vKj3nqJw6LHlehPR6vQptVQUIITSEGZp7wg70lWSfypebOTNhKpkWM1Qh516k3iAGTbSOSMfU0BZaSirnMq+zck+0SxTRZY3RZSYagtAY+8iXkaz1vGwvNm01Edpq2mTOQUPt8thDRzRISyCI3eLqqlpHPnuYfKY6J6CrEpITzLlnFrlHck5Ih3OZmS3DiDG/zwdNayaEXOeYX1ofGHKLyua+ZM2DRpMfbJ4k5+JGYqbS1jLDaNA3NrfcW3Om511GT87RTWmMyWKuQ67T/ma+p0OQ4qGtrLWFk6Avoofk9YKsGkUScpp2sGA3EubapZzjmOFyzdcZ9qY+ro1yFFk75iapQssWET4oGabBallCHn8hoYTmGmUJBosWbApZk4QdzdvHyVpNFgotFLYRYy1C3ranMI+5RpQzgLraPuqScLJ8vS+opsY7T9lIAmQsZtvUZrsMYocusGHmmOsi2KflnCoEjZLK4zD3kMg9i2AIX1kzjTXRJWF+XDrlx7iIrdVILs5arrFg7rk3lo9ZKK8lg5IvN9NCfUovfs3fR8lD563nPD49gUrrq88QbFf7WNteo6AAwzQlzT922RaMERljh2HW0YoMQkt7oc9h/uU6JIwx74vQolYbY0NyLmcGybVsw/xpU431dc05j/M8W/N5SOsSmvuLHoOhBAk7Qys8PE2YhKSHvaxjD6MWJMkHx3E/Vn79BIkMs6fPstnFnibbSEXiMOadxEw25HGX5Jo55x6Z6KAWItXDObH902Fm7QcIrYg+rKVpfN3zYGP+NFmD+blZhmi+voS5oFvWB7Jciyhbaqzazh1rPK+hQh7DPGYs15xNljOnoY/7innagojms6eIZMpclTrx/kFG0SzXMWfOFqFh0UJNMCFL8GCHGSaPcx2xS7SQhDHmGm8Tuon565wZE2s0NP/uRK4F7ci1NV9XEFrLdycWCh35sjmHDJrH5GrQ66xQo5IIY74O+oiyFiR7EcxtOsIg8jw2DXIW82UuPt+4lDRvt/1bPbDjcz7mw+N8r30IE91sl+yHIlPMdQgW+2VHP7kXSw2CtCwdfdo00trZ0rAMWliQsK+8z3dNEsRg1nUlyT7IlOU3kzzb8wiMfQvvnrOGyhnCfB7k244zky5nI4ealznHw1yHGNaBCNoFu30Hc0ZGY/42L3cxeZyGbi9r7YuGyJksO1prMWa6ebMiYs2yrMxvQ4bl2r6uawySMAGcr0TqMkKZ1jcmCDHw+CbU5dPwO1rmmoKkxUQL+Vwy76K8tMTgK9Yu0fFPdJjM49yDyL5Ge8p1yH+xN7u8zzXXNTqeR75M+3AmFkm4lEVJa+3M/c2w0W1BmMf57JJGCRaI5PptUeyfBlA+9zQkiaf7v69pP/9lB+i2WetF9QZRKqHdhrzYO82PYg2eWXNtzGNIDh3XHZnn/HZ+bI2aL2eX/cHZMR/rY2Evf5/Pbspa9IHi9UwFtSwUibFgLYjRbnMuy2seggn603+zZTz9agMhz/PdJBPm1/tajj8/yzvn4+JwLyV8YNhGNbl3ZcY8hh02526t3PT0ulu+33FdX8/Djo7r/Gl0scu5A/mnjwl2JPfEpkaRIuS5xZtjyKyNCGMZDCs/XrIY1P76Mhj19DSgVWMf7BU5uw/p+fGZcwg9LIyJnLlhcg4LOVuuy72OYmNHrpW6tP/MfI/+Qv7t5e1/l1wn12JNWCxMNOa6LLQ4DNFgyD8YAgQCYBq99iCpLWEYQ4HtstJFbDpYG3lHFtZc4+n73SJaLGgLSZdSzPfBg3v7D9lb+2UPHtvx5TLyX3ryZbR6sjy2Rl1r0GSshvyyLeci+28ehrcbdJmYqpA+OBjv6FYNIo1sISGKfPhsYULH0G1y3SjsXctotYVKKeQeYoO56PZ9cx1d7OHHfHd5lMtrt7zPjt267E+QXUJI09gyYmkhFjeTzBLrIspy7Zf2IjkFYgSUhkmRUCXjgSPMkjNoQ5zsKc6RLPKvBhEZlmvY5czvV4rJkKIg3y9ydtvRkHPufYX9ku8QfV2e5s1uZbBM1jrIWmsfI192sDDE2lk6axH1yOeW3+aH7fYygnA2AHa6Wcc+gEr4UegOac993feMDCI+FseqBYPQUSzl44g1LYzin6EGZZgJY7vlL4eeWvM95OxGlC56LJnmIfIxWoM5ozkz18k9a12iYw1OzFlUUiVkTQY5ayaJxKzpokV2CR0QzoKuY611y2+qCKF0sLmbEoHV2OuVfYwxoab1ubWt5D7oYVaOPDPErInC7IpEtnw72z89tDftNrk+YLDbedPH97gYKev/ecqsdeTa7JA8Zoxj9E5HtzlaJMeB3te1lulAyz3Jy3w3BkECwjkCeH+5z+P++XcjJIEgIdDCNSWnNjpXUhk7kudqmpmw5rFLrgnvn5lc1wTDbDMhgm4z50Jp7ZLrmJbWd4PRLzvqEngqUZhmug1SsojNPqtbE5tRg/K8qpWemp1JsnMPlrRoWRg1siwk6RIaGhGChAAE5cHLbdl8fA5FwNPRyTXwId0jJOqLWJ4j525n6oLc281iQZFrm3bkyx1W+yCMIGPOoOyD3e6hydc9d8s5i5XYRkk5M5s8CZs57F2kEizP8nULmZxNaxp7mQhJXi9/mDMIb2t/O5LKthuAhBi6c02QgoA4SKhYD0XHnMPoNjQfY8yXsZnEiLFGhR19aDNnHoNe6GZf9BB5nBgzgkdiPmNERFBp+ZvFfA5mmw4s1yLmc2rhHJlnNpPrq202Sizr0ljHjhEiQgA8iX2do6pGSmKAIqAj90olSXdXUnTI+lBk7rkWM2fIcp1lx8g51/iu0TZvJ/rCmJazzHNfxr7mv8u5S8wZSTsUvhiqQz4n15mnYK2wfLmklLk/t4yCbVPerpz5nHueDRjB6Lx3khobQCBCHN2lk+I8r3NUxl8/sshnRjtCcs7cY15jrrGQj73gX8yrLEYeRyZ60S5vK//h7OFzhuBGuX+lW2jt1nLf0ST5nPLeImpNzmmaUYiZzLMZNNRNKbSMIfOX0dwjQuvtHsLY9yAJpLgeEtL+698x+//+f5xz5DlZvntMhpVBkjDYp/qYbYaQJWN2nJGckR/mxfY2n/N7yXJ+3co1grkQSmIohpk5u6UjZzSMMY9zTkVsjD3zbS4mhLwcxDBDInUDXWveXm+Xp5j6eCHh/2G3BKC/frl3r//p//1XnYc85rlC2JHKwmtGiXabJeQT/POvdpHrDH0RBL1ZlqzbzzP2tSMCAqGRHnehFJFszkktKTMJdjNyVnJA5ONsWsstopptbL4Jxobk245z7lWQ0wB9u1+vdz4+m6rLXhCIvxAdJIReq9u5/+mno5JojZ4E0yGlydo00WbHzHKtNfhHy3yd1oESQl4296Jjt77u2zH3LiIIDcYdJkMpRPkYoopxi8vWMcw910VjZjPPcxJmWzOzluXzjJyZ0cWyg5nn3CMwj9uyMiqVjCRICAUtNNguiYQkIN0I98c5q47PgiaRNG/DhPk4ZmOadkRoJGEfiioILsnrPBRkuq2+MnP+xgAIR+dgRM4k1y0hyL2ne967zNkazD0m2TI2ZoOhdazN53k9Xn6s/bqyQTlIEgiRc5zcCyAEENXcXspJPlsEUTGRVbKyzDbEbNuTh6lSQjMRG6bVU5QieZnriMv70GUn8xgdAkLIt5vBJJWQGEFaVHQQs4c9VBKa0aYek+fy2TBDNl+GGevApplzbLPRJb0Q7Hl11KArpCAQgMTF+S5e++FfszaLSsI5nANiI4+rqNQwRK4ffGa0ofq/FhJJJElBkIyZXWJ+X6aHGIL5y5s8ztOQnDvMtZBKG+qLuHTDnPO90wNTG2KQ14PZosYsMcxaMM4J4U2Jxus1NWL+z4fPp93uHbomrTy9+fHtf7e9tu1pS0J4GAKKopQjh/vyspjDsPJ/WjnDpw+lfJBrkmWDZTQNO3Zxbx2vjR0d/YKO0MdmhzBjGiIRYZKPj+PtizFmzG7+HzPnZFho6rA3XcwZh5kya64LyvBuUddxPahk2z9Vnw8bpgg6N9/W2/vtf76N2p7/+HmkEkIIARCR1OdTiJ5Su3Rimhkk7CP1WSeXFJFV2GCMzK/z3hvmXD53EPJtbJtfx0QiQflUHykWUp/K42b7f2sbWsOcYzOy0z0b2wYd347ZiNiOQajkPWbNdczjJYOMy/OnfD6fEOLmNohQ8Xa8vC7Mp08jjAwxBPIIS6flmGjlHD6fdGBjuS6RUEoilPiIGczrvgZ7+x4xj+1Czr5prn9hzkjyRlQ5PCdlDwyGuTb3GZtEYcfbQZemDZsz99mNEMhbOOdhz1UjyRj/V6qYa9GJQq4RqXCpdF0skoTwpiDnyJy5J0aEnOumHWdyHrpIBDnbzN+2/0Rv+njbJcx/OPdEQnQz91SSPua+mDOPF+SemL34umXOG6J9GN/fcwZsoBgDqY0u47aQzxTed8xWTEYMCUHIG4jooSiCGPl2c5+mUfZJSof8vqGH+57aZU2ecs2e0iJ/uaPLfKEPFLFBF5Xks2ObNR16sDHUEUM9bHY0X8/oYONhhpzylnB0KKYJSRXkukuc3oeJXjm1kZEQEkIw8lCSXDspFaHU0Y4xXVhGUaXygSSEsIf8up+CHWixj3vUw7XBfjJnX8uKdAQdKNKz7NiO61xDHzMLr0gV25hzsLGEiUFs2GyOhwbwwVpNwkxBJTeNedm5IRTFC0LPe22VVBWJgTwQRkJKV6ULEeY66Gbr5vChpiXyw6C9aK57WWvOw2gfwWWR5+2P9HFPHOTcQeenVDLmeWkQRGYzlC9Dvpxr7lkyGzYzn+UszbwuQ9cllaSiZbBocPhj5lyCRO35321s4+l5L0MRH5xLsX8GFRHGh0rOuUaLRkYoKddkXfaRM0J2uc65fI/mcT4XiyF6yHe7fYZ9wWbHoJzxz4ePMnTsBfmMCH/0RO2fQu6hlRRtiZhR7HJt8CTovN6O+/X1CLotl05E2ea5Ow5kqIjoevnfuxmXj0+QGsW7lGwvdpxTt/t0SBlGS4oUco9gR97z8/y42MM5ZDkP0SKfmc+YM68bc13kYZHknOPXB9HlmSbnyD3XOBSOwibhG3kodNaXf75e5/JpH1XPid3ABoXI1WMzgwZRmO61jkWzF4G9iihK+FBmdmCmcJNWG3TTbVL5xbV5juXnrO2H676a62KYiXyf1ryGiHzcvJ2OJV3mL3NfpLTjbMnZZZl7kdDJTOmbfBQ63d+ujphRVFVrq7pv5tqFa76cGQTRZVqsQG1bQgGEUHqTNfc+zryulXNzfp78gL2E3NvRsoz9F7phPkTvcm1+wuTccDSywzUP9hdkmSPRPkh2POeTKNIn56iC8q0g0scaJJhAdTcoZ3kZ1/dpJklAGxo1Cew7j0MUMYZ5TOYj2rEQK+iyyEdCyNlTvvPz5P60bvOX03GPXn3Oj13knnkOwlqtkLn3w2P+59g2ajNBNMHQIUqnsoMMusVZRVZDFZKEbjH0hKLL2BuYHZsx4rnVSRpqv+RByCMXzLfV8pzr0To4KnIGeT06dmm90DHm9/0FE3bL79cehu02v41MCGG3a1/roZgNniw+VZ7nnDOVIw/BRAsTUDTzTipQBamGRmKeo4fzu6B5mAJqd9q15utx3O4HGwgFMnbcXxVV7k0NuR+mVcpz/nYWk7k3XzuazJ/PPb/ZZebnXbCnouQxZD7za3vzYO+eJuUyYVhPN8qHYD5YKXtHIc7bYR/3fKwi21MloE20L7HLc8euo8xc1W47vfr+88vPX7789NPPL99e7/W8EWFt0atUfKILIdjDGpFaTzSyHmYvGIzdPufX3cK+8lnK+10w546OYeyyed25psm3v93zvWbzmNA8X56QuRaCaLuE9/2P4/76+n//eW25/OPPWzKen0YgNDZo87Kn1fQ2r52sV62877/+c3XP13tTtf36wzYqVUBCeG+1zNpDIyRmH1oLqeVP54xd2nyzkfXwzWl98ds+yLlLI+fc52+O5s8uf3KsNda+GpqWSbTm7EPLyjkYIARyEsHQxOb28p+/f/39n/fp/Pj3//yvH87z589mrA0xl1UX5k/rGEIkeAF1tbZbJVVVoeAdK3mcz7SQb+4DEfnsYdp38kf3ke/2G1+vX9Htn/47X+57PWBPfTXM1+vY5Zzcc29Ec50gc4+BQCBioNOGdb2v8joqOdnDZGsZ0wBntcD+Aplct0VYJK04xUhqrxEgEIzkq+cPRNbHsCbykd/eN0a30fHNpo8/PWeMvkD/3GD9bsG+k+8uvzn2xZwdny8LXc7c55pzt4chvC1Ku+7rnEoHlTYTj3ARkHd3MxIWalkLwLbtZQUYl4Qi4QcnX+a5meeQ/MF9JNfM5z3ld/tezO/7cPbdfnWOfvWba/lvOhj5Jw/6IAyG/M0QMIKodvdB5xyORNnClmniK5vd0e3elhETgbZLuycF2faRSnjsaNkXSYzQAx8LQsL6A9IR9pv8bv477YNM1t/7h5ehr5b1G4PB/qF8bLkOk7Nh8B2EmIi9etG3lSM//jokSo+JucftTvRFHTuuSbCgrLlW9+3rFUi7Xca4YEsn1rhYQo5N/miENJ99LPP8BTpGnn8rX9Y/0b45W67rN7v1KfsNTJ7n8XfMn21/KyxznRaaCwIKiHPe7nMex30qfHh+nfP6n/6nTpMwayZb7kIrreWsqA8WukXumWLP7nZ+fT2avt2XGdsxb6upvcz1EFLM55g59A0lf7Inu90H6w/ky6C/55f5nGVH67sln99aTB6HCfrOfLM+dHweImTy5XzONYie1n3er68vX16O1lCp7eOvPp7X669//+vVavmYtZhmBfGLc41FlrOIiGgv7bZno91rLsd+dpuNlCVp2MeI02KHKGJfTRLEMmGYx9CfEWT9hfw2ZwsxNE2faH21ppF5jLX57GOxrMEiq6VJWCxzpgUt7MIyoWNAe57XLz99+/a1s21jFKNIastp55wjYuYcyxIJuFJ3+tLFnPMxUFEEpVFoA9gZqXCg1hmteRwNWVMXabGgjSyW57lnOvK5WE9fN5cRpk/5dUPWaIRlmVjH2hpayz22IEa39jG1RlsLa6IRYtFoMteWSSN2NJkshKZPfX3pUTW2ESBJSVKclS9TIgkjQMzj+r7syA5syEMRkDcEJdoZB7ZSQmliNMtnWHSdm9bSaJ4blvk4QdPEaITpQXdyDtmHfN0xMcLIl4MmmBs0NGiN2KL5/oIJFkfQIIwuy2i5Z86coQS1sW+3qm3kTCWGpAjpoSl90PHbYRhzVqAiIlFaRIVG2E6wK86xdFab6XouS1eLWMm6YUue92CXprEsv936mND8Oh8bLWjBnO1oR3O2TDw8zkILFiOjaR9omKzF3kuTNYnJmjN0tFtTe0eAbdN466KqUiEkRQxlpQkykXugJZ/YwwzGfCkCGrA1TbvaXquX3eN1mj51jfPqNK3dsVmd15mdFotIkzVnpEbbos2CRdpDH1nz8Pvrq0XWgsScw4ue2MTwuq+GrGHRovd2aM1qYY3m+lxr9bLURMeG93kfdBJPT8/RW6+iQvdasuZ42oqMLVVUpQBiSZDJNznlOVUX1DAM0UkRbKOsqd3H6231nK8//fNr5+e///Wz3V9//31x5/rx179/HoyrTofzer06e//n73/ue06v8zo/z48jb+p1snhLz/48z/ucc5LXycZYh3Y652C3rs8eIiK86+Obnj/PvDHljZ83qzRlTlt733mdc2Sn2P37P//169fOz79e3SXTqd723va+73/+ef96zbz5qext/vDTrP7VO/WWP3/+57zvm1dv79uPnufpprYRef7zn/ci22VLktoIwSBqyDp06Nh85NeDOSeIIIKI4MLuNRvWcftnxon9Grb3HfrxOifasV2rOOz96+7NVserV6/cbcXBq9Me++NUnF7H7DYIdTqnTY94S54/zunntaRSiTd7hraUenv1rnrG+6p0d7eOc85Kuvf96+97Ta8Td5JT6067e9+79309D+/7Pgx7UExlVLI1ess828wSqVFbat8ul5GkRkgSQjCoBa3FhZhfBqrP7Mu+mG8NgoBBhCiRxd297JB20O7FmeetbLsbp3OSa4ZFs2ELsnqZsVOsrGEN49CMec0sz7F536LDGTy9m2BBLDJNFjuLc5tNTGZ7dWp315nZ4fosj8c5L6N3rpMYPe0JKXq1Bm3msSJEukIaSCAIJyzRaq0F8zH03df4AQYzTB49FGKMgAAisuvms9yk3QU3YdWH3eOjsbHVNNbcZta29hITDitXY9gNx0NGs7V3c0+p0oHGZPRmi7a92LyNWbKzs8usMWfqSHtLdkWXpVsyr0qlmbByNo8GlVVsek2PGRoRAhAhPIycY/G5tIbc82sHv9tBrpn4UArJdTLHkq3Zu5G3WbBgVDedVa3ZmLqw5nPG9i40U0uwhdklZ+kKabL5HK/FzEe6iyzs2mFbG+/G0pbJRlbeVht1VjcNCtO2xqG2nHnD3iKJvNr2vkU59jL3Vs7hQfYe1P5nUvI/VXJtIYyTP1aQa84lKTcyM+FVmC32WkLtaBYrsZcjazZjaeQy2Exo1sqks1na7DJnHWOFOVuWoR3NuFZdlmTG7DBoezepYWYaips5V+0k79JWsbFG1KRIozRFUkxFuaZGyFnOhU1BBCn+J0UXkWl/gCsEXRAiki5b2PL21lt7/oxWe6ufl60n59Dbu845x+Pkvfd7V6/TZvdiRusnOeVeu3JeP35E71/vab1nN9Js7ZwOurub6nRwdzlVs51NssW0WV6sLMaf7ZW3trmtzk/F27tYerclR4fTadbcmxHU6xrEeL3y+HzoMjlnSOQFFX39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';
final Uint8List _luckivaLogoBytes = base64Decode(_luckivaLogoBase64);

class _LuckivaLogo extends StatelessWidget {
  final double size;
  final double radius;

  const _LuckivaLogo({this.size = 64, this.radius = 18});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(1.2),
      decoration: BoxDecoration(
        color: const Color(0xFF07110E),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFFFFC857).withOpacity(.42)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3350E7BE),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.memory(
        _luckivaLogoBytes,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        gaplessPlayback: true,
      ),
    );
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
            brightness: Brightness.dark,
            scaffoldBackgroundColor: bg,
            colorScheme: ColorScheme.fromSeed(
              seedColor: green,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            fontFamily: 'Arial',
            navigationBarTheme: NavigationBarThemeData(
              backgroundColor: const Color(0xFF071118),
              indicatorColor: green.withOpacity(.14),
              labelTextStyle: MaterialStatePropertyAll(
                TextStyle(fontWeight: FontWeight.w700, color: white),
              ),
            ),
          ),
          home: AuthGate(key: ValueKey(language)),
        );
      },
    );
  }
}

// ============================================================
// GLOBAL PAGE BACK BUTTON
// Shows on pushed pages and safely stays hidden on the root page.
// ============================================================
Widget? luckivaBackButton(BuildContext context) {
  if (!Navigator.of(context).canPop()) return null;

  return IconButton(
    tooltip: 'Back',
    onPressed: () => Navigator.of(context).maybePop(),
    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
  );
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
        child: Container(
          width: 290,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: green.withOpacity(.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(.07),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _LuckivaLogo(size: 68, radius: 21),
              const SizedBox(height: 18),
              const Text(
                'LUCKIVA',
                style: TextStyle(
                  color: white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                t('Your Luck. Your Moment.'),
                style: const TextStyle(color: muted, fontSize: 13),
              ),
              const SizedBox(height: 24),
              const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: green,
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
// NAVIGATION + DATA
// ============================================================

class LuckyEntryData {
  final String entryId;
  final String orderId;
  final String drawTitle;
  final String plan;
  final String prize;
  final String entryFee;
  final String paidAmount;
  final int entries;
  final String startDate;
  final String expiryDate;
  final String status;

  const LuckyEntryData({
    required this.entryId,
    required this.orderId,
    required this.drawTitle,
    required this.plan,
    required this.prize,
    required this.entryFee,
    required this.paidAmount,
    required this.entries,
    required this.startDate,
    required this.expiryDate,
    required this.status,
  });

  factory LuckyEntryData.fromJson(Map<String, dynamic> json) {
    return LuckyEntryData(
      entryId: '${json['entryId'] ?? 'N/A'}',
      orderId: '${json['orderId'] ?? 'N/A'}',
      drawTitle: '${json['drawTitle'] ?? 'LUCKIVA Draw'}',
      plan: '${json['plan'] ?? json['drawTitle'] ?? 'Plan'}',
      prize: '${json['prize'] ?? 'N/A'}',
      entryFee: '${json['entryFee'] ?? 'N/A'}',
      paidAmount: '${json['paidAmount'] ?? json['entryFee'] ?? 'N/A'}',
      entries: int.tryParse('${json['entries'] ?? 1}') ?? 1,
      startDate: '${json['startDate'] ?? json['createdAt'] ?? ''}',
      expiryDate: '${json['expiryDate'] ?? ''}',
      status: '${json['status'] ?? 'PENDING'}',
    );
  }

  DateTime? get start => DateTime.tryParse(startDate);

  DateTime? get expiry => DateTime.tryParse(expiryDate);

  bool get isExpired {
    final date = expiry;
    return date != null && date.isBefore(DateTime.now());
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;

  final pages = const [
    HomePage(),
    DrawsPage(),
    MyEntriesPage(),
    ResultsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071118),
      body: pages[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: const Color(0xFF071118),
          indicatorColor: const Color(0xFF00E0C6).withOpacity(.16),
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>(
            (states) => TextStyle(
              color: states.contains(MaterialState.selected)
                  ? const Color(0xFF55F5D8)
                  : Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
          iconTheme: MaterialStateProperty.resolveWith<IconThemeData?>(
            (states) => IconThemeData(
              color: states.contains(MaterialState.selected)
                  ? const Color(0xFF55F5D8)
                  : Colors.white,
              size: 25,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (value) => setState(() => index = value),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.confirmation_num_outlined),
              selectedIcon: Icon(Icons.confirmation_num_rounded),
              label: 'Draws',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long_rounded),
              label: 'My Entries',
            ),
            NavigationDestination(
              icon: Icon(Icons.emoji_events_outlined),
              selectedIcon: Icon(Icons.emoji_events_rounded),
              label: 'Results',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<_DrawDefinition> _draws = const [
    _DrawDefinition(
      title: 'LUCKIVA Daily Draw',
      prize: 'Rs. 25,000',
      entry: 'Rs. 1',
      icon: Icons.today_rounded,
      countdownType: DrawCountdownType.daily,
      tag: 'DAILY',
      headline: 'TODAY COULD BE YOUR DAY!',
      subtitle: 'Small Entry. Big Happiness!',
    ),
    _DrawDefinition(
      title: 'LUCKIVA Weekly Draw',
      prize: 'Rs. 100,000',
      entry: 'Rs. 5',
      icon: Icons.calendar_view_week_rounded,
      countdownType: DrawCountdownType.weekly,
      tag: 'WEEKLY',
      headline: 'MOST POPULAR',
      subtitle: 'Better Chances. Bigger Dreams!',
    ),
    _DrawDefinition(
      title: 'LUCKIVA Monthly Draw',
      prize: 'Rs. 1,000,000',
      entry: 'Rs. 100',
      icon: Icons.calendar_month_rounded,
      countdownType: DrawCountdownType.monthly,
      tag: 'MONTHLY',
      headline: 'BIG PRIZE',
      subtitle: 'Bigger Prizes. Real Opportunities!',
    ),
    _DrawDefinition(
      title: 'LUCKIVA 6-Month Special',
      prize: 'Rs. 10,000,000',
      entry: 'Rs. 280',
      icon: Icons.workspace_premium_rounded,
      countdownType: DrawCountdownType.sixMonth,
      tag: 'SPECIAL',
      headline: 'MEGA DRAW',
      subtitle: 'Life Changing Prizes!',
      showCar: true,
    ),
  ];

  Future<void> _openDraw(_DrawDefinition draw) async {
    await LuckivaAdService.instance.maybeShowInterstitial();
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DrawDetailsPage(
          title: draw.title,
          prize: draw.prize,
          entry: draw.entry,
        ),
      ),
    );
  }

  void _showHowItWorks() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF101C24),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const Padding(
        padding: EdgeInsets.fromLTRB(24, 22, 24, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How It Works',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 18),
            _HowStep(
              number: '1',
              title: 'Choose a draw',
              text: 'Select your preferred LUCKIVA draw.',
            ),
            _HowStep(
              number: '2',
              title: 'Enter',
              text: 'Complete your entry using the shown fee.',
            ),
            _HowStep(
              number: '3',
              title: 'Results',
              text: 'Check the published result after the draw.',
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width >= 1100
        ? 38.0
        : width >= 700
        ? 28.0
        : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xFF071118),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontal, 14, horizontal, 0),
                child: _LuckivaHero(
                  onNotifications: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsPage(),
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontal, 16, horizontal, 10),
                child: _HomeTabs(
                  onPastResults: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ResultsPage()),
                  ),
                  onHowItWorks: _showHowItWorks,
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.fromLTRB(horizontal, 12, horizontal, 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: EdgeInsets.only(
                      bottom: index == _draws.length - 1 ? 12 : 16,
                    ),
                    child: _ReferenceDrawCard(
                      draw: _draws[index],
                      onTap: () => _openDraw(_draws[index]),
                    ),
                  ),
                  childCount: _draws.length,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontal, 2, horizontal, 22),
                child: const _TrustBar(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LuckivaHero extends StatelessWidget {
  final VoidCallback onNotifications;

  const _LuckivaHero({required this.onNotifications});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 650;

    // Keep the original 1024x290 banner ratio on every device so the
    // complete artwork (including the LUCKIVA text and trophy) remains
    // visible on narrow phones instead of being cropped by BoxFit.cover.
    return AspectRatio(
      aspectRatio: 1024 / 290,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFF063C35),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF22E2C0).withOpacity(.35)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x6600BFA6),
              blurRadius: 34,
              offset: Offset(0, 16),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.memory(
              _luckivaHeroBytes,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
              alignment: Alignment.center,
              filterQuality: FilterQuality.high,
            ),
            Positioned(
              right: compact ? 10 : 18,
              top: compact ? 10 : 18,
              child: Material(
                color: const Color(0xFF071820).withOpacity(.72),
                shape: const CircleBorder(),
                child: IconButton(
                  onPressed: onNotifications,
                  icon: const Icon(Icons.notifications_none_rounded),
                  color: Colors.white,
                  tooltip: 'Notifications',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTabs extends StatelessWidget {
  final VoidCallback onPastResults;
  final VoidCallback onHowItWorks;

  const _HomeTabs({required this.onPastResults, required this.onHowItWorks});

  Widget _tab({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool selected,
    VoidCallback? onTap,
  }) {
    final child = Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        gradient: selected
            ? const LinearGradient(
                colors: [Color(0xFF4DE0B8), Color(0xFF22CDB6)],
              )
            : null,
        color: selected ? null : const Color(0xFF0C171F),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: selected ? Colors.transparent : Colors.white.withOpacity(.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: selected ? Colors.black : Colors.white70, size: 21),
          const SizedBox(width: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: selected ? Colors.black : Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF0A141A),
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: Colors.white.withOpacity(.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.24),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 560;
          if (compact) {
            return ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                _tab(
                  context: context,
                  icon: Icons.card_giftcard_rounded,
                  label: 'Active Draws',
                  selected: true,
                ),
                const SizedBox(width: 7),
                _tab(
                  context: context,
                  icon: Icons.emoji_events_outlined,
                  label: 'Past Results',
                  selected: false,
                  onTap: onPastResults,
                ),
                const SizedBox(width: 7),
                _tab(
                  context: context,
                  icon: Icons.info_rounded,
                  label: 'How It Works',
                  selected: false,
                  onTap: onHowItWorks,
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: _tab(
                  context: context,
                  icon: Icons.card_giftcard_rounded,
                  label: 'Active Draws',
                  selected: true,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _tab(
                  context: context,
                  icon: Icons.emoji_events_outlined,
                  label: 'Past Results',
                  selected: false,
                  onTap: onPastResults,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _tab(
                  context: context,
                  icon: Icons.info_rounded,
                  label: 'How It Works',
                  selected: false,
                  onTap: onHowItWorks,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReferenceDrawCard extends StatefulWidget {
  final _DrawDefinition draw;
  final VoidCallback onTap;

  const _ReferenceDrawCard({required this.draw, required this.onTap});

  @override
  State<_ReferenceDrawCard> createState() => _ReferenceDrawCardState();
}

class _ReferenceDrawCardState extends State<_ReferenceDrawCard> {
  late Duration _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(_updateRemaining);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  DateTime _nextDrawTime() {
    final now = DateTime.now();
    switch (widget.draw.countdownType) {
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
    final value = _nextDrawTime().difference(DateTime.now());
    _remaining = value.isNegative ? Duration.zero : value;
  }

  String _countdown(Duration value) {
    final days = value.inDays;
    final hours = value.inHours.remainder(24).toString().padLeft(2, '0');
    final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    return days > 0
        ? '${days}d ${hours}h ${minutes}m'
        : '${hours}h ${minutes}m ${seconds}s';
  }

  List<Color> get _colors {
    switch (widget.draw.countdownType) {
      case DrawCountdownType.daily:
        return const [Color(0xFF5A3B00), Color(0xFF120F09), Color(0xFF071D19)];
      case DrawCountdownType.weekly:
        return const [Color(0xFF073C96), Color(0xFF071B43), Color(0xFF06121C)];
      case DrawCountdownType.monthly:
        return const [Color(0xFF4B1085), Color(0xFF160A35), Color(0xFF08121D)];
      case DrawCountdownType.sixMonth:
        return const [Color(0xFF5A320C), Color(0xFF241306), Color(0xFF09151A)];
    }
  }

  Color get _accent {
    switch (widget.draw.countdownType) {
      case DrawCountdownType.daily:
        return const Color(0xFFFFD34F);
      case DrawCountdownType.weekly:
        return const Color(0xFF4B9BFF);
      case DrawCountdownType.monthly:
        return const Color(0xFFB66CFF);
      case DrawCountdownType.sixMonth:
        return const Color(0xFFFF5A5A);
    }
  }

  String get _drawsIn {
    switch (widget.draw.countdownType) {
      case DrawCountdownType.daily:
        return 'Draws Every Day';
      case DrawCountdownType.weekly:
        return 'Draws in 7 Days';
      case DrawCountdownType.monthly:
        return 'Draws in 30 Days';
      case DrawCountdownType.sixMonth:
        return 'Draws in 6 Months';
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 700;
    final car = widget.draw.showCar;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          constraints: const BoxConstraints(minHeight: 218),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _accent.withOpacity(.72)),
            boxShadow: [
              BoxShadow(
                color: _accent.withOpacity(.12),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: compact ? _mobileCard(car) : _desktopCard(car),
        ),
      ),
    );
  }

  Widget _mobileCard(bool car) {
    return Column(
      children: [
        AspectRatio(aspectRatio: 634 / 217, child: _visualPanel(car)),
        _infoPanel(),
      ],
    );
  }

  Widget _desktopCard(bool car) {
    // Keep the artwork proportional on Windows/web and avoid cropping.
    // The card height follows the source artwork ratio with safe limits,
    // so the same draw image stays visually balanced on small and large PCs.
    return LayoutBuilder(
      builder: (context, constraints) {
        final visualWidth = (constraints.maxWidth - 320).clamp(420.0, 1400.0);
        final cardHeight = (visualWidth * 217 / 634).clamp(230.0, 420.0);

        return SizedBox(
          height: cardHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 2, child: _visualPanel(car)),
              SizedBox(width: 320, child: _infoPanel()),
            ],
          ),
        );
      },
    );
  }

  Widget _visualPanel(bool car) {
    Uint8List imageBytes;
    switch (widget.draw.countdownType) {
      case DrawCountdownType.daily:
        imageBytes = _luckivaDailyBytes;
        break;
      case DrawCountdownType.weekly:
        imageBytes = _luckivaWeeklyBytes;
        break;
      case DrawCountdownType.monthly:
        imageBytes = _luckivaMonthlyBytes;
        break;
      case DrawCountdownType.sixMonth:
        imageBytes = _luckivaMegaBytes;
        break;
    }

    return Container(
      color: const Color(0xFF071118),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Fixed to the source artwork ratio. BoxFit.contain then guarantees
          // the complete artwork remains visible on phones and Windows.
          Center(
            child: AspectRatio(
              aspectRatio: 634 / 217,
              child: Image.memory(
                imageBytes,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.transparent, const Color(0xCC061016)],
                stops: const [0.48, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 14,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.42),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white.withOpacity(.14)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome_rounded, color: gold, size: 13),
                  const SizedBox(width: 5),
                  Text(
                    widget.draw.tag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoPanel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
      decoration: BoxDecoration(
        color: const Color(0xB8071118),
        border: Border(
          left: BorderSide(color: Colors.white.withOpacity(.12), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  _drawsIn,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _accent.withOpacity(.90),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(
                  widget.draw.tag,
                  style: TextStyle(
                    color:
                        widget.draw.countdownType == DrawCountdownType.sixMonth
                        ? Colors.white
                        : Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Entry Fee',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 2),
          Text(
            widget.draw.entry,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              const Icon(Icons.timer_outlined, color: Colors.white54, size: 16),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  _countdown(_remaining),
                  style: TextStyle(
                    color: _accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: widget.onTap,
              icon: const Icon(Icons.arrow_forward_rounded, size: 20),
              label: const Text(
                'Enter Now',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC94D),
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustBar extends StatelessWidget {
  const _TrustBar();

  @override
  Widget build(BuildContext context) {
    final items = const [
      (Icons.verified_user_rounded, 'Safe & Secure'),
      (Icons.groups_rounded, 'Thousands of Participants'),
      (Icons.emoji_events_rounded, 'Real Winners'),
      (Icons.flash_on_rounded, 'Instant Results'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: const Color(0xFF082D2A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF00DDBE).withOpacity(.35)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        runSpacing: 10,
        children: items.map((item) {
          return SizedBox(
            width: 185,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.$1, color: const Color(0xFF42F3D2), size: 22),
                const SizedBox(width: 9),
                Flexible(
                  child: Text(
                    item.$2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _HowStep extends StatelessWidget {
  final String number;
  final String title;
  final String text;

  const _HowStep({
    required this.number,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF38DCC1),
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawDefinition {
  final String title;
  final String prize;
  final String entry;
  final IconData icon;
  final DrawCountdownType countdownType;
  final String tag;
  final String headline;
  final String subtitle;
  final bool showCar;

  const _DrawDefinition({
    required this.title,
    required this.prize,
    required this.entry,
    required this.icon,
    required this.countdownType,
    required this.tag,
    required this.headline,
    required this.subtitle,
    this.showCar = false,
  });
}

class _HeroBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xB5071820),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF18CFAF).withOpacity(.48)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFFFD45A), size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? action;
  final VoidCallback? onTap;
  final double horizontal;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
    required this.horizontal,
    this.action,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(horizontal, 24, horizontal, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(color: muted, fontSize: 11),
                ),
              ],
            ),
          ),
          if (action != null)
            TextButton(
              onPressed: onTap,
              child: Text(
                action ?? '',
                style: const TextStyle(
                  color: greenDark,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WinningHighlights extends StatelessWidget {
  const _WinningHighlights();

  static const winners = [
    ('LUCKIVA Mega Draw', 'Rs. 100,000', 'WINNER #10482'),
    ('LUCKIVA Lucky Draw', 'Rs. 25,000', 'WINNER #8391'),
    ('LUCKIVA Mini Draw', 'Rs. 10,000', 'WINNER #4418'),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final desktop = width >= 1000;

    return SizedBox(
      height: 156,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: winners.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = winners[index];
          return SizedBox(
            width: desktop ? 300 : 280,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: index == 0
                      ? const [Color(0xFF102F28), Color(0xFF063B2F)]
                      : const [Color(0xFF101E26), Color(0xFF0A141A)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: index == 0
                      ? green.withOpacity(.24)
                      : Colors.white.withOpacity(.07),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(.05),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -18,
                    top: -20,
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      size: 72,
                      color: (index == 0 ? gold : green).withOpacity(.07),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: index == 0
                                ? const [gold, Color(0xFFD99616)]
                                : [
                                    green.withOpacity(.18),
                                    green.withOpacity(.07),
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Icon(
                          Icons.emoji_events_rounded,
                          color: index == 0
                              ? const Color(0xFF6E4700)
                              : greenDark,
                          size: 27,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.$1,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: index == 0 ? Colors.white : white,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.$2,
                              style: TextStyle(
                                color: index == 0 ? green : greenDark,
                                fontSize: 23,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.$3,
                              style: TextStyle(
                                color: index == 0
                                    ? const Color(0xFFB8D6CF)
                                    : muted,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EntriesPreview extends StatelessWidget {
  final List<LuckyEntryData> entries;

  const _EntriesPreview({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: entries
          .map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _EntryListCard(entry: entry),
            ),
          )
          .toList(),
    );
  }
}

class _EntryListCard extends StatelessWidget {
  final LuckyEntryData entry;

  const _EntryListCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final status = entry.isExpired ? 'EXPIRED' : entry.status.toUpperCase();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(.07)),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(.035),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [green, greenDark]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.confirmation_num_rounded,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.drawTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${entry.entries} entry • ${entry.entryFee}',
                  style: const TextStyle(color: muted, fontSize: 10),
                ),
              ],
            ),
          ),
          _StatusBadge(status: status),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final normalized = status.toUpperCase();
    final isActive = normalized == 'ACTIVE';
    final isWinner = normalized == 'WINNER';

    final color = isWinner
        ? gold
        : isActive
        ? greenDark
        : normalized == 'EXPIRED'
        ? Colors.redAccent
        : gold;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(.16)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _LoadingPanel extends StatelessWidget {
  const _LoadingPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: green, strokeWidth: 2),
      ),
    );
  }
}

class _EmptyEntriesPanel extends StatelessWidget {
  const _EmptyEntriesPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(.07)),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: green.withOpacity(.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.receipt_long_rounded, color: greenDark),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Text(
              'No purchased entries yet. Your successful payments will appear here automatically.',
              style: TextStyle(color: muted, fontSize: 11, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// END HOME
// ============================================================

// ============================================================
// STAT CARD
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
        border: Border.all(color: Colors.white.withOpacity(.07)),
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

class _DrawCardState extends State<DrawCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(_updateRemaining);
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Container(
          height: 154,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: widget.highlighted
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF103D34), Color(0xFF0A201C)],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFFFFF), Color(0xFFF3F8F6)],
                  ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.highlighted
                  ? green.withOpacity(.3)
                  : Colors.white.withOpacity(.07),
            ),
            boxShadow: [
              BoxShadow(
                color: (widget.highlighted ? green : Colors.black).withOpacity(
                  .08 + (_controller.value * .04),
                ),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -18,
                top: -28,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (widget.highlighted ? green : gold).withOpacity(.07),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: Transform.translate(
                  offset: Offset(0, -_controller.value * 5),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: (widget.highlighted ? green : gold).withOpacity(.35),
                    size: 20,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: widget.highlighted
                            ? [gold, const Color(0xFFD58D0C)]
                            : [green.withOpacity(.18), green.withOpacity(.07)],
                      ),
                      borderRadius: BorderRadius.circular(19),
                      boxShadow: [
                        BoxShadow(
                          color: (widget.highlighted ? gold : green)
                              .withOpacity(.18),
                          blurRadius: 14,
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.highlighted
                          ? const Color(0xFF714800)
                          : greenDark,
                      size: 31,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: widget.highlighted
                                      ? Colors.white
                                      : white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            if (widget.highlighted)
                              _smallBadge('FEATURED', gold),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Text(
                          widget.prize,
                          style: TextStyle(
                            color: widget.highlighted ? green : greenDark,
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.entry,
                          style: TextStyle(
                            color: widget.highlighted
                                ? const Color(0xFFB8D4CD)
                                : muted,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.timer_rounded, color: gold, size: 14),
                            const SizedBox(width: 5),
                            Text(
                              _formatCountdown(_remaining),
                              style: TextStyle(
                                color: widget.highlighted
                                    ? const Color(0xFFFFD66E)
                                    : const Color(0xFF9A6A00),
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: widget.highlighted ? Colors.white54 : muted,
                    size: 14,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _smallBadge(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(.15),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: TextStyle(color: color, fontSize: 7, fontWeight: FontWeight.w900),
    ),
  );
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
// DRAWS + PLANS + MY ENTRIES
// ============================================================

class DrawsPage extends StatelessWidget {
  const DrawsPage({super.key});

  static const draws = [
    _DrawDefinition(
      title: 'LUCKIVA Daily Draw',
      prize: 'Rs. 25,000',
      entry: 'Rs. 1',
      icon: Icons.today_rounded,
      countdownType: DrawCountdownType.daily,
      tag: 'DAILY',
      headline: 'TODAY COULD BE YOUR DAY!',
      subtitle: 'Small Entry. Big Happiness!',
    ),
    _DrawDefinition(
      title: 'LUCKIVA Weekly Draw',
      prize: 'Rs. 100,000',
      entry: 'Rs. 5',
      icon: Icons.calendar_view_week_rounded,
      countdownType: DrawCountdownType.weekly,
      tag: 'WEEKLY',
      headline: 'MOST POPULAR',
      subtitle: 'Better Chances. Bigger Dreams!',
    ),
    _DrawDefinition(
      title: 'LUCKIVA Monthly Draw',
      prize: 'Rs. 1,000,000',
      entry: 'Rs. 100',
      icon: Icons.calendar_month_rounded,
      countdownType: DrawCountdownType.monthly,
      tag: 'MONTHLY',
      headline: 'BIG PRIZE',
      subtitle: 'Bigger Prizes. Real Opportunities!',
    ),
    _DrawDefinition(
      title: 'LUCKIVA 6-Month Special',
      prize: 'Rs. 10,000,000',
      entry: 'Rs. 280',
      icon: Icons.workspace_premium_rounded,
      countdownType: DrawCountdownType.sixMonth,
      tag: 'SPECIAL',
      headline: 'MEGA DRAW',
      subtitle: 'Life Changing Prizes!',
      showCar: true,
    ),
  ];

  Future<void> _open(BuildContext context, _DrawDefinition draw) async {
    await LuckivaAdService.instance.maybeShowInterstitial();
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DrawDetailsPage(
          title: draw.title,
          prize: draw.prize,
          entry: draw.entry,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width >= 1100
        ? 38.0
        : width >= 700
        ? 28.0
        : 16.0;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontal, 20, horizontal, 12),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(18, 17, 18, 17),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF123D36),
                        Color(0xFF0B211F),
                        Color(0xFF0A141A),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: green.withOpacity(.25)),
                    boxShadow: [
                      BoxShadow(
                        color: green.withOpacity(.08),
                        blurRadius: 26,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const _LuckivaLogo(size: 52, radius: 17),
                      const SizedBox(width: 13),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lucky Draws',
                              style: TextStyle(
                                color: white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'CHOOSE YOUR MOMENT. ENTER WITH CONFIDENCE.',
                              style: TextStyle(
                                color: green,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                letterSpacing: .8,
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
            SliverPadding(
              padding: EdgeInsets.fromLTRB(horizontal, 4, horizontal, 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final draw = draws[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: _ReferenceDrawCard(
                      draw: draw,
                      onTap: () => _open(context, draw),
                    ),
                  );
                }, childCount: draws.length),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 26),
                child: const _TrustPanel(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrustPanel extends StatelessWidget {
  const _TrustPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [green.withOpacity(.08), card]),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: green.withOpacity(.12)),
      ),
      child: const Row(
        children: [
          Icon(Icons.verified_user_rounded, color: greenDark, size: 28),
          SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transparent by design',
                  style: TextStyle(
                    color: white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Clear prices, entry references and status information throughout the journey.',
                  style: TextStyle(color: muted, fontSize: 10, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlansPage extends StatelessWidget {
  const PlansPage({super.key});

  static const plans = [
    _PlanDefinition(
      title: 'Daily',
      price: 'Rs. 1',
      validity: '24 hours',
      prize: 'Rs. 25,000',
      drawTitle: 'LUCKIVA Daily Draw',
      icon: Icons.today_rounded,
    ),
    _PlanDefinition(
      title: 'Weekly',
      price: 'Rs. 5',
      validity: '7 days',
      prize: 'Rs. 100,000',
      drawTitle: 'LUCKIVA Weekly Draw',
      icon: Icons.calendar_view_week_rounded,
    ),
    _PlanDefinition(
      title: 'Monthly',
      price: 'Rs. 100',
      validity: '30 days',
      prize: 'Rs. 1,000,000',
      drawTitle: 'LUCKIVA Monthly Draw',
      icon: Icons.calendar_month_rounded,
      featured: true,
    ),
    _PlanDefinition(
      title: '6 Months',
      price: 'Rs. 280',
      validity: '180 days',
      prize: 'Rs. 10,000,000',
      drawTitle: 'LUCKIVA 6-Month Special',
      icon: Icons.workspace_premium_rounded,
      featured: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        leading: luckivaBackButton(context),
        backgroundColor: bg,
        foregroundColor: white,
        title: const Text(
          'Plans',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 1000
              ? 4
              : constraints.maxWidth >= 650
              ? 2
              : 1;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
            child: Wrap(
              spacing: 14,
              runSpacing: 14,
              children: plans.map((plan) {
                final width = columns == 4
                    ? (constraints.maxWidth - 42) / 4
                    : columns == 2
                    ? (constraints.maxWidth - 14) / 2
                    : constraints.maxWidth;

                return SizedBox(
                  width: width,
                  child: _PlanCard(plan: plan),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

class _PlanDefinition {
  final String title;
  final String price;
  final String validity;
  final String prize;
  final String drawTitle;
  final IconData icon;
  final bool featured;

  const _PlanDefinition({
    required this.title,
    required this.price,
    required this.validity,
    required this.prize,
    required this.drawTitle,
    required this.icon,
    this.featured = false,
  });
}

class _PlanCard extends StatelessWidget {
  final _PlanDefinition plan;

  const _PlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: plan.featured
            ? const LinearGradient(
                colors: [Color(0xFF082820), Color(0xFF0D5D4C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFF101E26), Color(0xFF0A141A)],
              ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: plan.featured
              ? green.withOpacity(.24)
              : Colors.white.withOpacity(.07),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: plan.featured
                      ? gold.withOpacity(.14)
                      : green.withOpacity(.10),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(plan.icon, color: plan.featured ? gold : greenDark),
              ),
              const Spacer(),
              if (plan.featured)
                const Text(
                  'PREMIUM',
                  style: TextStyle(
                    color: gold,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            plan.title,
            style: TextStyle(
              color: plan.featured ? Colors.white : white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            plan.drawTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: plan.featured ? const Color(0xFFB7D8D0) : muted,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            plan.price,
            style: TextStyle(
              color: plan.featured ? green : greenDark,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Prize pool ${plan.prize}',
            style: TextStyle(
              color: plan.featured ? Colors.white70 : muted,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'Validity ${plan.validity} • 1 entry',
            style: TextStyle(
              color: plan.featured ? const Color(0xFFB7D8D0) : muted,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () async {
                await LuckivaAdService.instance.maybeShowInterstitial();
                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DrawDetailsPage(
                      title: plan.drawTitle,
                      prize: plan.prize,
                      entry: plan.price,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: plan.featured ? green : white,
                foregroundColor: plan.featured ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Enter Draw',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanMiniCard extends StatelessWidget {
  final String title;
  final String price;
  final String validity;
  final bool featured;

  const _PlanMiniCard({
    required this.title,
    required this.price,
    required this.validity,
    this.featured = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: featured ? const Color(0xFF0B3E33) : card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: featured
              ? green.withOpacity(.20)
              : Colors.white.withOpacity(.07),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: featured ? Colors.white : white,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: TextStyle(
              color: featured ? green : greenDark,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            validity,
            style: TextStyle(
              color: featured ? const Color(0xFFB7D8D0) : muted,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class MyEntriesPage extends StatefulWidget {
  const MyEntriesPage({super.key});

  @override
  State<MyEntriesPage> createState() => _MyEntriesPageState();
}

class _MyEntriesPageState extends State<MyEntriesPage> {
  bool loading = true;
  String? error;
  List<LuckyEntryData> entries = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (!mounted) return;
      setState(() {
        loading = false;
        entries = [];
      });
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
          '$apiBaseUrl/api/user/draw-entries?userId=${Uri.encodeQueryComponent(user.uid)}',
        ),
        headers: apiRequestHeaders,
      );

      if (response.statusCode == 404) {
        if (!mounted) return;
        setState(() {
          entries = [];
          loading = false;
          error = null;
        });
        return;
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Server returned ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body);
      final list = decoded is Map && decoded['entries'] is List
          ? decoded['entries'] as List
          : <dynamic>[];

      if (!mounted) return;

      setState(() {
        entries = list
            .whereType<Map>()
            .map(
              (item) =>
                  LuckyEntryData.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width >= 1100
        ? 38.0
        : width >= 700
        ? 28.0
        : 16.0;
    final activeCount = entries.where((e) => !e.isExpired).length;
    final expiredCount = entries.where((e) => e.isExpired).length;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: RefreshIndicator(
          color: green,
          backgroundColor: card,
          onRefresh: _load,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(horizontal, 18, horizontal, 14),
                  child: Row(
                    children: [
                      const _LuckivaLogo(size: 48, radius: 16),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My Entries',
                              style: TextStyle(
                                color: white,
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'YOUR ENTRIES • YOUR CHANCES • YOUR MOMENT',
                              style: TextStyle(
                                color: green,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                                letterSpacing: .65,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _load,
                        tooltip: 'Refresh',
                        icon: const Icon(Icons.refresh_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF101F27),
                          foregroundColor: white,
                          side: BorderSide(
                            color: Colors.white.withOpacity(.10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!loading && error == null && entries.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _EntryStat(
                            value: '${entries.length}',
                            label: 'TOTAL ENTRIES',
                            icon: Icons.confirmation_num_rounded,
                            accent: gold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _EntryStat(
                            value: '$activeCount',
                            label: 'ACTIVE',
                            icon: Icons.bolt_rounded,
                            accent: green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _EntryStat(
                            value: '$expiredCount',
                            label: 'EXPIRED',
                            icon: Icons.history_rounded,
                            accent: const Color(0xFF8FA3AA),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (loading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: green,
                      strokeWidth: 2.5,
                    ),
                  ),
                )
              else if (error != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 30),
                    child: _ErrorPanel(message: error ?? 'Unknown error'),
                  ),
                )
              else if (entries.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 30),
                    child: _PremiumEmptyEntries(),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(horizontal, 2, horizontal, 30),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 13),
                        child: _FullEntryCard(entry: entries[index]),
                      ),
                      childCount: entries.length,
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

class _EntryStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color accent;

  const _EntryStat({
    required this.value,
    required this.label,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent.withOpacity(.12), const Color(0xFF0A141A)],
        ),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: accent.withOpacity(.22)),
      ),
      child: Column(
        children: [
          Icon(icon, color: accent, size: 18),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: accent,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: muted,
              fontSize: 7,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumEmptyEntries extends StatelessWidget {
  const _PremiumEmptyEntries();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF102D29), Color(0xFF0B171D)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: green.withOpacity(.22)),
        boxShadow: [
          BoxShadow(
            color: green.withOpacity(.06),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [gold, Color(0xFFE0A01C)]),
              boxShadow: [
                BoxShadow(color: gold.withOpacity(.18), blurRadius: 25),
              ],
            ),
            child: const Icon(
              Icons.confirmation_num_rounded,
              color: Color(0xFF4D3300),
              size: 38,
            ),
          ),
          const SizedBox(height: 17),
          const Text(
            'No Entries Yet',
            style: TextStyle(
              color: white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Your successful entries will appear here with their payment, prize and validity details.',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 11, height: 1.5),
          ),
          const SizedBox(height: 17),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            decoration: BoxDecoration(
              color: green.withOpacity(.08),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: green.withOpacity(.18)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shield_rounded, color: green, size: 15),
                SizedBox(width: 6),
                Text(
                  'SECURE ENTRY RECORDS',
                  style: TextStyle(
                    color: green,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FullEntryCard extends StatelessWidget {
  final LuckyEntryData entry;

  const _FullEntryCard({required this.entry});

  String _fmt(String value) {
    final d = DateTime.tryParse(value);
    if (d == null) return value.isEmpty ? 'N/A' : value;
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final status = entry.isExpired ? 'EXPIRED' : entry.status.toUpperCase();
    final accent = entry.isExpired ? const Color(0xFF8B7A80) : green;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withOpacity(.10),
            const Color(0xFF0C171F),
            const Color(0xFF091117),
          ],
        ),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: accent.withOpacity(.20)),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(.05),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final compact = c.maxWidth < 650;
          final header = Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accent.withOpacity(.28), accent.withOpacity(.08)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: accent.withOpacity(.20)),
                ),
                child: Icon(Icons.confirmation_num_rounded, color: accent),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.drawTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${entry.plan} • ${entry.entries} entry',
                      style: const TextStyle(color: muted, fontSize: 10),
                    ),
                  ],
                ),
              ),
              _StatusBadge(status: status),
            ],
          );

          final infoItems = [
            _EntryInfo(
              label: 'Entry ID',
              value: entry.entryId,
              fullWidth: compact,
            ),
            _EntryInfo(
              label: 'Payment',
              value: entry.paidAmount,
              fullWidth: compact,
            ),
            _EntryInfo(
              label: 'Prize Pool',
              value: entry.prize,
              fullWidth: compact,
            ),
            _EntryInfo(
              label: 'Entry Date',
              value: _fmt(entry.startDate),
              fullWidth: compact,
            ),
            _EntryInfo(
              label: 'Valid Until',
              value: _fmt(entry.expiryDate),
              fullWidth: compact,
            ),
            _EntryInfo(
              label: 'Transaction',
              value: entry.orderId,
              fullWidth: compact,
            ),
          ];

          final details = compact
              ? Column(
                  children: [
                    for (var i = 0; i < infoItems.length; i++) ...[
                      infoItems[i],
                      if (i != infoItems.length - 1) const SizedBox(height: 9),
                    ],
                  ],
                )
              : Wrap(spacing: 10, runSpacing: 10, children: infoItems);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header,
              const SizedBox(height: 16),
              details,
              if (compact) const SizedBox(height: 2),
            ],
          );
        },
      ),
    );
  }
}

class _EntryInfo extends StatelessWidget {
  final String label;
  final String value;
  final bool fullWidth;

  const _EntryInfo({
    required this.label,
    required this.value,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : 190,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF101E26), Color(0xFF0A141A)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: muted, fontSize: 9)),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  final String message;

  const _ErrorPanel({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF241418), Color(0xFF10161A)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.redAccent.withOpacity(.22)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.redAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Could not load entries.\n$message',
              style: const TextStyle(color: muted, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// RESULTS

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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
              child: Row(
                children: [
                  const _LuckivaLogo(size: 48, radius: 16),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Results',
                      style: TextStyle(
                        color: white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
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
                    const _LuckivaLogo(size: 60, radius: 18),
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
                  child: Text(
                    t('Login / Create Account'),
                    style: const TextStyle(fontWeight: FontWeight.w900),
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
              title: t('Trust & Transparency'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TrustTransparencyPage(),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: ProfileMenu(
              icon: Icons.help_outline_rounded,
              title: t('Help & Support'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HelpSupportPage()),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: ProfileMenu(
              icon: Icons.info_outline_rounded,
              title: t('About LUCKIVA'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutLuckivaPage()),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: ProfileMenu(
              icon: Icons.language_rounded,
              title: t('Language'),
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
// TRUST & TRANSPARENCY
// ============================================================

class TrustTransparencyPage extends StatelessWidget {
  const TrustTransparencyPage({super.key});

  Widget _section({
    required IconData icon,
    required String title,
    required String body,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: green.withOpacity(.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: green.withOpacity(.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: green, size: 22),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: const TextStyle(
                    color: muted,
                    height: 1.45,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, color: green, size: 17),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: white,
                height: 1.35,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        leading: luckivaBackButton(context),
        backgroundColor: bg,
        foregroundColor: white,
        elevation: 0,
        title: Text(
          t('Trust & Transparency'),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [green.withOpacity(.18), green.withOpacity(.05), card],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: green.withOpacity(.16)),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: green.withOpacity(.14),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_user_rounded,
                    color: green,
                    size: 29,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trust starts with clear information.',
                        style: TextStyle(
                          color: white,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'LUCKIVA keeps draw details, entries and published results easy to understand.',
                        style: TextStyle(
                          color: muted,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Our Transparency Principles',
            style: TextStyle(
              color: white,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          _section(
            icon: Icons.description_outlined,
            title: 'Clear Draw Information',
            body:
                'Important draw information and prize details are presented before you continue with an entry.',
          ),
          _section(
            icon: Icons.receipt_long_rounded,
            title: 'Entry Records',
            body:
                'Your submitted entries are associated with your account so you can review them from My Entries.',
          ),
          _section(
            icon: Icons.emoji_events_outlined,
            title: 'Published Results',
            body:
                'Published result information is displayed clearly so users can check the outcome of relevant draws.',
          ),
          _section(
            icon: Icons.security_rounded,
            title: 'Account Security',
            body:
                'LUCKIVA uses account authentication to help protect access to your account and its information.',
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: card2,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: green.withOpacity(.08)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Before You Enter',
                  style: TextStyle(
                    color: white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 12),
                _TrustCheckRow(text: 'Review the draw and prize information.'),
                _TrustCheckRow(
                  text: 'Check your entry details before submitting.',
                ),
                _TrustCheckRow(
                  text: 'Keep your transaction information when applicable.',
                ),
                _TrustCheckRow(
                  text: 'Contact support if something is unclear.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: green.withOpacity(.10)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.support_agent_rounded, color: green, size: 22),
                SizedBox(width: 11),
                Expanded(
                  child: Text(
                    'Questions or concerns? Contact LUCKIVA Support at luckiva8@gmail.com.',
                    style: TextStyle(
                      color: muted,
                      height: 1.4,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustCheckRow extends StatelessWidget {
  final String text;

  const _TrustCheckRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, color: green, size: 17),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: white,
                height: 1.35,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HELP & SUPPORT
// ============================================================

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  Future<void> _copySupportEmail(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: 'luckiva8@gmail.com'));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('luckiva8@gmail.com copied')));
  }

  Widget _faq(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: green.withOpacity(.10)),
      ),
      child: ExpansionTile(
        iconColor: green,
        collapsedIconColor: muted,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(
          question,
          style: const TextStyle(color: white, fontWeight: FontWeight.w800),
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: const TextStyle(color: muted, height: 1.45, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        leading: luckivaBackButton(context),
        backgroundColor: bg,
        foregroundColor: white,
        elevation: 0,
        title: Text(
          t('Help & Support'),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: green.withOpacity(.12)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0x2200E0A8),
                  child: Icon(Icons.support_agent_rounded, color: green),
                ),
                const SizedBox(width: 13),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LUCKIVA Support',
                        style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'luckiva8@gmail.com',
                        style: TextStyle(
                          color: greenDark,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Need help? Check the FAQs or contact support.',
                        style: TextStyle(color: muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => _copySupportEmail(context),
            icon: const Icon(Icons.email_outlined),
            label: const Text('Copy support email'),
            style: OutlinedButton.styleFrom(
              foregroundColor: greenDark,
              side: BorderSide(color: green.withOpacity(.35)),
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              color: white,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          _faq(
            'How do I enter a draw?',
            'Open Draws, select the draw you want, review the details and continue through the entry flow.',
          ),
          _faq(
            'Where can I see my entries?',
            'Open My Entries from the bottom navigation to review entries associated with your account.',
          ),
          _faq(
            'Where are results shown?',
            'Open Results from the bottom navigation. Published result information is displayed there.',
          ),
          _faq(
            'What should I do if a payment or entry has a problem?',
            'Keep your transaction information and contact support with the relevant details so the issue can be reviewed.',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ABOUT LUCKIVA
// ============================================================

class AboutLuckivaPage extends StatelessWidget {
  const AboutLuckivaPage({super.key});

  Widget _row(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: green.withOpacity(.10)),
        ),
        child: Row(
          children: [
            Icon(icon, color: green),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(color: white, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        leading: luckivaBackButton(context),
        backgroundColor: bg,
        foregroundColor: white,
        elevation: 0,
        title: Text(
          t('About LUCKIVA'),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [green.withOpacity(.15), card]),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: green.withOpacity(.14)),
            ),
            child: const Column(
              children: [
                const _LuckivaLogo(size: 76, radius: 22),
                SizedBox(height: 14),
                Text(
                  'LUCKIVA',
                  style: TextStyle(
                    color: white,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Your Luck. Your Moment.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: muted, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'About',
            style: TextStyle(
              color: white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'LUCKIVA is a draw experience focused on clear draw information, simple entry flows and easy access to published results.',
            style: TextStyle(color: muted, height: 1.5),
          ),
          const SizedBox(height: 18),
          _row(Icons.apps_rounded, 'App', 'LUCKIVA'),
          _row(Icons.language_rounded, 'Language', appLanguage.value),
          _row(Icons.verified_rounded, 'Version', '1.0.0'),
          _row(Icons.email_outlined, 'Support', 'luckiva8@gmail.com'),
          const SizedBox(height: 4),
          const Center(
            child: Text(
              'Thank you for using LUCKIVA.',
              style: TextStyle(color: muted, fontWeight: FontWeight.w600),
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
        leading: luckivaBackButton(context),
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
        leading: luckivaBackButton(context),
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
                onPressed: () async {
                  await LuckivaAdService.instance.maybeShowInterstitial();
                  if (!context.mounted) return;
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
// CHECKOUT + PAYMENT CONFIRMATION
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
  XFile? paymentScreenshot;
  bool uploading = false;

  Future<void> _pickScreenshot() async {
    final picker = ImagePicker();

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: card,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: green),
              title: const Text('Gallery', style: TextStyle(color: white)),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: green),
              title: const Text('Camera', style: TextStyle(color: white)),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final file = await picker.pickImage(source: source, imageQuality: 85);

    if (file != null && mounted) {
      setState(() => paymentScreenshot = file);
    }
  }

  Future<void> _submitPayment() async {
    if (paymentScreenshot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add your payment screenshot.')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login before submitting payment.'),
        ),
      );
      return;
    }

    setState(() => uploading = true);

    try {
      final screenshot = paymentScreenshot;
      if (screenshot == null) {
        setState(() => uploading = false);
        return;
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$apiBaseUrl/api/payment'),
      );

      final amount = widget.entry.replaceAll(RegExp(r'[^0-9.]'), '');

      request.fields.addAll({
        'title': widget.title,
        'entry': widget.entry,
        'amount': amount,
        'paymentMethod': selectedMethod,
        'userId': user.uid,
        'userName': user.displayName ?? '',
        'userEmail': user.email ?? '',
      });

      request.files.add(
        await http.MultipartFile.fromPath('screenshot', screenshot.path),
      );

      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (!mounted) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> decoded = {};

        try {
          final parsed = jsonDecode(body);
          if (parsed is Map) {
            decoded = Map<String, dynamic>.from(parsed);
          }
        } catch (_) {}

        final orderId = '${decoded['orderId'] ?? 'PENDING'}';

        final rawEntry = decoded['drawEntry'];

        final drawEntry = rawEntry is Map
            ? Map<String, dynamic>.from(rawEntry)
            : <String, dynamic>{};

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PrototypeConfirmationPage(
              title: widget.title,
              entryPrice: widget.entry,
              orderId: orderId,
              drawEntry: drawEntry,
            ),
          ),
        );
      } else {
        String message = 'Payment upload failed: ${response.statusCode}';

        try {
          final parsed = jsonDecode(body);
          if (parsed is Map && parsed['message'] != null) {
            message = parsed['message'].toString();
          }
        } catch (_) {}

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not connect to payment server: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => uploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        leading: luckivaBackButton(context),
        backgroundColor: bg,
        foregroundColor: white,
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth >= 900 ? 900.0 : double.infinity;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
                child: SizedBox(
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _checkoutHeader(),
                      const SizedBox(height: 16),
                      _orderSummary(),
                      const SizedBox(height: 14),
                      _paymentMethods(),
                      const SizedBox(height: 14),
                      if (selectedMethod == 'Easypaisa') _prototypeQrBox(),
                      const SizedBox(height: 14),
                      _screenshotBox(),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: uploading ? null : _submitPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: green,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: uploading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : const Text(
                                  'Submit Payment',
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          'Your payment is securely submitted for review.',
                          style: TextStyle(color: muted, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _checkoutHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF082B23), Color(0xFF0B5D4B)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: green.withOpacity(.20)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: gold.withOpacity(.13),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.shield_rounded, color: gold, size: 27),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Secure Payment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.title} • ${widget.entry}',
                  style: const TextStyle(
                    color: Color(0xFFB7D8D0),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentMethods() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Method',
            style: TextStyle(
              color: white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          _paymentMethod('Easypaisa', Icons.account_balance_wallet_rounded),
        ],
      ),
    );
  }

  Widget _paymentMethod(String name, IconData icon) {
    final selected = selectedMethod == name;

    return GestureDetector(
      onTap: () => setState(() => selectedMethod = name),
      child: Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? green.withOpacity(.07) : bg,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected ? green : Colors.white.withOpacity(.06),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? greenDark : muted),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  color: white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? greenDark : muted,
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
            'Payment Instructions',
            style: TextStyle(
              color: white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Use the available payment method and attach the proof below.',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 10, height: 1.4),
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
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          _SummaryLine(label: 'Selected Plan', value: widget.title),
          _SummaryLine(label: 'Entry Price', value: widget.entry),
        ],
      ),
    );
  }

  Widget _screenshotBox() {
    final imagePath = paymentScreenshot?.path;
    final hasImage = imagePath != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: green.withOpacity(.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  hasImage ? Icons.check_rounded : Icons.upload_file_rounded,
                  color: green,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasImage ? 'Screenshot added' : 'Payment Screenshot',
                      style: const TextStyle(
                        color: white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasImage ? 'Ready to upload' : 'Add your payment proof',
                      style: const TextStyle(color: muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _pickScreenshot,
                child: Text(hasImage ? 'Change' : 'Add'),
              ),
            ],
          ),
          if (imagePath != null) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(
                File(imagePath),
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: muted, fontSize: 11),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: white,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PrototypeConfirmationPage extends StatelessWidget {
  final String title;
  final String entryPrice;
  final String orderId;
  final Map<String, dynamic> drawEntry;

  const PrototypeConfirmationPage({
    super.key,
    required this.title,
    required this.entryPrice,
    required this.orderId,
    required this.drawEntry,
  });

  String _string(String key, String fallback) {
    final value = drawEntry[key];

    if (value == null || value.toString().isEmpty) {
      return fallback;
    }

    return value.toString();
  }

  String _formatDate(String value) {
    final date = DateTime.tryParse(value);

    if (date == null) {
      return value.isEmpty ? 'Pending' : value;
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final entryId = _string('entryId', 'Created');
    final plan = _string('plan', title);
    final prize = _string('prize', 'N/A');
    final entries = _string('entries', '1');
    final startDate = _formatDate(_string('startDate', ''));
    final expiryDate = _formatDate(_string('expiryDate', ''));
    final status = _string('status', 'PENDING');

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        leading: luckivaBackButton(context),
        backgroundColor: bg,
        foregroundColor: white,
        title: const Text(
          'Payment Confirmation',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: green.withOpacity(.14)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(.07),
                      blurRadius: 25,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [green, greenDark],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.black,
                        size: 45,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Payment Successful',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: white,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: muted, fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF082A22), Color(0xFF0B5B4A)],
                        ),
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: gold.withOpacity(.13),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.confirmation_num_rounded,
                              color: gold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plan,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$entries entry received',
                                  style: const TextStyle(
                                    color: Color(0xFFB7D8D0),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _StatusBadge(status: status),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _confirmationGrid([
                      ('Payment', entryPrice),
                      ('Entry Price', entryPrice),
                      ('Entries Received', entries),
                      ('Prize Pool', prize),
                      ('Start Date', startDate),
                      ('Valid Until', expiryDate),
                      ('Transaction ID', orderId),
                      ('Entry ID', entryId),
                    ]),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: gold.withOpacity(.07),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'Your payment and entry reference have been recorded. Keep the Entry ID and Transaction ID for your records.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: muted,
                          fontSize: 10,
                          height: 1.45,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MyEntriesPage(),
                            ),
                            (route) => route.isFirst,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: green,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'View My Entries',
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
      ),
    );
  }

  Widget _confirmationGrid(List<(String, String)> items) {
    return LayoutBuilder(
      builder: (context, c) {
        final twoColumns = c.maxWidth >= 540;
        final width = twoColumns ? (c.maxWidth - 10) / 2 : c.maxWidth;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: items.map((item) {
            return SizedBox(
              width: width,
              child: Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.$1,
                      style: const TextStyle(color: muted, fontSize: 9),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.$2,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// ============================================================
// LOGIN / SIGNUP
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
        leading: luckivaBackButton(context),
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
          borderSide: BorderSide(color: Colors.white.withOpacity(.07)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: green),
        ),
      ),
    );
  }
}
