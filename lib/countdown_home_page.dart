import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'full_screen_countdown.dart';
import 'motivational_quotes.dart';

class CountDownHomePage extends StatefulWidget {
  const CountDownHomePage({super.key});

  @override
  CountDownHomePageState createState() => CountDownHomePageState();
}

class CountDownHomePageState extends State<CountDownHomePage> {
  int _days = 0;
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  String _motivationQuote = '';
  String _currentCountdown = 'TYT';

  DateTime _targetDate = DateTime(2025, 6, 21, 10, 00);
  Timer? _timer;

  BannerAd? bannerAd;
  bool isLoaded = false;

  var adUnit = "ca-app-pub-3940256099942544/9214589741";

  @override
  void initState() {
    super.initState();
    initBannerAd();
    _startCountdown();
    _updateMotivationQuote();
    Timer.periodic(const Duration(days: 1), (timer) {
      _updateMotivationQuote();
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  initBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnit,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print("BannerAd failed to load: $error");
        },
      ),
      request: const AdRequest(),
    );

    bannerAd?.load();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final difference = _targetDate.difference(now);

      setState(() {
        _days = difference.inDays;
        _hours = difference.inHours.remainder(24);
        _minutes = difference.inMinutes.remainder(60);
        _seconds = difference.inSeconds.remainder(60);
      });
    });
  }

  void _updateMotivationQuote() {
    setState(() {
      _motivationQuote =
          motivationalQuotes[DateTime.now().day % motivationalQuotes.length];
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    bannerAd?.dispose(); // bannerAd'i dispose et
    super.dispose();
    
  }
void _navigateToFullScreen(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => FullScreenCountDown(
        days: _days,
        hours: _hours,
        minutes: _minutes,
        seconds: _seconds,
        countdownType: _currentCountdown,
        targetDate: _targetDate,
      ),
    ),
  );
}

  void _setTargetDate(DateTime date, String countdownType) {
    setState(() {
      _targetDate = date;
      _currentCountdown = countdownType;
    });
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140.0),
        child: AppBar(
          backgroundColor: const Color(0xFF2B2B2B),
          elevation: 0,
          flexibleSpace: const Padding(
            padding: EdgeInsets.only(top: 60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'YKS 2025',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'GERİ SAYIM',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTimeColumn('$_days', 'Gün'),
                    const SizedBox(width: 20),
                    _buildTimeColumn('$_hours', 'Saat'),
                    const SizedBox(width: 20),
                    _buildTimeColumn('$_minutes', 'Dakika'),
                    const SizedBox(width: 20),
                    _buildTimeColumn('$_seconds', 'Saniye'),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          _setTargetDate(DateTime(2025, 6, 21, 10, 00), 'TYT'),
                      child: const Text('TYT'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () =>
                          _setTargetDate(DateTime(2025, 6, 22, 10, 00), 'AYT'),
                      child: const Text('AYT'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () =>
                          _setTargetDate(DateTime(2025, 6, 22, 15, 45), 'YDT'),
                      child: const Text('YDT'),
                    ),
                  ],
                ),
                const SizedBox(height: 64),
                const Text(
                  'Günün Sözü',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    _motivationQuote,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.fullscreen, color: Colors.white),
                onPressed: () => _navigateToFullScreen(context),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isLoaded
          ? SizedBox(
              height: bannerAd?.size.height.toDouble(),
              width: bannerAd?.size.width.toDouble(),
              child: AdWidget(ad: bannerAd!),
            )
          : const SizedBox(),
    );
  }

  Column _buildTimeColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ],
    );
  }
}
