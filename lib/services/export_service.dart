import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class ExportService {
  static Future<String> exportToPDF(Map<String, dynamic> data) async {
    final pdf = pw.Document();

    // Add main page
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            _buildHeader(),
            pw.SizedBox(height: 20),
            _buildSummarySection(data['statistics']),
            pw.SizedBox(height: 20),
            _buildProductsTable(data['products']),
            pw.SizedBox(height: 20),
            _buildRevenueChart(data['revenueData']),
          ];
        },
      ),
    );

    // Add detailed products page
    if (data['products'].isNotEmpty) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              _buildHeader(
                  title: 'Detailed Product Report / Báo cáo chi tiết sản phẩm'),
              pw.SizedBox(height: 20),
              _buildDetailedProductsList(data['products']),
            ];
          },
        ),
      );
    }

    // Save PDF
    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'inventory_report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    return file.path;
  }

  static pw.Widget _buildHeader({String? title}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title ?? 'Inventory Management Report / Báo cáo quản lý kho',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Generated on / Tạo lúc: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey700,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummarySection(Map<String, dynamic> statistics) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total Products / Tổng sản phẩm',
              '${statistics['totalProducts']}', PdfColors.blue),
          _buildStatItem(
              'Total Value / Tổng giá trị',
              '\$${statistics['totalValue'].toStringAsFixed(0)}',
              PdfColors.green),
          _buildStatItem('Low Stock / Hàng sắp hết',
              '${statistics['lowStockCount']}', PdfColors.orange),
          _buildStatItem('Recent Activities / Hoạt động gần đây',
              '${statistics['recentActivities']}', PdfColors.purple),
        ],
      ),
    );
  }

  static pw.Widget _buildStatItem(String label, String value, PdfColor color) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 10,
            color: PdfColors.grey700,
          ),
          textAlign: pw.TextAlign.center,
        ),
      ],
    );
  }

  static pw.Widget _buildProductsTable(List<dynamic> products) {
    if (products.isEmpty) {
      return pw.Center(
        child: pw.Text(
          'No products found / Không tìm thấy sản phẩm',
          style: pw.TextStyle(fontSize: 16, color: PdfColors.grey600),
        ),
      );
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(1.5),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1),
        4: const pw.FlexColumnWidth(1.5),
      },
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue100),
          children: [
            _buildTableCell('Product Name / Tên sản phẩm', isHeader: true),
            _buildTableCell('Category / Danh mục', isHeader: true),
            _buildTableCell('Qty / SL', isHeader: true),
            _buildTableCell('Price / Giá', isHeader: true),
            _buildTableCell('Value / Giá trị', isHeader: true),
          ],
        ),
        // Data rows
        ...products.map((product) => pw.TableRow(
              children: [
                _buildTableCell(product['name']),
                _buildTableCell(product['category']),
                _buildTableCell('${product['quantity']}'),
                _buildTableCell('\$${product['price'].toStringAsFixed(2)}'),
                _buildTableCell(
                    '\$${(product['quantity'] * product['price']).toStringAsFixed(2)}'),
              ],
            )),
      ],
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 10 : 9,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.blue900 : PdfColors.black,
        ),
      ),
    );
  }

  static pw.Widget _buildRevenueChart(List<dynamic> revenueData) {
    if (revenueData.isEmpty) {
      return pw.Center(
        child: pw.Text(
          'No revenue data available / Không có dữ liệu doanh thu',
          style: pw.TextStyle(fontSize: 16, color: PdfColors.grey600),
        ),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Revenue Overview / Tổng quan doanh thu',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FlexColumnWidth(1),
            1: const pw.FlexColumnWidth(2),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                _buildTableCell('Date / Ngày', isHeader: true),
                _buildTableCell('Revenue / Doanh thu', isHeader: true),
              ],
            ),
            ...revenueData.take(10).map((data) {
              final date = DateTime.parse(data['date']);
              return pw.TableRow(
                children: [
                  _buildTableCell(DateFormat('dd/MM/yyyy').format(date)),
                  _buildTableCell('\$${data['revenue'].toStringAsFixed(0)}'),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildDetailedProductsList(List<dynamic> products) {
    return pw.Column(
      children: products.map((product) {
        return pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 12),
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                product['name'],
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Text('Code: ${product['code']}'),
                  ),
                  pw.Expanded(
                    child: pw.Text('Category: ${product['category']}'),
                  ),
                  pw.Expanded(
                    child: pw.Text('Supplier: ${product['supplier']}'),
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Text('Quantity: ${product['quantity']}'),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                        'Price: \$${product['price'].toStringAsFixed(2)}'),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                        'Value: \$${(product['quantity'] * product['price']).toStringAsFixed(2)}'),
                  ),
                ],
              ),
              if (product['description'] != null &&
                  product['description'].isNotEmpty) ...[
                pw.SizedBox(height: 4),
                pw.Text(
                  'Description: ${product['description']}',
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  static Future<String> exportToCSV(Map<String, dynamic> data) async {
    final buffer = StringBuffer();

    // Header
    buffer.writeln(
        'Inventory Management Report - ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}');
    buffer.writeln();

    // Summary
    buffer.writeln('SUMMARY / TỔNG KẾT');
    buffer.writeln(
        'Total Products / Tổng sản phẩm,${data['statistics']['totalProducts']}');
    buffer.writeln(
        'Total Value / Tổng giá trị,\$${data['statistics']['totalValue'].toStringAsFixed(0)}');
    buffer.writeln(
        'Low Stock / Hàng sắp hết,${data['statistics']['lowStockCount']}');
    buffer.writeln(
        'Recent Activities / Hoạt động gần đây,${data['statistics']['recentActivities']}');
    buffer.writeln();

    // Products
    buffer.writeln('PRODUCTS / SẢN PHẨM');
    buffer.writeln(
        'Name / Tên,Code / Mã,Category / Danh mục,Quantity / Số lượng,Price / Giá,Value / Giá trị,Supplier / Nhà cung cấp,Description / Mô tả');

    for (var product in data['products']) {
      buffer.writeln(
          '${product['name']},${product['code']},${product['category']},${product['quantity']},\$${product['price'].toStringAsFixed(2)},\$${(product['quantity'] * product['price']).toStringAsFixed(2)},${product['supplier']},"${product['description'] ?? ''}"');
    }

    buffer.writeln();

    // Revenue data
    buffer.writeln('REVENUE DATA / DỮ LIỆU DOANH THU');
    buffer.writeln('Date / Ngày,Revenue / Doanh thu');

    for (var revenue in data['revenueData']) {
      final date = DateTime.parse(revenue['date']);
      buffer.writeln(
          '${DateFormat('dd/MM/yyyy').format(date)},\$${revenue['revenue'].toStringAsFixed(0)}');
    }

    // Save CSV
    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'inventory_report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(buffer.toString());

    return file.path;
  }
}

