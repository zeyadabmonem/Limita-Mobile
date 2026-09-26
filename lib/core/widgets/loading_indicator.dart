import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Standard loading spinner. Use this everywhere instead of a bare
/// [CircularProgressIndicator] so sizing/color stay consistent.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.size = 28, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: color ?? AppColors.primary,
        ),
      ),
    );
  }
}

/// Full-screen loading state, for pages that have nothing else to show
/// yet (e.g. first load).
class FullScreenLoading extends StatelessWidget {
  const FullScreenLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoadingIndicator());
  }
}
