import 'package:flutter/material.dart';
import 'package:stoplight_app/features/report/reports_history_page.dart';
import 'package:stoplight_app/features/auth/profile_page.dart';

import '../report/report_page.dart';
import '../widgets/loading_overlay.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // 3 tabs: Home / Reports / Profile
  late final List<Widget> _pages = [
    const _HomeContent(),
    const ReportsHistoryPage(),
    const ProfilePage(),    // 👈 now connected
  ];

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  String get _title {
    switch (_selectedIndex) {
      case 0:
        return "Stop Light";
      case 1:
        return "Your Reports";
      case 2:
        return "Profile";
      default:
        return "Stop Light";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        title: Text(
          _title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

//---------------------------------------------------------------

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final _vinOrLink = TextEditingController();
  final _year = TextEditingController();
  final _make = TextEditingController();
  final _model = TextEditingController();
  final _mileage = TextEditingController();
  final _price = TextEditingController();

  bool _showManual = false;
  bool _isLoading = false;

  Future<void> _onAnalyze() async {
    FocusScope.of(context).unfocus(); // hide keyboard
    setState(() => _isLoading = true);

    // simulate loading / AI analysis
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // navigate to report page
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
    return LoadingOverlay(
      isLoading: _isLoading,
      message: "Analyzing with AI...",
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const SizedBox(height: 8),
          Text(
            "Hi Bohdan,",
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800, color: const Color(0xFF0D1B3D)),
          ),
          const SizedBox(height: 2),
          const Text("Let’s check your car", style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 16),

          // VIN / link field
          TextField(
            controller: _vinOrLink,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "Enter VIN or listing link",
            ),
          ),
          const SizedBox(height: 8),

          // manual toggle button
          TextButton.icon(
            onPressed: () => setState(() => _showManual = !_showManual),
            icon: Icon(_showManual ? Icons.expand_less : Icons.expand_more),
            label: Text(_showManual ? "Hide manual entry" : "Enter manually"),
          ),

          // manual input card
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _showManual
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Vehicle Information",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700, color: const Color(0xFF0D1B3D))),
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
                            child: _LabeledField(label: "Make", controller: _make)),
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

          // analyze button
          FilledButton(
            onPressed: _onAnalyze,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text("Analyze"),
          ),
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  const _LabeledField({required this.label, required this.controller, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(controller: controller, keyboardType: keyboardType),
      ],
    );
  }
}

