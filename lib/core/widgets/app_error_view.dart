import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../error/failures.dart';
import '../theme/app_text_styles.dart';

/// Maps a domain [Failure] to a user-facing message.
/// Centralized here so copy stays consistent across every feature.
String failureMessage(Failure failure) {
  return switch (failure) {
    NetworkFailure() => AppStrings.noInternetConnection,
    TimeoutFailure() => AppStrings.requestTimeout,
    UnauthorizedFailure() => AppStrings.unauthorized,
    ValidationFailure(:final message) => message,
    ServerFailure(:final message) => message.isNotEmpty ? message : AppStrings.serverError,
    CacheFailure() => AppStrings.genericError,
    UnknownFailure() => AppStrings.genericError,
  };
}

/// Reusable error state with an icon, message and retry action.
/// Works both full-screen and embedded inside a page.
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.failure,
    this.onRetry,
  });

  final Failure failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text(
              failureMessage(failure),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: onRetry,
                child: const Text(AppStrings.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
