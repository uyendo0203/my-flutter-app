import 'package:flutter/material.dart';
import '../models/work.dart';

extension WorkStatusExtension on WorkStatus {
  String get statusText {
    switch (this) {
      case WorkStatus.pending:
        return 'Chờ xử lý';
      case WorkStatus.inProgress:
        return 'Đang thực hiện';
      case WorkStatus.completed:
        return 'Hoàn thành';
      case WorkStatus.cancelled:
        return 'Đã hủy';
    }
  }

  String get displayText => statusText;

  Color get color {
    switch (this) {
      case WorkStatus.pending:
        return const Color(0xFFE3F2FD);
      case WorkStatus.inProgress:
        return const Color(0xFFFFF3E0);
      case WorkStatus.completed:
        return const Color(0xFFE8F5E8);
      case WorkStatus.cancelled:
        return const Color(0xFFFFEBEE);
    }
  }

  Color get textColor {
    switch (this) {
      case WorkStatus.pending:
        return const Color(0xFF1976D2);
      case WorkStatus.inProgress:
        return const Color(0xFFEF6C00);
      case WorkStatus.completed:
        return const Color(0xFF388E3C);
      case WorkStatus.cancelled:
        return const Color(0xFFD32F2F);
    }
  }
}

extension WorkPriorityExtension on WorkPriority {
  String get priorityText {
    switch (this) {
      case WorkPriority.low:
        return 'Thấp';
      case WorkPriority.medium:
        return 'Trung bình';
      case WorkPriority.high:
        return 'Cao';
      case WorkPriority.urgent:
        return 'Khẩn cấp';
    }
  }

  String get displayText => priorityText;

  Color get color {
    switch (this) {
      case WorkPriority.low:
        return const Color(0xFFE8F5E8);
      case WorkPriority.medium:
        return const Color(0xFFFFF3E0);
      case WorkPriority.high:
        return const Color(0xFFFFE0B2);
      case WorkPriority.urgent:
        return const Color(0xFFFFEBEE);
    }
  }

  Color get textColor {
    switch (this) {
      case WorkPriority.low:
        return const Color(0xFF388E3C);
      case WorkPriority.medium:
        return const Color(0xFFEF6C00);
      case WorkPriority.high:
        return const Color(0xFFFF8F00);
      case WorkPriority.urgent:
        return const Color(0xFFD32F2F);
    }
  }
}