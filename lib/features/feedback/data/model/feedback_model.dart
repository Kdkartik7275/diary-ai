import '../../domain/entity/feedback_entity.dart';

class FeedbackModel extends FeedbackEntity {
  FeedbackModel({
    required super.id,
    required super.type,
    required super.email,
    required super.bugCategory,
    required super.rating,
    required super.description,
    required super.userId,
  });

  factory FeedbackModel.fromMap(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: _feedbackTypeFromString(json['type'] as String),
      email: json['email'] as String?,
      bugCategory: json['bugCategory'] as String?,
      rating: json['rating'] as int?,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': _feedbackTypeToString(type),
      'email': email,
      'bugCategory': bugCategory,
      'rating': rating,
      'description': description,
    };
  }

  FeedbackModel copyWith({
    String? id,
    String? userId,
    FeedbackType? type,
    String? email,
    String? bugCategory,
    int? rating,
    String? description,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      email: email ?? this.email,
      bugCategory: bugCategory ?? this.bugCategory,
      rating: rating ?? this.rating,
      description: description ?? this.description,
    );
  }

  static FeedbackType _feedbackTypeFromString(String value) {
    switch (value) {
      case 'bug':
        return FeedbackType.bug;
      case 'idea':
        return FeedbackType.idea;
      case 'general':
        return FeedbackType.general;
      default:
        return FeedbackType.general;
    }
  }

  static String _feedbackTypeToString(FeedbackType type) {
    return type.name;
  }
}
