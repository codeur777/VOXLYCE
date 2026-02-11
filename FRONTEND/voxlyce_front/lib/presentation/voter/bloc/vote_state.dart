import 'package:equatable/equatable.dart';
import '../../../data/models/election_model.dart';
import '../../../data/models/candidate_model.dart';
import '../../../data/models/vote_model.dart';

/// Vote States
abstract class VoteState extends Equatable {
  const VoteState();

  @override
  List<Object?> get props => [];
}

class VoteInitial extends VoteState {}

class VoteLoading extends VoteState {}

class ElectionsLoaded extends VoteState {
  final List<ElectionModel> elections;

  const ElectionsLoaded(this.elections);

  @override
  List<Object?> get props => [elections];
}

class ElectionDetailsLoaded extends VoteState {
  final ElectionModel election;
  final List<CandidateModel> candidates;
  final Map<String, dynamic> votingStatus;

  const ElectionDetailsLoaded({
    required this.election,
    required this.candidates,
    required this.votingStatus,
  });

  @override
  List<Object?> get props => [election, candidates, votingStatus];
}

class VoteSubmitted extends VoteState {
  final String message;

  const VoteSubmitted(this.message);

  @override
  List<Object?> get props => [message];
}

class VoteResultsLoaded extends VoteState {
  final Map<String, dynamic> results;

  const VoteResultsLoaded(this.results);

  @override
  List<Object?> get props => [results];
}

class VoteHistoryLoaded extends VoteState {
  final List<VoteModel> votes;

  const VoteHistoryLoaded(this.votes);

  @override
  List<Object?> get props => [votes];
}

class VoteError extends VoteState {
  final String message;

  const VoteError(this.message);

  @override
  List<Object?> get props => [message];
}
