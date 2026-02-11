import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Premium Loading Widget
class LoadingWidget extends StatelessWidget {
  final String? message;
  final Color? color;
  final double? size;

  const LoadingWidget({
    this.message,
    this.color,
    this.size,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size ?? 48.w,
            height: size ?? 48.h,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppColors.kPrimary,
              ),
            ),
          ),
          if (message != null) ...[
            SizedBox(height: AppSpacing.mdVertical),
            Text(
              message!,
              style: AppTypography.kBody1.copyWith(
                color: AppColors.kGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Full Screen Loading Overlay
class LoadingOverlay extends StatelessWidget {
  final String? message;

  const LoadingOverlay({
    this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.kBlack.withOpacity(0.5),
      child: LoadingWidget(message: message),
    );
  }
}

/// Shimmer Loading Effect
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final double? borderRadius;

  const ShimmerLoading({
    required this.width,
    required this.height,
    this.borderRadius,
    Key? key,
  }) : super(key: key);

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? AppSpacing.radiusMd,
            ),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: isDarkMode
                  ? [
                      AppColors.kSecondaryLight,
                      AppColors.kGreyDark,
                      AppColors.kSecondaryLight,
                    ]
                  : [
                      AppColors.kGreyLight,
                      AppColors.kWhite,
                      AppColors.kGreyLight,
                    ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
            ),
          ),
        );
      },
    );
  }
}
