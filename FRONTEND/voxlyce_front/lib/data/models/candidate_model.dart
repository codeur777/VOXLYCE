import 'user_model.dart';
import 'position_model.dart';

/// Candidate Model
class CandidateModel {
  final int id;
  final UserModel user;
  final PositionModel position;
  final String manifesto;
  final String status;
  final String? studentCardPhotoUrl;
  final bool depositFeePaid;
  final double depositFeeAmount;
  final String? paymentReference;
  final DateTime? paymentDate;

  CandidateModel({
    required this.id,
    required this.user,
    required this.position,
    required this.manifesto,
    required this.status,
    this.studentCardPhotoUrl,
    required this.depositFeePaid,
    required this.depositFeeAmount,
    this.paymentReference,
    this.paymentDate,
  });

  factory CandidateModel.fromJson(Map<String, dynamic> json) {
    return CandidateModel(
      id: json['id'] as int,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      position: PositionModel.fromJson(json['position'] as Map<String, dynamic>),
      manifesto: json['manifesto'] as String,
      status: json['status'] as String,
      studentCardPhotoUrl: json['studentCardPhotoUrl'] as String?,
      depositFeePaid: json['depositFeePaid'] as bool? ?? false,
      depositFeeAmount: (json['depositFeeAmount'] as num?)?.toDouble() ?? 500.0,
      paymentReference: json['paymentReference'] as String?,
      paymentDate: json['paymentDate'] != null
          ? DateTime.parse(json['paymentDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'position': position.toJson(),
      'manifesto': manifesto,
      'status': status,
      'studentCardPhotoUrl': studentCardPhotoUrl,
      'depositFeePaid': depositFeePaid,
      'depositFeeAmount': depositFeeAmount,
      'paymentReference': paymentReference,
      'paymentDate': paymentDate?.toIso8601String(),
    };
  }

  bool get isPending => status == 'PENDING';
  bool get isAccepted => status == 'ACCEPTED';
  bool get isRejected => status == 'REJECTED';
  bool get isWithdrawn => status == 'WITHDRAWN';
}
