import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../application/auth_controller.dart';
import '../data/auth_repository.dart';

class OtpVerifyScreen extends ConsumerStatefulWidget {
  const OtpVerifyScreen({super.key, required this.email});
  final String email;

  @override
  ConsumerState<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifyScreen> {
  final _codeCtrl  = TextEditingController();
  final _nameCtrl  = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _needsProfile = false; // set true after first call reveals new user

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _codeCtrl.text.trim();
    if (code.length < 4) {
      setState(() => _error = 'يرجى إدخال رمز التحقق كاملاً');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await ref.read(authRepositoryProvider).verifyOtp(
            email: widget.email,
            code: code,
            name:  _needsProfile ? _nameCtrl.text.trim()  : null,
            phone: _needsProfile ? _phoneCtrl.text.trim() : null,
          );

      if (result.isNew && !_needsProfile) {
        // First-time user — ask for name + phone then re-submit with same code.
        setState(() {
          _needsProfile = true;
          _loading = false;
        });
        return;
      }

      ref.read(authControllerProvider.notifier).setAuthenticated(result.patient!);
      if (!mounted) return;
      // If new user with no address yet → go to onboarding address screen
      if (result.patient!.addresses.isEmpty) {
        context.go('/onboarding-address');
      } else {
        context.go('/home');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التحقق من البريد الإلكتروني'),
        backgroundColor: kMedicalBlue,
        foregroundColor: Colors.white,
      ),
      backgroundColor: kBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),

            // ── Email display card ──────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kSurface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: kCardShadowBlue,
                      blurRadius: 24,
                      offset: Offset(0, 6)),
                  BoxShadow(
                      color: Color(0x06000000),
                      blurRadius: 6,
                      offset: Offset(0, 1)),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.mark_email_read_outlined,
                      color: kMedicalBlue, size: 40),
                  const SizedBox(height: 10),
                  const Text(
                    'أرسلنا رمز إلى',
                    style: TextStyle(color: kTextSecondary, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.email,
                    style: const TextStyle(
                      color: kMedicalBlue,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── OTP input ───────────────────────────────────────────
            TextField(
              controller: _codeCtrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 32,
                  letterSpacing: 10,
                  fontWeight: FontWeight.w700,
                  color: kTextPrimary),
              maxLength: 6,
              decoration: InputDecoration(
                hintText: '000000',
                hintStyle: TextStyle(
                  letterSpacing: 10,
                  color: kTextSecondary.withValues(alpha: 0.5),
                  fontSize: 32,
                ),
                filled: true,
                fillColor: kBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: kMedicalBlue, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 20),
                counterText: '',
              ),
            ),

            // ── Profile fields (animated in for new users) ──────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SizeTransition(sizeFactor: anim, child: child),
              ),
              child: _needsProfile
                  ? _ProfileCard(
                      nameCtrl: _nameCtrl,
                      phoneCtrl: _phoneCtrl,
                    )
                  : const SizedBox.shrink(),
            ),

            // ── Error banner ────────────────────────────────────────
            if (_error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: kError.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: kError.withValues(alpha: 0.25)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: kError, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(_error!,
                          style: const TextStyle(
                              color: kError, fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 28),

            _GradientButton(
              label: _needsProfile ? 'إنشاء الحساب' : 'تأكيد',
              icon: _needsProfile
                  ? Icons.person_add_rounded
                  : Icons.check_circle_outline,
              onPressed: _verify,
              loading: _loading,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Profile Card (new user) ──────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.nameCtrl, required this.phoneCtrl});
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('profile-card'),
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: kCardShadowBlue,
              blurRadius: 24,
              offset: Offset(0, 6)),
          BoxShadow(
              color: Color(0x06000000),
              blurRadius: 6,
              offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'مرحباً! أكمل بياناتك',
            style: TextStyle(
              color: kTextPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: nameCtrl,
            decoration: InputDecoration(
              labelText: 'الاسم الكامل',
              prefixIcon:
                  const Icon(Icons.person_outline, color: kTextSecondary),
              filled: true,
              fillColor: kBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: kMedicalBlue, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 16),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(
              labelText: 'رقم الموبايل',
              prefixIcon:
                  const Icon(Icons.phone_outlined, color: kTextSecondary),
              filled: true,
              fillColor: kBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: kMedicalBlue, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 16),
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
      vsync: this, duration: const Duration(milliseconds: 90));
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
          onTapDown: (_) {
            if (!widget.loading) _ctrl.forward();
          },
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
                      width: 22,
                      height: 22,
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
                          style: const TextStyle(
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
