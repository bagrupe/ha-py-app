import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Provider für den sicheren Speicher, der verschlüsselte SharedPreferences auf Android verwendet.
final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());
