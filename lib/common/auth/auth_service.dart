import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static Stream<AuthState> get onAuthStateChange =>
      Supabase.instance.client.auth.onAuthStateChange;

  static User? get user => Supabase.instance.client.auth.currentUser;

  static Session? get session => Supabase.instance.client.auth.currentSession;
}
