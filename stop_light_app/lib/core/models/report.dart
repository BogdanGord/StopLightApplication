import 'issue.dart';

class Report {
  final String? vin;
  final int year;
  final String make;
  final String model;
  final String? engineCode;
  final int odometerKm;
  final int askingPriceCad;
  final int marketLowCad;
  final int marketHighCad;
  final String priceJudgment; // under|fair|over
  final int riskScore; // 0..100
  final List<Issue> issues;
  final List<String> negotiationPoints;
  final String bottomLine;
  final Uri mpiLink;
  final Uri lienLink;
  final String winterNote;

  const Report({
    this.vin,
    required this.year,
    required this.make,
    required this.model,
    this.engineCode,
    required this.odometerKm,
    required this.askingPriceCad,
    required this.marketLowCad,
    required this.marketHighCad,
    required this.priceJudgment,
    required this.riskScore,
    required this.issues,
    required this.negotiationPoints,
    required this.bottomLine,
    required this.mpiLink,
    required this.lienLink,
    required this.winterNote,
  });
}
