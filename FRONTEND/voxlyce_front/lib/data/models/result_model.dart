import 'package:equatable/equatable.dart';

class ResultModel extends Equatable {
  final int electionId;
  final String electionTitle;
  final List<PositionResult> positions;
  final int totalVotes;
  final double participationRate;
  final DateTime? completedAt;

  const ResultModel({
    required this.electionId,
    required this.electionTitle,
    required this.positions,
    required this.totalVotes,
    required this.participationRate,
    this.completedAt,
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      electionId: json['electionId'] as int,
      electionTitle: json['electionTitle'] as String,
      positions: (json['positions'] as List)
          .map((p) => PositionResult.fromJson(p as Map<String, dynamic>))
          .toList(),
      totalVotes: json['totalVotes'] as int,
      participationRate: (json['participationRate'] as num).toDouble(),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'electionId': electionId,
      'electionTitle': electionTitle,
      'positions': positions.map((p) => p.toJson()).toList(),
      'totalVotes': totalVotes,
      'participationRate': participationRate,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        electionId,
        electionTitle,
        positions,
        totalVotes,
        participationRate,
        completedAt,
      ];
}

class PositionResult extends Equatable {
  final int positionId;
  final String positionName;
  final List<CandidateResult> candidates;
  final int totalVotes;

  const PositionResult({
    required this.positionId,
    required this.positionName,
    required this.candidates,
    required this.totalVotes,
  });

  factory PositionResult.fromJson(Map<String, dynamic> json) {
    return PositionResult(
      positionId: json['positionId'] as int,
      positionName: json['positionName'] as String,
      candidates: (json['candidates'] as List)
          .map((c) => CandidateResult.fromJson(c as Map<String, dynamic>))
          .toList(),
      totalVotes: json['totalVotes'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'positionId': positionId,
      'positionName': positionName,
      'candidates': candidates.map((c) => c.toJson()).toList(),
      'totalVotes': totalVotes,
    };
  }

  @override
  List<Object?> get props => [positionId, positionName, candidates, totalVotes];
}

class CandidateResult extends Equatable {
  final int candidateId;
  final String candidateName;
  final int votes;
  final double percentage;
  final bool isWinner;

  const CandidateResult({
    required this.candidateId,
    required this.candidateName,
    required this.votes,
    required this.percentage,
    required this.isWinner,
  });

  factory CandidateResult.fromJson(Map<String, dynamic> json) {
    return CandidateResult(
      candidateId: json['candidateId'] as int,
      candidateName: json['candidateName'] as String,
      votes: json['votes'] as int,
      percentage: (json['percentage'] as num).toDouble(),
      isWinner: json['isWinner'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'candidateId': candidateId,
      'candidateName': candidateName,
      'votes': votes,
      'percentage': percentage,
      'isWinner': isWinner,
    };
  }

  @override
  List<Object?> get props =>
      [candidateId, candidateName, votes, percentage, isWinner];
}
