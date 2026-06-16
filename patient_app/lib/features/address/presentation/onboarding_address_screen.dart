import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../application/address_controller.dart';

class OnboardingAddressScreen extends ConsumerStatefulWidget {
  const OnboardingAddressScreen({super.key});

  @override
  ConsumerState<OnboardingAddressScreen> createState() =>
      _OnboardingAddressScreenState();
}

class _OnboardingAddressScreenState
    extends ConsumerState<OnboardingAddressScreen> {
  final _lineCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  double? _lat;
  double? _lng;
  bool _locating = false;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _lineCtrl.dispose();
    _cityCtrl.dispose();
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              const Icon(Icons.location_on, size: 56, color: kMedicalBlue),
              const SizedBox(height: 16),
              Text('أضف عنوانك',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('نحتاج عنوانك لتوصيل دوائك',
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: _locating ? null : _useGps,
                icon: _locating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child:
                            CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.my_location),
                label: Text(
                    _lat != null ? 'تم تحديد الموقع ✓' : 'استخدم موقعي الحالي'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lineCtrl,
                decoration: const InputDecoration(
                  labelText: 'العنوان التفصيلي *',
                  hintText: 'مثال: 12 شارع النيل، الدور الثالث',
                  prefixIcon: Icon(Icons.home_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _cityCtrl,
                decoration: const InputDecoration(
                  labelText: 'المدينة / الحي',
                  prefixIcon: Icon(Icons.location_city_outlined),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center),
              ],
              const Spacer(),
              _saving
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _save,
                      child: const Text('حفظ والمتابعة'),
                    ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.go('/home'),
                child: const Text('تخطي الآن'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
