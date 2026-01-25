import 'package:flutter/material.dart';
import 'package:hassan_app/widgets/footer_note.dart';
import '../../l10n/app_localizations.dart';
import '../../data/city_service.dart';
import '../../data/skill_service.dart';

class FindWorkerScreen extends StatefulWidget {
  const FindWorkerScreen({super.key});

  @override
  State<FindWorkerScreen> createState() => _FindWorkerScreenState();
}

class _FindWorkerScreenState extends State<FindWorkerScreen> {
  String? _selectedProvince;
  String? _selectedCity;
  String? _selectedSkill;

  final _formKey = GlobalKey<FormState>();

  final CityService _cityService = CityService();
  final SkillService _skillService = SkillService();

  late Future<Map<String, List<String>>> _citiesFuture;
  late Future<List<String>> _skillsFuture;

  bool _isSubmitting = false; // Loading overlay when button is pressed

  @override
  void initState() {
    super.initState();
    _citiesFuture = _cityService.fetchCities();
    _skillsFuture = _skillService.fetchSkills();
  }

  // New method to handle search logic
  void _searchWorkers() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          if (!mounted) return;
          Navigator.pushNamed(
            context,
            '/worker-results',
            arguments: {
              'province': _selectedProvince,
              'city': _selectedCity,
              'skill': _selectedSkill,
            },
          ).then((_) {
            // Reset _isSubmitting when returning from the results screen
            if (mounted) {
              setState(() {
                _isSubmitting = false;
              });
            }
          });
        },
      );
    }
  }

  // Helper method to build dropdown labels
  Widget _buildDropdownLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(l10n.findWorkerTitle),
          automaticallyImplyLeading: false, 
        ),
        body: FutureBuilder<Map<String, List<String>>>(
            future: _citiesFuture,
            builder: (context, citySnapshot) {
              if (citySnapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingScreen(context);
              }
              if (citySnapshot.hasError || !citySnapshot.hasData) {
                return Center(child: Text(l10n.errorLoadingCities, style: TextStyle(color: theme.colorScheme.error)));
              }

              final cities = citySnapshot.data!;

              return FutureBuilder<List<String>>(
                future: _skillsFuture,
                builder: (context, skillSnapshot) {
                  if (skillSnapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingScreen(context);
                  }
                  if (skillSnapshot.hasError || !skillSnapshot.hasData) {
                    return Center(
                      child: Text(l10n.errorLoadingSkills, style: TextStyle(color: theme.colorScheme.error)),
                    );
                  }

                  final skills = skillSnapshot.data!;

                  return Stack(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: theme.primaryColor.withOpacity(0.1)),
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.search, size: 40, color: theme.primaryColor),
                                    const SizedBox(height: 12),
                                    Text(
                                      l10n.findWorkerInstruction,
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 30),

                              // Province Dropdown
                              _buildDropdownLabel(context, l10n.labelProvince),
                              DropdownButtonFormField<String>(
                                value: _selectedProvince,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.map),
                                  hintText: l10n.selectProvince,
                                ),
                                items: cities.keys
                                    .map(
                                      (province) => DropdownMenuItem(
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
                              const SizedBox(height: 20),

                              // City Dropdown
                              _buildDropdownLabel(context, l10n.labelCity),
                              DropdownButtonFormField<String>(
                                value: _selectedCity,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.location_city),
                                  hintText: l10n.selectCity,
                                ),
                                items: _selectedProvince == null
                                    ? []
                                    : cities[_selectedProvince!]!
                                          .map(
                                            (city) => DropdownMenuItem(
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
                              const SizedBox(height: 20),

                              // Skill Dropdown
                              _buildDropdownLabel(context, l10n.labelSkill),
                              DropdownButtonFormField<String>(
                                value: _selectedSkill,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.work),
                                  hintText: l10n.selectWorkerType,
                                ),
                                items: skills
                                    .map(
                                      (skill) => DropdownMenuItem(
                                        value: skill,
                                        child: Text(skill),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) => setState(
                                  () => _selectedSkill = value,
                                ),
                                validator: (value) => value == null
                                    ? l10n.errorSelectSkill
                                    : null,
                              ),
                              const SizedBox(height: 40),

                              // Search Button
                              ElevatedButton.icon(
                                onPressed: _searchWorkers,
                                icon: const Icon(Icons.search),
                                label: Text(l10n.btnSearch),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 56),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Overlay loading spinner when submitting
                      if (_isSubmitting)
                        Container(
                          color: Theme.of(context).scaffoldBackgroundColor
                              .withOpacity(0.7),
                          child: Center(
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: CircularProgressIndicator(
                                strokeWidth: 6,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            }),
    );
  }

  // Full screen loading for initial data fetch
  Widget _buildLoadingScreen(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: CircularProgressIndicator(
          strokeWidth: 6,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
