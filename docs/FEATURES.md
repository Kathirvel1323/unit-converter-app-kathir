# Unit Converter enhancements

- Length, weight, and temperature remain separate navigation screens.
- Swap the selected source and destination units instantly.
- Save the last five conversions for the current screen.
- Conversion results update live as values and units change.

## Structure

- `lib/main.dart`: unit data, conversion logic, category menu, and converter screen.
- `test/conversion_test.dart`: conversion logic checks.
- `test/widget_test.dart`: navigation and UI checks.

## Demo checklist

1. Open each conversion category from the home menu.
2. Enter a value and change the units.
3. Swap units and confirm the result updates.
4. Save a conversion and view it in Recent conversions.
