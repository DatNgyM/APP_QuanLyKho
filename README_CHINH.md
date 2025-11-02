# 📱 APP QUẢN LÝ KHO - HƯỚNG DẪN CHÍNH

## 🎯 Tổng quan

App quản lý kho kết nối với **Supabase** (chung với Web bán hàng)

- ✅ Real-time sync với Web
- ✅ Credentials bảo mật (không lộ khi push Git)
- ✅ Tự động fetch categories, brands từ Supabase
- ✅ Hiển thị products với giá VND

---

## 🚀 Setup lần đầu

### 1. Clone project
```bash
git clone your-repo.git
cd APP_QuanLyKho
```

### 2. Setup Supabase credentials
```bash
# Copy template
copy lib\config\supabase_env.example.dart lib\config\supabase_env.dart

# Mở lib\config\supabase_env.dart
# Điền thông tin Supabase của bạn:
# - supabaseUrl: 'https://xxxxx.supabase.co'
# - supabaseAnonKey: 'eyJhbGci...'
```

### 3. Install dependencies
```bash
flutter pub get
```

### 4. Run app
```bash
flutter run
# Hoặc web:
flutter run -d chrome
```

---

## 📊 Database Structure

App kết nối với các bảng:

### 🗄️ **products**
- `id` (integer)
- `category_id` (integer) → Link với `categories`
- `brand_id` (integer) → Link với `brands`
- `name`, `sku`, `price`, `quantity`
- `description`, `image_url`
- Specs: `cpu`, `ram`, `rom`, `screen_size`, `battery_capacity`...

### 🏷️ **categories**
- `id` (integer)
- `name` ('Điện thoại', 'Laptop', 'Tablet'...)
- `slug`, `description`

### 🏢 **brands**
- `id` (integer)
- `name` ('Apple', 'Samsung', 'Xiaomi'...)
- `slug`, `logo`, `description`

---

## ✨ Features

### 🏠 Dashboard:
- ✅ Metrics: Total products, Total value, Low stock
- ✅ Quick actions
- ✅ Recent activities
- ✅ **Nút Sync** để đồng bộ với Web
- ✅ **Real-time auto sync** (optional)

### 📦 Inventory:
- ✅ Danh sách sản phẩm từ Supabase
- ✅ Search, Filter, Sort
- ✅ Add/Edit/Delete products
- ✅ Upload ảnh

### 📊 Reports:
- ✅ Statistics
- ✅ Charts
- ✅ Export PDF/CSV

### ⚙️ Settings:
- ✅ Language (VI/EN)
- ✅ Theme (Light/Dark/System)
- ✅ Profile
- ✅ Test Supabase Connection

---

## 🔄 Đồng bộ với Web

App và Web cùng dùng Supabase:

```
Web (Bán hàng)
    ↓ (Update quantity)
Supabase Database
    ↓ (Real-time)
App (Quản lý kho)
    ↓
Dashboard cập nhật ngay!
```

### 2 cách sync:

1. **Real-time Auto:** Tự động sync khi Web thay đổi
2. **Nút Sync:** Click để refresh thủ công

---

## 🔐 Bảo mật

### ✅ An toàn:
- Credentials ở file riêng (`supabase_env.dart`)
- File này **KHÔNG PUSH** lên Git (đã add vào .gitignore)
- Chỉ push file template (`.example.dart`)

### ⚠️ Quan trọng:
**KHÔNG BAO GIỜ commit file `supabase_env.dart` lên Git!**

---

## 📁 Cấu trúc quan trọng

```
lib/
├── config/
│   ├── supabase_env.dart          ⚠️ KHÔNG PUSH (ignored)
│   └── supabase_env.example.dart  ✅ PUSH được
├── services/
│   ├── supabase_service.dart      ✅ Auto fetch categories/brands
│   └── local_mockup_service.dart  ✅ Fallback nếu offline
├── providers/
│   └── inventory_provider.dart    ✅ Quản lý state
└── screens/
    └── dashboard_screen.dart      ✅ Hiển thị data

Sbp/
├── products_rows.sql              ✅ Data có sẵn từ Supabase
├── categories_rows.sql            ✅ 5 categories
├── brands_rows.sql                ✅ 12 brands
└── full.sql                       ✅ Full schema
```

---

## 🎯 Workflow

### Lần đầu:
```
1. Setup credentials (supabase_env.dart)
2. flutter run
3. Sign Up / Login
4. Dashboard tự động load data từ Supabase
5. ✅ Thấy tất cả products!
```

### Hàng ngày:
```
1. Mở app
2. Login
3. Dashboard sync tự động
4. Xem/Quản lý kho
5. Real-time update từ Web
```

---

## 💡 Tips

### Sync data:
- AppBar → Icon 🔄 (Sync button)
- Hoặc Pull-to-refresh

### Thêm product mới:
- Dashboard → ➕ Add Product
- Điền form → Save
- Tự động đồng bộ với Web

### Xem chi tiết:
- Inventory → Click product
- Xem specs đầy đủ

---

## 📖 Documentation

- **SETUP_SUPABASE_AN_TOAN.md** - Bảo mật credentials
- **_DA_BAO_MAT_XONG.txt** - Tóm tắt
- **Sbp/** folder - SQL data từ Supabase

---

## 🆘 Troubleshooting

### Lỗi: "Supabase not initialized"
→ Check `supabase_env.dart` đã điền đúng thông tin chưa

### Không thấy products:
→ Check Supabase có data không
→ Check RLS policies
→ Click nút Sync

### Real-time không hoạt động:
→ Check Supabase Realtime enabled
→ Restart app

---

## 🎉 Kết luận

✅ **App an toàn** - Credentials không lộ  
✅ **Tự động sync** - Real-time với Web  
✅ **Dễ setup** - Copy template và điền  
✅ **Production ready!**

---

**Version:** 5.0.0 (Secure + Real-time)  
**Date:** 2025-11-02  
**Status:** ✅ READY FOR PRODUCTION

