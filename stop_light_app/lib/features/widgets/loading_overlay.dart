import 'dart:ui';
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content
        child,

        // Blur + overlay
        if (isLoading) ...[
          // Blur the background
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: const SizedBox.expand(),
            ),
          ),
          // Dim layer + spinner
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.25),
              alignment: Alignment.center,
              child: _OverlayContent(message: message),
            ),
          ),
        ],
      ],
    );
  }
}

class _OverlayContent extends StatelessWidget {
  final String? message;
  const _OverlayContent({this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const StopLightSpinner(),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Simple “stop light” spinner with three animated dots (red / yellow / green).
class StopLightSpinner extends StatefulWidget {
  const StopLightSpinner({super.key});

  @override
  State<StopLightSpinner> createState() => _StopLightSpinnerState();
}

class _StopLightSpinnerState extends State<StopLightSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const colors = [Color(0xFFC62828), Color(0xFFF9A825), Color(0xFF2E7D32)];
    return SizedBox(
      height: 72,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _c,
            builder: (_, __) {
              // phase offset per dot
              final t = (_c.value + i / 3) % 1.0;
              // scale 0.7 -> 1.0 -> 0.7
              final scale = 0.7 + 0.3 * (1 - (2 * (t - 0.5)).abs());
              final opacity = 0.5 + 0.5 * (1 - (2 * (t - 0.5)).abs());
              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: 16,
                    height: 16,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: colors[i],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colors[i].withOpacity(0.5),
                          blurRadius: 12,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
