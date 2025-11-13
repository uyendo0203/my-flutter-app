import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/work/work_bloc.dart';
import '../bloc/work/work_event.dart';
import '../bloc/work/work_state.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_state.dart';
import '../models/work.dart';
import '../models/profile.dart';
import '../widgets/work_card.dart';
import '../utils/work_extensions.dart';
import 'work_form_screen.dart';

class WorkListScreen extends StatefulWidget {
  const WorkListScreen({super.key});

  @override
  State<WorkListScreen> createState() => _WorkListScreenState();
}

class _WorkListScreenState extends State<WorkListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedProfileFilter;
  WorkStatus? _selectedStatusFilter;
  WorkPriority? _selectedPriorityFilter;

  @override
  void initState() {
    super.initState();
    context.read<WorkBloc>().add(const LoadWorksEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Công việc'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<WorkBloc>().add(LoadWorksEvent(profileId: _selectedProfileFilter));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(child: _buildWorkList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "work_add_button",
        onPressed: _navigateToWorkForm,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm công việc...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        context.read<WorkBloc>().add(const SearchWorksEvent(''));
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
            onChanged: (value) {
              context.read<WorkBloc>().add(SearchWorksEvent(value));
            },
          ),
          const SizedBox(height: 12),
          
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildProfileFilter(),
                const SizedBox(width: 8),
                _buildStatusFilter(),
                const SizedBox(width: 8),
                _buildPriorityFilter(),
                const SizedBox(width: 8),
                _buildClearFiltersButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileFilter() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is! ProfileLoaded) {
          return const SizedBox.shrink();
        }

        return PopupMenuButton<String?>(
          child: Chip(
            label: Text(_selectedProfileFilter == null 
              ? 'Tất cả Profile'
              : profileState.profiles
                  .firstWhere((p) => p.id == _selectedProfileFilter)
                  .name),
            deleteIcon: _selectedProfileFilter != null ? const Icon(Icons.close, size: 16) : null,
            onDeleted: _selectedProfileFilter != null ? () {
              setState(() => _selectedProfileFilter = null);
              context.read<WorkBloc>().add(const LoadWorksEvent());
            } : null,
          ),
          itemBuilder: (context) => [
            const PopupMenuItem<String?>(
              value: null,
              child: Text('Tất cả Profile'),
            ),
            ...profileState.profiles.map((profile) => PopupMenuItem<String>(
                  value: profile.id,
                  child: Text(profile.name),
                )),
          ],
          onSelected: (value) {
            setState(() => _selectedProfileFilter = value);
            context.read<WorkBloc>().add(LoadWorksEvent(profileId: value));
          },
        );
      },
    );
  }

  Widget _buildStatusFilter() {
    return PopupMenuButton<WorkStatus?>(
      child: Chip(
        label: Text(_selectedStatusFilter?.statusText ?? 'Trạng thái'),
        deleteIcon: _selectedStatusFilter != null ? const Icon(Icons.close, size: 16) : null,
        onDeleted: _selectedStatusFilter != null ? () {
          setState(() => _selectedStatusFilter = null);
          context.read<WorkBloc>().add(const FilterWorksByStatusEvent(null));
        } : null,
      ),
      itemBuilder: (context) => [
        const PopupMenuItem<WorkStatus?>(
          value: null,
          child: Text('Tất cả trạng thái'),
        ),
        ...WorkStatus.values.map((status) => PopupMenuItem<WorkStatus>(
              value: status,
              child: Text(status.statusText),
            )),
      ],
      onSelected: (value) {
        setState(() => _selectedStatusFilter = value);
        context.read<WorkBloc>().add(FilterWorksByStatusEvent(value));
      },
    );
  }

  Widget _buildPriorityFilter() {
    return PopupMenuButton<WorkPriority?>(
      child: Chip(
        label: Text(_selectedPriorityFilter?.priorityText ?? 'Độ ưu tiên'),
        deleteIcon: _selectedPriorityFilter != null ? const Icon(Icons.close, size: 16) : null,
        onDeleted: _selectedPriorityFilter != null ? () {
          setState(() => _selectedPriorityFilter = null);
          context.read<WorkBloc>().add(const FilterWorksByPriorityEvent(null));
        } : null,
      ),
      itemBuilder: (context) => [
        const PopupMenuItem<WorkPriority?>(
          value: null,
          child: Text('Tất cả mức độ'),
        ),
        ...WorkPriority.values.map((priority) => PopupMenuItem<WorkPriority>(
              value: priority,
              child: Text(priority.priorityText),
            )),
      ],
      onSelected: (value) {
        setState(() => _selectedPriorityFilter = value);
        context.read<WorkBloc>().add(FilterWorksByPriorityEvent(value));
      },
    );
  }

  Widget _buildClearFiltersButton() {
    final hasFilters = _selectedProfileFilter != null || 
                      _selectedStatusFilter != null || 
                      _selectedPriorityFilter != null ||
                      _searchController.text.isNotEmpty;

    if (!hasFilters) return const SizedBox.shrink();

    return ActionChip(
      label: const Text('Xóa bộ lọc'),
      onPressed: () {
        setState(() {
          _selectedProfileFilter = null;
          _selectedStatusFilter = null;
          _selectedPriorityFilter = null;
        });
        _searchController.clear();
        context.read<WorkBloc>().add(const LoadWorksEvent());
      },
    );
  }

  Widget _buildWorkList() {
    return BlocConsumer<WorkBloc, WorkState>(
      listener: (context, state) {
        if (state is WorkErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is WorkActionSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is WorkLoadingState) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Đang tải danh sách công việc...'),
              ],
            ),
          );
        }

        if (state is WorkLoadedState) {
          if (state.filteredWorks.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<WorkBloc>().add(LoadWorksEvent(profileId: _selectedProfileFilter));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.filteredWorks.length,
              itemBuilder: (context, index) {
                final work = state.filteredWorks[index];
                final profile = _getProfileById(work.profileId);
                
                return WorkCard(
                  key: ValueKey(work.id),
                  work: work,
                  profile: profile,
                  onEdit: () => _navigateToWorkForm(work: work),
                  onDelete: () => _showDeleteDialog(work),
                  onStatusChange: (newStatus) => _updateWorkStatus(work, newStatus),
                );
              },
            ),
          );
        }

        return _buildEmptyState();
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_outline,
            size: 80,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có công việc nào',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy thêm công việc đầu tiên!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _navigateToWorkForm,
            icon: const Icon(Icons.add),
            label: const Text('Thêm công việc đầu tiên'),
          ),
        ],
      ),
    );
  }

  Profile? _getProfileById(String profileId) {
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is ProfileLoaded) {
      try {
        return profileState.profiles.firstWhere((profile) => profile.id == profileId);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  void _navigateToWorkForm({Work? work}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => WorkFormScreen(work: work),
      ),
    );

    if (result == true) {
      context.read<WorkBloc>().add(LoadWorksEvent(profileId: _selectedProfileFilter));
    }
  }

  void _showDeleteDialog(Work work) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              const TextSpan(text: 'Bạn có chắc chắn muốn xóa công việc '),
              TextSpan(
                text: '"${work.title}"',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: '?\n\nHành động này không thể hoàn tác.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<WorkBloc>().add(DeleteWorkEvent(work.id));
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _updateWorkStatus(Work work, WorkStatus newStatus) {
    final updatedWork = work.copyWith(
      status: newStatus,
      completedAt: newStatus == WorkStatus.completed ? DateTime.now() : null,
      progress: newStatus == WorkStatus.completed ? 1.0 : work.progress,
    );
    
    context.read<WorkBloc>().add(UpdateWorkEvent(updatedWork));
  }
}