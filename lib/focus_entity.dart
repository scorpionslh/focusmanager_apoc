class FocusEntity {
  final int id;
  final String name;
  final String description;
  final String image;
  final String? background;
  final String? color;

  FocusEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    this.background,
    this.color,
  });
}
