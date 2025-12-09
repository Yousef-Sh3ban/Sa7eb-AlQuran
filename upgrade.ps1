# تنظيف وتحديث المشروع بالكامل
Write-Host "🧹 تنظيف المشروع..." -ForegroundColor Yellow
flutter clean

Write-Host "`n📦 تحديث جميع الحزم..." -ForegroundColor Green
flutter pub upgrade

Write-Host "`n✅ تم التحديث بنجاح!" -ForegroundColor Green
Write-Host "`nلتشغيل التطبيق: flutter run" -ForegroundColor Cyan
