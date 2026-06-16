import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../data/order_repository.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key, required this.orderId});
  final int orderId;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  WebViewController? _webController;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPaymentUrl();
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
            // Paymob redirects to a success/failure URL after payment
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
        backgroundColor: kMedicalBlue,
        foregroundColor: Colors.white,
        title: const Text('الدفع الإلكتروني'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('إلغاء الدفع؟'),
                content: const Text('هل تريد إلغاء عملية الدفع والعودة؟'),
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
                    child: const Text('نعم، إلغاء'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: kSurface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: kCardShadowBlue,
                          blurRadius: 24,
                          offset: Offset(0, 6)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: kError.withValues(alpha: 0.10),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.error_outline,
                            color: kError, size: 34),
                      ),
                      const SizedBox(height: 16),
                      Text(_error!,
                          style: const TextStyle(color: kError),
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
            WebViewWidget(controller: _webController!)
          else
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 52,
                    height: 52,
                    child: CircularProgressIndicator(
                        color: kMedicalBlue, strokeWidth: 3),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'جارٍ تحميل صفحة الدفع...',
                    style: TextStyle(color: kTextSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
          if (_loading && _webController != null)
            const Center(
              child: SizedBox(
                width: 52,
                height: 52,
                child: CircularProgressIndicator(
                    color: kMedicalBlue, strokeWidth: 3),
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
