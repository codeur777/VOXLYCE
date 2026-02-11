import 'package:equatable/equatable.dart';

/// Candidate Events
abstract class CandidateEvent extends Equatable {
  const CandidateEvent();

  @override
  List<Object?> get props => [];
}

class RegisterCandidate extends CandidateEvent {
  final int positionId;
  final String manifesto;

  const RegisterCandidate({
    required this.positionId,
    required this.manifesto,
  });

  @override
  List<Object?> get props => [positionId, manifesto];
}

class LoadMyCandidatures extends CandidateEvent {}

class UpdateCandidature extends CandidateEvent {
  final int candidateId;
  final String manifesto;

  const UpdateCandidature({
    required this.candidateId,
    required this.manifesto,
  });

  @override
  List<Object?> get props => [candidateId, manifesto];
}

class WithdrawCandidature extends CandidateEvent {
  final int candidateId;

  const WithdrawCandidature(this.candidateId);

  @override
  List<Object?> get props => [candidateId];
}

class PayDepositFee extends CandidateEvent {
  final int candidateId;
  final String paymentReference;

  const PayDepositFee({
    required this.candidateId,
    required this.paymentReference,
  });

  @override
  List<Object?> get props => [candidateId, paymentReference];
}

class CheckPaymentStatus extends CandidateEvent {
  final int candidateId;

  const CheckPaymentStatus(this.candidateId);

  @override
  List<Object?> get props => [candidateId];
}

class UploadStudentCard extends CandidateEvent {
  final int candidateId;
  final String photoUrl;

  const UploadStudentCard({
    required this.candidateId,
    required this.photoUrl,
  });

  @override
  List<Object?> get props => [candidateId, photoUrl];
}
