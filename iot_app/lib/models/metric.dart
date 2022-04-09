class Metric {
  final DateTime date;
  final double temperature;

  Metric({required this.date, required this.temperature});

  static Metric fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json['date']);

    return Metric(
      date: date,
      temperature: json['temperature'] is int
          ? json['temperature'].toDouble()
          : json['temperature'],
    );
  }
}
