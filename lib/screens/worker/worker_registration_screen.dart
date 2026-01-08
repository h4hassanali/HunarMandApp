import 'package:flutter/material.dart';
import 'package:hassan_app/widgets/footer_note.dart';
import '../../data/skills.dart';
import '../../data/firestore_service.dart';
import '../../data/city_service.dart';
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

  late Future<Map<String, List<String>>> _citiesFuture;

  @override
  void initState() {
    super.initState();
    _citiesFuture = _cityService.fetchCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('کاریگر رجسٹریشن')),
      body: SafeArea(
        child: FooterNote(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<Map<String, List<String>>>(
              future: _citiesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(
                    child: Text('شہر لوڈ کرنے میں مسئلہ ہوا'),
                  );
                }

                final cities = snapshot.data!;

                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'براہِ کرم اپنی درست معلومات درج کریں',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),

                      // Name
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'نام',
                          hintText: 'مثال: محمد اسلم',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'براہِ کرم اپنا نام درج کریں'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Phone
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'فون نمبر',
                          hintText: 'مثال: 03XXXXXXXXX',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'براہِ کرم اپنا فون نمبر درج کریں'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Province dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedProvince,
                        decoration: const InputDecoration(
                          labelText: 'صوبہ منتخب کریں',
                          border: OutlineInputBorder(),
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
                        validator: (value) =>
                            value == null ? 'براہِ کرم صوبہ منتخب کریں' : null,
                      ),
                      const SizedBox(height: 20),

                      // City dropdown
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
                                    (city) => DropdownMenuItem(
                                      value: city,
                                      child: Text(city),
                                    ),
                                  )
                                  .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedCity = value),
                        validator: (value) =>
                            value == null ? 'براہِ کرم شہر منتخب کریں' : null,
                      ),
                      const SizedBox(height: 20),

                      // Skills
                      InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'مہارت منتخب کریں',
                          border: OutlineInputBorder(),
                        ),
                        child: Column(
                          children: skills
                              .map(
                                (skill) => CheckboxListTile(
                                  title: Text(skill),
                                  value: _selectedSkills.contains(skill),
                                  onChanged: (selected) {
                                    setState(() {
                                      if (selected == true) {
                                        _selectedSkills.add(skill);
                                      } else {
                                        _selectedSkills.remove(skill);
                                      }
                                    });
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Submit
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              _selectedSkills.isNotEmpty) {
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
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'کچھ غلط ہو گیا، دوبارہ کوشش کریں',
                                  ),
                                ),
                              );
                            }
                          } else if (_selectedSkills.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'براہِ کرم کم از کم ایک مہارت منتخب کریں',
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
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
    );
  }
}
