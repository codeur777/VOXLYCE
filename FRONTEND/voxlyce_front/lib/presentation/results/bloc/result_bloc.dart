import 'package:flutter_bloc/flutter_bloc.dart';
import 'result_event.dart';
import 'result_state.dart';
import '../../../data/repositories/result_repository_impl.dart';
import '../../../data/models/result_model.dart';

/// BLoC pour la gestion des résultats
class ResultBloc extends Bloc<ResultEvent, ResultState> {
  final ResultRepositoryImpl _resultRepository;

  ResultBloc({ResultRepositoryImpl? resultRepository})
      : _resultRepository = resultRepository ?? ResultRepositoryImpl(),
        super(ResultInitial()) {
    on<LoadCompletedElections>(_onLoadCompletedElections);
    on<LoadElectionResults>(_onLoadElectionResults);
    on<ExportResultsPDF>(_onExportResultsPDF);
    on<RefreshResults>(_onRefreshResults);
  }

  Future<void> _onLoadCompletedElections(
    LoadCompletedElections event,
    Emitter<ResultState> emit,
  ) async {
    emit(ResultLoading());
    try {
      final elections = await _resultRepository.getCompletedElections();
      emit(CompletedElectionsLoaded(elections));
    } catch (e) {
      emit(ResultError('Erreur lors du chargement des élections: ${e.toString()}'));
    }
  }

  Future<void> _onLoadElectionResults(
    LoadElectionResults event,
    Emitter<ResultState> emit,
  ) async {
    emit(ResultLoading());
    try {
      // TODO: Replace with actual API call
      // For now, create mock data
      final result = ResultModel(
        electionId: event.electionId,
        electionTitle: 'Élection Mock',
        positions: [
          PositionResult(
            positionId: 1,
            positionName: 'Président',
            totalVotes: 86,
            candidates: [
              CandidateResult(
                candidateId: 1,
                candidateName: 'Jean Dupont',
                votes: 45,
                percentage: 52.3,
                isWinner: true,
              ),
              CandidateResult(
                candidateId: 2,
                candidateName: 'Marie Martin',
                votes: 35,
                percentage: 40.7,
                isWinner: false,
              ),
              CandidateResult(
                candidateId: 3,
                candidateName: 'Pierre Durand',
                votes: 6,
                percentage: 7.0,
                isWinner: false,
              ),
            ],
          ),
          PositionResult(
            positionId: 2,
            positionName: 'Vice-Président',
            totalVotes: 86,
            candidates: [
              CandidateResult(
                candidateId: 4,
                candidateName: 'Sophie Bernard',
                votes: 50,
                percentage: 58.1,
                isWinner: true,
              ),
              CandidateResult(
                candidateId: 5,
                candidateName: 'Luc Petit',
                votes: 36,
                percentage: 41.9,
                isWinner: false,
              ),
            ],
          ),
        ],
        totalVotes: 172,
        participationRate: 85.0,
        completedAt: DateTime.now(),
      );
      
      emit(ElectionResultsLoaded(result: result));
    } catch (e) {
      emit(ResultError('Erreur lors du chargement des résultats: ${e.toString()}'));
    }
  }

  Future<void> _onExportResultsPDF(
    ExportResultsPDF event,
    Emitter<ResultState> emit,
  ) async {
    try {
      // TODO: Implémenter l'export PDF
      final filePath = '/path/to/results_${event.electionId}.pdf';
      emit(ResultsExported(filePath));
    } catch (e) {
      emit(ResultError('Erreur lors de l\'export PDF: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshResults(
    RefreshResults event,
    Emitter<ResultState> emit,
  ) async {
    // Recharger les résultats
    add(LoadElectionResults(event.electionId));
  }
}
