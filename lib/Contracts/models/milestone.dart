import 'package:equatable/equatable.dart';

class Milestone extends Equatable {
  final String id;
  final String description;
  final double amount;
  final DateTime deadline;

  const Milestone({
    required this.id,
    required this.description,
    required this.amount,
    required this.deadline,
  });

  Milestone copyWith({
    String? description,
    double? amount,
    DateTime? deadline,
  }) {
    return Milestone(
      id: id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      deadline: deadline ?? this.deadline,
    );
  }

  factory Milestone.fromJson(Map<String, dynamic> j) {
    return Milestone(
      id: j['id'] as String,
      description: j['description'] as String,
      amount: (j['amount'] as num).toDouble(),
      deadline: DateTime.parse(j['deadline'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'amount': amount,
    'deadline': deadline.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, description, amount, deadline];
}
