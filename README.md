# Organic Farm

Flutter app for land, contracts, operations, production, finance, and media.

- Android application id: `com.orgaincfarm`
- iOS bundle id: `com.orgaincfarm`
- API: `https://theorgaincfarm.com/api/`

## Run

```powershell
cd E:\OrganicFarmFlutter
flutter pub get
flutter run
```

Android:

```powershell
flutter run -d android
```

iOS (macOS with Xcode):

```powershell
cd ios
pod install
cd ..
flutter run -d ios
```

## Release

- Android: `flutter build appbundle`
- iOS: open `ios/Runner.xcworkspace` in Xcode, set the signing team, then `flutter build ipa`
