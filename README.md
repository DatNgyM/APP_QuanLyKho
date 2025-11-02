<!-- # Quản Lý Kho / Inventory Management App

A modern Flutter inventory management application with bilingual support (English/Vietnamese).

Ứng dụng quản lý kho hàng hiện đại với hỗ trợ song ngữ (Tiếng Anh/Tiếng Việt).

## Features / Tính năng

### 🏠 Dashboard / Bảng điều khiển
- **Key Metrics / Chỉ số chính**: Total products, low stock alerts, out of stock items, total value
- **Quick Actions / Hành động nhanh**: Add products, scan barcode, view reports, export data
- **Recent Activity / Hoạt động gần đây**: Track recent inventory changes

### 📦 Inventory Management / Quản lý kho hàng
- **Product List / Danh sách sản phẩm**: View all products with search and filter options
- **Add Products / Thêm sản phẩm**: Create new products with detailed information
- **Edit Products / Chỉnh sửa sản phẩm**: Update product details
- **Delete Products / Xóa sản phẩm**: Remove products from inventory
- **Stock Tracking / Theo dõi kho**: Monitor quantity levels and low stock alerts

### 📊 Reports / Báo cáo
- **Summary Statistics / Thống kê tổng quan**: Overview of inventory metrics
- **Low Stock Reports / Báo cáo hàng sắp hết**: Identify products needing restocking
- **Export Options / Tùy chọn xuất dữ liệu**: Export data to CSV or PDF formats

### ⚙️ Settings / Cài đặt
- **Language Toggle / Chuyển đổi ngôn ngữ**: Switch between English and Vietnamese
- **Theme Selection / Chọn giao diện**: Light, Dark, or System theme
- **User Profile / Hồ sơ người dùng**: Manage user information
- **App Information / Thông tin ứng dụng**: Version details and help

## Screenshots / Hình ảnh

### Login Screen / Màn hình đăng nhập
- Modern login interface with language toggle
- Demo credentials provided for testing
- Responsive design with smooth animations

### Dashboard / Bảng điều khiển
- Key metrics cards with trend indicators
- Quick action buttons for common tasks
- Recent activity feed

### Inventory / Kho hàng
- Product grid/list view with search and filters
- Category-based filtering
- Sort by name, price, quantity, date
- Product cards with stock status indicators

## Getting Started / Bắt đầu

### ⚡ Quick Start (2 minutes)

1. **Install & Run**
   ```bash
   flutter pub get
   flutter run
   ```

2. **Sign Up** trong app
   - Email: test@example.com
   - Password: 123456

3. **Done!** 🎉

📖 **Chi tiết:** Xem `QUICK_START.md`

---

### 📦 Add Mockup Data (10 products) - 2 CÁCH

#### ⚡ **CÁCH 1: Tự động trong Flutter** (Recommended - KHÔNG CẦN SQL!)

App sẽ **TỰ ĐỘNG** tạo 10 products + 8 activities khi:
- Database rỗng (lần đầu login)
- Hoặc click nút "Load Mockup" trong Dashboard

**Không cần làm gì!** Chỉ cần Login → Tự động có data! 🎉

📖 **Chi tiết:** Xem `MOCKUP_FLUTTER_GUIDE.md`

---

#### 🗄️ **CÁCH 2: Chạy SQL** (Nếu muốn)

1. **Get User ID:**
   - [Supabase Dashboard](https://app.supabase.com) → Authentication → Users → Copy UUID

2. **Run SQL:**
   - Mở `supabase_seed_data.sql`
   - Replace `YOUR_USER_ID` → (UUID của bạn)
   - Supabase → SQL Editor → Paste → Run

3. **Restart app**

📖 **Chi tiết:** Xem `HUONG_DAN_TAO_DU_LIEU_MAU.md`

---

### Prerequisites / Yêu cầu hệ thống
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code
- Android device or emulator / iOS simulator
- ✅ **Supabase account** (Free tier OK)

## Project Structure / Cấu trúc dự án

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   └── product.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── inventory_provider.dart
│   ├── language_provider.dart
│   └── theme_provider.dart
├── screens/                  # UI screens
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── main_screen.dart
│   ├── dashboard_screen.dart
│   ├── inventory_screen.dart
│   ├── add_product_screen.dart
│   ├── reports_screen.dart
│   └── settings_screen.dart
├── utils/                    # Utilities
│   ├── app_localizations.dart
│   └── app_theme.dart
└── widgets/                  # Reusable widgets
    ├── metric_card.dart
    ├── product_card.dart
    ├── quick_action_button.dart
    ├── recent_activity_card.dart
    ├── recent_activity_item.dart
    └── search_filter_bar.dart
```

## Technologies Used / Công nghệ sử dụng

- **Flutter**: Cross-platform mobile development
- **Provider**: State management
- **Supabase**: Backend as a Service (Auth + Database + Real-time)
- **Google Fonts**: Typography
- **Flutter Animate**: Smooth animations
- **Shared Preferences**: Local storage
- **Intl**: Internationalization support
- **PDF/CSV Export**: Reports generation

## Features in Detail / Chi tiết tính năng

### Bilingual Support / Hỗ trợ song ngữ
- Complete English and Vietnamese translations
- Dynamic language switching
- Localized date and number formats
- RTL support ready

### Modern UI Design / Thiết kế giao diện hiện đại
- Material Design 3 principles
- Custom color scheme with green primary colors
- Smooth animations and transitions
- Responsive layout for different screen sizes
- Dark and light theme support

### State Management / Quản lý trạng thái
- Provider pattern for state management
- Separate providers for different concerns
- Persistent storage for user preferences
- Real-time UI updates

### Data Management / Quản lý dữ liệu
- In-memory data storage (can be extended to use databases)
- Product CRUD operations
- Search and filtering capabilities
- Category-based organization

## 📚 Documentation

### Quick Start:
- **`QUICK_START.md`** - Start using app in 2 minutes ⚡
- **`MOCKUP_FLUTTER_GUIDE.md`** - Auto mockup data (NO SQL needed!) 🎨

### Detailed Guides:
- **`HUONG_DAN_TAO_DU_LIEU_MAU.md`** - Detailed setup guide (Vietnamese)
- **`SETUP_DASHBOARD.md`** - Dashboard setup summary
- **`DASHBOARD_COMPLETE.md`** - Dashboard completion report
- **`MOCKUP_COMPLETE.md`** - Mockup system completion report

### SQL Scripts:
- **`supabase_seed_data.sql`** - Sample data (10 products)
- **`supabase_full_schema_seed.sql`** - Full schema với 20 products

### Configuration:
- **`SUPABASE_SETUP.md`** - Supabase configuration guide

---

## ✨ Completed Features

- [x] **Supabase integration** (Auth + Database + Real-time)
- [x] **User authentication** (Sign up, Login, Logout)
- [x] **Product management** (CRUD operations)
- [x] **Image upload** for products
- [x] **Search, Filter, Sort** functionality
- [x] **Dashboard** with metrics and activities
- [x] **Reports & Analytics** with charts
- [x] **Export to PDF/CSV**
- [x] **Bilingual support** (Vietnamese/English)
- [x] **Dark/Light theme**
- [x] **Row Level Security** (RLS)
- [x] **Real-time data sync**
- [x] **Developer tools** (Test connection)

## Future Enhancements / Cải tiến tương lai

- [ ] Barcode scanning functionality
- [ ] Advanced charts & analytics
- [ ] Push notifications
- [ ] Offline support with local cache
- [ ] Bulk import/export
- [ ] Multi-warehouse support
- [ ] Role-based access control

## Contributing / Đóng góp

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License / Giấy phép

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact / Liên hệ

For questions or support, please contact [your-email@example.com]

---

<!-- **Note / Lưu ý**: This is a demo application for learning purposes. For production use, additional security measures and backend integration would be required.

**Ghi chú**: Đây là ứng dụng demo cho mục đích học tập. Để sử dụng trong sản xuất, cần thêm các biện pháp bảo mật và tích hợp backend. -->
 -->
