class ParsedSmsResult {
  const ParsedSmsResult({
    this.billAmount,
    this.billingPeriod,
    this.previousMeterReading,
    this.currentMeterReading,
    this.dueDate,
    required this.isSuccessful,
    required this.rawText,
    this.errorMessage,
  });

  final double? billAmount;
  final String? billingPeriod;
  final double? previousMeterReading;
  final double? currentMeterReading;
  final DateTime? dueDate;
  final bool isSuccessful;
  final String rawText;
  final String? errorMessage;

  int get fieldsFound {
    int count = 0;
    if (billAmount != null) count++;
    if (billingPeriod != null) count++;
    if (previousMeterReading != null) count++;
    if (currentMeterReading != null) count++;
    if (dueDate != null) count++;
    return count;
  }
}
