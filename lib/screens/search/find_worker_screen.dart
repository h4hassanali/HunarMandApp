import 'package:flutter/material.dart';
import 'package:hassan_app/widgets/footer_note.dart';
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('کاریگر تلاش کریں')),
        body: FooterNote(
          child: FutureBuilder<Map<String, List<String>>>(
            future: _citiesFuture,
            builder: (context, citySnapshot) {
              if (citySnapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingScreen(context);
              }
              if (citySnapshot.hasError || !citySnapshot.hasData) {
                return const Center(child: Text('شہر لوڈ کرنے میں مسئلہ ہوا'));
              }

              final cities = citySnapshot.data!;

              return FutureBuilder<List<String>>(
                future: _skillsFuture,
                builder: (context, skillSnapshot) {
                  if (skillSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return _buildLoadingScreen(context);
                  }
                  if (skillSnapshot.hasError || !skillSnapshot.hasData) {
                    return const Center(
                      child: Text('مہارتیں لوڈ کرنے میں مسئلہ ہوا'),
                    );
                  }

                  final skills = skillSnapshot.data!;

                  return Stack(
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Center(
                                child: AbsorbPointer(
                                  absorbing: _isSubmitting,
                                  child: Form(
                                    key: _formKey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const Text(
                                            'اپنی ضرورت کے مطابق معلومات منتخب کریں',
                                            style: TextStyle(fontSize: 16),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 20),

                                          // Province Dropdown
                                          DropdownButtonFormField<String>(
                                            value: _selectedProvince,
                                            decoration: const InputDecoration(
                                              labelText: 'صوبہ منتخب کریں',
                                              border: OutlineInputBorder(),
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
                                                ? 'براہِ کرم صوبہ منتخب کریں'
                                                : null,
                                          ),
                                          const SizedBox(height: 20),

                                          // City Dropdown
                                          DropdownButtonFormField<String>(
                                            value: _selectedCity,
                                            decoration: const InputDecoration(
                                              labelText: 'شہر منتخب کریں',
                                              border: OutlineInputBorder(),
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
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedCity = value;
                                              });
                                            },
                                            validator: (value) => value == null
                                                ? 'براہِ کرم شہر منتخب کریں'
                                                : null,
                                          ),
                                          const SizedBox(height: 20),

                                          // Skill Dropdown
                                          DropdownButtonFormField<String>(
                                            value: _selectedSkill,
                                            decoration: const InputDecoration(
                                              labelText:
                                                  'کاریگر کی قسم منتخب کریں',
                                              border: OutlineInputBorder(),
                                            ),
                                            items: skills
                                                .map(
                                                  (skill) => DropdownMenuItem(
                                                    value: skill,
                                                    child: Text(skill),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedSkill = value;
                                              });
                                            },
                                            validator: (value) => value == null
                                                ? 'براہِ کرم مہارت منتخب کریں'
                                                : null,
                                          ),
                                          const SizedBox(height: 30),

                                          // Search Button
                                          ElevatedButton.icon(
                                            onPressed: _isSubmitting
                                                ? null
                                                : () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      setState(
                                                        () => _isSubmitting =
                                                            true,
                                                      );
                                                      Future.delayed(
                                                        const Duration(
                                                          milliseconds: 500,
                                                        ),
                                                        () {
                                                          if (!mounted) return;
                                                          Navigator.pushNamed(
                                                            context,
                                                            '/worker-results',
                                                            arguments: {
                                                              'province':
                                                                  _selectedProvince,
                                                              'city':
                                                                  _selectedCity,
                                                              'skill':
                                                                  _selectedSkill,
                                                            },
                                                          );
                                                          setState(
                                                            () =>
                                                                _isSubmitting =
                                                                    false,
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                            icon: const Icon(
                                              Icons.search,
                                              size: 24,
                                            ),
                                            label: const Text(
                                              'تلاش کریں',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(
                                                double.infinity,
                                                56,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              elevation: 3,
                                            ),
                                          ),
                                          const SizedBox(height: 30),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // Overlay loading spinner when submitting
                      if (_isSubmitting)
                        Container(
                          color: Theme.of(context).scaffoldBackgroundColor
                              .withValues(alpha: (0.7 * 255)),
                          child: const Center(
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: CircularProgressIndicator(strokeWidth: 6),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
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
