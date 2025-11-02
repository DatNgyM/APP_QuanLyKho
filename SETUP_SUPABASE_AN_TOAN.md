# 🔐 SETUP SUPABASE AN TOÀN - BẢO MẬT CREDENTIALS

## ✅ ĐÃ BẢO MẬT XONG!

Thông tin Supabase giờ **KHÔNG BỊ LỘ** khi push lên Git!

---

## 📁 Cấu trúc files:

```
lib/config/
  ├── supabase_env.dart          ← ⚠️ KHÔNG PUSH (đã add vào .gitignore)
  └── supabase_env.example.dart  ← ✅ PUSH được (template)

.gitignore
  ├── lib/config/supabase_env.dart  ← Đã thêm
  └── *.env                         ← Đã thêm
```

---

## 🔐 Cách hoạt động:

### 1. **File thật (supabase_env.dart):**
```dart
class SupabaseEnv {
  static const String supabaseUrl = 'https://tnctyxsglejxdkqdkedd.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOi...'; // ← THẬT
}
```
**→ KHÔNG PUSH LÊN GIT!** ⚠️

### 2. **File mẫu (supabase_env.example.dart):**
```dart
class SupabaseEnv {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
}
```
**→ PUSH LÊN GIT OK!** ✅

---

## 👥 Khi người khác clone project:

### Bước 1: Clone
```bash
git clone your-repo.git
cd your-project
```

### Bước 2: Copy template
```bash
# Trong lib/config/
copy supabase_env.example.dart supabase_env.dart
# Hoặc Windows:
copy lib\config\supabase_env.example.dart lib\config\supabase_env.dart
```

### Bước 3: Điền thông tin
```dart
// Mở supabase_env.dart
// Thay:
'YOUR_SUPABASE_URL' → 'https://xxxxx.supabase.co'
'YOUR_SUPABASE_ANON_KEY' → 'eyJhbGci...'
```

### Bước 4: Run
```bash
flutter run
```

---

## ✅ Kiểm tra đã an toàn chưa:

### Test Git:
```bash
git status
```

**PHẢI THẤY:**
```
✅ supabase_env.example.dart (tracked)
❌ supabase_env.dart (ignored - không hiển thị)
```

### Nếu thấy supabase_env.dart:
```bash
# Xóa khỏi Git (nếu đã commit trước đó)
git rm --cached lib/config/supabase_env.dart
git commit -m "Remove sensitive credentials"
```

---

## 📊 So sánh:

### TRƯỚC (KHÔNG AN TOÀN):
```dart
// main.dart - PUSH LÊN GIT
await Supabase.initialize(
  url: 'https://tnctyxsglejxdkqdkedd.supabase.co', // ❌ LỘ!
  anonKey: 'eyJhbGci...', // ❌ LỘ!
);
```

### SAU (AN TOÀN):
```dart
// main.dart - PUSH LÊN GIT
await Supabase.initialize(
  url: SupabaseEnv.supabaseUrl, // ✅ AN TOÀN!
  anonKey: SupabaseEnv.supabaseAnonKey, // ✅ AN TOÀN!
);

// supabase_env.dart - KHÔNG PUSH
// → Credentials ở file này (ignored)
```

---

## 🎯 Best Practices:

### ✅ LÀM:
- Dùng file riêng cho credentials
- Add vào .gitignore
- Tạo file .example làm template
- Document trong README

### ❌ KHÔNG LÀM:
- Hardcode credentials trong code
- Commit credentials lên Git
- Share credentials qua chat/email
- Dùng credentials trong comments

---

## 🔄 Nếu đã push credentials lên Git:

### ⚠️ QUAN TRỌNG:

```bash
# 1. Đổi credentials trong Supabase Dashboard
Supabase → Settings → API → Reset anon key

# 2. Xóa khỏi Git history
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch lib/main.dart" \
  --prune-empty --tag-name-filter cat -- --all

# 3. Force push (NGUY HIỂM!)
git push origin --force --all

# Hoặc đơn giản: Tạo project Supabase mới!
```

---

## 📖 Hướng dẫn cho Team:

### File README.md thêm:

```markdown
## Setup Credentials

1. Copy file template:
   ```bash
   cp lib/config/supabase_env.example.dart lib/config/supabase_env.dart
   ```

2. Điền thông tin Supabase của bạn vào `lib/config/supabase_env.dart`

3. KHÔNG commit file `supabase_env.dart`!
```

---

## 🎉 Kết quả:

✅ **Credentials an toàn**  
✅ **Không lộ khi push Git**  
✅ **Dễ setup cho người khác**  
✅ **Professional workflow**

---

**Status:** ✅ SECURE!  
**Files:** Đã tạo xong  
**Git:** Đã ignore  
**Ready:** Có thể push lên Git an toàn!

🔐 **Giờ push lên Git không lo lộ credentials nữa!** 🔐

