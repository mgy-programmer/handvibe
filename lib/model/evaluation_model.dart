class EvaluationModel {
  final String evaluatorId;
  final String sellerId;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final bool isAnonymous;

  EvaluationModel({
    required this.evaluatorId,
    required this.sellerId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.isAnonymous = false,
  });

  factory EvaluationModel.fromJson(Map<String, dynamic> json) {
    return EvaluationModel(
      sellerId: json['sellerId'],
      evaluatorId: json['evaluatorId'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
      isAnonymous: json['isAnonymous']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'evaluatorId': evaluatorId,
      'sellerId': sellerId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'isAnonymous': isAnonymous,
    };
  }
}