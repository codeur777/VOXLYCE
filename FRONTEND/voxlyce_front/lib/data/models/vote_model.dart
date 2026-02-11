import 'package:equatable/equatable.dart';

class VoteModel extends Equatable {
  final int id;
  final int electionId;
  final String electionTitle;
  final int candidateId;
  final String candidateName;
  final int positionId;
  final String positionName;
  final DateTime votedAt;
  final String status; // COMPLETED, ONGOING
  final String? classroom;

  const VoteModel({
    required this.id,
    required this.electionId,
    required this.electionTitle,
    required this.candidateId,
    required this.candidateName,
    required this.positionId,
    required this.positionName,
    required this.votedAt,
    required this.status,
    this.classroom,
  });

  factory VoteModel.fromJson(Map<String, dynamic> json) {
    return VoteModel(
      id: json['id'] as int,
      electionId: json['electionId'] as int,
      electionTitle: json['electionTitle'] as String,
      candidateId: json['candidateId'] as int,
      candidateName: json['candidateName'] as String,
      positionId: json['positionId'] as int,
      positionName: json['positionName'] as String,
      votedAt: DateTime.parse(json['votedAt'] as String),
      status: json['status'] as String,
      classroom: json['classroom'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'electionId': electionId,
      'electionTitle': electionTitle,
      'candidateId': candidateId,
      'candidateName': candidateName,
      'positionId': positionId,
      'positionName': positionName,
      'votedAt': votedAt.toIso8601String(),
      'status': status,
      'classroom': classroom,
    };
  }

  @override
  List<Object?> get props => [
        id,
        electionId,
        electionTitle,
        candidateId,
        candidateName,
        positionId,
        positionName,
        votedAt,
        status,
        classroom,
      ];
}
