class Request {
  final String id;
  final String name;
  final String contact;
  final String hospital;
  final String residence;
  final String case_;
  final int bags;
  final String bloodGroup;
  final String gender;
  final String details;
  final String userId;
  Request({
    required this.id,
    required this.name,
    required this.contact,
    required this.hospital,
    required this.residence,
    required this.case_,
    required this.bags,
    required this.bloodGroup,
    required this.gender,
    required this.details,
    required this.userId
  });

  Request.fromJson(Map<String,Object?> json):this(
    id: json['id'] as String,
    name: json['name'] as String,
    contact: json['contact'] as String,
    hospital: json['hospital'] as String,
    residence: json['residence'] as String,
    case_: json['case_'] as String,
    bags: json['bags'] as int,
    bloodGroup: json['bloodGroup'] as String,
    gender: json['gender'] as String,
    details: json['details'] as String,
    userId: json['userId'] as String,
  );
  Map<String,Object?> toJson(){
    return {
      'id': id,
      'name':name,
      'contact': contact,
      'hospital': hospital,
      'residence': residence,
      'case': case_,
      'bags':bags,
      'bloodGroup':bloodGroup,
      'gender':gender,
      'details':details,
      'userId':userId,
    };
  }

}