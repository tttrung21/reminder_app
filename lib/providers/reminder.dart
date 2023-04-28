enum Priority { None, Low, Medium, High }

class Reminder {
  String reminderId;
  String listId;
  String title;
  DateTime? dueDate;
  DateTime? dueTime;
  bool flagged;
  bool completed;
  List<String>? tags;
  Priority priority;
  List<String>? subTasks;
  String? imageUrl;
  String? notes;
  int? repeat;

  Reminder(
      {required this.reminderId,
      required this.listId,
      required this.title,
      this.dueDate,
      this.dueTime,
      this.flagged = false,
      this.completed = false,
      this.tags,
      this.priority = Priority.None,
      this.subTasks,
      this.imageUrl,
      this.notes,
      this.repeat});

  factory Reminder.fromJson(Map<String, dynamic> data) {
    final reminderId = data['reminderId'] as String;
    final listId = data['listId'] as String;
    final title = data['title'] as String;
    final dueDate = data['dueDate'] as String;
    final dueTime = data['dueTime'] as String;
    final flagged = data['flagged'] as bool;
    final completed = data['completed'] as bool;
    final tags = data['tags'] as List<String>?;
    final priority = data['priority'] as String;
    final subTasks = data['subTasks'] as List<String>?;
    final imageUrl = data['imageUrl'] as String?;
    final notes = data['notes'] as String?;
    final repeat = data['repeat'] as int?;

    return Reminder(
        reminderId: reminderId,
        listId: listId,
        title: title,
        dueDate: data['dueDate'] == null
            ? null
            : DateTime.parse(dueDate),
        dueTime: data['dueTime'] == null
            ? null
            : DateTime.parse(dueTime),
        flagged: flagged,
        completed: completed,
        tags: tags == null
            ? null
            : List<String>.from(tags),
        priority: Priority.values.firstWhere(
                (element) => element.name == priority),
        subTasks: subTasks== null
            ? null
            : List<String>.from(subTasks),
        imageUrl: imageUrl,
        notes: notes,
        repeat: repeat);
  }
  Map<String,dynamic> toJson(){
    return{
      'reminderId': reminderId,
      'listId': listId,
      'title': title,
      'dueDate': dueDate?.toIso8601String(),
      'dueTime': dueTime?.toIso8601String(),
      'flagged': flagged,
      'completed': completed,
      'tags': tags,
      'priority': priority.toString().substring(9),
      'subTasks': subTasks,
      'imageUrl': imageUrl,
      'notes': notes,
      'repeat': repeat
    };
  }
}
