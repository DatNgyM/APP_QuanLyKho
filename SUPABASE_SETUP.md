# 🚀 Hướng dẫn cấu hình Supabase cho APP Quản Lý Kho

## 📋 Bước 1: Lấy thông tin Supabase

1. Truy cập [Supabase Dashboard](https://app.supabase.com)
2. Chọn project của bạn
3. Vào **Settings** (biểu tượng bánh răng bên trái)
4. Chọn **API**
5. Copy hai thông tin sau:
   - **Project URL** (URL)
   - **anon/public key** (API Key)

## 📝 Bước 2: Cập nhật file config

Mở file `lib/config/supabase_config.dart` và thay đổi:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';  // ← Thay đổi ở đây
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';  // ← Thay đổi ở đây
}
```

Thành:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://xxxxx.supabase.co';  // ← URL của bạn
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';  // ← Key của bạn
}
```

## 🗄️ Bước 3: Kiểm tra cấu trúc Database

Đảm bảo Supabase của bạn có các bảng sau:

### 📊 Table: `profiles`
```sql
- id (uuid, primary key, references auth.users)
- email (text)
- full_name (text)
- avatar_url (text)
- created_at (timestamp)
- updated_at (timestamp)
```

### 📦 Table: `products`
```sql
- id (uuid, primary key)
- user_id (uuid, references auth.users)
- name (text)
- code (text)
- category (text)
- quantity (integer)
- price (decimal)
- description (text)
- image_url (text)
- supplier (text)
- minimum_quantity (integer)
- created_at (timestamp)
- updated_at (timestamp)
```

### 📝 Table: `activities`
```sql
- id (uuid, primary key)
- user_id (uuid, references auth.users)
- product_id (uuid, references products)
- action_type (text)
- title (text)
- subtitle (text)
- created_at (timestamp)
```

## 🔐 Bước 4: Row Level Security (RLS)

Đảm bảo RLS được enable và có các policies phù hợp cho mỗi bảng.

## ✅ Bước 5: Chạy app

```bash
flutter run
```

## 🎯 Các tính năng đã tích hợp:

- ✅ **Authentication**: Đăng nhập/Đăng ký với Supabase Auth
- ✅ **Real-time Data**: Products được đồng bộ từ Supabase
- ✅ **Dashboard**: Hiển thị thống kê và activities
- ✅ **CRUD Operations**: Thêm, sửa, xóa products
- ✅ **Activity Logging**: Tự động log các hoạt động
- ✅ **Pull to Refresh**: Làm mới dữ liệu

## 🔧 Troubleshooting

### Lỗi: "Invalid API key"
- Kiểm tra lại URL và API Key trong `supabase_config.dart`
- Đảm bảo không có khoảng trắng thừa

### Lỗi: "Row Level Security"
- Kiểm tra RLS policies trong Supabase
- Đảm bảo user_id được set đúng

### Lỗi: "No data"
- Đảm bảo đã đăng nhập thành công
- Kiểm tra network connection
- Xem logs trong debug console

## 📞 Liên hệ

Nếu gặp vấn đề, kiểm tra:
1. Supabase Dashboard logs
2. Flutter debug console
3. Network tab trong browser (nếu web)

---

**Chúc bạn code vui vẻ! 🚀**

