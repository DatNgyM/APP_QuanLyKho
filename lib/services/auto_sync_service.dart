import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

/// 🔄 Service tự động đồng bộ dữ liệu từ Supabase
/// - Sync khi mở app
/// - Sync theo định kỳ
/// - Sync khi có thay đổi (Real-time)
class AutoSyncService {
  static final AutoSyncService _instance = AutoSyncService._internal();
  factory AutoSyncService() => _instance;
  AutoSyncService._internal();

  final SupabaseService _supabaseService = SupabaseService();
  final SupabaseClient _client = Supabase.instance.client;
  
  DateTime? _lastSyncTime;
  bool _isSyncing = false;
  String _syncStatus = 'Not synced';

  // Getters
  DateTime? get lastSyncTime => _lastSyncTime;
  bool get isSyncing => _isSyncing;
  String get syncStatus => _syncStatus;

  /// 🚀 Sync toàn bộ dữ liệu từ Supabase
  Future<Map<String, dynamic>> syncAll({bool force = false}) async {
    if (_isSyncing && !force) {
      return {
        'success': false,
        'message': 'Sync đang chạy...',
      };
    }

    _isSyncing = true;
    _syncStatus = 'Syncing...';
    
    try {
      debugPrint('🔄 [AUTO SYNC] Starting full sync from Supabase...');
      final startTime = DateTime.now();

      // 1. Sync Categories
      final categories = await _supabaseService.getCategories();
      debugPrint('✅ [AUTO SYNC] Categories: ${categories.length}');

      // 2. Sync Brands
      final brands = await _supabaseService.getBrands();
      debugPrint('✅ [AUTO SYNC] Brands: ${brands.length}');

      // 3. Sync Products
      final products = await _supabaseService.getProducts();
      debugPrint('✅ [AUTO SYNC] Products: ${products.length}');

      final duration = DateTime.now().difference(startTime);
      _lastSyncTime = DateTime.now();
      _syncStatus = 'Synced successfully';

      debugPrint('🎉 [AUTO SYNC] COMPLETE in ${duration.inMilliseconds}ms');
      debugPrint('📊 [AUTO SYNC] Summary:');
      debugPrint('   - Categories: ${categories.length}');
      debugPrint('   - Brands: ${brands.length}');
      debugPrint('   - Products: ${products.length}');

      return {
        'success': true,
        'message': 'Đồng bộ thành công!',
        'categoriesCount': categories.length,
        'brandsCount': brands.length,
        'productsCount': products.length,
        'duration': duration.inMilliseconds,
        'lastSyncTime': _lastSyncTime,
      };
    } catch (e) {
      debugPrint('❌ [AUTO SYNC] ERROR: $e');
      _syncStatus = 'Sync failed: $e';
      
      return {
        'success': false,
        'message': 'Lỗi đồng bộ: $e',
      };
    } finally {
      _isSyncing = false;
    }
  }

  /// 🔔 Subscribe to Real-time changes (Optional - Advanced)
  /// Lắng nghe thay đổi real-time từ Supabase
  void subscribeToChanges({
    required Function() onProductChange,
  }) {
    debugPrint('🔔 [AUTO SYNC] Subscribing to real-time changes...');

    // Subscribe to products table changes
    _client
        .channel('public:products')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'products',
          callback: (payload) {
            debugPrint('🔔 [REALTIME] Product changed: ${payload.eventType}');
            debugPrint('   Data: ${payload.newRecord}');
            onProductChange();
          },
        )
        .subscribe();

    debugPrint('✅ [AUTO SYNC] Real-time subscription active');
  }

  /// 📊 Lấy thống kê sync
  Map<String, dynamic> getSyncStats() {
    return {
      'lastSyncTime': _lastSyncTime?.toIso8601String() ?? 'Never',
      'isSyncing': _isSyncing,
      'syncStatus': _syncStatus,
      'minutesSinceLastSync': _lastSyncTime != null
          ? DateTime.now().difference(_lastSyncTime!).inMinutes
          : null,
    };
  }

  /// 🧪 Test connection to Supabase
  Future<bool> testConnection() async {
    try {
      debugPrint('🔌 [AUTO SYNC] Testing Supabase connection...');
      
      final response = await _client
          .from('products')
          .select('id')
          .limit(1);
      
      debugPrint('✅ [AUTO SYNC] Connection OK! Sample: $response');
      return true;
    } catch (e) {
      debugPrint('❌ [AUTO SYNC] Connection FAILED: $e');
      return false;
    }
  }

  /// 📅 Sync theo định kỳ (Optional)
  /// Gọi hàm này để bật auto sync mỗi X phút
  Stream<Map<String, dynamic>> periodicSync({
    Duration interval = const Duration(minutes: 5),
  }) async* {
    while (true) {
      await Future.delayed(interval);
      final result = await syncAll();
      yield result;
    }
  }
}

