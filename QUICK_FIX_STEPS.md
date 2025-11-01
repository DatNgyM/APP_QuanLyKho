# 🚨 FIX LOGIN LỖI "Invalid login credentials"

## 🎯 NGUYÊN NHÂN:
Users trong `auth.users` đang ở trạng thái **"Waiting for verification"** → Không thể login!

---

## ✅ GIẢI PHÁP (3 PHÚT):

### **BƯỚC 1: Confirm Users trong Supabase**

1. Mở **Supabase Dashboard** → **SQL Editor**
2. Click **"New query"**
3. Copy và paste đoạn SQL này:

```sql
-- Confirm tất cả users
UPDATE auth.users 
SET email_confirmed_at = NOW(), 
    confirmed_at = NOW()
WHERE email_confirmed_at IS NULL;

-- Kiểm tra
SELECT email, email_confirmed_at, confirmed_at 
FROM auth.users;
```

4. Click **"Run"** (hoặc Ctrl + Enter)
5. ✅ Thấy message "Success"

---

### **BƯỚC 2: Tắt Email Confirmation (Cho Development)**

1. Vào **Authentication** → **Providers**
2. Click vào **"Email"**
3. Scroll xuống tìm **"Confirm email"** 
4. ❌ **TẮT** (uncheck) option này
5. Click **"Save"**

Hoặc:

1. Vào **Authentication** → **Settings**
2. Tìm **"Email Confirmations"**
3. ❌ **Disable** nó
4. **Save**

---

### **BƯỚC 3: Test Login**

1. **Hot Restart** app:
   ```bash
   # Trong terminal đang chạy app
   R
   ```

2. **Đăng nhập** với một trong các email đã tạo:
   - Email: (email bạn đã sign up)
   - Password: (password bạn đã dùng)

3. ✅ **Thành công** vào Dashboard!

---

## 🔍 KIỂM TRA USERS HIỆN TẠI:

### Option 1: Trong SQL Editor
```sql
SELECT 
  email,
  email_confirmed_at,
  confirmed_at,
  created_at
FROM auth.users
ORDER BY created_at DESC;
```

### Option 2: Trong Dashboard
1. Vào **Authentication** → **Users**
2. Xem cột **"Last sign in at"**
3. Không còn "Waiting for verification" nữa ✅

---

## 🆘 NẾU VẪN LỖI:

### Lỗi: "Invalid credentials" sau khi confirm
**Nguyên nhân:** Password không đúng hoặc email không tồn tại

**Giải pháp:**
1. **Đăng ký tài khoản MỚI** qua app (Click "Sign Up")
2. Dùng **email Gmail thật**
3. Password đơn giản: `123456`
4. Sau khi đăng ký xong → Tự động login

### Lỗi: "User already exists"
**Giải pháp:**
1. Xóa user cũ trong **Authentication** → **Users**
2. Đăng ký lại

### Lỗi: "Email address is invalid"
**Giải pháp:**
1. Dùng email Gmail thật: `yourname@gmail.com`
2. KHÔNG dùng: `admin@example.com`, `test@test.com`

---

## 📝 CHECKLIST:

- [ ] Chạy SQL confirm users ✅
- [ ] Tắt Email Confirmation ✅
- [ ] Hot Restart app (R) ✅
- [ ] Test đăng nhập ✅
- [ ] Vào Dashboard thành công ✅

---

## 🎯 SAU KHI FIX:

App sẽ:
- ✅ Đăng nhập thành công
- ✅ Thấy Dashboard với metrics
- ✅ Có thể thêm/sửa/xóa products
- ✅ RLS hoạt động (mỗi user thấy products của mình)

---

**LÀM NGAY 3 BƯỚC TRÊN VÀ BÁO KẾT QUẢ!** 🚀

