class WorkerModel {
  final String name;
  final String skill;
  final String city;
  final String phone;

  WorkerModel({
    required this.name,
    required this.skill,
    required this.city,
    this.phone = '03XXXXXXXXX', // default placeholder
  });
}
