import 'package:flutter/material.dart';

class StopLightGauge extends StatelessWidget {
  final int risk; // 0..100
  const StopLightGauge({super.key, required this.risk});

  Color _c(int v) => v >= 70 ? const Color(0xFFC62828)
      : v >= 30 ? const Color(0xFFF9A825)
      : const Color(0xFF2E7D32);

  String _t(int v) => v >= 70 ? 'High' : v >= 30 ? 'Medium' : 'Low';

  @override
  Widget build(BuildContext context) {
    final c = _c(risk);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
            color: c.withOpacity(.1),
            shape: BoxShape.circle,
            border: Border.all(color: c, width: 3),
          ),
          alignment: Alignment.center,
          child: Icon(
            risk >= 70 ? Icons.close : risk >= 30 ? Icons.error_outline : Icons.check,
            color: c, size: 36,
          ),
        ),
        const SizedBox(height: 6),
        Text('${_t(risk)} • $risk/100',
            style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
