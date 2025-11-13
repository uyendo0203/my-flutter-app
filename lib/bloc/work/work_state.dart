import 'package:equatable/equatable.dart';
import '../../models/work.dart';

abstract class WorkState extends Equatable {
  const WorkState();

  @override
  List<Object?> get props => [];
}

class WorkInitialState extends WorkState {
  const WorkInitialState();
}

class WorkLoadingState extends WorkState {
  const WorkLoadingState();
}

class WorkLoadedState extends WorkState {
  final List<Work> works;
  final List<Work> filteredWorks;
  final String searchQuery;
  final WorkStatus? statusFilter;
  final WorkPriority? priorityFilter;
  final String? profileFilter;

  const WorkLoadedState({
    required this.works,
    required this.filteredWorks,
    this.searchQuery = '',
    this.statusFilter,
    this.priorityFilter,
    this.profileFilter,
  });

  @override
  List<Object?> get props => [
        works,
        filteredWorks,
        searchQuery,
        statusFilter,
        priorityFilter,
        profileFilter,
      ];

  WorkLoadedState copyWith({
    List<Work>? works,
    List<Work>? filteredWorks,
    String? searchQuery,
    WorkStatus? statusFilter,
    WorkPriority? priorityFilter,
    String? profileFilter,
    bool clearStatusFilter = false,
    bool clearPriorityFilter = false,
    bool clearProfileFilter = false,
  }) {
    return WorkLoadedState(
      works: works ?? this.works,
      filteredWorks: filteredWorks ?? this.filteredWorks,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      priorityFilter: clearPriorityFilter ? null : (priorityFilter ?? this.priorityFilter),
      profileFilter: clearProfileFilter ? null : (profileFilter ?? this.profileFilter),
    );
  }
}

class WorkErrorState extends WorkState {
  final String message;

  const WorkErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class WorkActionSuccessState extends WorkState {
  final String message;

  const WorkActionSuccessState(this.message);

  @override
  List<Object> get props => [message];
}