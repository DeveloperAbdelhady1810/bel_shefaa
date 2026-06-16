import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../auth/domain/patient.dart';
import '../data/address_repository.dart';

class AddressController extends AsyncNotifier<List<PatientAddress>> {
  @override
  Future<List<PatientAddress>> build() =>
      ref.read(addressRepositoryProvider).list();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(addressRepositoryProvider).list());
  }

  Future<PatientAddress?> addAddress({
    required String label,
    required String addressLine,
    String? city,
    required double lat,
    required double lng,
  }) async {
    try {
      final addr = await ref.read(addressRepositoryProvider).store(
            label: label,
            addressLine: addressLine,
            city: city,
            lat: lat,
            lng: lng,
          );
      state.whenData((list) => state = AsyncData([...list, addr]));
      return addr;
    } catch (e) {
      return null;
    }
  }

  Future<void> delete(int id) async {
    await ref.read(addressRepositoryProvider).delete(id);
    state.whenData(
        (list) => state = AsyncData(list.where((a) => a.id != id).toList()));
  }
}

final addressControllerProvider =
    AsyncNotifierProvider<AddressController, List<PatientAddress>>(
        AddressController.new);

// Helper: get current GPS position (requests permission if needed)
Future<Position?> getCurrentPosition() async {
  LocationPermission perm = await Geolocator.checkPermission();
  if (perm == LocationPermission.denied) {
    perm = await Geolocator.requestPermission();
  }
  if (perm == LocationPermission.deniedForever ||
      perm == LocationPermission.denied) {
    return null;
  }
  return Geolocator.getCurrentPosition(
      locationSettings:
          const LocationSettings(accuracy: LocationAccuracy.high));
}
