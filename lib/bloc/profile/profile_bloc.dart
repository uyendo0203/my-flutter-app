import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/mock_data_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfiles>(_onLoadProfiles);
    on<AddProfile>(_onAddProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<DeleteProfile>(_onDeleteProfile);
  }

  void _onLoadProfiles(LoadProfiles event, Emitter<ProfileState> emit) {
    emit(ProfileLoading());
    try {
      emit(ProfileLoaded(MockDataRepository.getProfiles()));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void _onAddProfile(AddProfile event, Emitter<ProfileState> emit) {
    try {
      MockDataRepository.addProfile(event.profile);
      emit(ProfileLoaded(MockDataRepository.getProfiles()));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) {
    try {
      final success = MockDataRepository.updateProfile(event.profile);
      if (success) {
        emit(ProfileLoaded(MockDataRepository.getProfiles()));
      } else {
        emit(const ProfileError('Profile not found'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void _onDeleteProfile(DeleteProfile event, Emitter<ProfileState> emit) {
    try {
      MockDataRepository.deleteProfile(event.id);
      emit(ProfileLoaded(MockDataRepository.getProfiles()));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}