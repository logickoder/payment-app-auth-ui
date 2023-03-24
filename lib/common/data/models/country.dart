class Country {
  Country({
    required this.name,
    required this.dialCode,
    required this.emoji,
    required this.code,
  });

  final String name, dialCode, emoji, code;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        name: json['name'],
        dialCode: json['dial_code'],
        emoji: json['emoji'],
        code: json['code'],
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['dial_code'] = dialCode;
    data['emoji'] = emoji;
    data['code'] = code;
    return data;
  }
}
