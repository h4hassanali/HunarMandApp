import 'package:flutter/material.dart';
import 'package:hassan_app/widgets/footer_note.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('براہِ کرم تمام فیلڈز درست طریقے سے بھریں'),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('کچھ غلط ہو گیا، دوبارہ کوشش کریں')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('کاریگر رجسٹریشن')),
        body: FooterNote(
          child: Stack(
            children: [
              // Main content
              Opacity(
                opacity: _isSubmitting ? 0.5 : 1,
                child: AbsorbPointer(
                  absorbing: _isSubmitting,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _isLoading
                          ? const SizedBox.shrink() // hide form until data fetched
                          : FutureBuilder<Map<String, List<String>>>(
                              future: _citiesFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox.shrink();
                                }

                                if (snapshot.hasError || !snapshot.hasData) {
                                  return Center(
                                    child: Text(
                                      'شہر لوڈ کرنے میں مسئلہ ہوا',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  );
                                }

                                final cities = snapshot.data!;

                                return Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'براہِ کرم اپنی درست معلومات درج کریں',
                                        style: theme.textTheme.bodyLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 20),

                                      // Name
                                      Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: TextFormField(
                                            controller: _nameController,
                                            decoration: const InputDecoration(
                                              labelText: 'نام',
                                              hintText: 'مثال: محمد اسلم',
                                              border: InputBorder.none,
                                            ),
                                            validator: (value) =>
                                                value == null || value.isEmpty
                                                ? 'براہِ کرم اپنا نام درج کریں'
                                                : null,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // Phone
                                      Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: TextFormField(
                                            controller: _phoneController,
                                            keyboardType: TextInputType.phone,
                                            decoration: const InputDecoration(
                                              labelText: 'فون نمبر',
                                              hintText: 'مثال: 03XXXXXXXXX',
                                              border: InputBorder.none,
                                            ),
                                            validator: (value) =>
                                                value == null || value.isEmpty
                                                ? 'براہِ کرم اپنا فون نمبر درج کریں'
                                                : null,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // Province
                                      Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          child: DropdownButtonFormField<String>(
                                            value: _selectedProvince,
                                            decoration: const InputDecoration(
                                              labelText: 'صوبہ منتخب کریں',
                                              border: InputBorder.none,
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
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // City
                                      Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          child: DropdownButtonFormField<String>(
                                            value: _selectedCity,
                                            decoration: const InputDecoration(
                                              labelText: 'شہر منتخب کریں',
                                              border: InputBorder.none,
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
                                                ? 'براہِ کرم شہر منتخب کریں'
                                                : null,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // Skills
                                      FutureBuilder<List<String>>(
                                        future: _skillsFuture,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const SizedBox.shrink();
                                          }
                                          if (snapshot.hasError ||
                                              !snapshot.hasData) {
                                            return Center(
                                              child: Text(
                                                'مہارتیں لوڈ کرنے میں مسئلہ ہوا',
                                                style:
                                                    theme.textTheme.bodyLarge,
                                              ),
                                            );
                                          }
                                          final skills = snapshot.data!;
                                          return Card(
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Text(
                                                    'مہارت منتخب کریں',
                                                    style: theme
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  ...skills.map(
                                                    (skill) => CheckboxListTile(
                                                      title: Text(skill),
                                                      value: _selectedSkills
                                                          .contains(skill),
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
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 30),

                                      // Submit
                                      ElevatedButton(
                                        onPressed: _isSubmitting
                                            ? null
                                            : _submitForm,
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(
                                            double.infinity,
                                            56,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'رجسٹریشن مکمل کریں',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ),
              ),

              // Centered loading overlay
              if (_isLoading || _isSubmitting)
                Container(
                  color: Theme.of(
                    context,
                  ).scaffoldBackgroundColor.withValues(alpha: (0.7 * 255)),
                  child: Center(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        strokeWidth: 6,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
