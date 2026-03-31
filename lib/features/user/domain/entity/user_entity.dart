// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  final String id;
  final String fullName;
  final String? username;
  final String? bio;
  final bool? isStoriesPublic;
  final bool? profileVisibility;
  final bool? isDeleted;
  final Timestamp? deletedAt;
  final String email;
  final String? profileUrl;
  final String? phone;
  final String? location;
  final Timestamp createdAt;

  UserEntity({
    required this.id,
    required this.fullName,
    this.username,
    this.bio,
    this.isDeleted,
    this.deletedAt,
    this.isStoriesPublic,
    this.profileVisibility,
    required this.email,
    this.profileUrl,
    this.phone,
    this.location,
    required this.createdAt,
  });
}
