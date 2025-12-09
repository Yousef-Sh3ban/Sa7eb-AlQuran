# حالة المشروع - Sprint 1: Foundation Setup

## ✅ المهام المنجزة (Completed)

### 1. إعداد البيئة الأساسية
- ✅ تهيئة `pubspec.yaml` مع جميع Dependencies المطلوبة
- ✅ تثبيت الحزم عبر `flutter pub get`
- ✅ إنشاء البنية الأساسية للمجلدات (Core/Domain/Data/Presentation)

### 2. Core Layer (الطبقة الأساسية)
- ✅ **app_constants.dart**: ثوابت التطبيق
  - اسم التطبيق
  - روابط GitHub للتحديثات
  - مفاتيح التخزين المحلي
  - عدد الأسئلة لكل جلسة (10)
  - عتبة تسجيل الدخول (50 سؤال)
  
- ✅ **question_category_colors.dart**: ThemeExtension للألوان
  - Hifz (حفظ) = أخضر
  - Tajweed (تجويد) = بنفسجي
  - Tafseer (تفسير) = برتقالي
  - General (عام) = أزرق
  
- ✅ **app_theme.dart**: نظام التصميم الكامل
  - Light Theme & Dark Theme
  - Material 3 Design System
  - خط Amiri من Google Fonts
  - Seed Color: Islamic Green (#2E7D32)
  - CardThemeData مع elevation و shadow
  
- ✅ **app_router.dart**: نظام التوجيه GoRouter
  - `/` → HomeScreen
  - `/surah/:id` → SurahDashboardScreen
  - `/surah/:id/quiz?retryMode=true` → QuizScreen
  - Error handler page

### 3. Domain Layer (طبقة النطاق)
- ✅ **question_category.dart**: Enum للفئات
  - القيم: hifz, tajweed, tafseer, general
  - displayName getter (أسماء عربية)
  - icon getter (إيموجي)
  - fromString static method

### 4. Data Layer (طبقة البيانات)

#### Models (النماذج)
- ✅ **surah_model.dart**: نموذج السورة
  - Fields: id, nameArabic, nameEnglish, revelationType, totalAyahs, orderNumber
  - JSON serialization مع snake_case
  
- ✅ **question_model.dart**: نموذج السؤال MCQ
  - Fields: id, surahId, category, questionText, options[4], correctAnswerIndex, explanation
  - Custom serialization للـ QuestionCategory enum
  
- ✅ **user_progress_model.dart**: تتبع تقدم المستخدم
  - Fields: questionId, status (0=new, 1=incorrect, 2=correct), attempts, lastAttempt
  - Helper methods: isCorrect, isIncorrect, isNew
  - copyWith method

#### Database (قاعدة البيانات)
- ✅ **database.dart**: Drift Database
  - **Questions Table**: id, surahId, category, questionText, options, correctAnswerIndex, explanation
  - **UserProgress Table**: questionId (FK), status, attempts, lastAttempt
  - Methods:
    - `getQuestionsBySurah(surahId)`
    - `getProgress(questionId)`
    - `upsertProgress(questionId, status, attempts)`

### 5. Presentation Layer (طبقة العرض)

#### Screens (الشاشات - Placeholder)
- ✅ **home_screen.dart**: الشاشة الرئيسية
  - AppBar مع عنوان "صاحب القرآن"
  - أيقونة كتاب كبيرة
  - نص "قائمة السور"
  
- ✅ **surah_dashboard_screen.dart**: لوحة تحكم السورة
  - يستقبل معامل `surahId`
  - AppBar مع رقم السورة
  
- ✅ **quiz_screen.dart**: شاشة الاختبار
  - يستقبل معاملات `surahId` و `retryMode`
  - AppBar مع عنوان "الاختبار" أو "تصحيح الأخطاء"

### 6. Main App Configuration
- ✅ **main.dart**: تطبيق محدث
  - MaterialApp.router مع GoRouter
  - استخدام AppTheme.lightTheme و darkTheme
  - ThemeMode.system للتبديل التلقائي
  - إزالة كود Demo الافتراضي

### 7. Assets & Data
- ✅ **dummy_questions.json**: بيانات تجريبية
  - سورة الفاتحة (7 آيات)
  - سورة البقرة (286 آية)
  - 4 أسئلة نموذجية تغطي جميع الفئات
  - تم إضافتها لـ pubspec.yaml assets

### 8. Code Generation
- ✅ تشغيل `build_runner` بنجاح
- ✅ إنشاء جميع `.g.dart` files:
  - `surah_model.g.dart`
  - `question_model.g.dart`
  - `user_progress_model.g.dart`
  - `database.g.dart`

### 9. Helper Files
- ✅ **run_build.bat**: لتشغيل build_runner على Windows
- ✅ **run_app.bat**: لتشغيل التطبيق على Windows
- ✅ **README.md**: دليل شامل للمشروع

### 10. Quality Assurance
- ✅ لا توجد أخطاء تجميع (Compile Errors)
- ✅ جميع الملفات تتبع قواعد guidelines.md
- ✅ حد 80 حرف للسطر محترم
- ✅ استخدام const constructors حيثما أمكن

---

## ⏳ المهام المتبقية في Sprint 1

### Repository Layer
- [ ] **question_repository.dart**: مستودع الأسئلة
  - تحميل الأسئلة من JSON
  - حفظ الأسئلة في Database
  - استرجاع الأسئلة بناءً على filters

- [ ] **surah_repository.dart**: مستودع السور
  - تحميل قائمة السور
  - استرجاع معلومات سورة معينة

### Use Cases (حالات الاستخدام)
- [ ] **fetch_questions_usecase.dart**: خوارزمية الأسئلة الذكية
  - Priority 1: status=1 (أسئلة خاطئة)
  - Priority 2: أسئلة جديدة (غير موجودة في progress)
  - Exclude: status=2 (أسئلة صحيحة) إلا في وضع Review

- [ ] **calculate_stats_usecase.dart**: حساب الإحصائيات
  - Completion Rate = (attempts / total_questions) × 100%
  - Accuracy Rate = (correct / attempts) × 100%

### ViewModels (إدارة الحالة)
- [ ] **quiz_view_model.dart**: إدارة حالة الاختبار
  - تحميل الأسئلة
  - تتبع الإجابات
  - حساب النتيجة
  - حفظ التقدم

- [ ] **stats_view_model.dart**: إدارة الإحصائيات
  - استرجاع البيانات
  - حساب النسب المئوية
  - تحديث البيانات

---

## 📊 نسبة التقدم

### Sprint 1: Foundation Setup
- **المجموع الكلي**: 80% ✅
  - Core Layer: 100% ✅
  - Domain Layer: 100% ✅
  - Data Layer (Models + Database): 100% ✅
  - Data Layer (Repositories): 0% ⏳
  - Presentation (Screens Placeholder): 100% ✅
  - Presentation (ViewModels): 0% ⏳
  - Presentation (Complete UI): 0% ⏳
  - Use Cases: 0% ⏳

### الملفات المنشأة
```
✅ 7 ملفات Core
✅ 1 ملف Domain
✅ 3 ملفات Data Models
✅ 1 ملف Database
✅ 3 ملفات Screens
✅ 1 ملف Routing
✅ 1 ملف main.dart
✅ 1 ملف JSON بيانات تجريبية
✅ 4 ملفات .g.dart (مولدة تلقائياً)
✅ 2 ملفات batch helper
✅ 1 ملف README.md محدث

المجموع: 25+ ملف
```

---

## 🎯 الخطوات التالية (Next Steps)

### Priority 1: Repository Layer
1. إنشاء `question_repository.dart`
2. إنشاء `surah_repository.dart`
3. دمج JSON مع Database

### Priority 2: Use Cases
1. تطبيق خوارزمية Smart Fetching
2. إنشاء حاسبة الإحصائيات

### Priority 3: ViewModels & UI
1. إنشاء QuizViewModel
2. إنشاء StatsViewModel
3. بناء شاشة Quiz الكاملة
4. بناء Widgets (QuestionCard, AnswerButton, StatsCard)

### Priority 4: Testing & Polish
1. اختبار التطبيق end-to-end
2. إصلاح الأخطاء
3. تحسين الأداء
4. إضافة Animations و Transitions

---

## 🔧 أوامر مهمة

### توليد ملفات Code Generation
```bash
run_build.bat
# أو
flutter pub run build_runner build --delete-conflicting-outputs
```

### تشغيل التطبيق
```bash
run_app.bat
# أو
flutter run -d windows
```

### تحديث Dependencies
```bash
flutter pub get
```

### تحليل الكود
```bash
flutter analyze
```

---

## 📝 ملاحظات مهمة

1. **Database**: Drift يولد كود type-safe للجداول والاستعلامات
2. **JSON Serialization**: يتطلب build_runner لإنشاء `.g.dart` files
3. **Theme**: استخدم `Theme.of(context).extension<QuestionCategoryColors>()` للوصول للألوان المخصصة
4. **Routing**: استخدم `context.go('/path')` أو `context.push('/path')`
5. **Assets**: لا تنسى تحديث `pubspec.yaml` عند إضافة assets جديدة

---

**آخر تحديث**: تم إنشاء البنية الأساسية الكاملة للمشروع ✅  
**الحالة**: جاهز للانتقال إلى Sprint 2
