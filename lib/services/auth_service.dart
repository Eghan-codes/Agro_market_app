import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_model.dart';
import 'profile_service.dart';

class AuthService {
  AuthService._();

  static final SupabaseClient _client = Supabase.instance.client;

  static Future<bool> signIn(
      {required String email, required String password}) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session == null) return false;

      // Verify profile exists to ensure the app functions correctly
      final profile = await fetchCurrentProfile();
      if (profile == null) {
        // If no profile exists, the registration was incomplete.
        // We sign out to prevent broken state.
        await signOut();
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String role,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) return false;

      // Create the profile entry in the database
      await _client.from('profiles').insert({
        'id': user.id,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'role': role,
        'location': '',
      });

      return true;
    } catch (e) {
      // If profile creation fails, the user is still in Auth. 
      // Ideally, we should clean up here, but for now we return false.
      return false;
    }
  }

  static User? get currentUser => _client.auth.currentUser;

  static bool get isAuthenticated => currentUser != null;

  static Future<ProfileModel?> fetchCurrentProfile() async {
    final user = currentUser;
    if (user == null) return null;
    return ProfileService().fetchProfile(user.id);
  }

  static Future<bool> updateProfile(ProfileModel profile) async {
    return ProfileService().updateProfile(profile);
  }

  static Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
