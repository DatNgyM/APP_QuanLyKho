-- ==========================================
-- TEST: THÊM CATEGORIES & BRANDS MỚI
-- ==========================================
-- File này giúp test xem app có đồng bộ được không
-- Sau khi chạy SQL này, restart app và kiểm tra dropdown

-- ==========================================
-- 1. THÊM CATEGORIES MỚI
-- ==========================================

-- Thêm category "Máy ảnh"
INSERT INTO "public"."categories" ("name", "slug", "description") 
VALUES ('Máy ảnh', 'may-anh', 'Máy ảnh kỹ thuật số, DSLR, Mirrorless')
ON CONFLICT DO NOTHING;

-- Thêm category "Phụ kiện điện thoại"
INSERT INTO "public"."categories" ("name", "slug", "description") 
VALUES ('Phụ kiện điện thoại', 'phu-kien-dien-thoai', 'Ốp lưng, cáp sạc, tai nghe')
ON CONFLICT DO NOTHING;

-- Thêm category "Loa"
INSERT INTO "public"."categories" ("name", "slug", "description") 
VALUES ('Loa', 'loa', 'Loa Bluetooth, loa karaoke, loa di động')
ON CONFLICT DO NOTHING;

-- ==========================================
-- 2. THÊM BRANDS MỚI
-- ==========================================

-- Thêm brand "Canon"
INSERT INTO "public"."brands" ("name", "slug", "logo", "description") 
VALUES ('Canon', 'canon', NULL, 'Canon Inc. - Hãng máy ảnh hàng đầu')
ON CONFLICT DO NOTHING;

-- Thêm brand "Sony"
INSERT INTO "public"."brands" ("name", "slug", "logo", "description") 
VALUES ('Sony', 'sony', NULL, 'Sony Corporation - Electronics')
ON CONFLICT DO NOTHING;

-- Thêm brand "JBL"
INSERT INTO "public"."brands" ("name", "slug", "logo", "description") 
VALUES ('JBL', 'jbl', NULL, 'JBL - Loa và thiết bị âm thanh')
ON CONFLICT DO NOTHING;

-- ==========================================
-- 3. KIỂM TRA KẾT QUẢ
-- ==========================================

-- Xem tất cả categories
SELECT * FROM "public"."categories" ORDER BY id;

-- Xem tất cả brands
SELECT * FROM "public"."brands" ORDER BY id;

-- ==========================================
-- 4. TEST TRÊN APP
-- ==========================================
-- Sau khi chạy SQL này:
-- 
-- 1. Restart app (hot restart: R)
-- 2. Mở Add Product screen
-- 3. Xem dropdown Category → Phải có:
--    - Máy ảnh
--    - Phụ kiện điện thoại
--    - Loa
-- 4. Xem dropdown Brand → Phải có:
--    - Canon
--    - Sony
--    - JBL
-- 5. Thử thêm sản phẩm với category/brand mới
-- 6. Kiểm tra trong Supabase xem category_id và brand_id có đúng không
-- ==========================================

-- ==========================================
-- 5. XÓA TEST DATA (NẾU CẦN)
-- ==========================================
-- Uncomment để xóa test data:

-- DELETE FROM "public"."categories" WHERE name IN ('Máy ảnh', 'Phụ kiện điện thoại', 'Loa');
-- DELETE FROM "public"."brands" WHERE name IN ('Canon', 'Sony', 'JBL');

-- ==========================================
-- 6. QUERY HỮU ÍCH
-- ==========================================

-- Xem products với category và brand names:
-- SELECT 
--   p.id,
--   p.name,
--   c.name as category_name,
--   b.name as brand_name,
--   p.price,
--   p.quantity
-- FROM products p
-- LEFT JOIN categories c ON p.category_id = c.id
-- LEFT JOIN brands b ON p.brand_id = b.id
-- ORDER BY p.created_at DESC
-- LIMIT 10;

