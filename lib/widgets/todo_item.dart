import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../model/todo.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo; // المهمة التي سيتم عرضها
  final onToDoChanged; // دالة يتم استدعاؤها عند تغيير حالة المهمة (تمت أو لم تتم)
  final onDeleteItem; // دالة لحذف المهمة

  // البناء الأساسي للعنصر، استقبال المتغيرات المطلوبة
  const ToDoItem({Key? key, required this.todo,required this.onToDoChanged,
    required this.onDeleteItem
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15), // إضافة هامش في الأسفل بين العناصر
      child: ListTile(
        onTap: () {
          // عند النقر على العنصر، يتم استدعاء دالة onToDoChanged لتحديث الحالة
          onToDoChanged(todo);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // تحديد الشكل بحدود مستديرة
        contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5), // تحديد المسافة الداخلية بين محتويات العنصر وحدوده من جميع الاتجاهات
        tileColor: Colors.white, // تحديد لون الخلفية للمهمة
        leading: Icon( // أيقونة الحالة (تمت أو لم تتم)
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank, // تغيير الأيقونة بناءً على حالة المهمة
          color: burgundy, //  لون الأيقونة
        ),
        title: Text( // النص المعروض في المهمة
          todo.todoText!, // نص المهمة
          style: TextStyle(
            fontSize: 18, // حجم الخط
            fontWeight: FontWeight.w500, // عرض الخط
            color: text, // لون النص
            decoration: todo.isDone ? TextDecoration.lineThrough : null, // إضافة خط في المنتصف إذا كانت المهمة مكتملة
          ),
        ),
        trailing: Container( //  الأيقونة (حذف)
          padding: EdgeInsets.zero, // إزالة مسافة بين محتوى العنصر وحدوده
          margin: EdgeInsets.symmetric(vertical: 0), // تقليل الهوامش لجعل العنصر في المنتصف
          width: 40, // تحديد عرض الأيقونة
          height: 40, // تحديد ارتفاع الأيقونة
          child: Center( // وضع الأيقونة في المنتصف تمامًا
            child: IconButton( // زر الحذف
              color: burgundy, // لون الأيقونة
              iconSize: 25, // حجم الأيقونة
              icon: Icon(Icons.delete), // تعيين الأيقونة لحذف المهمة
              onPressed: () {
                // عند الضغط على أيقونة الحذف، يتم استدعاء دالة onDeleteItem
                onDeleteItem(todo.id);
              },
            ),
          ),
        ),
      ),
    );
  }
}
