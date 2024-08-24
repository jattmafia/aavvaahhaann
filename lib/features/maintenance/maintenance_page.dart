import 'package:avahan/utils/assets.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset("assets/logo.svg", height: 24),
            const SizedBox(width: 8),
            Text(
              "Avahan".toUpperCase(),
              style: context.style.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: context.scheme.primary,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Spacer(flex: 1),
              Image.asset(Assets.sadhu3),
              const SizedBox(height: 24),
              Text(
                "We are currently under maintenance. We will be online soon.",
                style: context.style.titleLarge,
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
