import 'package:flutter/material.dart';
import '../report/report_page.dart';
import '../widgets/loading_overlay.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _vinOrLink = TextEditingController();
  final _year = TextEditingController();
  final _make = TextEditingController();
  final _model = TextEditingController();
  final _mileage = TextEditingController();
  final _price = TextEditingController();

  bool _showManual = false;
  int _navIndex = 0;

  // in HomePage state
  bool _isLoading = false;

  Future<void> _onAnalyze() async {
    setState(() => _isLoading = true);

    // Simulate AI/backend analysis (3 seconds)
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Navigate to ReportPage
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ReportPage(
        vin: _vinOrLink.text.trim().isEmpty ? null : _vinOrLink.text.trim(),
        year: int.tryParse(_year.text.trim()) ?? 0,
        make: _make.text.trim(),
        model: _model.text.trim(),
        mileageKm: int.tryParse(_mileage.text.trim()) ?? 0,
        priceCad: int.tryParse(_price.text.trim()) ?? 0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1), // deep blue
        title: const Text(
          "StopLight",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: _isLoading,
          message: "Analyzing with AI…",
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              const SizedBox(height: 8),
              Text(
                "Hi Bohdan,",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0D1B3D)),
              ),
              const SizedBox(height: 2),
              const Text("Let's check your car",
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 16),

              // VIN / Link field
              TextField(
                controller: _vinOrLink,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Enter VIN or listing link",
                ),
              ),
              const SizedBox(height: 8),

              // Toggle button for manual entry
              TextButton.icon(
                onPressed: () {
                  setState(() => _showManual = !_showManual);
                },
                icon: Icon(_showManual ? Icons.expand_less : Icons.expand_more),
                label:
                    Text(_showManual ? "Hide manual entry" : "Enter manually"),
              ),

              // Expandable manual entry card
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                crossFadeState: _showManual
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Vehicle Information",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF0D1B3D))),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                                child: _LabeledField(
                                    label: "Year",
                                    controller: _year,
                                    keyboardType: TextInputType.number)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _LabeledField(
                                    label: "Make", controller: _make)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _LabeledField(label: "Model", controller: _model),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                                child: _LabeledField(
                                    label: "Mileage (km)",
                                    controller: _mileage,
                                    keyboardType: TextInputType.number)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _LabeledField(
                                    label: "Price (CAD)",
                                    controller: _price,
                                    keyboardType: TextInputType.number)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                secondChild: const SizedBox.shrink(),
              ),

              const SizedBox(height: 24),

              // Analyze button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _onAnalyze,
                  child: const Text("Analyze"),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (i) => setState(() => _navIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: "Home"),
          NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined), label: "Reports"),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  const _LabeledField(
      {required this.label, required this.controller, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.black54, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(controller: controller, keyboardType: keyboardType),
      ],
    );
  }
}
