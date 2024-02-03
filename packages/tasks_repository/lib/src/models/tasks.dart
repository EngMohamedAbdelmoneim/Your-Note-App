import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  String userId;
  final String title;
  final String description;
  final DateTime date;
  final bool isDone;
  final bool isImportant;

  // Standard constructor
  TaskModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.date,
    required this.isDone,
    required this.isImportant
  });

  // Named constructor or factory method to create a new TaskModel with userId
  TaskModel.withUserId({
    required this.id,
    required String userId,
    required this.title,
    required this.description,
    required this.date,
    required this.isDone,
    required this.isImportant

  }) : userId = userId;

  // Convert TaskModel to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'isDone': isDone,
      'isImportant': isImportant,
      'date': date,
    };
  }

  // Create a TaskModel from a map retrieved from Firestore
  factory TaskModel.fromMap(Map<String, dynamic> map, String id) {
    return TaskModel(
      id: id,
      userId: map['userId'],
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'],
      isImportant: map['isImportant'],
      date: (map['date'] as Timestamp).toDate(),

    );
  }
  TaskModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    bool? isDone,
    bool? isImportant,
    DateTime? date,
  }) {
    return TaskModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        description: description ?? this.description,
        isDone: isDone ?? this.isDone,
        date: date ?? this.date,
        isImportant : isImportant ?? this.isImportant
    );
  }
}

