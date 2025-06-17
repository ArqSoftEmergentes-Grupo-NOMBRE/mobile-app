import 'package:equatable/equatable.dart';

class Developer extends Equatable {
  final String id;
  final String name;
  final int contracts;
  final int rating;

  const Developer({
    required this.id,
    required this.name,
    required this.contracts,
    required this.rating,
  });

  @override
  List<Object?> get props => [id, name, contracts, rating];
}
