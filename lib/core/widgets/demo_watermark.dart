import 'package:flutter/material.dart';
import '../../config/demo_config.dart';

class DemoWatermark extends StatelessWidget {
  const DemoWatermark({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kIsDemo) return const SizedBox.shrink();

    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              for (double y = 60; y < constraints.maxHeight; y += 220)
                for (double x = 20; x < constraints.maxWidth; x += 320)
                  Positioned(
                    left: x,
                    top: y,
                    child: Transform.rotate(
                      angle: -0.45,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400.withValues(alpha: 0.25),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'نسخه آزمایشی',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'IranYekan',
                            color: Colors.grey.shade500.withValues(alpha: 0.18),
                          ),
                        ),
                      ),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}
