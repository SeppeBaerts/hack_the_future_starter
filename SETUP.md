# Setup Guide - Agentic Ocean Explorer

This guide walks you through setting up the Agentic Ocean Explorer app from scratch.

## Prerequisites

### Required Software
- **Flutter SDK** ≥ 3.35.7
- **Dart SDK** ≥ 3.9
- **Node.js** (for Firebase CLI)
- **Git**

### Check Your Environment

```bash
flutter --version
dart --version
node --version
```

If any are missing, install them first.

---

## Step 1: Clone the Repository

```bash
git clone https://github.com/SeppeBaerts/hack_the_future_starter.git
cd hack_the_future_starter
```

---

## Step 2: Install Dependencies

```bash
flutter pub get
```

This will install all required packages including:
- `firebase_core`
- `genui_firebase_ai`
- `logging`
- `http`

---

## Step 3: Firebase Setup

### 3.1 Install Firebase CLI

**macOS (Homebrew):**
```bash
brew install firebase-cli
```

**npm (all platforms):**
```bash
npm install -g firebase-tools
```

### 3.2 Login to Firebase

```bash
firebase login
```

This will open a browser window for authentication.

### 3.3 Create Firebase Project

**Option A: Via CLI**
```bash
firebase projects:create agentic-ocean-explorer --display-name "Agentic Ocean Explorer"
```

**Option B: Via Console**
Go to https://console.firebase.google.com/ and click "Add project"

### 3.4 Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

Make sure `~/.pub-cache/bin` is in your PATH.

### 3.5 Configure Firebase for Flutter

```bash
flutterfire configure --project <your-project-id>
```

**Interactive Mode:**
```bash
flutterfire configure --project agentic-ocean-explorer
```

This will:
- Create `lib/firebase_options.dart`
- Configure Android, iOS, Web, and macOS platforms
- Register your app with Firebase

**Non-Interactive Mode:**
```bash
flutterfire configure \
  --project agentic-ocean-explorer \
  --platforms=android,ios,web,macos \
  -y
```

### 3.6 Enable Firebase AI Logic API

**Via Google Cloud Console:**

1. Go to: https://console.developers.google.com/apis/api/firebasevertexai.googleapis.com/overview?project=<your-project-id>
2. Click "Enable"
3. Wait a few minutes for propagation

**Via gcloud CLI:**
```bash
gcloud services enable firebasevertexai.googleapis.com --project=<your-project-id>
```

### 3.7 Enable AI Logic in Firebase Console

1. Go to Firebase Console: https://console.firebase.google.com/project/<your-project-id>
2. Navigate to: **Build** → **AI Logic** → **Apps**
3. Click "Get started" or "Enable"
4. Select "Gemini Developer API"
5. Choose your platforms (Android, iOS, Web)
6. Confirm status shows "Enabled"

**⏰ Wait Time:** Changes can take 5-10 minutes to propagate.

---

## Step 4: Verify Setup

### 4.1 Check firebase_options.dart

```bash
ls -la lib/firebase_options.dart
```

The file should exist and contain your Firebase configuration.

### 4.2 Check API Status

Verify the API is enabled:
```bash
gcloud services list --enabled --project=<your-project-id> | grep vertex
```

---

## Step 5: Run the App

### For Web
```bash
flutter run -d chrome
```

### For Android Emulator
```bash
flutter run -d android
```

### For iOS Simulator
```bash
flutter run -d ios
```

### For macOS Desktop
```bash
flutter run -d macos
```

---

## Step 6: Test the App

Once the app is running:

1. **Verify Agent Log Panel** appears at the top
2. **Type a question**: "What is the ocean temperature in the North Sea?"
3. **Watch the Agent Log** fill with steps
4. **See the visualization** appear with custom widgets
5. **Try the Stop button** (be quick!)

---

## Troubleshooting

### Error: "Firebase AI Logic API not enabled"

**Solution:**
1. Enable API in Cloud Console (see Step 3.6)
2. Wait 5-10 minutes
3. Restart your app

### Error: "firebase_options.dart not found"

**Solution:**
```bash
flutterfire configure --project <your-project-id>
```

### Error: "Null check operator used on a null value"

**Likely Cause:** Firebase not initialized properly

**Solution:**
1. Check firebase_options.dart exists
2. Verify Firebase.initializeApp() is called in main.dart
3. Clean and rebuild:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### Error: Custom widgets not appearing

**Solution:**
1. Check that GenUI catalog is properly configured
2. Verify imports in genui_service.dart
3. Check console for GenUI errors

### API Quota Exceeded

If you see quota errors with Gemini API:
1. Check your Firebase project quota in Cloud Console
2. Enable billing if needed for higher quotas
3. Use mock data fallback (already implemented)

---

## Billing Information

### Free Tier Limits

**Gemini Developer API (Free Tier):**
- 60 requests per minute
- 1,500 requests per day
- No credit card required

**Firebase (Spark Plan - Free):**
- 1GB storage
- 10GB download/month
- Sufficient for development

### Upgrading

If you need more quota:
1. Go to Firebase Console → Settings → Usage and billing
2. Upgrade to Blaze plan (pay-as-you-go)
3. Set budget alerts to avoid surprises

---

## Platform-Specific Setup

### Android

No additional setup required. Firebase is configured via `google-services.json` (auto-generated by FlutterFire CLI).

### iOS

1. Open `ios/Runner.xcworkspace` in Xcode
2. Verify `GoogleService-Info.plist` is in the project
3. Build and run

### Web

No additional setup required. Firebase config is embedded in the generated code.

### macOS

1. Enable network access in `macos/Runner/DebugProfile.entitlements`:
   ```xml
   <key>com.apple.security.network.client</key>
   <true/>
   ```
2. FlutterFire CLI should handle this automatically

---

## Environment Variables (Optional)

For CI/CD or team development, you can use environment variables:

```bash
export FIREBASE_PROJECT_ID="agentic-ocean-explorer"
export FIREBASE_API_KEY="your-api-key"
```

Then modify `firebase_options.dart` to read from environment.

---

## Next Steps

Once setup is complete:

1. Read [IMPLEMENTATION.md](IMPLEMENTATION.md) for architecture details
2. Read [DEMO.md](DEMO.md) for example usage scenarios
3. Read [QUICKREF.md](QUICKREF.md) for quick reference
4. Try the example queries listed in README.md

---

## Getting Help

### Common Issues

- Check [DEMO.md](DEMO.md) → "Common Issues to Check" section
- Review Firebase Console logs
- Check Flutter console for error messages

### Resources

- **Flutter GenUI**: https://github.com/flutter/genui
- **Firebase Documentation**: https://firebase.google.com/docs
- **Gemini API**: https://ai.google.dev/
- **FlutterFire**: https://firebase.flutter.dev/

### Community

- Flutter Discord: https://discord.gg/flutter
- Firebase Discord: https://discord.gg/BN2cgc3
- Stack Overflow: Tag with `flutter`, `firebase`, `genui`

---

## Success Checklist

- [ ] Flutter SDK installed and verified
- [ ] Firebase CLI installed and logged in
- [ ] Firebase project created
- [ ] FlutterFire CLI configured
- [ ] firebase_options.dart generated
- [ ] Firebase AI Logic API enabled
- [ ] AI Logic enabled in Firebase Console
- [ ] App runs without errors
- [ ] Agent log displays steps
- [ ] Custom widgets render correctly
- [ ] Ocean data tools work

**✅ Once all items are checked, you're ready to explore!**

---

**Need help?** Review the troubleshooting section or check the documentation files.

**Ready to extend?** See IMPLEMENTATION.md for how to add new tools and widgets.
