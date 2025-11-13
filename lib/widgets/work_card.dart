import 'package:flutter/material.dart';
import '../models/work.dart';
import '../models/profile.dart';
import '../utils/work_extensions.dart';

class WorkCard extends StatelessWidget {
  final Work work;
  final Profile? profile;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(WorkStatus)? onStatusChange;

  const WorkCard({
    super.key,
    required this.work,
    this.profile,
    this.onEdit,
    this.onDelete,
    this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: work.isOverdue 
          ? BorderSide(color: Colors.red.shade300, width: 2)
          : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 8),
            _buildDescription(context),
            const SizedBox(height: 12),
            _buildDetails(context),
            if (work.status == WorkStatus.inProgress && work.progress > 0) ...[
              const SizedBox(height: 12),
              _buildProgressBar(context),
            ],
            const SizedBox(height: 12),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                work.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  decoration: work.status == WorkStatus.completed
                    ? TextDecoration.lineThrough
                    : null,
                ),
              ),
              if (profile != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person, size: 14, color: Theme.of(context).colorScheme.outline),
                    const SizedBox(width: 4),
                    Text(
                      profile!.name,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        _buildPriorityChip(),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    if (work.description.isEmpty) {
      return Text(
        'Không có mô tả',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontStyle: FontStyle.italic,
          color: Theme.of(context).colorScheme.outline,
        ),
      );
    }
    
    return Text(
      work.description,
      style: Theme.of(context).textTheme.bodyMedium,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _buildStatusChip(),
        if (work.dueDate != null) _buildDueDate(context),
        _buildCreatedDate(context),
      ],
    );
  }

  Widget _buildPriorityChip() {
    Color chipColor;
    IconData priorityIcon;
    
    switch (work.priority) {
      case WorkPriority.low:
        chipColor = Colors.green;
        priorityIcon = Icons.keyboard_arrow_down;
        break;
      case WorkPriority.medium:
        chipColor = Colors.orange;
        priorityIcon = Icons.remove;
        break;
      case WorkPriority.high:
        chipColor = Colors.red;
        priorityIcon = Icons.keyboard_arrow_up;
        break;
      case WorkPriority.urgent:
        chipColor = Colors.purple;
        priorityIcon = Icons.priority_high;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(priorityIcon, size: 14, color: chipColor),
          const SizedBox(width: 4),
          Text(
            work.priority.priorityText,
            style: TextStyle(
              color: chipColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    IconData statusIcon;
    
    switch (work.status) {
      case WorkStatus.pending:
        chipColor = Colors.grey;
        statusIcon = Icons.radio_button_unchecked;
        break;
      case WorkStatus.inProgress:
        chipColor = Colors.blue;
        statusIcon = Icons.play_circle;
        break;
      case WorkStatus.completed:
        chipColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case WorkStatus.cancelled:
        chipColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 14, color: chipColor),
          const SizedBox(width: 4),
          Text(
            work.status.statusText,
            style: TextStyle(
              color: chipColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDueDate(BuildContext context) {
    final isOverdue = work.isOverdue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOverdue ? Colors.red.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isOverdue ? Colors.red.shade300 : Colors.blue.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOverdue ? Icons.warning : Icons.schedule,
            size: 14,
            color: isOverdue ? Colors.red : Colors.blue,
          ),
          const SizedBox(width: 4),
          Text(
            'Hạn: ${_formatDate(work.dueDate!)}',
            style: TextStyle(
              fontSize: 12,
              color: isOverdue ? Colors.red : Colors.blue,
              fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatedDate(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            size: 14,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 4),
          Text(
            'Ngày Tạo: ${_formatDate(work.createdAt)}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tiến độ',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '${(work.progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: work.progress,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(
            work.progress >= 1.0 ? Colors.green : Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        if (onStatusChange != null && work.status != WorkStatus.completed && work.status != WorkStatus.cancelled) ...[
          _buildStatusButton(),
          const SizedBox(width: 8),
        ],
        const Spacer(),
        if (onEdit != null) ...[
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: onEdit,
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
            tooltip: 'Chỉnh sửa',
          ),
          const SizedBox(width: 8),
        ],
        if (onDelete != null)
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            onPressed: onDelete,
            style: IconButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.1),
              foregroundColor: Colors.red,
            ),
            tooltip: 'Xóa',
          ),
      ],
    );
  }

  Widget _buildStatusButton() {
    String buttonText;
    WorkStatus nextStatus;
    Color buttonColor;
    
    switch (work.status) {
      case WorkStatus.pending:
        buttonText = 'Bắt đầu';
        nextStatus = WorkStatus.inProgress;
        buttonColor = Colors.blue;
        break;
      case WorkStatus.inProgress:
        buttonText = 'Hoàn thành';
        nextStatus = WorkStatus.completed;
        buttonColor = Colors.green;
        break;
      case WorkStatus.completed:
        return const SizedBox.shrink();
      case WorkStatus.cancelled:
        buttonText = 'Khôi phục';
        nextStatus = WorkStatus.pending;
        buttonColor = Colors.orange;
        break;
    }

    return ElevatedButton(
      onPressed: () => onStatusChange?.call(nextStatus),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(buttonText, style: const TextStyle(fontSize: 12)),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year}';
  }
}