class Donation {
  final String id;
  final String name;
  final String contact;
  final String hospital;
  final String residence;
  final int donationsDone;
  final String bloodGroup;
  final String gender;
  final String details;
  final String userId;
  final int weight;
  final int age;
  final String lastDonated;
  final String donationFrequency;
  final String highestEducation;
  final String currentOccupation;
  final String currentLivingArrg;
  final String eligibilityTest;
  final String futureDonationWillingness;
  final String createdAt;



  Donation({
    required this.id,
    required this.name,
    required this.contact,
    required this.hospital,
    required this.residence,
    required this.donationsDone,
    required this.bloodGroup,
    required this.gender,
    required this.details,
    required this.userId,
    required this.weight,
    required this.age,
    required this.lastDonated,
    required this.donationFrequency,
    required this.highestEducation,
    required this.currentOccupation,
    required this.currentLivingArrg,
    required this.eligibilityTest,
    required this.futureDonationWillingness,
    required this.createdAt

  });

  Donation.fromJson(Map<String, Object?> json) :this(
      id: json['id'] as String,
      name: json['name'] as String,
      contact: json['contact'] as String,
      hospital: json['hospital'] as String,
      residence: json['residence'] as String,
      bloodGroup: json['bloodGroup'] as String,
      gender: json['gender'] as String,
      details: json['details'] as String,
      donationsDone: json['donations_done'] as int,
      userId: json['userId'] as String,
      weight: json['weight'] as int,
      age: json['age'] as int,
      lastDonated: json['last_donated'] as String,
      donationFrequency: json['donation_frequency'] as String,
      highestEducation: json['education'] as String,
      currentOccupation: json['occupation'] as String,
      currentLivingArrg: json['living'] as String,
      eligibilityTest: json['eligible'] as String,
      futureDonationWillingness: json['future_will'] as String,
      createdAt:json['createdAt'] as String
   );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'hospital': hospital,
      'residence': residence,
      'donations_done': donationsDone,
      'bloodGroup': bloodGroup,
      'gender': gender,
      'details': details,
      'userId': userId,
      'weight': weight,
      'age': age,
      'last_donated': lastDonated,
      'donation_frequency': userId,
      'education': highestEducation,
      'occupation': currentOccupation,
      'living': currentLivingArrg,
      'eligible': eligibilityTest,
      'future_will': futureDonationWillingness,
      'createdAt':createdAt
    };
  }
}