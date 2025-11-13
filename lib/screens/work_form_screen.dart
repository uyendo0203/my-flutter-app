import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/work/work_bloc.dart';
import '../bloc/work/work_event.dart';
import '../bloc/work/work_state.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_state.dart';
import '../models/work.dart';

class WorkFormScreen extends StatefulWidget {
  final Work? work;

  const WorkFormScreen({super.key, this.work});

  @override
  State<WorkFormScreen> createState() => _WorkFormScreenState();
}

class _WorkFormScreenState extends State<WorkFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String? _selectedProfileId;
  WorkStatus _selectedStatus = WorkStatus.pending;
  WorkPriority _selectedPriority = WorkPriority.medium;
  DateTime? _dueDate;
  double _progress = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.work?.title ?? '');
    _descriptionController = TextEditingController(text: widget.work?.description ?? '');
    
    if (widget.work != null) {
      _selectedProfileId = widget.work!.profileId;
      _selectedStatus = widget.work!.status;
      _selectedPriority = widget.work!.priority;
      _dueDate = widget.work!.dueDate;
      _progress = widget.work!.progress;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.work != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Chỉnh sửa Công việc' : 'Thêm Công việc mới'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: BlocListener<WorkBloc, WorkState>(
        listener: (context, state) {
          if (state is WorkActionSuccessState) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true);
          } else if (state is WorkErrorState) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildFormField(
                  controller: _titleController,
                  label: 'Tiêu đề công việc *',
                  icon: Icons.work,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập tiêu đề công việc';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  controller: _descriptionController,
                  label: 'Mô tả công việc',
                  icon: Icons.description,
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                _buildProfileDropdown(),
                const SizedBox(height: 16),
                _buildStatusDropdown(),
                const SizedBox(height: 16),
                _buildPriorityDropdown(),
                const SizedBox(height: 16),
                _buildDueDatePicker(),
                if (_selectedStatus == WorkStatus.inProgress) ...[
                  const SizedBox(height: 16),
                  _buildProgressSlider(),
                ],
                const SizedBox(height: 32),
                _buildSubmitButton(),
                if (_isEditing) ...[
                  const SizedBox(height: 16),
                  _buildCancelButton(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      maxLines: maxLines,
      validator: validator,
    );
  }

  Widget _buildProfileDropdown() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is! ProfileLoaded || state.profiles.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Chưa có profile nào. Hãy tạo profile trước!'),
          );
        }

        return DropdownButtonFormField<String>(
          value: _selectedProfileId,
          decoration: InputDecoration(
            labelText: 'Chọn Profile *',
            prefixIcon: const Icon(Icons.person),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
          ),
          items: state.profiles.map((profile) {
            return DropdownMenuItem(
              value: profile.id,
              child: Text(profile.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedProfileId = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Vui lòng chọn profile';
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<WorkStatus>(
      value: _selectedStatus,
      decoration: InputDecoration(
        labelText: 'Trạng thái',
        prefixIcon: const Icon(Icons.flag),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      items: WorkStatus.values.map((status) {
        return DropdownMenuItem(
          value: status,
          child: Text(status.statusText),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedStatus = value;
            if (value == WorkStatus.completed) {
              _progress = 1.0;
            } else if (value == WorkStatus.pending) {
              _progress = 0.0;
            }
          });
        }
      },
    );
  }

  Widget _buildPriorityDropdown() {
    return DropdownButtonFormField<WorkPriority>(
      value: _selectedPriority,
      decoration: InputDecoration(
        labelText: 'Độ ưu tiên',
        prefixIcon: const Icon(Icons.priority_high),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      items: WorkPriority.values.map((priority) {
        return DropdownMenuItem(
          value: priority,
          child: Text(priority.priorityText),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedPriority = value;
          });
        }
      },
    );
  }

  Widget _buildDueDatePicker() {
    return InkWell(
      onTap: () => _selectDueDate(),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Hạn chót',
          prefixIcon: const Icon(Icons.calendar_today),
          suffixIcon: _dueDate != null 
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => setState(() => _dueDate = null),
              )
            : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
        child: Text(
          _dueDate != null 
            ? _formatDate(_dueDate!)
            : 'Chọn ngày hạn chót (tùy chọn)',
          style: TextStyle(
            color: _dueDate != null 
              ? Theme.of(context).textTheme.bodyLarge?.color
              : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tiến độ: ${(_progress * 100).toInt()}%',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Slider(
          value: _progress,
          onChanged: (value) => setState(() => _progress = value),
          divisions: 10,
          label: '${(_progress * 100).toInt()}%',
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleSubmit,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: _isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(
            _isEditing ? 'Cập nhật' : 'Thêm',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
    );
  }

  Widget _buildCancelButton() {
    return OutlinedButton(
      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Hủy',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  void _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final work = Work(
      id: widget.work?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      profileId: _selectedProfileId!,
      status: _selectedStatus,
      priority: _selectedPriority,
      createdAt: widget.work?.createdAt ?? DateTime.now(),
      dueDate: _dueDate,
      completedAt: _selectedStatus == WorkStatus.completed ? DateTime.now() : widget.work?.completedAt,
      progress: _progress,
    );

    if (_isEditing) {
      context.read<WorkBloc>().add(UpdateWorkEvent(work));
    } else {
      context.read<WorkBloc>().add(AddWorkEvent(work));
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year}';
  }
}

extension on WorkStatus {
  String get statusText {
    switch (this) {
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
}

extension on WorkPriority {
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
}