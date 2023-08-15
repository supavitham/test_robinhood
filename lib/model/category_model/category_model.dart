class CategoryModel {
  List<TaskModel>? tasks;
  int? pageNumber;
  int? totalPages;

  CategoryModel({
    this.tasks,
    this.pageNumber,
    this.totalPages,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        tasks: List<TaskModel>.from(json["tasks"].map((x) => TaskModel.fromJson(x))),
        pageNumber: json["pageNumber"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "tasks": List<dynamic>.from((tasks ?? []).map((x) => x.toJson())),
        "pageNumber": pageNumber,
        "totalPages": totalPages,
      };

  @override
  String toString() {
    return 'CategoryModel{tasks: $tasks, pageNumber: $pageNumber, totalPages: $totalPages}';
  }
}

class TaskModel {
  String? id;
  String? title;
  String? description;
  DateTime? createdAt;
  String? status;

  TaskModel({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.status,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        createdAt: DateTime.parse(json["createdAt"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "createdAt": createdAt?.toIso8601String(),
        "status": status,
      };

  @override
  String toString() {
    return 'TaskModel{id: $id, title: $title, description: $description, createdAt: $createdAt, status: $status}';
  }
}
