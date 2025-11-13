import 'package:equatable/equatable.dart';
import '../../models/profile.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfiles extends ProfileEvent {}

class AddProfile extends ProfileEvent {
  final Profile profile;

  const AddProfile(this.profile);

  @override
  List<Object> get props => [profile];
}

class UpdateProfile extends ProfileEvent {
  final Profile profile;

  const UpdateProfile(this.profile);

  @override
  List<Object> get props => [profile];
}

class DeleteProfile extends ProfileEvent {
  final String id;

  const DeleteProfile(this.id);

  @override
  List<Object> get props => [id];
}