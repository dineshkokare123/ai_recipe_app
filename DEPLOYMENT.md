# 📋 Deployment Checklist

## Before You Deploy

### ✅ API Configuration
- [ ] Add your Gemini API key to `lib/services/gemini_service.dart`
- [ ] Test API key works correctly
- [ ] Consider using environment variables for production
- [ ] Set up API usage monitoring

### ✅ Testing
- [ ] Test on iOS device/simulator
- [ ] Test on Android device/emulator
- [ ] Test recipe generation
- [ ] Test offline functionality
- [ ] Test search and filters
- [ ] Test favorites system
- [ ] Test rating system
- [ ] Test share functionality
- [ ] Test error scenarios

### ✅ Performance
- [ ] Run `flutter analyze` and fix issues
- [ ] Test app performance
- [ ] Check memory usage
- [ ] Verify image caching works
- [ ] Test with large recipe collections

### ✅ Assets
- [ ] Add app icon (iOS & Android)
- [ ] Add launch screen images
- [ ] Add placeholder recipe images (optional)
- [ ] Add demo video (optional)

### ✅ App Store Preparation

#### iOS (App Store)
- [ ] Update `ios/Runner/Info.plist` with app info
- [ ] Set bundle identifier
- [ ] Configure signing in Xcode
- [ ] Create app icons (1024x1024 for store)
- [ ] Prepare screenshots (required sizes)
- [ ] Write app description
- [ ] Set privacy policy URL
- [ ] Test on real iOS device

#### Android (Play Store)
- [ ] Update `android/app/build.gradle`
- [ ] Set application ID
- [ ] Configure signing key
- [ ] Create app icons (512x512 for store)
- [ ] Prepare screenshots (required sizes)
- [ ] Write app description
- [ ] Set privacy policy URL
- [ ] Test on real Android device

### ✅ Documentation
- [x] README.md
- [x] QUICK_START.md
- [x] API_SETUP.md
- [x] FEATURES.md
- [ ] Privacy Policy
- [ ] Terms of Service (if needed)
- [ ] Support email/contact

### ✅ Code Quality
- [ ] Remove debug print statements (or use proper logging)
- [ ] Remove unused imports
- [ ] Add error logging (consider using Sentry/Firebase Crashlytics)
- [ ] Optimize images
- [ ] Minify code for release

### ✅ Security
- [ ] Never commit API keys to git
- [ ] Add `.env` to `.gitignore`
- [ ] Review permissions in AndroidManifest.xml
- [ ] Review permissions in Info.plist
- [ ] Implement rate limiting for API calls

## Build Commands

### Development Build
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android
```

### Release Build

#### Android APK
```bash
flutter build apk --release
```

#### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## App Store Submission

### iOS App Store
1. Open Xcode
2. Select "Product" > "Archive"
3. Upload to App Store Connect
4. Fill in app information
5. Submit for review

### Google Play Store
1. Create app in Play Console
2. Upload app bundle
3. Fill in store listing
4. Complete content rating
5. Submit for review

## Post-Deployment

### ✅ Monitoring
- [ ] Set up analytics (Firebase Analytics, etc.)
- [ ] Set up crash reporting
- [ ] Monitor API usage
- [ ] Track user feedback

### ✅ Marketing
- [ ] Create landing page
- [ ] Prepare social media posts
- [ ] Create demo video
- [ ] Write blog post
- [ ] Submit to app directories

### ✅ Support
- [ ] Set up support email
- [ ] Create FAQ
- [ ] Monitor reviews
- [ ] Respond to user feedback

## Version Management

### Current Version
- Version: 1.0.0
- Build: 1

### Update Locations
- `pubspec.yaml` (line 19)
- `android/app/build.gradle` (versionCode & versionName)
- `ios/Runner/Info.plist` (CFBundleVersion & CFBundleShortVersionString)

## Required Permissions

### Android (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

### iOS (Info.plist)
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to save recipe images</string>
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to take recipe photos</string>
```

## Environment-Specific Configuration

### Development
- Use test API key
- Enable debug logging
- Show error details

### Production
- Use production API key
- Disable debug logging
- Hide error details
- Enable crash reporting

## Backup & Recovery

### Before Major Updates
- [ ] Backup current codebase
- [ ] Tag release in git
- [ ] Document changes
- [ ] Test migration path

## Legal Requirements

### Privacy Policy
Must include:
- What data is collected
- How data is used
- How data is stored
- User rights
- Contact information

### App Store Requirements
- Age rating
- Content warnings
- In-app purchases (if any)
- Subscription details (if any)

## Optimization Tips

### Reduce App Size
```bash
flutter build apk --split-per-abi
```

### Analyze Bundle Size
```bash
flutter build apk --analyze-size
```

### Performance Profiling
```bash
flutter run --profile
```

## Common Issues & Solutions

### Issue: API Key Not Working
- Verify key is correct
- Check API is enabled in Google Cloud Console
- Verify billing is set up

### Issue: Build Fails
- Run `flutter clean`
- Run `flutter pub get`
- Delete `build` folder
- Try again

### Issue: App Crashes on Startup
- Check Hive initialization
- Verify all dependencies are compatible
- Check for null safety issues

## Success Criteria

Before marking deployment as complete:
- [ ] App runs without crashes
- [ ] All features work as expected
- [ ] Performance is acceptable
- [ ] UI looks good on all screen sizes
- [ ] Offline mode works correctly
- [ ] API integration works
- [ ] User feedback is positive

## Next Version Planning

### v1.1.0 (Planned Features)
- [ ] Recipe video recording
- [ ] Meal planning calendar
- [ ] Shopping list generation
- [ ] Cloud backup
- [ ] Social sharing

---

**Last Updated**: November 2024  
**Status**: Ready for deployment after API key configuration  
**Priority**: High - Production ready
