enum FeedbackType { bug, idea, general }

class FeedbackEntity {
  final String id;
  final String userId;
  final FeedbackType type;
  final String? email;
  final String? bugCategory;
  final int? rating;
  final String description;

  FeedbackEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.email,
    required this.bugCategory,
    required this.rating,
    required this.description,
  });
}
