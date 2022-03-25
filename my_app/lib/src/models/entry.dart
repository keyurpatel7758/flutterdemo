class Entry {
  String? entryId = '';
  String date = '';
  String? entry = '';

  Entry({required this.date, this.entry, this.entryId});

  factory Entry.fromJson(Map<String, dynamic>? json) {
    return Entry(
        date: json!['date'], entry: json['entry'], entryId: json['entryId']);
  }

  Map<String, dynamic> toMap() {
    return {'date': date, 'entry': entry, 'entryId': entryId};
  }
}
