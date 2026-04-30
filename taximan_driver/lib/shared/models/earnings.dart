class Earnings {
  const Earnings({
    required this.today,
    required this.week,
    required this.total,
    required this.completedTrips,
  });

  final int today;
  final int week;
  final int total;
  final int completedTrips;

  String get todayFormatted => '${today.toStringAsFixed(0)} FCFA';
  String get weekFormatted => '${week.toStringAsFixed(0)} FCFA';
  String get totalFormatted => '${total.toStringAsFixed(0)} FCFA';

  Map<String, dynamic> toMap() {
    return {
      'today': today,
      'week': week,
      'total': total,
      'completedTrips': completedTrips,
    };
  }

  factory Earnings.fromMap(Map<String, dynamic> map) {
    return Earnings(
      today: map['today'] as int? ?? 0,
      week: map['week'] as int? ?? 0,
      total: map['total'] as int? ?? 0,
      completedTrips: map['completedTrips'] as int? ?? 0,
    );
  }
}
