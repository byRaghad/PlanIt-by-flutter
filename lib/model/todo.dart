import 'package:hive/hive.dart';

part 'todo.g.dart'; //   يشير إلى الملف المنشئ تلقائيًا (todo.g.dart) الذي يحتوي على الكود الخاص بـ Hive لقراءة وكتابة البيانات.

//  تُستخدم لتحديد العنصر كنوع قابل للتخزين في قاعدة بيانات Hive.
@HiveType(typeId: 0)
class ToDo {
  @HiveField(0)
  String? id; //   يمثل id المهمة وهو فريد لكل مهمه

  @HiveField(1)
  String? todoText; //   نص المهمه

  @HiveField(2)
  bool isDone; //  يمثل حالة المهمة (تمت أو لا)

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false, // الحاله الافتراضيه للمهمه هي لم تكتمل بعد
  });
}
