class ContactModel {
  final String telegram;
  final String call;

  ContactModel({
    required this.telegram,
    required this.call,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      telegram: json['telegram'] ?? '',
      call: json['call'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'telegram': telegram,
      'call': call,
    };
  }
}
