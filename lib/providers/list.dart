class List {
  String listId;
  String title;
  int icon;
  int color;

  List({
    required this.listId,
    required this.title,
    required this.icon,
    required this.color
  });

  factory List.fromJson(Map<String,dynamic> data){
    final listId = data['listId'] as String;
    final title = data['title'] as String;
    final icon = data['icon'] as int;
    final color = data['color'] as int;
    return List(listId: listId, title: title, icon: icon, color: color);
  }
  Map<String,dynamic> toJson(){
    return {
      'listId': listId,
      'title': title,
      'icon': icon,
      'color': color
    };
  }
}