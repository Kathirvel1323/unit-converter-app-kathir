import 'package:flutter/material.dart';

void main() => runApp(const UnitConverterApp());

enum Quantity { length, weight, temperature }

class UnitConverterApp extends StatelessWidget {
  const UnitConverterApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Unit Converter',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D4ED8)), useMaterial3: true),
        home: const ConverterHome(),
      );
}

class Unit {
  const Unit(this.name, this.symbol, this.factor);
  final String name;
  final String symbol;
  // Factor to the category's base unit. Temperature uses Celsius and is handled separately.
  final double factor;
}

const units = <Quantity, List<Unit>>{
  Quantity.length: [Unit('Meters', 'm', 1), Unit('Kilometers', 'km', 1000), Unit('Centimeters', 'cm', 0.01), Unit('Feet', 'ft', 0.3048)],
  Quantity.weight: [Unit('Grams', 'g', 1), Unit('Kilograms', 'kg', 1000), Unit('Pounds', 'lb', 453.59237), Unit('Ounces', 'oz', 28.349523125)],
  Quantity.temperature: [Unit('Celsius', '°C', 1), Unit('Fahrenheit', '°F', 1), Unit('Kelvin', 'K', 1)],
};

double convert(double value, Quantity type, String from, String to) {
  if (type == Quantity.temperature) {
    final celsius = switch (from) {
      '°F' => (value - 32) * 5 / 9,
      'K' => value - 273.15,
      _ => value,
    };
    return switch (to) {
      '°F' => celsius * 9 / 5 + 32,
      'K' => celsius + 273.15,
      _ => celsius,
    };
  }
  final categoryUnits = units[type]!;
  final fromUnit = categoryUnits.firstWhere((unit) => unit.symbol == from);
  final toUnit = categoryUnits.firstWhere((unit) => unit.symbol == to);
  return value * fromUnit.factor / toUnit.factor;
}

class ConverterHome extends StatelessWidget {
  const ConverterHome({super.key});

  @override
  Widget build(BuildContext context) {
    assert((convert(1000, Quantity.length, 'm', 'km') - 1).abs() < 1e-9);
    assert((convert(1000, Quantity.weight, 'g', 'kg') - 1).abs() < 1e-9);
    assert((convert(0, Quantity.temperature, '°C', '°F') - 32).abs() < 1e-9);
    return Scaffold(
      appBar: AppBar(title: const Text('Unit Converter'), centerTitle: true),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(padding: const EdgeInsets.all(20), children: [
            Text('Choose a category', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('Convert common measurements with clear, reusable unit data.'),
            const SizedBox(height: 20),
            const _CategoryTile(type: Quantity.length, icon: Icons.straighten),
            const _CategoryTile(type: Quantity.weight, icon: Icons.scale_outlined),
            const _CategoryTile(type: Quantity.temperature, icon: Icons.thermostat),
          ]),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.type, required this.icon});
  final Quantity type;
  final IconData icon;

  String get title => switch (type) { Quantity.length => 'Length', Quantity.weight => 'Weight', Quantity.temperature => 'Temperature' };

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
          title: Text(title),
          subtitle: Text(units[type]!.map((unit) => unit.symbol).join('  •  ')),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ConverterScreen(type: type, title: title))),
        ),
      );
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key, required this.type, required this.title});
  final Quantity type;
  final String title;

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final _valueController = TextEditingController(text: '1');
  late Unit _from;
  late Unit _to;

  @override
  void initState() {
    super.initState();
    _from = units[widget.type]!.first;
    _to = units[widget.type]![1];
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parsed = double.tryParse(_valueController.text.trim());
    final result = parsed == null ? null : convert(parsed, widget.type, _from.symbol, _to.symbol);
    return Scaffold(
      appBar: AppBar(title: Text('${widget.title} Converter')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              TextField(controller: _valueController, keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true), decoration: const InputDecoration(labelText: 'Value', border: OutlineInputBorder()), onChanged: (_) => setState(() {})),
              const SizedBox(height: 16),
              _unitDropdown(_from, (unit) => setState(() => _from = unit!)),
              const SizedBox(height: 8),
              const Center(child: Icon(Icons.south)),
              const SizedBox(height: 8),
              _unitDropdown(_to, (unit) => setState(() => _to = unit!)),
              const SizedBox(height: 24),
              if (result == null)
                const Text('Enter a valid number to convert.', style: TextStyle(color: Colors.red), textAlign: TextAlign.center)
              else
                Text('${result.toStringAsFixed(4)} ${_to.symbol}', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ]))),
          ),
        ),
      ),
    );
  }

  Widget _unitDropdown(Unit value, ValueChanged<Unit?> onChanged) => DropdownButtonFormField<Unit>(
        initialValue: value,
        decoration: const InputDecoration(border: OutlineInputBorder()),
        items: units[widget.type]!.map((unit) => DropdownMenuItem(value: unit, child: Text('${unit.name} (${unit.symbol})'))).toList(),
        onChanged: onChanged,
      );
}

