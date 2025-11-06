import 'package:flutter/material.dart';
import '../models/order_status.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;
  final String? languageCode;

  const OrderStatusBadge({
    super.key,
    required this.status,
    this.languageCode = 'vi',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIcon(),
            size: 14,
            color: _getTextColor(),
          ),
          const SizedBox(width: 4),
          Text(
            status.getLabel(languageCode ?? 'vi'),
            style: TextStyle(
              color: _getTextColor(),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (status) {
      case OrderStatus.pending:
        return Colors.amber[100]!;
      case OrderStatus.processing:
        return Colors.blue[100]!;
      case OrderStatus.completed:
        return Colors.green[100]!;
      case OrderStatus.cancelled:
        return Colors.red[100]!;
    }
  }

  Color _getTextColor() {
    switch (status) {
      case OrderStatus.pending:
        return Colors.amber[900]!;
      case OrderStatus.processing:
        return Colors.blue[900]!;
      case OrderStatus.completed:
        return Colors.green[900]!;
      case OrderStatus.cancelled:
        return Colors.red[900]!;
    }
  }

  IconData _getIcon() {
    switch (status) {
      case OrderStatus.pending:
        return Icons.schedule;
      case OrderStatus.processing:
        return Icons.autorenew;
      case OrderStatus.completed:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }
}

