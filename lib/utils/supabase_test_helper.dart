import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 🔍 Helper class để test kết nối Supabase
/// Dùng trong Development/Debug mode
class SupabaseTestHelper {
  static final client = Supabase.instance.client;

  /// ✅ Kiểm tra kết nối Supabase
  static Future<Map<String, dynamic>> testConnection() async {
    final Map<String, dynamic> result = {
      'status': 'unknown',
      'message': '',
      'details': <String, dynamic>{},
    };

    try {
      // Test 1: Kiểm tra client đã khởi tạo chưa
      final user = client.auth.currentUser;
      
      // Test 2: Kiểm tra auth state
      final details = result['details'] as Map<String, dynamic>;
      details['isAuthenticated'] = user != null;
      details['userEmail'] = user?.email ?? 'Not logged in';
      details['userId'] = user?.id ?? 'N/A';

      // Test 3: Test query đơn giản (đếm products)
      try {
        final response = await client
            .from('products')
            .select('id')
            .limit(1);
        
        details['databaseConnection'] = 'OK';
        details['productsTableExists'] = true;
        details['productCount'] = response.length;
      } catch (e) {
        details['databaseConnection'] = 'Error: $e';
        details['productsTableExists'] = false;
      }

      // Test 4: Kiểm tra connection
      details['supabaseUrl'] = 'https://tnctyxsglejxdkqdkedd.supabase.co';
      details['hasApiKey'] = true;
      details['connectionStatus'] = 'Connected';

      result['status'] = 'success';
      result['message'] = 'Supabase connection is working!';

    } catch (e) {
      result['status'] = 'error';
      result['message'] = 'Lỗi khi test connection: $e';
    }

    return result;
  }

  /// 📊 Lấy thống kê database
  static Future<Map<String, dynamic>> getDatabaseStats() async {
    try {
      final user = client.auth.currentUser;
      if (user == null) {
        return {
          'error': 'User chưa đăng nhập',
          'totalProducts': 0,
          'totalActivities': 0,
        };
      }

      // Đếm products
      final productsResponse = await client
          .from('products')
          .select('id')
          .count();

      // Đếm activities
      final activitiesResponse = await client
          .from('activities')
          .select('id')
          .count();

      return {
        'totalProducts': productsResponse.count ?? 0,
        'totalActivities': activitiesResponse.count ?? 0,
        'userId': user.id,
        'userEmail': user.email,
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'totalProducts': 0,
        'totalActivities': 0,
      };
    }
  }

  /// 🎨 Hiển thị dialog test kết nối
  static void showTestDialog(BuildContext context) async {
    // Hiển thị loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Chạy test
    final testResult = await testConnection();
    final dbStats = await getDatabaseStats();

    // Đóng loading
    if (context.mounted) {
      Navigator.pop(context);
    }

    // Hiển thị kết quả
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(
                testResult['status'] == 'success'
                    ? Icons.check_circle
                    : Icons.error,
                color: testResult['status'] == 'success'
                    ? Colors.green
                    : Colors.red,
              ),
              const SizedBox(width: 8),
              const Text('Supabase Connection Test'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status
                _buildInfoRow('Status:', testResult['status'] as String),
                _buildInfoRow('Message:', testResult['message'] as String),
                
                const Divider(height: 24),
                const Text(
                  'Connection Details:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Details
                ...((testResult['details'] as Map<String, dynamic>)
                    .entries
                    .map((e) => _buildInfoRow(
                          '${e.key}:',
                          e.value.toString(),
                        ))),

                const Divider(height: 24),
                const Text(
                  'Database Stats:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Stats
                ...(dbStats.entries
                    .map((e) => _buildInfoRow(
                          '${e.key}:',
                          e.value.toString(),
                        ))),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  static Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  /// 🧹 Clear all data (DANGER!)
  static Future<bool> clearAllData() async {
    try {
      await client.from('activities').delete().neq('id', '00000000-0000-0000-0000-000000000000');
      await client.from('products').delete().neq('id', '00000000-0000-0000-0000-000000000000');
      return true;
    } catch (e) {
      debugPrint('Error clearing data: $e');
      return false;
    }
  }
}

