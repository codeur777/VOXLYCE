import '../../../data/models/election_model.dart';
import '../../../data/models/result_model.dart';

/// States pour ResultBloc
abstract class ResultState {}

/// État initial
class ResultInitial extends ResultState {}

/// Chargement en cours
class ResultLoading extends ResultState {}

/// Élections terminées chargées
class CompletedElectionsLoaded extends ResultState {
  final List<ElectionModel> elections;

  CompletedElectionsLoaded(this.elections);
}

/// Résultats d'une élection chargés
class ElectionResultsLoaded extends ResultState {
  final ResultModel result;

  ElectionResultsLoaded({
    required this.result,
  });
}

/// Export PDF réussi
class ResultsExported extends ResultState {
  final String filePath;

  ResultsExported(this.filePath);
}

/// Erreur
class ResultError extends ResultState {
  final String message;

  ResultError(this.message);
}
