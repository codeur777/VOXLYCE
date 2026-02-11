import 'package:flutter_bloc/flutter_bloc.dart';
import 'vote_event.dart';
import 'vote_state.dart';
import '../../../data/repositories/election_repository.dart';
import '../../../data/repositories/vote_repository.dart';

/// Vote BLoC
class VoteBloc extends Bloc<VoteEvent, VoteState> {
  final ElectionRepository _electionRepository;
  final VoteRepository _voteRepository;

  VoteBloc({
    ElectionRepository? electionRepository,
    VoteRepository? voteRepository,
  })  : _electionRepository = electionRepository ?? ElectionRepository(),
        _voteRepository = voteRepository ?? VoteRepository(),
        super(VoteInitial()) {
    on<LoadElections>(_onLoadElections);
    on<LoadElectionDetails>(_onLoadElectionDetails);
    on<SubmitVote>(_onSubmitVote);
    on<LoadElectionResults>(_onLoadElectionResults);
    on<LoadVoteHistory>(_onLoadVoteHistory);
  }

  Future<void> _onLoadElections(
    LoadElections event,
    Emitter<VoteState> emit,
  ) async {
    emit(VoteLoading());
    try {
      final elections = await _electionRepository.getElections();
      emit(ElectionsLoaded(elections));
    } catch (e) {
      emit(VoteError(e.toString()));
    }
  }

  Future<void> _onLoadElectionDetails(
    LoadElectionDetails event,
    Emitter<VoteState> emit,
  ) async {
    emit(VoteLoading());
    try {
      final election = await _electionRepository.getElectionDetails(event.electionId);
      final candidates = await _voteRepository.getElectionCandidates(event.electionId);
      final votingStatus = await _voteRepository.getVotingStatus(event.electionId);

      emit(ElectionDetailsLoaded(
        election: election,
        candidates: candidates,
        votingStatus: votingStatus,
      ));
    } catch (e) {
      emit(VoteError(e.toString()));
    }
  }

  Future<void> _onSubmitVote(
    SubmitVote event,
    Emitter<VoteState> emit,
  ) async {
    emit(VoteLoading());
    try {
      await _voteRepository.submitVote(
        electionId: event.electionId,
        votes: event.votes,
      );
      emit(const VoteSubmitted('Vote soumis avec succès!'));
    } catch (e) {
      emit(VoteError(e.toString()));
    }
  }

  Future<void> _onLoadElectionResults(
    LoadElectionResults event,
    Emitter<VoteState> emit,
  ) async {
    emit(VoteLoading());
    try {
      final results = await _voteRepository.getElectionResults(event.electionId);
      emit(VoteResultsLoaded(results));
    } catch (e) {
      emit(VoteError(e.toString()));
    }
  }

  Future<void> _onLoadVoteHistory(
    LoadVoteHistory event,
    Emitter<VoteState> emit,
  ) async {
    emit(VoteLoading());
    try {
      final votes = await _voteRepository.getVoteHistory(
        statusFilter: event.statusFilter,
      );
      emit(VoteHistoryLoaded(votes));
    } catch (e) {
      emit(VoteError(e.toString()));
    }
  }
}
