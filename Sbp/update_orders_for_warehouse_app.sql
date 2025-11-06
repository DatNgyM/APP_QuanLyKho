-- =====================================================
-- UPDATE ORDERS TABLE FOR WAREHOUSE APP
-- Thêm các cột cần thiết cho app quản lý kho
-- =====================================================

-- Bước 1: Thêm cột order_source (phân biệt đơn từ web hay app)
ALTER TABLE public.orders 
ADD COLUMN IF NOT EXISTS order_source text DEFAULT 'web' 
CHECK (order_source IN ('web', 'app'));

-- Bước 2: Thêm cột order_type (phân biệt loại: sale/import/export)
ALTER TABLE public.orders 
ADD COLUMN IF NOT EXISTS order_type text DEFAULT 'sale' 
CHECK (order_type IN ('sale', 'import', 'export'));

-- Bước 3: Thêm cột notes (ghi chú cho phiếu nhập/xuất)
ALTER TABLE public.orders 
ADD COLUMN IF NOT EXISTS notes text;

-- Bước 4: Tạo index để query nhanh hơn
CREATE INDEX IF NOT EXISTS idx_orders_source_type 
ON public.orders(order_source, order_type);

CREATE INDEX IF NOT EXISTS idx_orders_status 
ON public.orders(status);

CREATE INDEX IF NOT EXISTS idx_orders_date 
ON public.orders(order_date DESC);

-- Bước 5: Thêm comment cho các cột mới
COMMENT ON COLUMN public.orders.order_source IS 'Nguồn đơn hàng: web (thương mại điện tử) hoặc app (quản lý kho)';
COMMENT ON COLUMN public.orders.order_type IS 'Loại đơn: sale (bán hàng), import (nhập hàng), export (xuất hàng)';
COMMENT ON COLUMN public.orders.notes IS 'Ghi chú cho phiếu nhập/xuất hàng';

-- =====================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================

-- Bật RLS nếu chưa có
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;

-- Drop policies cũ nếu có (để tránh lỗi duplicate)
DROP POLICY IF EXISTS "Staff can view app orders" ON public.orders;
DROP POLICY IF EXISTS "Staff can create app orders" ON public.orders;
DROP POLICY IF EXISTS "Staff can update app orders" ON public.orders;
DROP POLICY IF EXISTS "Staff can view order items" ON public.order_items;
DROP POLICY IF EXISTS "Staff can create order items" ON public.order_items;

-- Policy 1: Staff đã đăng nhập có thể xem đơn app
CREATE POLICY "Staff can view app orders"
ON public.orders
FOR SELECT
USING (
  order_source = 'app' 
  AND 
  auth.role() = 'authenticated'
);

-- Policy 2: Staff có thể tạo đơn app
CREATE POLICY "Staff can create app orders"
ON public.orders
FOR INSERT
WITH CHECK (
  order_source = 'app'
  AND
  auth.role() = 'authenticated'
);

-- Policy 3: Staff có thể cập nhật đơn app
CREATE POLICY "Staff can update app orders"
ON public.orders
FOR UPDATE
USING (
  order_source = 'app'
  AND
  auth.role() = 'authenticated'
);

-- Policy 4: Cho phép xem order_items
CREATE POLICY "Staff can view order items"
ON public.order_items
FOR SELECT
USING (
  auth.role() = 'authenticated'
);

-- Policy 5: Cho phép insert order_items
CREATE POLICY "Staff can create order items"
ON public.order_items
FOR INSERT
WITH CHECK (
  auth.role() = 'authenticated'
);

-- =====================================================
-- HELPER FUNCTIONS (Optional - Nâng cao)
-- =====================================================

-- Function: Tự động cập nhật tổng số lượng sản phẩm
CREATE OR REPLACE FUNCTION update_order_total_quantity()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE orders
  SET total_amount = (
    SELECT COALESCE(SUM(quantity * unit_price), 0)
    FROM order_items
    WHERE order_id = NEW.order_id
  )
  WHERE id = NEW.order_id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger: Tự động tính tổng khi thêm/sửa/xóa order_items
DROP TRIGGER IF EXISTS trigger_update_order_total ON public.order_items;
CREATE TRIGGER trigger_update_order_total
AFTER INSERT OR UPDATE OR DELETE ON public.order_items
FOR EACH ROW
EXECUTE FUNCTION update_order_total_quantity();

-- =====================================================
-- TEST DATA (Optional - Dữ liệu mẫu để test)
-- =====================================================

-- Tạo đơn nhập hàng mẫu
-- INSERT INTO public.orders (order_source, order_type, user_id, status, total_amount, staff_id, notes)
-- VALUES (
--   'app',
--   'import',
--   NULL,
--   'completed',
--   40000000,
--   'admin-user-id',
--   'Nhập hàng từ ABC Electronics - Tháng 11/2025'
-- );

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Kiểm tra cấu trúc bảng orders
-- SELECT column_name, data_type, column_default, is_nullable
-- FROM information_schema.columns
-- WHERE table_name = 'orders'
-- ORDER BY ordinal_position;

-- Kiểm tra indexes
-- SELECT indexname, indexdef
-- FROM pg_indexes
-- WHERE tablename = 'orders';

-- Kiểm tra policies
-- SELECT policyname, cmd, qual
-- FROM pg_policies
-- WHERE tablename = 'orders';

-- =====================================================
-- DONE! 
-- Chạy file này trong Supabase SQL Editor
-- =====================================================

