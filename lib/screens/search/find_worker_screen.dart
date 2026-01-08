import 'package:flutter/material.dart';
import 'package:hassan_app/widgets/footer_note.dart';
import '../../data/cities.dart';
import '../../data/skills.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('کاریگر تلاش کریں')),
      body: SafeArea(
        child: FooterNote(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'اپنی ضرورت کے مطابق معلومات منتخب کریں',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  // Province Dropdown
                  DropdownButtonFormField<String>(
                    initialValue: _selectedProvince,
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

                  // City Dropdown
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCity,
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
                    onChanged: (value) {
                      setState(() {
                        _selectedCity = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'براہِ کرم شہر منتخب کریں' : null,
                  ),
                  const SizedBox(height: 20),

                  // Skill Dropdown
                  DropdownButtonFormField<String>(
                    initialValue: _selectedSkill,
                    decoration: const InputDecoration(
                      labelText: 'کاریگر کی قسم منتخب کریں',
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
                    validator: (value) =>
                        value == null ? 'براہِ کرم مہارت منتخب کریں' : null,
                  ),
                  const SizedBox(height: 30),

                  // Search Button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushNamed(
                          context,
                          '/worker-results',
                          arguments: {
                            'province': _selectedProvince,
                            'city': _selectedCity,
                            'skill': _selectedSkill,
                          },
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
                      'تلاش کریں',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
