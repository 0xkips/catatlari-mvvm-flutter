class RunningModel {
  final String date;
  final String distance;
  final String duration;

  RunningModel({
    required this.date,
    required this.distance,
    required this.duration,
  });

  factory RunningModel.fromJson(Map<String, dynamic> json) {
    return RunningModel(
      date: json['date']?.toString() ?? '',
      distance: json['distance']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'distance': distance,
      'duration': duration,
    };
  }
}
