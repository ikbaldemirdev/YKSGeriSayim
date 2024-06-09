import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yks_geri_sayim/countdown_home_page.dart';

class FullScreenCountDown extends StatefulWidget {
  final int days;
  final int hours;
  final int minutes;
  final int seconds;
  final String countdownType;
  final DateTime targetDate;

  const FullScreenCountDown({
    Key? key,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.countdownType,
    required this.targetDate,
  }) : super(key: key);

  @override
  FullScreenCountDownState createState() => FullScreenCountDownState();
}

class FullScreenCountDownState extends State<FullScreenCountDown> {
  late Timer _timer;
  late int _days;
  late int _hours;
  late int _minutes;
  late int _seconds;

  @override
  void initState() {
    super.initState();
    _days = widget.days;
    _hours = widget.hours;
    _minutes = widget.minutes;
    _seconds = widget.seconds;
    _startCountdown();
    
    
  }

  @override
  void dispose() {
    _timer.cancel();
    
    
    
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final difference = widget.targetDate.difference(now);

      setState(() {
        _days = difference.inDays;
        _hours = difference.inHours.remainder(24);
        _minutes = difference.inMinutes.remainder(60);
        _seconds = difference.inSeconds.remainder(60);
      });
    });
  }

  void _navigateToFullScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CountDownHomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color(0xFF2B2B2B), // Ana sayfanın rengiyle aynı
            child: Center(
              child: RotatedBox(
                quarterTurns: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.countdownType,
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTimeColumn('$_days', 'Gün'),
                        const SizedBox(width: 40),
                        _buildTimeColumn('$_hours', 'Saat'),
                        const SizedBox(width: 40),
                        _buildTimeColumn('$_minutes', 'Dakika'),
                        const SizedBox(width: 40),
                        _buildTimeColumn('$_seconds', 'Saniye'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
              onPressed: () {
                _navigateToFullScreen(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Column _buildTimeColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 36, color: Colors.white),
        ),
      ],
    );
  }
}
