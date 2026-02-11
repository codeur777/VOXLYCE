import 'package:equatable/equatable.dart';
import '../../../data/models/candidate_model.dart';
import '../../../data/models/payment_model.dart';

/// Candidate States
abstract class CandidateState extends Equatable {
  const CandidateState();

  @override
  List<Object?> get props => [];
}

class CandidateInitial extends CandidateState {}

class CandidateLoading extends CandidateState {}

class CandidateRegistered extends CandidateState {
  final CandidateModel candidate;

  const CandidateRegistered(this.candidate);

  @override
  List<Object?> get props => [candidate];
}

class MyCandidaturesLoaded extends CandidateState {
  final List<CandidateModel> candidatures;

  const MyCandidaturesLoaded(this.candidatures);

  @override
  List<Object?> get props => [candidatures];
}

class CandidateUpdated extends CandidateState {
  final CandidateModel candidate;

  const CandidateUpdated(this.candidate);

  @override
  List<Object?> get props => [candidate];
}

class CandidateWithdrawn extends CandidateState {
  final String message;

  const CandidateWithdrawn(this.message);

  @override
  List<Object?> get props => [message];
}

class PaymentCompleted extends CandidateState {
  final PaymentResponseModel payment;

  const PaymentCompleted(this.payment);

  @override
  List<Object?> get props => [payment];
}

class PaymentStatusLoaded extends CandidateState {
  final PaymentResponseModel payment;

  const PaymentStatusLoaded(this.payment);

  @override
  List<Object?> get props => [payment];
}

class StudentCardUploaded extends CandidateState {
  final String message;

  const StudentCardUploaded(this.message);

  @override
  List<Object?> get props => [message];
}

class CandidateError extends CandidateState {
  final String message;

  const CandidateError(this.message);

  @override
  List<Object?> get props => [message];
}
