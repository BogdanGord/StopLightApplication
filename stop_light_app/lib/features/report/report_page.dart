import 'package:flutter/material.dart';
import '../widgets/stoplight_gauge.dart';

class ReportPage extends StatelessWidget {
  final String? vin;
  final int year;
  final String make;
  final String model;
  final int mileageKm;
  final int priceCad;

  const ReportPage({
    super.key,
    this.vin,
    required this.year,
    required this.make,
    required this.model,
    required this.mileageKm,
    required this.priceCad,
  });

  @override
  Widget build(BuildContext context) {
    const riskScore = 62;
    const marketLow = 9500;
    const marketHigh = 12500;
    const priceJudgment = 'fair';

    final issues = const [
      {
        'title': 'Timing chain / tensioner',
        'severity': 'high',
        'range': '120–180k km',
        'symptoms': 'Rattle at cold start, timing codes',
        'checks': 'Cold start, scan angles, service record',
        'cost': 'indie 1,600–2,600 • dealer 2,500–3,800 CAD',
      },
      {
        'title': 'Water pump / thermostat',
        'severity': 'medium',
        'range': '60–160k km',
        'symptoms': 'Coolant traces, overheating',
        'checks': 'Visual pump, temp scan',
        'cost': 'indie 550–900 CAD',
      },
    ];

    final negotiation = [
      'Timing chain likely soon — ask ~\$2,000 CAD discount.',
      'Check for coolant leaks — budget ~\$600 CAD.',
      'No service records? Negotiate for upcoming work.'
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Report')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$year $make $model',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800, color: const Color(0xFF0D1B3D))),
                    const SizedBox(height: 6),
                    Text('Mileage: $mileageKm km',
                        style: const TextStyle(color: Colors.black54)),
                    const SizedBox(height: 6),
                    Text('Asking: \$$priceCad • Market: \$$marketLow–\$$marketHigh • ${priceJudgment.toUpperCase()}'),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const StopLightGauge(risk: riskScore),
            ],
          ),
          const SizedBox(height: 16),
          _SectionTitle('Issues'),
          const SizedBox(height: 8),
          ...issues.map((i) => _IssueListTile(issue: i)).toList(),
          const SizedBox(height: 16),
          _SectionTitle('Negotiation points'),
          const SizedBox(height: 8),
          ...negotiation.map((t) => ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            leading: const Icon(Icons.chevron_right),
            title: Text(t),
          )),
          const SizedBox(height: 16),
          _SectionTitle('Bottom line'),
          const SizedBox(height: 8),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Price near top of market. If no proof of timing chain replacement, ask for -\$1,000…-\$1,500 CAD.',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800, color: const Color(0xFF0D1B3D)),
    );
  }
}

class _IssueListTile extends StatelessWidget {
  final Map<String, Object> issue;
  const _IssueListTile({required this.issue});

  Color _sevColor(String s) => switch (s) {
    'high' => const Color(0xFFC62828),
    'medium' => const Color(0xFFF9A825),
    _ => const Color(0xFF2E7D32),
  };

  @override
  Widget build(BuildContext context) {
    final sev = (issue['severity'] as String);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 10, height: 10,
                    decoration: BoxDecoration(color: _sevColor(sev), shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(child: Text(issue['title'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w700))),
              ],
            ),
            const SizedBox(height: 6),
            if (issue['range'] != null)
              Text('Risk mileage: ${issue['range']}', style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 6),
            Text('Symptoms: ${issue['symptoms']}', style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 6),
            Text('Checks: ${issue['checks']}', style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 8),
            Text('Cost: ${issue['cost']}', style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
