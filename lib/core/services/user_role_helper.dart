import 'dart:convert';
import 'package:aleman/core/services/app_storage_key.dart';
import 'package:aleman/core/services/shared_pref_helper.dart';

class UserRoleHelper {
  static String? _cachedRole;

  static void setRole(String role) {
    if (role.trim().isEmpty) return;
    _cachedRole = role.trim();
    SharedPrefHelper.setData(PrefKeys.role, _cachedRole!);
  }

  static void clearRole() {
    _cachedRole = null;
    SharedPrefHelper.removeData(PrefKeys.role);
  }

  static String getUserRoleSync() {
    if (_cachedRole != null && _cachedRole!.isNotEmpty) {
      return _cachedRole!;
    }
    final saved = SharedPrefHelper.getString(PrefKeys.role);
    if (saved.trim().isNotEmpty) {
      _cachedRole = saved.trim();
      return _cachedRole!;
    }
    return '';
  }

  static bool isParentMerchantSync() {
    final role = getUserRoleSync().toLowerCase();
    return role == 'parentmerchant' ||
        role == 'parentmerchantid' ||
        role.contains('parentmerchant') ||
        role.contains('bigmerchant');
  }

  static bool isSmallMerchantSync() {
    final role = getUserRoleSync().toLowerCase();
    return role == 'smallmerchant' ||
        role.contains('smallmerchant') ||
        role.contains('submerchant');
  }

  static Future<String> getUserRole() async {
    final syncRole = getUserRoleSync();
    if (syncRole.isNotEmpty) {
      return syncRole;
    }

    // Fallback: Try decoding JWT access token claims
    try {
      final token =
          await SharedPrefHelper.getSecuredString(PrefKeys.userAccessToken);
      if (token.isNotEmpty) {
        final parts = token.split('.');
        if (parts.length == 3) {
          final normalized = base64Url.normalize(parts[1]);
          final payload = utf8.decode(base64Url.decode(normalized));
          final Map<String, dynamic> data =
              json.decode(payload) as Map<String, dynamic>;

          final role = (data[
                      'http://schemas.microsoft.com/ws/2008/06/identity/claims/role'] ??
                  data['role'])
              ?.toString();

          if (role != null && role.trim().isNotEmpty) {
            _cachedRole = role.trim();
            await SharedPrefHelper.setData(PrefKeys.role, _cachedRole!);
            return _cachedRole!;
          }
        }
      }
    } catch (_) {}

    return '';
  }

  static Future<bool> isParentMerchant() async {
    final role = (await getUserRole()).toLowerCase();
    return role == 'parentmerchant' ||
        role == 'parentmerchantid' ||
        role.contains('parentmerchant') ||
        role.contains('bigmerchant');
  }

  static Future<bool> isSmallMerchant() async {
    final role = (await getUserRole()).toLowerCase();
    return role == 'smallmerchant' ||
        role.contains('smallmerchant') ||
        role.contains('submerchant');
  }
}
