# 🔌 Hướng dẫn Kết nối Supabase

## ✅ Kết nối đã hoàn tất!

App Flutter của bạn đã kết nối thành công với Supabase thông qua:
- **Supabase URL**: `https://tnctyxsglejxdkqdkedd.supabase.co`
- **Supabase Anon Key**: Đã được cấu hình

---

## 📝 Connection String bạn vừa cho (PostgreSQL Direct)

```
postgresql://postgres.tnctyxsglejxdkqdkedd:676767L@ucky7788@aws-1-us-east-2.pooler.supabase.com:5432/postgres
```

**Parse ra:**
- **User**: `postgres.tnctyxsglejxdkqdkedd`
- **Password**: `676767L@ucky7788`
- **Host**: `aws-1-us-east-2.pooler.supabase.com`
- **Port**: `5432`
- **Database**: `postgres`

---

## 🤔 KHI NÀO DÙNG CONNECTION STRING NÀY?

### ❌ KHÔNG dùng cho Flutter app
Flutter app của bạn đã dùng **Supabase SDK** (qua HTTP/REST API), không cần PostgreSQL connection string.

### ✅ Dùng khi muốn:

#### 1. **Kết nối qua Database Client** (DBeaver, pgAdmin, TablePlus)

**Ví dụ với DBeaver:**
```
Host: aws-1-us-east-2.pooler.supabase.com
Port: 5432
Database: postgres
User: postgres.tnctyxsglejxdkqdkedd
Password: 676767L@ucky7788
```

#### 2. **Chạy SQL Scripts từ terminal**

```bash
psql "postgresql://postgres.tnctyxsglejxdkqdkedd:676767L@ucky7788@aws-1-us-east-2.pooler.supabase.com:5432/postgres"
```

#### 3. **Backend Services** (Node.js, Python, etc.)

```javascript
// Node.js với pg
const { Pool } = require('pg');
const pool = new Pool({
  connectionString: 'postgresql://postgres.tnctyxsglejxdkqdkedd:676767L@ucky7788@aws-1-us-east-2.pooler.supabase.com:5432/postgres'
});
```

---

## 🎯 APP FLUTTER CỦA BẠN

### ✅ Đang dùng đúng cách:

**File: `lib/config/supabase_config.dart`**
```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://tnctyxsglejxdkqdkedd.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
}
```

**File: `lib/main.dart`**
```dart
await SupabaseService.initialize();
```

**File: `lib/services/supabase_service.dart`**
```dart
await client.from('products').select(); // ✅ Dùng REST API
```

---

## 🔐 BẢO MẬT QUAN TRỌNG

### ⚠️ Lưu ý về Connection String:

1. **KHÔNG COMMIT** connection string vào Git!
2. **KHÔNG SHARE** password này công khai!
3. Password này có quyền **FULL ACCESS** database!

### 🔒 Tốt nhất:

- Flutter app: Dùng **Supabase Anon Key** (RLS bảo vệ) ✅
- Backend/Scripts: Dùng **Service Role Key** hoặc **Connection String** ✅
- Công khai: **KHÔNG BAO GIỜ** ❌

---

## 📊 KIỂM TRA KẾT NỐI

### Trong Flutter App:

```dart
// Test connection
final response = await Supabase.instance.client
    .from('products')
    .select()
    .limit(1);

print('Connected! Got ${response.length} products');
```

### Qua psql terminal:

```bash
psql "postgresql://postgres.tnctyxsglejxdkqdkedd:676767L@ucky7788@aws-1-us-east-2.pooler.supabase.com:5432/postgres"

# Trong psql:
\dt  # List tables
SELECT * FROM auth.users LIMIT 1;  # Test query
```

---

## 🆘 Troubleshooting

### Lỗi: "Could not connect"
- ✅ Kiểm tra firewall/network
- ✅ Verify password chính xác
- ✅ Đảm bảo Supabase project đang active

### Lỗi: "Permission denied"
- ✅ Check RLS policies
- ✅ Verify user có quyền truy cập

### Lỗi trong Flutter app: "Invalid API key"
- ✅ Kiểm tra `supabaseUrl` và `supabaseAnonKey` trong config
- ✅ Đảm bảo đã chạy `flutter pub get`
- ✅ Hot restart app

---

## ✅ TÓM TẮT

| Mục đích | Dùng gì |
|----------|---------|
| **Flutter App** | Supabase URL + Anon Key ✅ (đã setup) |
| **Database Client** | Connection String 📊 |
| **SQL Scripts** | Connection String 📝 |
| **Backend API** | Connection String hoặc Service Role Key 🔧 |

**App của bạn đã kết nối đúng rồi!** 🎉

---

## 🚀 Next Steps

1. ✅ Confirm users đang "Waiting for verification"
2. ✅ Setup RLS policies cho tables
3. ✅ Test đăng nhập với user đã confirm
4. ✅ Tạo products và verify RLS hoạt động

**Happy Coding!** 🎊

