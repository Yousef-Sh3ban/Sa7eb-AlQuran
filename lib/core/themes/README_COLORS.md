# دليل استخدام ألوان التطبيق (AppColors)

## نظرة عامة
ملف `app_colors.dart` يحتوي على جميع الألوان والقيم الثابتة المستخدمة في التطبيق. هذا يسهل تغيير الألوان والأحجام من مكان واحد.

## كيفية الاستخدام

### 1. استيراد الملف
```dart
import 'package:sa7eb_alquran/core/themes/app_colors.dart';
```

### 2. الألوان الأساسية

#### اللون الأساسي
```dart
// استخدام اللون الأخضر الإسلامي الأساسي
Container(
  color: AppColors.primaryGreen,
)
```

#### ألوان الدقة (Accuracy)
```dart
// استخدام لون حسب نسبة الدقة
Color accuracyColor = AppColors.getAccuracyColor(85.0); // أخضر
Color accuracyColor = AppColors.getAccuracyColor(65.0); // برتقالي
Color accuracyColor = AppColors.getAccuracyColor(40.0); // أحمر

// أو استخدام الألوان مباشرة
Text('نجاح', style: TextStyle(color: AppColors.success))
Text('تحذير', style: TextStyle(color: AppColors.warning))
Text('خطأ', style: TextStyle(color: AppColors.error))
```

### 3. الشفافية

```dart
// إضافة شفافية للون
Container(
  color: AppColors.withOpacity(AppColors.primaryGreen, AppColors.opacity30),
)

// أو استخدام الشفافيات المحددة مسبقاً
BoxShadow(
  color: AppColors.withOpacity(Colors.black, AppColors.opacity15),
)
```

### 4. أحجام الخطوط

```dart
Text(
  'نص صغير',
  style: TextStyle(fontSize: AppColors.fontSizeSmall), // 10
)

Text(
  'نص عادي',
  style: TextStyle(fontSize: AppColors.fontSizeBody), // 12
)

Text(
  'عنوان',
  style: TextStyle(fontSize: AppColors.fontSizeHeading), // 18
)
```

### 5. أحجام الأيقونات

```dart
Icon(
  Icons.home,
  size: AppColors.iconSizeSmall, // 16
)

Icon(
  Icons.settings,
  size: AppColors.iconSizeMedium, // 20
)

Icon(
  Icons.emoji_events,
  size: AppColors.iconSizeXLarge, // 40
)
```

### 6. Border Radius

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(AppColors.radiusSmall), // 8
  ),
)

Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppColors.radiusLarge), // 16
  ),
)
```

### 7. المسافات (Spacing & Padding)

```dart
// Padding
Padding(
  padding: EdgeInsets.all(AppColors.spacingLarge), // 16
)

// المسافة بين العناصر
SizedBox(height: AppColors.spacingMedium) // 12
SizedBox(width: AppColors.spacingSmall) // 8

// Margin
Container(
  margin: EdgeInsets.fromLTRB(
    AppColors.spacingLarge,  // 16
    AppColors.spacingMedium, // 12
    AppColors.spacingLarge,  // 16
    AppColors.spacingSmall,  // 8
  ),
)
```

### 8. Elevation (الظل)

```dart
Card(
  elevation: AppColors.elevationLow, // 2
)

BoxShadow(
  blurRadius: AppColors.elevationHigh, // 8
)
```

## تغيير الألوان والقيم

لتغيير أي لون أو قيمة في التطبيق بالكامل، قم بتعديل القيم في ملف `app_colors.dart`:

```dart
// مثال: تغيير اللون الأساسي من الأخضر إلى الأزرق
static const Color primaryGreen = Color(0xFF1976D2); // أزرق

// مثال: تغيير حجم الخط الأساسي
static const double fontSizeBody = 14.0; // كان 12

// مثال: تغيير Border Radius
static const double radiusMedium = 16.0; // كان 12
```

## أمثلة عملية

### مثال 1: إنشاء Container مع جميع القيم من AppColors
```dart
Container(
  padding: EdgeInsets.all(AppColors.spacingLarge),
  margin: EdgeInsets.symmetric(
    horizontal: AppColors.spacingLarge,
    vertical: AppColors.spacingMedium,
  ),
  decoration: BoxDecoration(
    color: AppColors.primaryGreen,
    borderRadius: BorderRadius.circular(AppColors.radiusLarge),
    boxShadow: [
      BoxShadow(
        color: AppColors.withOpacity(AppColors.primaryGreen, AppColors.opacity30),
        blurRadius: AppColors.elevationMedium,
        offset: Offset(0, 2),
      ),
    ],
  ),
  child: Text(
    'مرحباً',
    style: TextStyle(
      fontSize: AppColors.fontSizeHeading,
      color: Colors.white,
    ),
  ),
)
```

### مثال 2: استخدام ألوان الدقة
```dart
Widget buildAccuracyWidget(double accuracy) {
  return Container(
    padding: EdgeInsets.all(AppColors.spacingMedium),
    decoration: BoxDecoration(
      color: AppColors.withOpacity(
        AppColors.getAccuracyColor(accuracy),
        AppColors.opacity15,
      ),
      borderRadius: BorderRadius.circular(AppColors.radiusMedium),
    ),
    child: Row(
      children: [
        Icon(
          Icons.gps_fixed,
          color: AppColors.getAccuracyColor(accuracy),
          size: AppColors.iconSizeMedium,
        ),
        SizedBox(width: AppColors.spacingSmall),
        Text(
          '${accuracy.toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: AppColors.fontSizeTitle,
            color: AppColors.getAccuracyColor(accuracy),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
```

## ملاحظات هامة

1. **الثبات**: جميع القيم ثابتة (`const`) لتحسين الأداء
2. **المركزية**: كل التعديلات تتم من مكان واحد
3. **الوضوح**: أسماء واضحة وموثقة بالعربية
4. **المرونة**: يمكن إضافة قيم جديدة بسهولة
5. **الاتساق**: ضمان تناسق التصميم في كل التطبيق

## إضافة قيم جديدة

لإضافة قيمة جديدة، اتبع النمط الموجود:

```dart
// في app_colors.dart
static const double yourNewValue = 24.0;
static const Color yourNewColor = Color(0xFFYOURHEX);
```

ثم استخدمها في أي مكان:
```dart
Container(
  height: AppColors.yourNewValue,
  color: AppColors.yourNewColor,
)
```
