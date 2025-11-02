// ✅ FILE MẪU - PUSH LÊN GIT ĐƯỢC
// 📝 Hướng dẫn: Copy file này thành supabase_env.dart và điền thông tin thật

/// Thông tin kết nối Supabase (BẢO MẬT)
class SupabaseEnv {
  // 🔐 Lấy từ: Supabase Dashboard → Settings → API
  
  /// Project URL
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  
  /// Anon/Public Key
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  // 📖 Ví dụ:
  // static const String supabaseUrl = 'https://xxxxxxxxxxxxx.supabase.co';
  // static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
}

