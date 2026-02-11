/// Events pour ResultBloc
abstract class ResultEvent {}

/// Charger les élections terminées
class LoadCompletedElections extends ResultEvent {}

/// Charger les résultats d'une élection
class LoadElectionResults extends ResultEvent {
  final int electionId;

  LoadElectionResults(this.electionId);
}

/// Exporter les résultats en PDF
class ExportResultsPDF extends ResultEvent {
  final int electionId;

  ExportResultsPDF(this.electionId);
}

/// Rafraîchir les résultats
class RefreshResults extends ResultEvent {
  final int electionId;

  RefreshResults(this.electionId);
}
