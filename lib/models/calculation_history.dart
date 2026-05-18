class CalculationHistory {
  const CalculationHistory({
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  final String expression;
  final String result;
  final DateTime timestamp;

  Map<String, dynamic> toJson() {
    return {
      'expression': expression,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory CalculationHistory.fromJson(Map<String, dynamic> json) {
    return CalculationHistory(
      expression: json['expression'] as String? ?? '',
      result: json['result'] as String? ?? '',
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
