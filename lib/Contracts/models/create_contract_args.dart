import 'package:equatable/equatable.dart';
import 'milestone.dart';

class CreateContractArgs extends Equatable {
  final String developerId;
  final String title;
  final String description;
  final String? referenceFile;
  final List<Milestone> milestones;

  const CreateContractArgs({
    required this.developerId,
    required this.title,
    required this.description,
    this.referenceFile,
    required this.milestones,
  });

  @override
  List<Object?> get props =>
      [developerId, title, description, referenceFile, milestones];
}
