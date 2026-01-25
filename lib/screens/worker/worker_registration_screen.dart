import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../data/firestore_service.dart';
import '../../data/city_service.dart';
import '../../data/skill_service.dart';
import '../../models/worker_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WorkerRegistrationScreen extends StatefulWidget {
  const WorkerRegistrationScreen({super.key});

  @override
  State<WorkerRegistrationScreen> createState() =>
      _WorkerRegistrationScreenState();
}

class _WorkerRegistrationScreenState extends State<WorkerRegistrationScreen> {
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  final PageController _pageController = PageController();
  int _currentStep = 0;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _selectedProvince;
  String? _selectedCity;
  final List<String> _selectedSkills = [];

  final FirestoreService _firestoreService = FirestoreService();
  final CityService _cityService = CityService();
  final SkillService _skillService = SkillService();

  late Future<Map<String, List<String>>> _citiesFuture;
  late Future<List<String>> _skillsFuture;

  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    setState(() => _isLoading = true);
    _citiesFuture = _cityService.fetchCities();
    _skillsFuture = _skillService.fetchSkills();
    try {
      await Future.wait([_citiesFuture, _skillsFuture]);
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_formKeyStep1.currentState!.validate()) {
        _pageController.nextPage(
            duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        setState(() => _currentStep = 1);
      }
    }
  }

  void _prevStep() {
    if (_currentStep == 1) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentStep = 0);
    }
  }

  void _submitForm() async {
    if (!_formKeyStep2.currentState!.validate() || _selectedSkills.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorSelectSkill)),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final worker = WorkerModel(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      skill: _selectedSkills.join(', '),
      city: _selectedCity!,
    );

    try {
      await _firestoreService.addWorker(worker);
      if (!mounted) return;
      Navigator.pushNamed(context, '/register-success');
    } catch (_) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorLoadingCities)), // Generic error
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.workerRegistrationTitle)),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
          : Column(
              children: [
                _buildProgressIndicator(theme),
                Expanded(
                  child: FutureBuilder<Map<String, List<String>>>(
                    future: _citiesFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox.shrink();
                      final cities = snapshot.data!;

                      return PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildStep1(l10n, theme),
                          _buildStep2(l10n, theme, cities),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Row(
        children: [
          _buildStepCircle(theme, 1, _currentStep >= 0),
          Expanded(child: Divider(color: theme.primaryColor, thickness: 2)),
          _buildStepCircle(theme, 2, _currentStep >= 1),
        ],
      ),
    );
  }

  Widget _buildStepCircle(ThemeData theme, int step, bool isActive) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isActive ? theme.primaryColor : Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$step',
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ).animate(target: isActive ? 1 : 0).scale(duration: 300.ms);
  }

  Widget _buildStep1(AppLocalizations l10n, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKeyStep1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Personal Information",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Let's start with your basic details",
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.labelName,
                prefixIcon: const Icon(Icons.person_outline),
                fillColor: Colors.white,
              ),
              validator: (v) => v?.isEmpty ?? true ? l10n.errorName : null,
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: l10n.labelPhone,
                prefixIcon: const Icon(Icons.phone_outlined),
                fillColor: Colors.white,
              ),
              validator: (v) => v?.isEmpty ?? true ? l10n.errorPhone : null,
            ),

            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _nextStep,
              child: const Text('Next Step'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2(AppLocalizations l10n, ThemeData theme, Map<String, List<String>> cities) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKeyStep2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
               alignment: Alignment.centerLeft,
               child: TextButton.icon(
                 onPressed: _prevStep,
                 icon: const Icon(Icons.arrow_back),
                 label: const Text("Back"),
               ),
            ),
            
            Text(
              "Work Details",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
             const SizedBox(height: 8),
            Text(
              "Where do you work and what do you do?",
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            DropdownButtonFormField<String>(
              value: _selectedProvince,
              items: cities.keys.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              onChanged: (v) => setState(() {
                _selectedProvince = v;
                _selectedCity = null;
              }),
              decoration: InputDecoration(
                labelText: l10n.selectProvince,
                prefixIcon: const Icon(Icons.map_outlined),
                 fillColor: Colors.white,
              ),
              validator: (v) => v == null ? l10n.errorSelectProvince : null,
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _selectedCity,
              items: _selectedProvince == null ? [] : cities[_selectedProvince]!.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _selectedCity = v),
              decoration: InputDecoration(
                labelText: l10n.selectCity,
                prefixIcon: const Icon(Icons.location_city_outlined),
                 fillColor: Colors.white,
              ),
              validator: (v) => v == null ? l10n.errorSelectCity : null,
            ),

            const SizedBox(height: 30),
            
            // Skills
            FutureBuilder<List<String>>(
              future: _skillsFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: snapshot.data!.map((skill) {
                        return CheckboxListTile(
                          title: Text(skill),
                          value: _selectedSkills.contains(skill),
                          activeColor: theme.primaryColor,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedSkills.add(skill);
                              } else {
                                _selectedSkills.remove(skill);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                );
              }
            ),

            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitForm,
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(l10n.btnRegister),
            ),
          ],
        ),
      ),
    );
  }
}
