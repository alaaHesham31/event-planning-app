class EventCategory {
  final String id;        // Stable key, e.g. "sport"
  final String name;      // Localized name
  final String iconPath;  // Icon asset
  final String? imagePath; // Background image asset

  EventCategory({
    required this.id,
    required this.name,
    required this.iconPath,
     this.imagePath,
  });
}
