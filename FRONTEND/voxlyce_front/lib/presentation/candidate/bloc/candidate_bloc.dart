import 'package:flutter_bloc/flutter_bloc.dart';
import 'candidate_event.dart';
import 'candidate_state.dart';
import '../../../data/repositories/candidate_repository.dart';

/// Candidate BLoC
class CandidateBloc extends Bloc<CandidateEvent, CandidateState> {
  final CandidateRepository _candidateRepository;

  CandidateBloc({CandidateRepository? candidateRepository})
      : _candidateRepository = candidateRepository ?? CandidateRepository(),
        super(CandidateInitial()) {
    on<RegisterCandidate>(_onRegisterCandidate);
    on<LoadMyCandidatures>(_onLoadMyCandidatures);
    on<UpdateCandidature>(_onUpdateCandidature);
    on<WithdrawCandidature>(_onWithdrawCandidature);
    on<PayDepositFee>(_onPayDepositFee);
    on<CheckPaymentStatus>(_onCheckPaymentStatus);
    on<UploadStudentCard>(_onUploadStudentCard);
  }

  Future<void> _onRegisterCandidate(
    RegisterCandidate event,
    Emitter<CandidateState> emit,
  ) async {
    emit(CandidateLoading());
    try {
      final candidate = await _candidateRepository.applyAsCandidate(
        positionId: event.positionId,
        manifesto: event.manifesto,
      );
      emit(CandidateRegistered(candidate));
    } catch (e) {
      emit(CandidateError(e.toString()));
    }
  }

  Future<void> _onLoadMyCandidatures(
    LoadMyCandidatures event,
    Emitter<CandidateState> emit,
  ) async {
    emit(CandidateLoading());
    try {
      final candidatures = await _candidateRepository.getMyCandidatures();
      emit(MyCandidaturesLoaded(candidatures));
    } catch (e) {
      emit(CandidateError(e.toString()));
    }
  }

  Future<void> _onUpdateCandidature(
    UpdateCandidature event,
    Emitter<CandidateState> emit,
  ) async {
    emit(CandidateLoading());
    try {
      final candidate = await _candidateRepository.updateCandidature(
        id: event.candidateId,
        positionId: 0, // Will be updated from backend
        manifesto: event.manifesto,
      );
      emit(CandidateUpdated(candidate));
    } catch (e) {
      emit(CandidateError(e.toString()));
    }
  }

  Future<void> _onWithdrawCandidature(
    WithdrawCandidature event,
    Emitter<CandidateState> emit,
  ) async {
    emit(CandidateLoading());
    try {
      await _candidateRepository.withdrawCandidature(event.candidateId);
      emit(const CandidateWithdrawn('Candidature retirée avec succès'));
    } catch (e) {
      emit(CandidateError(e.toString()));
    }
  }

  Future<void> _onPayDepositFee(
    PayDepositFee event,
    Emitter<CandidateState> emit,
  ) async {
    emit(CandidateLoading());
    try {
      final payment = await _candidateRepository.payDepositFee(
        candidateId: event.candidateId,
        paymentMethod: 'MOBILE_MONEY',
        paymentReference: event.paymentReference,
        amount: 500.0,
      );
      emit(PaymentCompleted(payment));
    } catch (e) {
      emit(CandidateError(e.toString()));
    }
  }

  Future<void> _onCheckPaymentStatus(
    CheckPaymentStatus event,
    Emitter<CandidateState> emit,
  ) async {
    emit(CandidateLoading());
    try {
      final payment = await _candidateRepository.getPaymentStatus(event.candidateId);
      emit(PaymentStatusLoaded(payment));
    } catch (e) {
      emit(CandidateError(e.toString()));
    }
  }

  Future<void> _onUploadStudentCard(
    UploadStudentCard event,
    Emitter<CandidateState> emit,
  ) async {
    emit(CandidateLoading());
    try {
      await _candidateRepository.uploadStudentCard(
        candidateId: event.candidateId,
        photoUrl: event.photoUrl,
      );
      emit(const StudentCardUploaded('Carte étudiante téléchargée avec succès'));
    } catch (e) {
      emit(CandidateError(e.toString()));
    }
  }
}
