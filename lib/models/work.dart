import 'package:equatable/equatable.dart';

enum WorkStatus {
  pending,
  inProgress,
  completed,
  cancelled,
}

enum WorkPriority {
  low,
  medium,
  high,
  urgent,
}

class Work extends Equatable {
  final String id;
  final String title;
  final String description;
  final String profileId;
  final WorkStatus status;
  final WorkPriority priority;
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final double progress;

  const Work({
    required this.id,
    required this.title,
    required this.description,
    required this.profileId,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
    this.progress = 0.0,
  });

  Work copyWith({
    String? id,
    String? title,
    String? description,
    String? profileId,
    WorkStatus? status,
    WorkPriority? priority,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
    double? progress,
  }) {
    return Work(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      profileId: profileId ?? this.profileId,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        profileId,
        status,
        priority,
        createdAt,
        dueDate,
        completedAt,
        progress,
      ];

  String get statusText {
    switch (status) {
      case WorkStatus.pending:
        return 'Chờ xử lý';
      case WorkStatus.inProgress:
        return 'Đang làm';
      case WorkStatus.completed:
        return 'Hoàn thành';
      case WorkStatus.cancelled:
        return 'Đã hủy';
    }
  }

  String get priorityText {
    switch (priority) {
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

  bool get isOverdue {
    if (dueDate == null || status == WorkStatus.completed) return false;
    return DateTime.now().isAfter(dueDate!);
  }
}