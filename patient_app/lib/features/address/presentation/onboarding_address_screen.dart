import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../application/address_controller.dart';

class OnboardingAddressScreen extends ConsumerStatefulWidget {
  const OnboardingAddressScreen({super.key});

  @override
  ConsumerState<OnboardingAddressScreen> createState() =>
      _OnboardingAddressScreenState();
}

class _OnboardingAddressScreenState
    extends ConsumerState<OnboardingAddressScreen>
    with TickerProviderStateMixin {
  final _lineCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  double? _lat;
  double? _lng;
  bool _locating = false;
  bool _saving = false;
  String? _error;

  // Pin bounce animation
  late final AnimationController _pinCtrl;
  late final Animation<double> _pinBounce;

  // GPS success pulse animation
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _pinCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _pinBounce = CurvedAnimation(parent: _pinCtrl, curve: Curves.bounceOut);
    _pinCtrl.forward();

    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _pulseAnim = Tween<double>(begin: 0.97, end: 1.03).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _lineCtrl.dispose();
    _cityCtrl.dispose();
    _pinCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _useGps() async {
    setState(() {
      _locating = true;
      _error = null;
    });
    final pos = await getCurrentPosition();
    if (pos == null) {
      setState(() {
        _error = 'تعذّر تحديد الموقع. تأكد من تفعيل خدمة الموقع.';
        _locating = false;
      });
      return;
    }
    setState(() {
      _lat = pos.latitude;
      _lng = pos.longitude;
      _locating = false;
    });
    // Start pulse animation on success
    _pulseCtrl.repeat(reverse: true);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تحديد موقعك الحالي ✓')),
    );
  }

  Future<void> _save() async {
    final line = _lineCtrl.text.trim();
    if (line.isEmpty) {
      setState(() => _error = 'يرجى إدخال العنوان التفصيلي');
      return;
    }
    if (_lat == null) {
      setState(() => _error = 'يرجى تحديد موقعك أولاً');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final addr = await ref.read(addressControllerProvider.notifier).addAddress(
          label: 'المنزل',
          addressLine: line,
          city: _cityCtrl.text.trim().isEmpty ? null : _cityCtrl.text.trim(),
          lat: _lat!,
          lng: _lng!,
        );
    if (!mounted) return;
    setState(() => _saving = false);
    if (addr != null) {
      context.go('/home');
    } else {
      setState(() => _error = 'تعذّر حفظ العنوان، يرجى المحاولة مجدداً.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          // ── Gradient header ────────────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            height: size.height * 0.40,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [kMedicalBlueDark, kMedicalBlue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated bouncing location pin
                    ScaleTransition(
                      scale: _pinBounce,
                      child: Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.location_on_rounded,
                            color: Colors.white, size: 44),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'حدد عنوانك',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'نوصل دواءك لباب بيتك',
                      style: GoogleFonts.notoKufiArabic(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── White bottom card ──────────────────────────────────────
          Positioned(
            top: size.height * 0.34,
            left: 0, right: 0, bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: kSurface,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // GPS Button
                    if (_locating)
                      OutlinedButton.icon(
                        onPressed: null,
                        icon: const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: kMedicalBlue),
                        ),
                        label: Text(
                          'جارٍ تحديد الموقع...',
                          style: GoogleFonts.cairo(
                              color: kMedicalBlue,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    else if (_lat != null)
                      // GPS success card with pulse
                      AnimatedBuilder(
                        animation: _pulseAnim,
                        builder: (context, child) => Transform.scale(
                          scale: _pulseCtrl.isAnimating
                              ? _pulseAnim.value
                              : 1.0,
                          child: child,
                        ),
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: kSuccessLight,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: kSuccess.withValues(alpha: 0.5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle_rounded,
                                  color: kSuccess, size: 22),
                              const SizedBox(width: 8),
                              Text(
                                'تم تحديد الموقع ✓',
                                style: GoogleFonts.cairo(
                                    color: kSuccess,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: _useGps,
                                child: Text(
                                  'تحديث',
                                  style: GoogleFonts.cairo(
                                      color: kMedicalBlue,
                                      fontSize: 12,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      OutlinedButton.icon(
                        onPressed: _useGps,
                        icon: const Icon(Icons.my_location),
                        label: Text(
                          'استخدم موقعي الحالي',
                          style: GoogleFonts.cairo(
                              fontWeight: FontWeight.w600),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Address line
                    TextField(
                      controller: _lineCtrl,
                      decoration: InputDecoration(
                        labelText: 'العنوان التفصيلي *',
                        hintText: 'مثال: 12 شارع النيل، الدور الثالث',
                        prefixIcon: const Icon(Icons.home_outlined,
                            color: kTextSecondary),
                        filled: true,
                        fillColor: kBg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: kDivider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: kMedicalBlue, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 16),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // City
                    TextField(
                      controller: _cityCtrl,
                      decoration: InputDecoration(
                        labelText: 'المدينة / الحي',
                        prefixIcon: const Icon(Icons.location_city_outlined,
                            color: kTextSecondary),
                        filled: true,
                        fillColor: kBg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: kDivider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: kMedicalBlue, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 16),
                      ),
                    ),

                    // Error
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: kErrorLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: kError.withValues(alpha: 0.25)),
                        ),
                        child: Text(
                          _error!,
                          style: GoogleFonts.notoKufiArabic(
                              color: kError, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],

                    const SizedBox(height: 28),

                    // Save button
                    _GradientButton(
                      label: 'حفظ والمتابعة',
                      icon: Icons.check_rounded,
                      onPressed: _save,
                      loading: _saving,
                    ),

                    const SizedBox(height: 12),

                    // Skip
                    TextButton(
                      onPressed: () => context.go('/home'),
                      child: Text(
                        'تخطي الآن',
                        style: GoogleFonts.notoKufiArabic(
                            color: kTextSecondary, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Gradient Button ──────────────────────────────────────────────────────────

class _GradientButton extends StatefulWidget {
  const _GradientButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.color1 = kMedicalBlue,
    this.color2 = kMedicalBlueDark,
  });
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool loading;
  final Color color1;
  final Color color2;

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 80));
  late final Animation<double> _scale =
      Tween(begin: 1.0, end: 0.96).animate(
          CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
        scale: _scale,
        child: GestureDetector(
          onTapDown: (_) { if (!widget.loading) _ctrl.forward(); },
          onTapUp: (_) {
            _ctrl.reverse();
            if (!widget.loading) widget.onPressed();
          },
          onTapCancel: () => _ctrl.reverse(),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [widget.color1, widget.color2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: widget.color1.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: widget.loading
                  ? const SizedBox(
                      width: 22, height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.label,
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      );
}
