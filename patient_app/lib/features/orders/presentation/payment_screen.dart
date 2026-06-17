import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../data/order_repository.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key, required this.orderId});
  final int orderId;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen>
    with SingleTickerProviderStateMixin {
  WebViewController? _webController;
  bool _loading = true;
  String? _error;

  // Shimmer for loading state
  late final AnimationController _shimmerCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1400))
    ..repeat();

  @override
  void initState() {
    super.initState();
    _fetchPaymentUrl();
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchPaymentUrl() async {
    try {
      final result =
          await ref.read(orderRepositoryProvider).pay(widget.orderId);
      final url = result.paymentUrl;
      if (url.isEmpty) throw Exception('لم يتم الحصول على رابط الدفع');
      _initWebView(url);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _initWebView(String url) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _loading = true),
          onPageFinished: (loadedUrl) {
            setState(() => _loading = false);
            if (loadedUrl.contains('success') ||
                loadedUrl.contains('paid')) {
              context.pushReplacement('/tracking/${widget.orderId}');
            } else if (loadedUrl.contains('fail') ||
                loadedUrl.contains('error')) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('فشل الدفع. يمكنك المحاولة مجدداً.')),
              );
              context.pop();
            }
          },
          onWebResourceError: (error) {
            setState(() {
              _loading = false;
              _error = 'خطأ في تحميل صفحة الدفع: ${error.description}';
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
    setState(() => _webController = controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kSurface,
        foregroundColor: kDeepNavy,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text('الدفع الإلكتروني',
            style: GoogleFonts.cairo(
                color: kDeepNavy, fontSize: 17, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: kDeepNavy),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('إلغاء الدفع؟',
                    style:
                        GoogleFonts.cairo(fontWeight: FontWeight.w700)),
                content: Text('هل تريد إلغاء عملية الدفع والعودة؟',
                    style: GoogleFonts.notoKufiArabic()),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('لا'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.pop();
                    },
                    child: Text('نعم، إلغاء',
                        style: GoogleFonts.cairo(color: kError)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          // Error state
          if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: kCardDecoration(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 72, height: 72,
                        decoration: const BoxDecoration(
                          color: kErrorLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.error_outline,
                            color: kError, size: 36),
                      ),
                      const SizedBox(height: 16),
                      Text(_error!,
                          style: GoogleFonts.notoKufiArabic(color: kError),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 20),
                      _GradientButton(
                        label: 'إعادة المحاولة',
                        icon: Icons.refresh,
                        onPressed: () {
                          setState(() {
                            _error = null;
                            _loading = true;
                          });
                          _fetchPaymentUrl();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          else if (_webController != null)
            // Actual WebView
            WebViewWidget(controller: _webController!)
          else
            // Initial branded loading card
            Center(
              child: AnimatedBuilder(
                animation: _shimmerCtrl,
                builder: (context, child) {
                  return Container(
                    margin: const EdgeInsets.all(32),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: kDivider),
                      gradient: LinearGradient(
                        colors: [
                          kSurface,
                          kMedicalBlueLight.withValues(
                              alpha: 0.3 * _shimmerCtrl.value),
                          kSurface,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: const [
                        BoxShadow(
                            color: kShadowBlue,
                            blurRadius: 20,
                            offset: Offset(0, 6)),
                        BoxShadow(
                            color: kShadowDeep,
                            blurRadius: 4,
                            offset: Offset(0, 2)),
                      ],
                    ),
                    child: child,
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(
                        color: kMedicalBlueLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock_outline,
                          color: kMedicalBlue, size: 32),
                    ),
                    const SizedBox(height: 16),
                    Text('جارٍ تحميل صفحة الدفع...',
                        style: GoogleFonts.cairo(
                            color: kTextPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
                    const SizedBox(height: 8),
                    Text('اتصال آمن عبر Paymob',
                        style: GoogleFonts.notoKufiArabic(
                            color: kTextSecondary, fontSize: 13)),
                    const SizedBox(height: 20),
                    const SizedBox(
                      width: 36, height: 36,
                      child: CircularProgressIndicator(
                          color: kMedicalBlue, strokeWidth: 3),
                    ),
                  ],
                ),
              ),
            ),

          // Page-change loading overlay (on top of WebView)
          if (_loading && _webController != null)
            Container(
              color: Colors.white.withValues(alpha: 0.6),
              child: const Center(
                child: SizedBox(
                  width: 40, height: 40,
                  child: CircularProgressIndicator(
                      color: kMedicalBlue, strokeWidth: 3),
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
                        Text(widget.label,
                            style: GoogleFonts.cairo(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
                      ],
                    ),
            ),
          ),
        ),
      );
}
