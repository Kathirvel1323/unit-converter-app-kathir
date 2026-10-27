# Unit Converter with Navigation

A Flutter app with a home menu and one reusable conversion screen for length, weight, and temperature. Length and weight use conversion factors; temperature uses dedicated formulas. Invalid input is reported without crashing.

## Run

Open [DartPad](https://dartpad.dev/), choose Flutter, paste `lib/main.dart`, and press **Run**. For a local run, install Flutter, run `flutter create --platforms=web .` once, then run `flutter pub get` and `flutter run -d chrome`.

## Checklist

- Uses a home menu, Navigator routes, and the standard back button for all three categories.
- Stores units as data and reuses one conversion screen; temperature uses dedicated formulas.
- Invalid input displays an inline message.
- Verify meters/kilometers, grams/kilograms, Celsius/Fahrenheit, and navigation back home.
- Run `flutter test`; GitHub Actions analyzes, tests, builds, and publishes the web preview.
