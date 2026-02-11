/// Position Model
class PositionModel {
  final int id;
  final String name;
  final String? description;

  PositionModel({
    required this.id,
    required this.name,
    this.description,
  });

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
