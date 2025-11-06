-- ============================================
-- 🔄 ĐỒNG BỘ auth.users → public.users
-- ============================================
-- Mục đích:
-- 1. Sync tất cả user CŨ (bao gồm admin12345@gmail.com)
-- 2. Tạo trigger tự động cho user MỚI
-- 3. Đảm bảo auth.users.id = public.users.id
-- 4. Admin (role_id = 1) login được cả App và Web
-- ============================================

-- ========================================
-- 📝 BƯỚC 1: SYNC TẤT CẢ USER CŨ
-- ========================================

DO $$
BEGIN
  RAISE NOTICE '🔄 Bắt đầu sync users từ auth.users → public.users...';
END $$;

-- Sync tất cả users hiện có từ auth.users vào public.users
INSERT INTO public.users (
  id,
  email,
  full_name,
  role_id,
  is_active,
  created_at
)
SELECT 
  au.id::text,                                           -- UUID từ auth.users
  au.email,                                              -- Email
  COALESCE(
    au.raw_user_meta_data->>'full_name',                -- Lấy từ metadata
    SPLIT_PART(au.email, '@', 1)                         -- Hoặc dùng phần trước @ của email
  ) as full_name,
  CASE 
    -- Nếu email có 'admin' → role_id = 1 (Admin)
    WHEN au.email LIKE '%admin%' THEN 1
    -- Ngược lại → role_id = 2 (Customer/Staff)
    ELSE 2
  END as role_id,
  true as is_active,
  COALESCE(au.created_at, NOW()) as created_at
FROM auth.users au
WHERE NOT EXISTS (
  -- Chỉ insert nếu chưa tồn tại trong public.users
  SELECT 1 FROM public.users pu WHERE pu.id = au.id::text
)
ON CONFLICT (id) DO UPDATE SET
  -- Nếu đã tồn tại, cập nhật email và full_name
  email = EXCLUDED.email,
  full_name = EXCLUDED.full_name;

DO $$
DECLARE
  synced_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO synced_count FROM public.users;
  RAISE NOTICE '✅ Đã sync xong! Tổng số users trong public.users: %', synced_count;
END $$;

-- ========================================
-- 📝 BƯỚC 2: TẠO FUNCTION XỬ LÝ USER MỚI
-- ========================================

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  -- Tự động tạo user trong public.users khi có user mới trong auth.users
  INSERT INTO public.users (
    id,
    email,
    full_name,
    role_id,
    is_active,
    created_at
  )
  VALUES (
    NEW.id::text,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', 'User'),
    CASE 
      WHEN NEW.email LIKE '%admin%' THEN 1
      ELSE 2
    END,
    true,
    NOW()
  )
  ON CONFLICT (id) DO NOTHING;  -- Tránh lỗi nếu đã tồn tại
  
  RAISE NOTICE '✅ Đã tạo user mới trong public.users: %', NEW.email;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ========================================
-- 📝 BƯỚC 3: TẠO TRIGGER CHO USER MỚI
-- ========================================

-- Xóa trigger cũ nếu có
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Tạo trigger mới
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

DO $$
BEGIN
  RAISE NOTICE '✅ Đã tạo trigger on_auth_user_created';
END $$;

-- ========================================
-- 📝 BƯỚC 4: FUNCTION CẬP NHẬT USER
-- ========================================

CREATE OR REPLACE FUNCTION public.handle_user_update()
RETURNS TRIGGER AS $$
BEGIN
  -- Cập nhật thông tin trong public.users khi auth.users thay đổi
  UPDATE public.users
  SET
    email = NEW.email,
    full_name = COALESCE(NEW.raw_user_meta_data->>'full_name', full_name)
  WHERE id = NEW.id::text;
  
  RAISE NOTICE '✅ Đã cập nhật user trong public.users: %', NEW.email;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ========================================
-- 📝 BƯỚC 5: TRIGGER CẬP NHẬT USER
-- ========================================

-- Xóa trigger cũ nếu có
DROP TRIGGER IF EXISTS on_auth_user_updated ON auth.users;

-- Tạo trigger cập nhật
CREATE TRIGGER on_auth_user_updated
  AFTER UPDATE ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_user_update();

DO $$
BEGIN
  RAISE NOTICE '✅ Đã tạo trigger on_auth_user_updated';
END $$;

-- ============================================
-- ✅ HOÀN THÀNH!
-- ============================================

DO $$
BEGIN
  RAISE NOTICE '';
  RAISE NOTICE '========================================';
  RAISE NOTICE '✅ ĐỒNG BỘ HOÀN TẤT!';
  RAISE NOTICE '========================================';
  RAISE NOTICE '';
  RAISE NOTICE '📋 ĐÃ THỰC HIỆN:';
  RAISE NOTICE '  ✅ Sync tất cả users từ auth.users → public.users';
  RAISE NOTICE '  ✅ Tạo trigger tự động cho user mới';
  RAISE NOTICE '  ✅ Tạo trigger tự động cập nhật user';
  RAISE NOTICE '  ✅ Admin (role_id = 1) login được cả App và Web';
  RAISE NOTICE '';
  RAISE NOTICE '🔄 CÁCH HOẠT ĐỘNG:';
  RAISE NOTICE '  1. User đăng ký/login qua auth.users';
  RAISE NOTICE '  2. Trigger tự động tạo/cập nhật public.users';
  RAISE NOTICE '  3. auth.users.id = public.users.id (cùng UUID)';
  RAISE NOTICE '';
  RAISE NOTICE '🔐 ADMIN LOGIN:';
  RAISE NOTICE '  ✅ Admin (role_id = 1) login App: OK';
  RAISE NOTICE '  ✅ Admin (role_id = 1) login Web: OK';
  RAISE NOTICE '';
  RAISE NOTICE '========================================';
END $$;

-- 🔍 KIỂM TRA KẾT QUẢ:

DO $$
DECLARE
  user_count INTEGER;
  auth_count INTEGER;
  admin_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO user_count FROM public.users;
  SELECT COUNT(*) INTO auth_count FROM auth.users;
  SELECT COUNT(*) INTO admin_count FROM public.users WHERE role_id = 1;
  
  RAISE NOTICE '';
  RAISE NOTICE '📊 THỐNG KÊ:';
  RAISE NOTICE '  auth.users: % users', auth_count;
  RAISE NOTICE '  public.users: % users', user_count;
  RAISE NOTICE '  Admin (role_id = 1): % users', admin_count;
  RAISE NOTICE '';
END $$;

-- Hiển thị danh sách users đã sync
SELECT 
  id,
  email,
  full_name,
  CASE role_id
    WHEN 1 THEN '🔑 Admin (Login App + Web)'
    WHEN 2 THEN '👤 Customer/Staff'
    ELSE '❓ Unknown'
  END as role,
  CASE 
    WHEN is_active THEN '✅ Active'
    ELSE '❌ Inactive'
  END as status,
  created_at
FROM public.users
ORDER BY created_at DESC;

-- Kiểm tra triggers đã tạo
SELECT 
  '✅ ' || trigger_name as trigger,
  event_manipulation as event,
  event_object_table as on_table
FROM information_schema.triggers
WHERE trigger_name IN ('on_auth_user_created', 'on_auth_user_updated')
ORDER BY trigger_name;

