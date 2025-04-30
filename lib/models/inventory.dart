class BloodInventory {
  final String id;
  final String name;
  final double hemoglobin;
  final double concentration;
  final String bloodGroup;
  final String gender;
  final String createdAt;

  BloodInventory({
    required this.id,
    required this.name,
    required this.hemoglobin,
    required this.concentration,
    required this.bloodGroup,
    required this.gender,
    required this.createdAt
  });

  BloodInventory.fromJson(Map<String,Object?> json):this(
      id: json['id'] as String,
      hemoglobin: json['hemoglobin'] as double,
      name: json['name'] as String,
      concentration: json['concentration'] as double,
      bloodGroup: json['bloodGroup'] as String,
      gender: json['gender'] as String,
      createdAt: json['createdAt'] as String
  );
  Map<String,Object?> toJson(){
    return {
      'id': id,
      'name':name,
      'bloodGroup':bloodGroup,
      'gender':gender,
      'createdAt': createdAt,
      'concentration':concentration,
      'bloodGroup': bloodGroup,
      'createdAt':createdAt
    };
  }
}