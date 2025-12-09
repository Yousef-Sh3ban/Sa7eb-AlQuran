# نظام اختيار ألوان التطبيق

## المزايا الجديدة

تم إضافة نظام شامل لاختيار ألوان التطبيق يتيح للمستخدم الاختيار بين 6 مخططات ألوان مختلفة.

## المخططات المتاحة

### 1. الأخضر الإسلامي (الافتراضي)
- اللون الأساسي: `#2E7D32`
- اللون الثانوي: `#388E3C`
- مناسب: للمظهر التقليدي الإسلامي

### 2. الأزرق الهادئ
- اللون الأساسي: `#1976D2`
- اللون الثانوي: `#42A5F5`
- مناسب: للباحثين عن الهدوء والتركيز

### 3. البنفسجي الروحاني
- اللون الأساسي: `#6A1B9A`
- اللون الثانوي: `#9C27B0`
- مناسب: للمظهر الروحاني والمميز

### 4. البرتقالي الدافئ
- اللون الأساسي: `#E65100`
- اللون الثانوي: `#FF6F00`
- مناسب: للطاقة والحيوية

### 5. البني الطبيعي
- اللون الأساسي: `#5D4037`
- اللون الثانوي: `#795548`
- مناسب: للمظهر الكلاسيكي والطبيعي

### 6. الأزرق الداكن الأنيق
- اللون الأساسي: `#0D47A1`
- اللون الثانوي: `#1565C0`
- مناسب: للأناقة والاحترافية

## كيفية الاستخدام من قبل المستخدم

1. افتح التطبيق
2. اذهب إلى تبويب "الإعدادات" في الشريط السفلي
3. في قسم "المظهر"، ستجد "اختر لون التطبيق"
4. اضغط على اللون المفضل
5. سيتم تطبيق اللون فوراً على كامل التطبيق
6. اختيارك محفوظ ويستمر بعد إغلاق التطبيق

## التحسينات على Text Styles

تم تحديث جميع نصوص التطبيق لاستخدام الألوان الصحيحة من الثيم:

### الألوان المستخدمة

- **onSurface**: للنصوص الرئيسية (العناوين والنصوص الهامة)
- **onSurfaceVariant**: للنصوص الثانوية (الشروحات والتفاصيل)
- **onPrimary**: للنصوص على خلفيات ملونة
- **onPrimaryContainer**: للنصوص على الحاويات الملونة

### Text Styles المحدثة

```dart
// العناوين الكبيرة
displayLarge, displayMedium, displaySmall
headlineLarge, headlineMedium, headlineSmall

// العناوين المتوسطة
titleLarge, titleMedium, titleSmall

// النصوص العادية
bodyLarge, bodyMedium, bodySmall

// التسميات
labelLarge, labelMedium, labelSmall
```

كل هذه الأنماط تأخذ اللون تلقائياً من الثيم المختار.

## للمطورين

### إضافة مخطط لون جديد

1. افتح `lib/core/themes/color_schemes.dart`
2. أضف مخطط جديد:

```dart
static const ColorScheme yourNewScheme = ColorScheme(
  primary: Color(0xFFYOURHEX),
  secondary: Color(0xFFYOURHEX),
  name: 'اسم اللون',
);
```

3. أضفه إلى قائمة `allSchemes`:

```dart
static const List<ColorScheme> allSchemes = [
  islamicGreen,
  calmBlue,
  // ... الألوان الأخرى
  yourNewScheme, // أضف اللون الجديد هنا
];
```

### تخصيص Text Style

لإضافة أو تعديل text style، افتح `lib/core/themes/app_theme.dart`:

```dart
static TextTheme _buildTextTheme(ColorScheme colorScheme) {
  return GoogleFonts.amiriTextTheme(
    ThemeData(brightness: colorScheme.brightness).textTheme,
  ).copyWith(
    // أضف أو عدل الأنماط هنا
    yourCustomStyle: GoogleFonts.amiri(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurface, // استخدم اللون من الثيم
    ),
  );
}
```

## الملفات المعدلة

1. **`lib/core/themes/color_schemes.dart`** - جديد
   - يحتوي على 6 مخططات ألوان
   - Helper methods للوصول للمخططات

2. **`lib/core/themes/app_theme.dart`** - محدث
   - دعم المخططات المخصصة
   - Text styles محسنة ومكتملة
   - استخدام الألوان الصحيحة من الثيم

3. **`lib/main.dart`** - محدث
   - حفظ واستعادة اختيار اللون
   - دالة `setColorScheme()` لتغيير اللون

4. **`lib/presentation/screens/home_screen.dart`** - محدث
   - widget اختيار اللون في الإعدادات
   - عرض جميع الألوان المتاحة
   - تمييز اللون المختار

## الحفظ التلقائي

- يتم حفظ اختيار اللون في `SharedPreferences`
- المفتاح: `colorSchemeIndex`
- يتم استعادة الاختيار عند فتح التطبيق
- يعمل مع الوضع الداكن والفاتح

## ملاحظات

- جميع الألوان متوافقة مع Material 3
- تعمل بشكل مثالي مع الوضع الفاتح والداكن
- النصوص تأخذ اللون الصحيح تلقائياً
- التطبيق يعيد تشغيل نفسه تلقائياً عند تغيير اللون
