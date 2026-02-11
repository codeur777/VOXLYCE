import 'package:equatable/equatable.dart';

/// Vote Events
abstract class VoteEvent extends Equatable {
  const VoteEvent();

  @override
  List<Object?> get props => [];
}

class LoadElections extends VoteEvent {}

class LoadElectionDetails extends VoteEvent {
  final int electionId;

  const LoadElectionDetails(this.electionId);

  @override
  List<Object?> get props => [electionId];
}

class SubmitVote extends VoteEvent {
  final int electionId;
  final Map<int, int> votes; // positionId -> candidateId

  const SubmitVote({
    required this.electionId,
    required this.votes,
  });

  @override
  List<Object?> get props => [electionId, votes];
}

class LoadElectionResults extends VoteEvent {
  final int electionId;

  const LoadElectionResults(this.electionId);

  @override
  List<Object?> get props => [electionId];
}

class LoadVoteHistory extends VoteEvent {
  final String? statusFilter; // ALL, COMPLETED, ONGOING

  const LoadVoteHistory({this.statusFilter});

  @override
  List<Object?> get props => [statusFilter];
}
