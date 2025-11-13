import '../models/work.dart';
import '../models/profile.dart';

class MockDataRepository {
  static List<Profile> _profiles = [
    const Profile(
      id: 'profile1',
      name: 'Nguyễn Văn An',
      email: 'nguyen.van.an@email.com',
      phone: '0901234567',
      bio: 'Developer với 5 năm kinh nghiệm trong Flutter và Mobile Development.',
    ),
    const Profile(
      id: 'profile2',
      name: 'Trần Thị Bình',
      email: 'tran.thi.binh@email.com',
      phone: '0912345678',
      bio: 'UI/UX Designer chuyên về thiết kế ứng dụng di động.',
    ),
    const Profile(
      id: 'profile3',
      name: 'Lê Hoàng Cường',
      email: 'le.hoang.cuong@email.com',
      phone: '0923456789',
      bio: 'Project Manager với kinh nghiệm quản lý các dự án công nghệ.',
    ),
    const Profile(
      id: 'profile4',
      name: 'Phạm Thị Duyên',
      email: 'pham.thi.duyen@email.com',
      phone: '0934567890',
      bio: 'QA Tester chuyên về automation testing và quality assurance.',
    ),
  ];

  static List<Work> _works = [
    Work(
      id: 'work1',
      title: 'Phát triển tính năng đăng nhập',
      description: 'Thiết kế và phát triển màn hình đăng nhập với xác thực đa yếu tố và tích hợp OAuth.',
      profileId: 'profile1',
      status: WorkStatus.inProgress,
      priority: WorkPriority.high,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      dueDate: DateTime.now().add(const Duration(days: 7)),
      progress: 0.7,
    ),
    Work(
      id: 'work2',
      title: 'Thiết kế giao diện trang chủ',
      description: 'Tạo mockup và prototype cho trang chủ ứng dụng với Material Design 3.',
      profileId: 'profile2',
      status: WorkStatus.completed,
      priority: WorkPriority.medium,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      completedAt: DateTime.now().subtract(const Duration(days: 1)),
      progress: 1.0,
    ),
    Work(
      id: 'work3',
      title: 'Viết tài liệu API',
      description: 'Tạo tài liệu chi tiết cho các API endpoints và integration guide.',
      profileId: 'profile3',
      status: WorkStatus.pending,
      priority: WorkPriority.urgent,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      dueDate: DateTime.now().add(const Duration(days: 2)),
      progress: 0.0,
    ),
    Work(
      id: 'work4',
      title: 'Test tính năng thanh toán',
      description: 'Kiểm tra và test toàn bộ flow thanh toán trên các thiết bị khác nhau.',
      profileId: 'profile4',
      status: WorkStatus.inProgress,
      priority: WorkPriority.high,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      dueDate: DateTime.now().add(const Duration(days: 5)),
      progress: 0.4,
    ),
    Work(
      id: 'work5',
      title: 'Tối ưu hóa performance',
      description: 'Phân tích và tối ưu hóa hiệu suất ứng dụng, giảm thời gian load và memory usage.',
      profileId: 'profile1',
      status: WorkStatus.cancelled,
      priority: WorkPriority.low,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      dueDate: DateTime.now().subtract(const Duration(days: 3)),
      progress: 0.2,
    ),
    Work(
      id: 'work6',
      title: 'Phát triển Dark Mode',
      description: 'Implement dark theme cho toàn bộ ứng dụng với dynamic switching.',
      profileId: 'profile2',
      status: WorkStatus.inProgress,
      priority: WorkPriority.medium,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      dueDate: DateTime.now().add(const Duration(days: 10)),
      progress: 0.6,
    ),
    Work(
      id: 'work7',
      title: 'Setup CI/CD Pipeline',
      description: 'Thiết lập automatic deployment và continuous integration cho project.',
      profileId: 'profile3',
      status: WorkStatus.pending,
      priority: WorkPriority.high,
      createdAt: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 14)),
      progress: 0.0,
    ),
    Work(
      id: 'work8',
      title: 'Security Audit',
      description: 'Kiểm tra bảo mật ứng dụng và fix các vulnerability được phát hiện.',
      profileId: 'profile4',
      status: WorkStatus.pending,
      priority: WorkPriority.urgent,
      createdAt: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 3)),
      progress: 0.0,
    ),
  ];

  // Profile methods
  static List<Profile> getProfiles() {
    return List.from(_profiles);
  }

  static Profile? getProfile(String id) {
    try {
      return _profiles.firstWhere((profile) => profile.id == id);
    } catch (e) {
      return null;
    }
  }

  static String addProfile(Profile profile) {
    _profiles.add(profile);
    return profile.id;
  }

  static bool updateProfile(Profile profile) {
    final index = _profiles.indexWhere((p) => p.id == profile.id);
    if (index != -1) {
      _profiles[index] = profile;
      return true;
    }
    return false;
  }

  static bool deleteProfile(String id) {
    final index = _profiles.indexWhere((p) => p.id == id);
    if (index != -1) {
      _profiles.removeAt(index);
      // Also remove all works associated with this profile
      _works.removeWhere((work) => work.profileId == id);
      return true;
    }
    return false;
  }

  // Work methods
  static List<Work> getWorks({String? profileId}) {
    if (profileId != null) {
      return _works.where((work) => work.profileId == profileId).toList();
    }
    return List.from(_works);
  }

  static Work? getWork(String id) {
    try {
      return _works.firstWhere((work) => work.id == id);
    } catch (e) {
      return null;
    }
  }

  static String addWork(Work work) {
    _works.add(work);
    return work.id;
  }

  static bool updateWork(Work work) {
    final index = _works.indexWhere((w) => w.id == work.id);
    if (index != -1) {
      _works[index] = work;
      return true;
    }
    return false;
  }

  static bool deleteWork(String id) {
    final index = _works.indexWhere((w) => w.id == id);
    if (index != -1) {
      _works.removeAt(index);
      return true;
    }
    return false;
  }

  static List<Work> searchWorks(String query) {
    if (query.isEmpty) return getWorks();
    
    final lowerQuery = query.toLowerCase();
    return _works.where((work) =>
        work.title.toLowerCase().contains(lowerQuery) ||
        work.description.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  static List<Work> filterWorks({
    WorkStatus? status,
    WorkPriority? priority,
    String? profileId,
  }) {
    List<Work> filtered = getWorks(profileId: profileId);
    
    if (status != null) {
      filtered = filtered.where((work) => work.status == status).toList();
    }
    
    if (priority != null) {
      filtered = filtered.where((work) => work.priority == priority).toList();
    }
    
    return filtered;
  }

  // Utility methods
  static int getWorkCountByStatus(WorkStatus status, {String? profileId}) {
    return filterWorks(status: status, profileId: profileId).length;
  }

  static int getOverdueWorksCount({String? profileId}) {
    final works = getWorks(profileId: profileId);
    return works.where((work) => 
        work.dueDate != null && 
        work.dueDate!.isBefore(DateTime.now()) &&
        work.status != WorkStatus.completed &&
        work.status != WorkStatus.cancelled
    ).length;
  }

  static double getAverageProgress({String? profileId}) {
    final works = getWorks(profileId: profileId);
    if (works.isEmpty) return 0.0;
    
    final totalProgress = works.fold(0.0, (sum, work) => sum + work.progress);
    return totalProgress / works.length;
  }

  static List<Work> getRecentWorks({int limit = 5, String? profileId}) {
    final works = getWorks(profileId: profileId);
    works.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return works.take(limit).toList();
  }

  static List<Work> getUpcomingDeadlines({int days = 7, String? profileId}) {
    final now = DateTime.now();
    final future = now.add(Duration(days: days));
    
    final works = getWorks(profileId: profileId);
    return works.where((work) =>
        work.dueDate != null &&
        work.dueDate!.isAfter(now) &&
        work.dueDate!.isBefore(future) &&
        work.status != WorkStatus.completed &&
        work.status != WorkStatus.cancelled
    ).toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
  }
}