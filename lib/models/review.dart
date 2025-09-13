class Review {
  final String id;
  final String patientId;
  final String physiotherapistId;
  final String appointmentId;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final String? patientName;
  final String? patientProfilePicture;

  const Review({
    required this.id,
    required this.patientId,
    required this.physiotherapistId,
    required this.appointmentId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.patientName,
    this.patientProfilePicture,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'physiotherapistId': physiotherapistId,
      'appointmentId': appointmentId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'patientName': patientName,
      'patientProfilePicture': patientProfilePicture,
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      patientId: json['patientId'],
      physiotherapistId: json['physiotherapistId'],
      appointmentId: json['appointmentId'],
      rating: json['rating'].toDouble(),
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
      patientName: json['patientName'],
      patientProfilePicture: json['patientProfilePicture'],
    );
  }

  Review copyWith({
    String? id,
    String? patientId,
    String? physiotherapistId,
    String? appointmentId,
    double? rating,
    String? comment,
    DateTime? createdAt,
    String? patientName,
    String? patientProfilePicture,
  }) {
    return Review(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      physiotherapistId: physiotherapistId ?? this.physiotherapistId,
      appointmentId: appointmentId ?? this.appointmentId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      patientName: patientName ?? this.patientName,
      patientProfilePicture:
          patientProfilePicture ?? this.patientProfilePicture,
    );
  }
}
