import 'dart:convert';
import '../../shared/services/http_client.dart';
import '../models/user_profile.dart';

abstract class IProfileService {
  Future<UserProfile> fetchProfile();
  Future<bool> updateProfile(UserProfile profile);
}

class ProfileService implements IProfileService {
  static const _path = '/profile';

  @override
  Future<UserProfile> fetchProfile() async {
    final res = await HttpClient.get(_path);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body)['data'] as Map<String, dynamic>;
      return UserProfile.fromJson(data);
    }
    throw Exception('Error fetching profile: ${res.body}');
  }

  @override
  Future<bool> updateProfile(UserProfile profile) async {
    final res = await HttpClient.put(_path, profile.toJson());
    if (res.statusCode == 200) return true;
    throw Exception('Error updating profile: ${res.body}');
  }
}
