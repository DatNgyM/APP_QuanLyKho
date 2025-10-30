class SupabaseConfig {
  // ⚠️ QUAN TRỌNG: Thay đổi các giá trị này bằng thông tin từ Supabase Dashboard
  // Vào: Supabase Dashboard -> Settings -> API

  static const String supabaseUrl = 'https://tnctyxsglejxdkqdkedd.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRuY3R5eHNnbGVqeGRrcWRrZWRkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc3Mzg1MDIsImV4cCI6MjA3MzMxNDUwMn0._6ASwFIDcaqOV2dP5-1CPskP9GRfHHIUtnoCJqJQD6g';

  // Ví dụ:
  // static const String supabaseUrl = 'https://xxxxxxxxxxxxx.supabase.co';
  // static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';

  // 🔍 Hướng dẫn lấy thông tin:
  // 1. Mở Supabase Dashboard
  // 2. Chọn project của bạn
  // 3. Vào Settings (bánh răng bên trái)
  // 4. Chọn API
  // 5. Copy "Project URL" và "anon/public key"
}
