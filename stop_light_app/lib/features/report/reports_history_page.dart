import 'package:flutter/material.dart';
import 'report_page.dart';

class ReportsHistoryPage extends StatefulWidget {
  const ReportsHistoryPage({super.key});

  @override
  State<ReportsHistoryPage> createState() => _ReportsHistoryPageState();
}

class _ReportsHistoryPageState extends State<ReportsHistoryPage> {
  // Mock data for now — later you’ll load from Supabase
  final List<Map<String, dynamic>> _reports = [
    {
      "id": "rpt1",
      "make": "Audi",
      "model": "A4",
      "year": 2014,
      "mileage": 143000,
      "price": 9500,
      "risk": 72,
      "summary":
      "Timing chain wear likely. Oil leaks common. Good condition overall."
    },
    {
      "id": "rpt2",
      "make": "Toyota",
      "model": "Camry",
      "year": 2019,
      "mileage": 78000,
      "price": 18500,
      "risk": 28,
      "summary": "Low-risk model. Usual brake wear. Excellent reliability."
    },
  ];

  Color _riskColor(int risk) {
    if (risk < 35) return const Color(0xFF2E7D32); // green
    if (risk < 70) return const Color(0xFFF9A825); // yellow
    return const Color(0xFFC62828); // red
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _reports.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final r = _reports[i];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ReportPage(
                vin: null,
                make: r["make"],
                model: r["model"],
                year: r["year"],
                mileageKm: r["mileage"],
                priceCad: r["price"],
              ),
            ));
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.5),
                    Colors.blue.shade50.withValues(alpha: 0.5),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Left: risk color bar
                  Container(
                    width: 8,
                    height: 72,
                    decoration: BoxDecoration(
                      color: _riskColor(r["risk"]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Right: main info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${r["make"]} ${r["model"]} ${r["year"]}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0D1B3D),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${r["mileage"]} km • \$${r["price"]}",
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          r["summary"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
