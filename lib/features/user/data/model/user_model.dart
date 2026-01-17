import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeline/features/user/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.createdAt,
    super.username,
    super.bio,
    super.isStoriesPublic,
    super.profileVisibility,
    super.profileUrl,
    super.location,
    super.phone,
    
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? username,
    String? bio,
    bool? isStoriesPublic,
    bool? profileVisibility,
    String? email,
    String? profileUrl,
    String? phone,
    String? location,
    Timestamp? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      isStoriesPublic: isStoriesPublic ?? this.isStoriesPublic,
      profileVisibility: profileVisibility ?? this.profileVisibility,
      email: email ?? this.email,
      profileUrl: profileUrl ?? this.profileUrl,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'bio': bio,
      'isStoriesPublic': isStoriesPublic,
      'profileVisibility': profileVisibility,
      'email': email,
      'profileUrl': profileUrl,
      'createdAt': createdAt,
      'phone':phone,
      'location':location
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      username: map['username'] ?? '',
      bio: map['bio'] ?? '',
      isStoriesPublic: map['isStoriesPublic'] ?? false,
      profileVisibility: map['profileVisibility'] ?? false,
      email: map['email'] ?? '',
      profileUrl: map['profileUrl'] ?? '',
      location: map['location'] ?? '',
      phone: map['phone'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() => toMap();




  Map<String, dynamic> toSql() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'bio': bio,
      'isStoriesPublic': isStoriesPublic == true ? 1 : 0,
      'profileVisibility': profileVisibility == true ? 1 : 0,
      'email': email,
      'profileUrl': profileUrl,
      'phone': phone,
      'location': location,
      'createdAt': createdAt.toDate().toIso8601String(),
    };
  }

  factory UserModel.fromSql(Map<String, dynamic> row) {
    return UserModel(
      id: row['id'] ?? '',
      fullName: row['fullName'] ?? '',
      username: row['username'],
      bio: row['bio'],
      isStoriesPublic: row['isStoriesPublic'] == 1,
      profileVisibility: row['profileVisibility'] == 1,
      email: row['email'] ?? '',
      profileUrl: row['profileUrl'],
      phone: row['phone'],
      location: row['location'],
      createdAt: Timestamp.fromDate(
        DateTime.tryParse(row['createdAt'] ?? '') ?? DateTime.now(),
      ),
    );
  }
}
