class EventCategory {
  final String id;
  final String name;
  final String iconPath;
  final String? imagePath;

  EventCategory({
    required this.id,
    required this.name,
    required this.iconPath,
     this.imagePath,
  });
}
