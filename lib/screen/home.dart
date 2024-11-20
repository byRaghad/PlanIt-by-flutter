import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../constants/colors.dart';
import '../main.dart';
import '../model/todo.dart';
import '../widgets/todo_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Box<ToDo> todoBox;
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();

  // تحديد رسالة التحية بناءً على الوقت الحالي
  String getGreetingMessage(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return AppLocalizations.of(context)!.goodMorning;
    } else if (hour >= 12 && hour < 17) {
      return AppLocalizations.of(context)!.goodAfternoon;
    } else if (hour >= 17 && hour < 21) {
      return AppLocalizations.of(context)!.goodEvening;
    } else {
      return AppLocalizations.of(context)!.goodNight;
    }
  }

  @override
  void initState() {
    super.initState();
    todoBox = Hive.box<ToDo>('todoBox'); // فتح صندوق البيانات
    _foundToDo = todoBox.values.toList(); // جلب كل البيانات من صندوق Hive
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightgrey2,
      appBar: _buildAppBar(), // بناء شريط العنوان
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                searchBox(context), // مربع البحث
                Expanded(
                  child: _foundToDo.isEmpty
                      ? Center( // عرض رسالة عند عدم وجود مهام
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list_alt,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.noTasks,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                      : ListView( // عرض المهام
                    children: [
                      Container(
                        margin:
                        const EdgeInsets.only(top: 50, bottom: 20),
                        child: Text(
                          getGreetingMessage(context), // عرض رسالة التحية
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: burgundy,
                          ),
                        ),
                      ),
                      for (ToDo todo in _foundToDo.reversed) // عرض كل المهام مع التحديثات
                        ToDoItem(
                          todo: todo,
                          onToDoChanged: _handleToDoChange, // تغيير حالة المهمة
                          onDeleteItem: _deleteToDoItem, // حذف المهمة
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // توزيع متساوٍ للعناصر
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20, right: 10, left: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _todoController,
                      textDirection: Directionality.of(context) == TextDirection.rtl
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.addTask, // نص الإضافة
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20, right: 10, left: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      _addToDoItem(_todoController.text); // إضافة مهمة جديدة
                    },
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: burgundy,
                      minimumSize: const Size(60, 60),
                      elevation: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  // تغيير حالة المهمة (تمت أو لم تتم)
  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  // حذف المهمة من Hive
  void _deleteToDoItem(String id) {
    setState(() {
      if (todoBox.containsKey(id)) {
        todoBox.delete(id);
        _foundToDo = todoBox.values.toList();
      }
    });
  }

  // إضافة مهمة جديدة
  void _addToDoItem(String todoText) {
    final newToDo = ToDo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      todoText: todoText,
    );
    setState(() {
      todoBox.put(newToDo.id, newToDo); // حفظ المهمة في Hive
      _foundToDo = todoBox.values.toList();
    });
    _todoController.clear(); // مسح النص بعد الإضافة
  }

  // تصفية المهام بناءً على النص المدخل في البحث
  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todoBox.values.toList();
    } else {
      results = todoBox.values
          .where((item) => item.todoText!
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }

  // مربع البحث
  Widget searchBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          prefixIcon: const Icon(
            Icons.search,
            color: burgundy,
            size: 20,
          ),
          prefixIconConstraints:
          const BoxConstraints(maxHeight: 20, minWidth: 25),
          border: InputBorder.none,
          hintText: AppLocalizations.of(context)!.search,
        ),
      ),
    );
  }

  // بناء شريط العنوان
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: lightgrey2,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/img/logo.png', // مسار الصورة في مجلد المشروع
            height: 40, // تعديل الحجم حسب الحاجة
            width: 40,  // تعديل الحجم حسب الحاجة
          ),
          GestureDetector(
            onTap: () {
              MyApp.localeNotifier.value =
              MyApp.localeNotifier.value.languageCode == 'en'
                  ? const Locale('ar')
                  : const Locale('en');
            },
            child: const Icon(
              Icons.language,
              color: burgundy,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

}

