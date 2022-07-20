class DataModel {
  String id;
  String name;
  String description;
  DateTime createdAt ,updatedAt;
  String userId;

  DataModel({required this.userId,required this.id,required this.name,required this.description,required this.createdAt,required this.updatedAt});
}