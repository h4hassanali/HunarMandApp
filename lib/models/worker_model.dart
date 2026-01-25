class WorkerModel {
  final String id;
  final String name;
  final String skill;
  final String city;
  final String phone;

  WorkerModel({
    this.id = '', // Default empty, or required if preferred. Using empty for backward compat temporarily.
    required this.name,
    required this.skill,
    required this.city,
    this.phone = '03XXXXXXXXX', // default placeholder
  });
}
