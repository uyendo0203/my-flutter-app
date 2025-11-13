import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/work.dart';
import '../../repositories/mock_data_repository.dart';
import 'work_event.dart';
import 'work_state.dart';

class WorkBloc extends Bloc<WorkEvent, WorkState> {

  WorkBloc() : super(const WorkInitialState()) {
    on<LoadWorksEvent>(_onLoadWorks);
    on<AddWorkEvent>(_onAddWork);
    on<UpdateWorkEvent>(_onUpdateWork);
    on<DeleteWorkEvent>(_onDeleteWork);
    on<SearchWorksEvent>(_onSearchWorks);
    on<FilterWorksByStatusEvent>(_onFilterByStatus);
    on<FilterWorksByPriorityEvent>(_onFilterByPriority);
  }

  void _onLoadWorks(LoadWorksEvent event, Emitter<WorkState> emit) async {
    emit(const WorkLoadingState());
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      List<Work> works = MockDataRepository.getWorks(profileId: event.profileId);

      emit(WorkLoadedState(
        works: MockDataRepository.getWorks(),
        filteredWorks: works,
        profileFilter: event.profileId,
      ));
    } catch (e) {
      emit(WorkErrorState('Không thể tải danh sách công việc: ${e.toString()}'));
    }
  }

  void _onAddWork(AddWorkEvent event, Emitter<WorkState> emit) {
    try {
      MockDataRepository.addWork(event.work);
      
      final currentState = state;
      if (currentState is WorkLoadedState) {
        emit(currentState.copyWith(
          works: MockDataRepository.getWorks(),
          filteredWorks: _applyFilters(currentState),
        ));
      } else {
        emit(WorkLoadedState(
          works: MockDataRepository.getWorks(),
          filteredWorks: MockDataRepository.getWorks(),
        ));
      }
      
      emit(const WorkActionSuccessState('Thêm công việc thành công!'));
    } catch (e) {
      emit(WorkErrorState('Không thể thêm công việc: ${e.toString()}'));
    }
  }

  void _onUpdateWork(UpdateWorkEvent event, Emitter<WorkState> emit) {
    try {
      final success = MockDataRepository.updateWork(event.work);
      if (!success) {
        emit(const WorkErrorState('Không tìm thấy công việc'));
        return;
      }
      
      final currentState = state;
      if (currentState is WorkLoadedState) {
        emit(currentState.copyWith(
          works: MockDataRepository.getWorks(),
          filteredWorks: _applyFilters(currentState),
        ));
      } else {
        emit(WorkLoadedState(
          works: MockDataRepository.getWorks(),
          filteredWorks: MockDataRepository.getWorks(),
        ));
      }
      
      emit(const WorkActionSuccessState('Cập nhật công việc thành công!'));
    } catch (e) {
      emit(WorkErrorState('Không thể cập nhật công việc: ${e.toString()}'));
    }
  }

  void _onDeleteWork(DeleteWorkEvent event, Emitter<WorkState> emit) {
    try {
      final success = MockDataRepository.deleteWork(event.workId);
      
      if (!success) {
        emit(const WorkErrorState('Không tìm thấy công việc'));
        return;
      }

      final currentState = state;
      if (currentState is WorkLoadedState) {
        emit(currentState.copyWith(
          works: MockDataRepository.getWorks(),
          filteredWorks: _applyFilters(currentState),
        ));
      } else {
        emit(WorkLoadedState(
          works: MockDataRepository.getWorks(),
          filteredWorks: MockDataRepository.getWorks(),
        ));
      }
      
      emit(const WorkActionSuccessState('Xóa công việc thành công!'));
    } catch (e) {
      emit(WorkErrorState('Không thể xóa công việc: ${e.toString()}'));
    }
  }

  void _onSearchWorks(SearchWorksEvent event, Emitter<WorkState> emit) {
    final currentState = state;
    if (currentState is WorkLoadedState) {
      emit(currentState.copyWith(
        searchQuery: event.query,
        filteredWorks: _applyFilters(currentState.copyWith(searchQuery: event.query)),
      ));
    }
  }

  void _onFilterByStatus(FilterWorksByStatusEvent event, Emitter<WorkState> emit) {
    final currentState = state;
    if (currentState is WorkLoadedState) {
      emit(currentState.copyWith(
        statusFilter: event.status,
        clearStatusFilter: event.status == null,
        filteredWorks: _applyFilters(currentState.copyWith(
          statusFilter: event.status,
          clearStatusFilter: event.status == null,
        )),
      ));
    }
  }

  void _onFilterByPriority(FilterWorksByPriorityEvent event, Emitter<WorkState> emit) {
    final currentState = state;
    if (currentState is WorkLoadedState) {
      emit(currentState.copyWith(
        priorityFilter: event.priority,
        clearPriorityFilter: event.priority == null,
        filteredWorks: _applyFilters(currentState.copyWith(
          priorityFilter: event.priority,
          clearPriorityFilter: event.priority == null,
        )),
      ));
    }
  }

  List<Work> _applyFilters(WorkLoadedState state) {
    List<Work> filtered = MockDataRepository.getWorks();

    // Filter by profile
    if (state.profileFilter != null) {
      filtered = filtered.where((work) => work.profileId == state.profileFilter).toList();
    }

    // Filter by status
    if (state.statusFilter != null) {
      filtered = filtered.where((work) => work.status == state.statusFilter).toList();
    }

    // Filter by priority
    if (state.priorityFilter != null) {
      filtered = filtered.where((work) => work.priority == state.priorityFilter).toList();
    }

    // Search filter
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((work) {
        return work.title.toLowerCase().contains(query) ||
               work.description.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }
}