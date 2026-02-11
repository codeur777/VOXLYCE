import 'position_model.dart';

/// Election Model
class ElectionModel {
  final int id;
  final String title;
  final String type;
  final String status;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? classroom;
  final List<PositionModel>? positions;

  ElectionModel({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    this.startTime,
    this.endTime,
    this.classroom,
    this.positions,
  });

  factory ElectionModel.fromJson(Map<String, dynamic> json) {
    return ElectionModel(
      id: json['id'] as int,
      title: json['title'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      startTime: json['startTime'] != null 
          ? DateTime.parse(json['startTime'] as String)
          : null,
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      classroom: json['classroom'] as String?,
      positions: json['positions'] != null
          ? (json['positions'] as List)
              .map((p) => PositionModel.fromJson(p as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'status': status,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'classroom': classroom,
      'positions': positions?.map((p) => p.toJson()).toList(),
    };
  }

  bool get isPending => status == 'PENDING';
  bool get isOngoing => status == 'ONGOING';
  bool get isValidated => status == 'VALIDATED';
  bool get isCommitteeVote => type == 'COMMITTEE_VOTE';
  bool get isClassVote => type == 'CLASS_VOTE';
}
