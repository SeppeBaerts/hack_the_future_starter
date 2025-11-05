## Agentic Ocean Explorer – Barebones GenUI + Firebase AI Starter

Deze handleiding is toegespitst op dit starterproject. Een aantal stappen zijn al voor je gedaan, zodat je snel verder kunt.

Referentie: [Unlockd student briefing (PDF)](https://unlockd.be/wp-content/uploads/2025/10/student-briefing.pdf)

### Wat is al gedaan
- Flutter/Dart project staat klaar.
- Dependencies in `pubspec.yaml` bevatten al:
    - `firebase_core`
    - `flutter_genui_firebase_ai` (via Git)
    - `logging`

Je hoeft deze packages dus niet meer toe te voegen.

### Nog te doen (stappen)
1) Controleer versies
    - Vereist: Flutter ≥ 3.35.7 en Dart ≥ 3.9 (`flutter --version`).

2) Firebase configureren
   2a) Firebase CLI installeren & inloggen (eenmalig)
    - macOS (Homebrew):
      ```bash
      brew install firebase-cli
      ```
      of via npm (Node vereist):
      ```bash
      npm install -g firebase-tools
      ```
    - Log in bij Firebase (opent browser):
      ```bash
      firebase login
      ```
    - Controle (optioneel):
      ```bash
      firebase projects:list
      ```

   2b) Firebase project aanmaken (CLI of Console)
    - Via CLI (kies een uniek projectId):
      ```bash
      firebase projects:create agentic-ocean-explorer --display-name "Agentic Ocean Explorer"
      firebase projects:list   # noteer je projectId
      ```
      of via de Console: `https://console.firebase.google.com/` → Project maken.

   2c) FlutterFire CLI koppelen en opties genereren
    - Installeer/activeer FlutterFire CLI en genereer `lib/firebase_options.dart`:
      ```bash
      dart pub global activate flutterfire_cli
      flutterfire configure --project <jouw-projectId>
      ```
      Tip: je kunt platforms kiezen met `--platforms=android,ios,web,macos` en non-interactief met `-y`.
    - Dit voegt platformconfig toe en maakt `firebase_options.dart` aan. Zet je Firebase project op Web/Android/iOS naar wens.

   2d) Firebase AI Logic API inschakelen (vereist door GenUI Firebase AI)
   - Open de Google Cloud Console API-pagina voor jouw project en schakel de API in:
     - Ga naar `https://console.developers.google.com/apis/api/firebasevertexai.googleapis.com/overview?project=<jouw-projectId>`
     - Klik op “Enable”/“Inschakelen”.
   - Als je dit net hebt aangezet, wacht enkele minuten zodat de wijziging doorpropagereert.
   - Indien gevraagd: zorg dat billing is ingeschakeld op het project.
   - Start daarna de app opnieuw.

   2e) In Firebase Console: AI Logic (Gemini Developer API) inschakelen
   - Ga naar de Firebase Console van je project (voorbeeldlink):
     - `https://console.firebase.google.com/u/5/project/agentic-ocean-explorer/ailogic/apps`
   - Navigeer naar Build → AI Logic → Apps.
   - Klik op “Get started”/“Enable” en kies “Gemini Developer API”.
   - Selecteer de platformen (Android / iOS / Web) die je gebruikt en doorloop de stappen.
   - Bevestig dat de status “Enabled” is en wacht enkele minuten.
   - Tip: deze stap zorgt er doorgaans ook voor dat de onderliggende Cloud API geactiveerd is; zo niet, volg stap 2d.

3) Start de app
```bash
flutter run
```

### Optioneel: Tools en eigen widgets
- Extra tools: registreer met `DynamicAiTool` en geef door via `FirebaseAiContentGenerator(additionalTools: [...])`.
- MCP in Dart: zie [`mcp_dart` op pub.dev](https://pub.dev/packages/mcp_dart) (stdio/Streamable HTTP client/server).
- Eigen widgets toevoegen aan de catalog: maak een `CatalogItem` en voeg toe met `CoreCatalogItems.asCatalog().copyWith([jouwItem])`.

### Tips
- Houd system-instructies beknopt en taakgericht.
- Gebruik de core catalog voor snelle iteratie; breid later uit.
- Zet logging op `Level.ALL` tijdens ontwikkeling.


