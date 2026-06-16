import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/auth_controller.dart';
import '../data/auth_repository.dart';

class OtpVerifyScreen extends ConsumerStatefulWidget {
  const OtpVerifyScreen({super.key, required this.email});
  final String email;

  @override
  ConsumerState<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifyScreen> {
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
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
            name: _needsProfile ? _nameCtrl.text.trim() : null,
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

      ref.read(authControllerProvider.notifier).setAuthenticated(result.patient);
      if (!mounted) return;
      // If new user with no address yet → go to onboarding address screen
      if (result.patient.addresses.isEmpty) {
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
      appBar: AppBar(title: const Text('التحقق من البريد الإلكتروني')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('أرسلنا رمز تحقق إلى',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(widget.email,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
            const SizedBox(height: 32),
            TextField(
              controller: _codeCtrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, letterSpacing: 8),
              decoration: const InputDecoration(
                hintText: '000000',
                hintStyle: TextStyle(letterSpacing: 8, color: Colors.grey),
              ),
              maxLength: 6,
            ),
            if (_needsProfile) ...[
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),
              Text('مرحباً بك! أكمل بياناتك',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                    labelText: 'الاسم الكامل',
                    prefixIcon: Icon(Icons.person_outline)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                textDirection: TextDirection.ltr,
                decoration: const InputDecoration(
                    labelText: 'رقم الموبايل',
                    prefixIcon: Icon(Icons.phone_outlined)),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center),
            ],
            const SizedBox(height: 28),
            _loading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _verify,
                    child: Text(_needsProfile ? 'إنشاء الحساب' : 'تأكيد'),
                  ),
          ],
        ),
      ),
    );
  }
}
