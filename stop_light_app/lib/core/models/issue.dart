class Issue {
  final String component;
  final String severity; // high|medium|low
  final List<int>? yearsAffected;
  final List<int>? mileageKmRange;
  final List<String> symptoms;
  final List<String> inspectionTips;
  final Map<String, List<num>> costCad; // {"indie":[min,max], ...}

  Issue({
    required this.component,
    required this.severity,
    this.yearsAffected,
    this.mileageKmRange,
    required this.symptoms,
    required this.inspectionTips,
    required this.costCad,
  });
}
