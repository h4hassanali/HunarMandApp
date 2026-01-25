import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../data/firestore_service.dart';
import '../../data/city_service.dart';
import '../../data/skill_service.dart';
import '../../models/worker_model.dart';

class WorkerRegistrationScreen extends StatefulWidget {
  const WorkerRegistrationScreen({super.key});

  @override
  State<WorkerRegistrationScreen> createState() =>
      _WorkerRegistrationScreenState();
}

class _WorkerRegistrationScreenState extends State<WorkerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

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

  bool _isLoading = true; // initial page loading
  bool _isSubmitting = false; // form submission loading

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

  void _submitForm() async {
    if (!_formKey.currentState!.validate() || _selectedSkills.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorSelectSkill),
        ),
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
        SnackBar(content: Text(l10n.errorLoadingCities)),
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
        body: SingleChildScrollView(
            child: Padding(
            padding: const EdgeInsets.all(20),
            child: _isLoading
                ? SizedBox(height: 300, child: Center(child: CircularProgressIndicator(color: theme.primaryColor)))
                : FutureBuilder<Map<String, List<String>>>(
                    future: _citiesFuture,
                    builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                        }

                        if (snapshot.hasError || !snapshot.hasData) {
                        return Center(
                            child: Text(
                            l10n.errorLoadingCities,
                            style: TextStyle(color: theme.colorScheme.error),
                            ),
                        );
                        }

                        final cities = snapshot.data!;

                        return Form(
                        key: _formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                            Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                color: theme.colorScheme.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: theme.colorScheme.secondary.withOpacity(0.3)),
                                ),
                                child: Row(
                                children: [
                                    Icon(Icons.info_outline, color: theme.colorScheme.secondary),
                                    const SizedBox(width: 12),
                                    Expanded(
                                    child: Text(
                                        l10n.findWorkerInstruction, // Reusing existing string or add new "Fill details carefully"
                                        style: TextStyle(color: theme.colorScheme.secondary),
                                    ),
                                    ),
                                ],
                                ),
                            ),
                            const SizedBox(height: 24),

                            _buildSectionHeader(context, 'Personal Information'),
                            
                            // Name
                            TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                labelText: l10n.labelName,
                                hintText: l10n.hintName,
                                prefixIcon: const Icon(Icons.person),
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? l10n.errorName
                                    : null,
                            ),
                            const SizedBox(height: 16),

                            // Phone
                            TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                labelText: l10n.labelPhone,
                                hintText: l10n.hintPhone,
                                prefixIcon: const Icon(Icons.phone),
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? l10n.errorPhone
                                    : null,
                            ),
                            const SizedBox(height: 32),

                            _buildSectionHeader(context, 'Location'),

                            // Province
                            DropdownButtonFormField<String>(
                                value: _selectedProvince,
                                decoration: InputDecoration(
                                labelText: l10n.selectProvince,
                                prefixIcon: const Icon(Icons.map),
                                ),
                                items: cities.keys
                                    .map(
                                        (province) =>
                                            DropdownMenuItem(
                                            value: province,
                                            child: Text(province),
                                            ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                    setState(() {
                                    _selectedProvince = value;
                                    _selectedCity = null;
                                    });
                                },
                                validator: (value) => value == null
                                    ? l10n.errorSelectProvince
                                    : null,
                            ),
                            const SizedBox(height: 16),

                            // City
                            DropdownButtonFormField<String>(
                                value: _selectedCity,
                                decoration: InputDecoration(
                                labelText: l10n.selectCity,
                                prefixIcon: const Icon(Icons.location_city),
                                ),
                                items: _selectedProvince == null
                                    ? []
                                    : cities[_selectedProvince!]!
                                            .map(
                                            (city) =>
                                                DropdownMenuItem(
                                                    value: city,
                                                    child: Text(city),
                                                ),
                                            )
                                            .toList(),
                                onChanged: (value) => setState(
                                    () => _selectedCity = value,
                                ),
                                validator: (value) => value == null
                                    ? l10n.errorSelectCity
                                    : null,
                            ),
                            const SizedBox(height: 32),

                            _buildSectionHeader(context, 'Skills'),

                            // Skills
                            FutureBuilder<List<String>>(
                                future: _skillsFuture,
                                builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                    return const LinearProgressIndicator();
                                }
                                if (snapshot.hasError ||
                                    !snapshot.hasData) {
                                    return Text(l10n.errorLoadingSkills, style: TextStyle(color: theme.colorScheme.error));
                                }
                                final skills = snapshot.data!;
                                return Container(
                                    decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(12),
                                    color: theme.cardColor,
                                    ),
                                    child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                        Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                            l10n.labelSkill,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        ),
                                        const Divider(height: 1),
                                        ...skills.map(
                                            (skill) => CheckboxListTile(
                                            title: Text(skill),
                                            value: _selectedSkills
                                                .contains(skill),
                                            activeColor: theme.primaryColor,
                                            onChanged: (selected) {
                                                setState(() {
                                                if (selected ==
                                                    true) {
                                                    _selectedSkills.add(
                                                    skill,
                                                    );
                                                } else {
                                                    _selectedSkills
                                                        .remove(skill);
                                                }
                                                });
                                            },
                                            ),
                                        ),
                                    ],
                                    ),
                                );
                                },
                            ),
                            const SizedBox(height: 40),

                            // Submit
                            SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                onPressed: _isSubmitting
                                    ? null
                                    : _submitForm,
                                child: _isSubmitting 
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : Text(
                                        l10n.btnRegister,
                                        style: const TextStyle(fontSize: 18),
                                    ),
                                ),
                            ),
                            const SizedBox(height: 40),
                            ],
                        ),
                        );
                    },
                ),
            ),
        ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
