import 'package:cloud_firestore/cloud_firestore.dart';

class Streak {
  Streak({
    required this.current,
    required this.longest,
    required this.lastEntryDate,
    required this.streakStartDate,
  });
  final int current;
  final int longest;
  final Timestamp lastEntryDate;
  final Timestamp streakStartDate;
}
