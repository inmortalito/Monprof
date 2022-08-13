import 'courses_model.dart';

class WishListModal {
  int id;
  String userId;
  String courseId;
  String createdAt;
  String updatedAt;
  CoursesModel course;

  WishListModal(this.id, this.userId, this.courseId, this.createdAt,
      this.updatedAt, this.course);
}