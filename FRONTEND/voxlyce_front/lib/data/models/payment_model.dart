/// Payment Response Model
class PaymentResponseModel {
  final int candidateId;
  final bool paid;
  final double amount;
  final String? paymentReference;
  final DateTime? paymentDate;
  final String message;

  PaymentResponseModel({
    required this.candidateId,
    required this.paid,
    required this.amount,
    this.paymentReference,
    this.paymentDate,
    required this.message,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      candidateId: json['candidateId'] as int,
      paid: json['paid'] as bool,
      amount: (json['amount'] as num).toDouble(),
      paymentReference: json['paymentReference'] as String?,
      paymentDate: json['paymentDate'] != null
          ? DateTime.parse(json['paymentDate'] as String)
          : null,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'candidateId': candidateId,
      'paid': paid,
      'amount': amount,
      'paymentReference': paymentReference,
      'paymentDate': paymentDate?.toIso8601String(),
      'message': message,
    };
  }
}

/// Payment Request Model
class PaymentRequestModel {
  final int candidateId;
  final String paymentMethod;
  final String paymentReference;
  final double amount;

  PaymentRequestModel({
    required this.candidateId,
    required this.paymentMethod,
    required this.paymentReference,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'candidateId': candidateId,
      'paymentMethod': paymentMethod,
      'paymentReference': paymentReference,
      'amount': amount,
    };
  }
}
