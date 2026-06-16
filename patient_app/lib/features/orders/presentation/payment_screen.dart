import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
      appBar: AppBar(
        title: const Text('الدفع الإلكتروني'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('إلغاء الدفع؟'),
                content: const Text(
                    'هل تريد إلغاء عملية الدفع والعودة؟'),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 8),
                    Text(_error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _error = null;
                          _loading = true;
                        });
                        _fetchPaymentUrl();
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            )
          else if (_webController != null)
            WebViewWidget(controller: _webController!)
          else
            const Center(child: CircularProgressIndicator()),
          if (_loading && _webController != null)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
