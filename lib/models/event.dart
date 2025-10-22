class Event {
  final String title;
  final String badge;
  final String imageUrl;
  final String price;
  final String type;
  final String place;
  final DateTime date;
  final String category;
  Event({
    required this.title,
    required this.imageUrl,
    required this.type,
    required this.badge,
    required this.price,
    required this.place,
    required this.date,
    required this.category,
  });
}
