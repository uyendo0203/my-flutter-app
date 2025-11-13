import 'package:equatable/equatable.dart';
import '../../models/work.dart';

abstract class WorkEvent extends Equatable {
  const WorkEvent();

  @override
  List<Object?> get props => [];
}

class LoadWorksEvent extends WorkEvent {
  final String? profileId;

  const LoadWorksEvent({this.profileId});

  @override
  List<Object?> get props => [profileId];
}

class AddWorkEvent extends WorkEvent {
  final Work work;

  const AddWorkEvent(this.work);

  @override
  List<Object> get props => [work];
}

class UpdateWorkEvent extends WorkEvent {
  final Work work;

  const UpdateWorkEvent(this.work);

  @override
  List<Object> get props => [work];
}

class DeleteWorkEvent extends WorkEvent {
  final String workId;

  const DeleteWorkEvent(this.workId);

  @override
  List<Object> get props => [workId];
}

class SearchWorksEvent extends WorkEvent {
  final String query;

  const SearchWorksEvent(this.query);

  @override
  List<Object> get props => [query];
}

class FilterWorksByStatusEvent extends WorkEvent {
  final WorkStatus? status;

  const FilterWorksByStatusEvent(this.status);

  @override
  List<Object?> get props => [status];
}

class FilterWorksByPriorityEvent extends WorkEvent {
  final WorkPriority? priority;

  const FilterWorksByPriorityEvent(this.priority);

  @override
  List<Object?> get props => [priority];
}