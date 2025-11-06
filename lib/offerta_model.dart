class OfferModel {
  final int id;
  final String text;

  OfferModel({
    required this.id,
    required this.text,
  });

  // JSON dan parse qilish
  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as int,
      text: json['text'] as String,
    );
  }

  // JSON ga o‘tkazish
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }
}
