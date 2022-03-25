class Profile {
  String userId = '';
  bool isGujaratiSelected = false;
  bool isEnglishSelected = false;
  bool isMainTeacher = false;
  bool isAssistantTeacher = false;
  String standards = '';
  String subjects = '';

  Profile(
      {required this.userId,
      required this.isGujaratiSelected,
      required this.isEnglishSelected,
      required this.isMainTeacher,
      required this.isAssistantTeacher,
      required this.standards,
      required this.subjects});

  factory Profile.fromJson(Map<String, dynamic>? json) {
    return Profile(
        userId: json!['userId'],
        isGujaratiSelected: json['isGujaratiSelected'],
        isEnglishSelected: json['isEnglishSelected'],
        isMainTeacher: json['isMainTeacher'],
        isAssistantTeacher: json['isAssistantTeacher'],
        standards: json['standards'],
        subjects: json['subjects']);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'isGujaratiSelected': isGujaratiSelected,
      'isEnglishSelected': isEnglishSelected,
      'isMainTeacher': isMainTeacher,
      'isAssistantTeacher': isAssistantTeacher,
      'standards': standards,
      'subjects': subjects
    };
  }
}
