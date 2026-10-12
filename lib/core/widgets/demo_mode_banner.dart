import 'package:flutter/material.dart';

/// Clearly visible banner shown on every screen while the app runs in
/// DEMO MODE (all data is fictional and local).
class DemoModeBanner extends StatelessWidget {
  const DemoModeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFB45309),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 24,
          width: double.infinity,
          child: Center(
            child: Text(
              'DEMO MODE — بيانات تجريبية تخيّلية، لا يوجد خادم حقيقي',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
