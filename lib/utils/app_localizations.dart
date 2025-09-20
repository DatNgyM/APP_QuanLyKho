import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('vi', 'VN'),
  ];

  // English translations
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Inventory Management',
      'welcome': 'Welcome',
      'login': 'Login',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'forgotPassword': 'Forgot Password?',
      'rememberMe': 'Remember Me',
      'dashboard': 'Dashboard',
      'inventory': 'Inventory',
      'products': 'Products',
      'addProduct': 'Add Product',
      'editProduct': 'Edit Product',
      'deleteProduct': 'Delete Product',
      'productName': 'Product Name',
      'productCode': 'Product Code',
      'category': 'Category',
      'quantity': 'Quantity',
      'price': 'Price',
      'description': 'Description',
      'save': 'Save',
      'cancel': 'Cancel',
      'search': 'Search',
      'filter': 'Filter',
      'sort': 'Sort',
      'totalProducts': 'Total Products',
      'lowStock': 'Low Stock',
      'outOfStock': 'Out of Stock',
      'recentActivity': 'Recent Activity',
      'settings': 'Settings',
      'profile': 'Profile',
      'language': 'Language',
      'theme': 'Theme',
      'lightTheme': 'Light',
      'darkTheme': 'Dark',
      'systemTheme': 'System',
      'notifications': 'Notifications',
      'help': 'Help',
      'about': 'About',
      'version': 'Version',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'confirm': 'Confirm',
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',
      'retry': 'Retry',
      'noData': 'No data available',
      'noInternet': 'No internet connection',
      'serverError': 'Server error occurred',
      'invalidCredentials': 'Invalid email or password',
      'productAdded': 'Product added successfully',
      'productUpdated': 'Product updated successfully',
      'productDeleted': 'Product deleted successfully',
      'areYouSure': 'Are you sure?',
      'deleteConfirmation': 'This action cannot be undone',
      'selectImage': 'Select Image',
      'camera': 'Camera',
      'gallery': 'Gallery',
      'removeImage': 'Remove Image',
      'selectCategory': 'Select Category',
      'electronics': 'Electronics',
      'clothing': 'Clothing',
      'books': 'Books',
      'food': 'Food',
      'other': 'Other',
      'quantityInStock': 'Quantity in Stock',
      'minimumQuantity': 'Minimum Quantity',
      'supplier': 'Supplier',
      'dateAdded': 'Date Added',
      'lastUpdated': 'Last Updated',
      'actions': 'Actions',
      'edit': 'Edit',
      'delete': 'Delete',
      'view': 'View',
      'addToCart': 'Add to Cart',
      'updateStock': 'Update Stock',
      'stockHistory': 'Stock History',
      'reports': 'Reports',
      'export': 'Export',
      'import': 'Import',
      'backup': 'Backup',
      'restore': 'Restore',
    },
    'vi': {
      'appTitle': 'Quản Lý Kho',
      'welcome': 'Chào mừng',
      'login': 'Đăng nhập',
      'logout': 'Đăng xuất',
      'email': 'Email',
      'password': 'Mật khẩu',
      'forgotPassword': 'Quên mật khẩu?',
      'rememberMe': 'Ghi nhớ đăng nhập',
      'dashboard': 'Bảng điều khiển',
      'inventory': 'Kho hàng',
      'products': 'Sản phẩm',
      'addProduct': 'Thêm sản phẩm',
      'editProduct': 'Chỉnh sửa sản phẩm',
      'deleteProduct': 'Xóa sản phẩm',
      'productName': 'Tên sản phẩm',
      'productCode': 'Mã sản phẩm',
      'category': 'Danh mục',
      'quantity': 'Số lượng',
      'price': 'Giá',
      'description': 'Mô tả',
      'save': 'Lưu',
      'cancel': 'Hủy',
      'search': 'Tìm kiếm',
      'filter': 'Lọc',
      'sort': 'Sắp xếp',
      'totalProducts': 'Tổng sản phẩm',
      'lowStock': 'Hàng sắp hết',
      'outOfStock': 'Hết hàng',
      'recentActivity': 'Hoạt động gần đây',
      'settings': 'Cài đặt',
      'profile': 'Hồ sơ',
      'language': 'Ngôn ngữ',
      'theme': 'Giao diện',
      'lightTheme': 'Sáng',
      'darkTheme': 'Tối',
      'systemTheme': 'Hệ thống',
      'notifications': 'Thông báo',
      'help': 'Trợ giúp',
      'about': 'Giới thiệu',
      'version': 'Phiên bản',
      'loading': 'Đang tải...',
      'error': 'Lỗi',
      'success': 'Thành công',
      'confirm': 'Xác nhận',
      'yes': 'Có',
      'no': 'Không',
      'ok': 'OK',
      'retry': 'Thử lại',
      'noData': 'Không có dữ liệu',
      'noInternet': 'Không có kết nối internet',
      'serverError': 'Lỗi máy chủ',
      'invalidCredentials': 'Email hoặc mật khẩu không đúng',
      'productAdded': 'Thêm sản phẩm thành công',
      'productUpdated': 'Cập nhật sản phẩm thành công',
      'productDeleted': 'Xóa sản phẩm thành công',
      'areYouSure': 'Bạn có chắc chắn?',
      'deleteConfirmation': 'Hành động này không thể hoàn tác',
      'selectImage': 'Chọn hình ảnh',
      'camera': 'Máy ảnh',
      'gallery': 'Thư viện',
      'removeImage': 'Xóa hình ảnh',
      'selectCategory': 'Chọn danh mục',
      'electronics': 'Điện tử',
      'clothing': 'Quần áo',
      'books': 'Sách',
      'food': 'Thực phẩm',
      'other': 'Khác',
      'quantityInStock': 'Số lượng trong kho',
      'minimumQuantity': 'Số lượng tối thiểu',
      'supplier': 'Nhà cung cấp',
      'dateAdded': 'Ngày thêm',
      'lastUpdated': 'Cập nhật cuối',
      'actions': 'Hành động',
      'edit': 'Sửa',
      'delete': 'Xóa',
      'view': 'Xem',
      'addToCart': 'Thêm vào giỏ',
      'updateStock': 'Cập nhật kho',
      'stockHistory': 'Lịch sử kho',
      'reports': 'Báo cáo',
      'export': 'Xuất',
      'import': 'Nhập',
      'backup': 'Sao lưu',
      'restore': 'Khôi phục',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]![key] ?? key;
  }

  // Convenience getters
  String get appTitle => translate('appTitle');
  String get welcome => translate('welcome');
  String get login => translate('login');
  String get logout => translate('logout');
  String get email => translate('email');
  String get password => translate('password');
  String get forgotPassword => translate('forgotPassword');
  String get rememberMe => translate('rememberMe');
  String get dashboard => translate('dashboard');
  String get inventory => translate('inventory');
  String get products => translate('products');
  String get addProduct => translate('addProduct');
  String get editProduct => translate('editProduct');
  String get deleteProduct => translate('deleteProduct');
  String get productName => translate('productName');
  String get productCode => translate('productCode');
  String get category => translate('category');
  String get quantity => translate('quantity');
  String get price => translate('price');
  String get description => translate('description');
  String get save => translate('save');
  String get cancel => translate('cancel');
  String get search => translate('search');
  String get filter => translate('filter');
  String get sort => translate('sort');
  String get totalProducts => translate('totalProducts');
  String get lowStock => translate('lowStock');
  String get outOfStock => translate('outOfStock');
  String get recentActivity => translate('recentActivity');
  String get settings => translate('settings');
  String get profile => translate('profile');
  String get language => translate('language');
  String get theme => translate('theme');
  String get lightTheme => translate('lightTheme');
  String get darkTheme => translate('darkTheme');
  String get systemTheme => translate('systemTheme');
  String get notifications => translate('notifications');
  String get help => translate('help');
  String get about => translate('about');
  String get version => translate('version');
  String get loading => translate('loading');
  String get error => translate('error');
  String get success => translate('success');
  String get confirm => translate('confirm');
  String get yes => translate('yes');
  String get no => translate('no');
  String get ok => translate('ok');
  String get retry => translate('retry');
  String get noData => translate('noData');
  String get noInternet => translate('noInternet');
  String get serverError => translate('serverError');
  String get invalidCredentials => translate('invalidCredentials');
  String get productAdded => translate('productAdded');
  String get productUpdated => translate('productUpdated');
  String get productDeleted => translate('productDeleted');
  String get areYouSure => translate('areYouSure');
  String get deleteConfirmation => translate('deleteConfirmation');
  String get selectImage => translate('selectImage');
  String get camera => translate('camera');
  String get gallery => translate('gallery');
  String get removeImage => translate('removeImage');
  String get selectCategory => translate('selectCategory');
  String get electronics => translate('electronics');
  String get clothing => translate('clothing');
  String get books => translate('books');
  String get food => translate('food');
  String get other => translate('other');
  String get quantityInStock => translate('quantityInStock');
  String get minimumQuantity => translate('minimumQuantity');
  String get supplier => translate('supplier');
  String get dateAdded => translate('dateAdded');
  String get lastUpdated => translate('lastUpdated');
  String get actions => translate('actions');
  String get edit => translate('edit');
  String get delete => translate('delete');
  String get view => translate('view');
  String get addToCart => translate('addToCart');
  String get updateStock => translate('updateStock');
  String get stockHistory => translate('stockHistory');
  String get reports => translate('reports');
  String get export => translate('export');
  String get import => translate('import');
  String get backup => translate('backup');
  String get restore => translate('restore');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'vi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

