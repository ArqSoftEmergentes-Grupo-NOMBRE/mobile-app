import 'package:equatable/equatable.dart';
import 'enums.dart';
import 'milestone.dart';

class Contract extends Equatable {
  final String id;
  final String developerId;
  final String developerName;
  final String developerPhotoUrl;
  final DateTime createdAt;
  final String projectTitle;
  final String projectDescription;
  final List<Milestone> milestones;
  final ContractStatus status;

  const Contract({
    required this.id,
    required this.developerId,
    required this.developerName,
    required this.developerPhotoUrl,
    required this.createdAt,
    required this.projectTitle,
    required this.projectDescription,
    required this.milestones,
    required this.status,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      id:                  json['id']                   as String,
      developerId:         json['developerId']          as String,
      developerName:       json['developerName']        as String?  ?? '',
      developerPhotoUrl:   json['developerPhotoUrl']    as String?  ?? '',
      createdAt:           DateTime.tryParse(json['createdAt'] as String? ?? '')
          ?? DateTime.now(),
      projectTitle:        json['projectTitle']         as String,
      projectDescription:  json['projectDescription']   as String,
      status:              ContractStatusX.fromString(
          json['status'] as String? ?? ''),
      milestones:          (json['milestones'] as List<dynamic>? ?? [])
          .map((e) => Milestone.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'developerId': developerId,
    'developerName': developerName,
    'developerPhotoUrl': developerPhotoUrl,
    'createdAt': createdAt.toIso8601String(),
    'projectTitle': projectTitle,
    'projectDescription': projectDescription,
    'status': status.backendValue,
    'milestones': milestones.map((m) => m.toJson()).toList(),
  };

  @override
  List<Object?> get props => [
    id,
    developerId,
    developerName,
    developerPhotoUrl,
    createdAt,
    projectTitle,
    projectDescription,
    milestones,
    status,
  ];
}
