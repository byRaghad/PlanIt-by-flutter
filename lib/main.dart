import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'screen/home.dart';
import 'model/todo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();//  يضمن أن النظام الأساسي (Flutter) جاهز لأي عمليات غير متزامنة.
  await Hive.initFlutter();// يهيئ مكتبة Hive (وهي قاعدة بيانات محلية) لاستخدامها مع Flutter.
  Hive.registerAdapter(ToDoAdapter());//تحويل المهام الى شكل يمكن تخزينه داخل Hive
  await Hive.openBox<ToDo>('todoBox');//لتخزين واسترجاع بيانات todo
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  //متغير لمراقبة وتغيير لغة التطبيق قابل للتحديث ديناميكيًا باستخدام ValueNotifier
  //هنا احدد التطبيق يفتح بأي لغة
  static final ValueNotifier<Locale> localeNotifier = ValueNotifier<Locale>(const Locale('ar'));
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //يجعل ال status bar شفاف
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return ValueListenableBuilder<Locale>(
      //مراقبة تغييرات اللغه
      valueListenable: localeNotifier,
      //  يُعيد بناء واجهة التطبيق عند تغيير اللغة.
      builder: (context, locale, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'PlanIt',
          //يحدد مصادر النصوص المترجمه
          localizationsDelegates: const [
            //  // مفوض خاص بتوفير النصوص المترجمة للتطبيق بناءً على ملفات الترجمة (arb files).
            AppLocalizations.delegate,
            // مفوض لدعم ترجمة النصوص الافتراضية لمكتبة Material Design.
            GlobalMaterialLocalizations.delegate,
            // مفوض لدعم ترجمة النصوص العامة في أدوات Flutter.
            GlobalWidgetsLocalizations.delegate,
            // مفوض لدعم ترجمة النصوص الخاصة بأدوات Cupertino لنظام iOS.
            GlobalCupertinoLocalizations.delegate,
          ],
          //يحدد اللغات المدعومه وهي العربي والانجليزي
          supportedLocales: const [
            Locale('en', ''),
            Locale('ar', ''),
          ],
          //تحدد اللغة الافتراضية لواجهة التطبيق. يتم تحديثها عند تغيير اللغة من إعدادات التطبيق.
          locale: locale,
          home: const Home(),
        );
      },
    );
  }
}
