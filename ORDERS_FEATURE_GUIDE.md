# 📦 HƯỚNG DẪN TÍNH NĂNG QUẢN LÝ ĐƠN HÀNG

## ✅ ĐÃ HOÀN THÀNH

Tính năng **Quản lý Đơn hàng** đã được triển khai đầy đủ vào app!

---

## 🎯 TỔNG QUAN

### Các file đã tạo/sửa:

#### **1. Supabase (Database)**
- ✅ `Sbp/update_orders_for_warehouse_app.sql` - Script SQL để update bảng orders

#### **2. Models (4 files)**
- ✅ `lib/models/order_status.dart` - Enum trạng thái đơn hàng
- ✅ `lib/models/order_type.dart` - Enum loại đơn (nhập/xuất)
- ✅ `lib/models/order_item.dart` - Model chi tiết sản phẩm trong đơn
- ✅ `lib/models/order.dart` - Model đơn hàng

#### **3. Services**
- ✅ `lib/services/supabase_service.dart` - Thêm 8 methods mới cho orders

#### **4. Provider**
- ✅ `lib/providers/order_provider.dart` - State management cho orders

#### **5. Widgets (4 files)**
- ✅ `lib/widgets/order_status_badge.dart` - Badge hiển thị trạng thái
- ✅ `lib/widgets/order_summary_card.dart` - Card thống kê
- ✅ `lib/widgets/order_item_row.dart` - Row hiển thị sản phẩm trong đơn
- ✅ `lib/widgets/order_card.dart` - Card hiển thị đơn hàng trong list

#### **6. Screens (3 files)**
- ✅ `lib/screens/orders_screen.dart` - Màn hình danh sách đơn hàng
- ✅ `lib/screens/order_detail_screen.dart` - Màn hình chi tiết đơn
- ✅ `lib/screens/create_order_screen.dart` - Màn hình tạo đơn mới

#### **7. Navigation**
- ✅ `lib/main.dart` - Thêm OrderProvider vào MultiProvider
- ✅ `lib/screens/main_screen.dart` - Thêm OrdersScreen vào BottomNavigationBar (tab thứ 3)

#### **8. Localization**
- ✅ `lib/l10n/app_vi.arb` - Thêm 38 strings tiếng Việt
- ✅ `lib/l10n/app_en.arb` - Thêm 38 strings tiếng Anh

---

## 🚀 HƯỚNG DẪN SỬ DỤNG

### **BƯỚC 1: Cập nhật Supabase Database**

1. Mở **Supabase Dashboard**
2. Vào **SQL Editor**
3. Copy toàn bộ nội dung file `Sbp/update_orders_for_warehouse_app.sql`
4. Paste vào editor và nhấn **RUN**

Script này sẽ:
- Thêm 3 cột mới vào bảng `orders`: `order_source`, `order_type`, `notes`
- Tạo indexes để query nhanh
- Setup Row Level Security (RLS) policies
- Tạo functions/triggers tự động (optional)

### **BƯỚC 2: Chạy app**

```bash
# Trong thư mục project
flutter pub get
flutter run
```

### **BƯỚC 3: Sử dụng tính năng**

App sẽ có 5 tabs trong BottomNavigationBar:
1. Dashboard (Bảng điều khiển)
2. Inventory (Kho hàng)
3. **Orders (Đơn hàng)** ← MỚI
4. Reports (Báo cáo)
5. Settings (Cài đặt)

---

## 📱 CHỨC NĂNG CỦA TRANG ORDERS

### **1. Màn hình Danh sách Đơn hàng**

**Có gì?**
- 3 Summary Cards: Tổng đơn / Chờ xử lý / Hoàn thành
- 3 Tabs: Tất cả / Nhập hàng / Xuất hàng
- Filter chips theo trạng thái: Tất cả / Chờ xác nhận / Đang xử lý / Hoàn thành / Đã hủy
- Danh sách đơn hàng với OrderCard
- FAB "Tạo đơn mới"
- Search, Refresh, Pull to refresh

**Thao tác:**
- Tap vào đơn → Xem chi tiết
- Tap icon ⋮ → Cập nhật trạng thái / Hủy đơn
- Swipe down → Refresh
- Tap Search → Tìm kiếm theo ID, tên đối tác
- Tap FAB → Tạo đơn mới

### **2. Màn hình Tạo đơn mới**

**Có gì?**
- Radio button chọn loại: Nhập hàng / Xuất hàng
- Form thông tin đối tác (Tên, SĐT, Địa chỉ)
- Danh sách sản phẩm với nút "Thêm sản phẩm"
- Nhập số lượng cho từng sản phẩm
- Tổng số lượng và tổng tiền tự động
- Ghi chú (optional)
- Nút Lưu

**Thao tác:**
1. Chọn loại đơn (Nhập/Xuất)
2. Nhập thông tin đối tác
3. Tap "Thêm sản phẩm" → Chọn từ danh sách
4. Nhập số lượng
5. Tap "Lưu"

### **3. Màn hình Chi tiết đơn hàng**

**Có gì?**
- Status Timeline (visual)
- Thông tin chung (ID, loại, trạng thái, ngày tạo)
- Thông tin đối tác
- Danh sách sản phẩm
- Tổng số lượng và tổng tiền
- Ghi chú
- Nút "Cập nhật trạng thái" và "Hủy đơn"

**Thao tác:**
- Tap "Cập nhật trạng thái" → Dialog chọn trạng thái mới
- Tap "Hủy đơn" → Confirmation dialog → Hủy

---

## 🗂️ CẤU TRÚC DỮ LIỆU

### **Bảng `orders` (đã update)**

```sql
orders
├── id (int)
├── order_source (text) → 'web' hoặc 'app' [MỚI]
├── order_type (text) → 'sale', 'import', 'export' [MỚI]
├── user_id (text, nullable)
├── order_date (timestamp)
├── status (text) → 'pending', 'processing', 'completed', 'cancelled'
├── total_amount (numeric)
├── staff_id (text)
├── notes (text) [MỚI]
└── ... (các trường khác của web)
```

### **Query mẫu**

```sql
-- Lấy tất cả đơn app
SELECT * FROM orders 
WHERE order_source = 'app'
ORDER BY order_date DESC;

-- Lấy đơn nhập hàng
SELECT * FROM orders 
WHERE order_source = 'app' 
  AND order_type = 'import';

-- Lấy đơn xuất hàng đang chờ
SELECT * FROM orders 
WHERE order_source = 'app' 
  AND order_type = 'export'
  AND status = 'pending';
```

---

## 🎨 UI/UX HIGHLIGHTS

### **Design Pattern**
- Giống với ProductCard (elevation 2, borderRadius 12)
- Màu sắc nhất quán theo app theme
- Icons rõ ràng cho mỗi loại đơn (⬇️ nhập, ⬆️ xuất)
- Status badges với màu theo trạng thái

### **Colors**
- **Import (Nhập):** Green
- **Export (Xuất):** Orange
- **Pending:** Amber
- **Processing:** Blue
- **Completed:** Green
- **Cancelled:** Red

### **Animations**
- FadeIn + SlideY cho cards
- Delay stagger cho list items
- Smooth transitions

---

## 🔧 TROUBLESHOOTING

### **Lỗi: Cannot find table 'orders'**
→ Chạy lại SQL script trong Supabase

### **Lỗi: User not authenticated**
→ Đăng nhập lại vào app

### **Lỗi: RLS policy violation**
→ Kiểm tra policies trong Supabase, đảm bảo authenticated users có quyền

### **Không thấy tab Orders**
→ Hot restart app (`r` trong terminal hoặc restart app)

### **Localization không hoạt động**
→ Chạy `flutter pub get` và restart app

---

## 📊 METRICS & STATISTICS

OrderProvider cung cấp các metrics:
- `totalOrders` - Tổng số đơn
- `importOrdersCount` - Số đơn nhập
- `exportOrdersCount` - Số đơn xuất
- `pendingOrdersCount` - Số đơn chờ
- `processingOrdersCount` - Số đơn đang xử lý
- `completedOrdersCount` - Số đơn hoàn thành
- `cancelledOrdersCount` - Số đơn đã hủy
- `totalImportAmount` - Tổng giá trị nhập
- `totalExportAmount` - Tổng giá trị xuất

---

## 🎯 NEXT STEPS (Tùy chọn)

Các tính năng có thể thêm sau:
- [ ] Export orders to PDF
- [ ] Barcode scanning cho sản phẩm
- [ ] Realtime sync (Supabase Realtime)
- [ ] Push notifications khi có đơn mới
- [ ] Dashboard charts cho orders
- [ ] Filter theo ngày tháng
- [ ] Tự động cập nhật kho khi hoàn thành đơn

---

## ✅ CHECKLIST HOÀN THÀNH

- [x] Tạo file SQL
- [x] Tạo Models (4 files)
- [x] Update Services (8 methods)
- [x] Tạo Provider
- [x] Tạo Widgets (4 files)
- [x] Tạo Screens (3 files)
- [x] Update Navigation
- [x] Thêm Localization
- [x] Fix linter errors
- [x] Test compile

---

## 🙏 LƯU Ý

1. **Database:** Nhớ chạy SQL script trước khi test
2. **Authentication:** Cần đăng nhập mới thấy orders
3. **RLS:** Policies đã được setup, chỉ authenticated users mới truy cập được
4. **Web vs App:** Đơn từ web (order_source='web') sẽ KHÔNG hiển thị trong app
5. **Localization:** Support cả tiếng Việt và tiếng Anh

---

**Chúc bạn code vui vẻ! 🚀**

Nếu có vấn đề, hãy check:
1. Supabase connection
2. SQL script đã chạy chưa
3. Linter errors
4. Hot restart app

