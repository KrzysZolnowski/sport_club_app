import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddPlayerScreen extends StatefulWidget {
  const AddPlayerScreen({super.key});

  @override
  State<AddPlayerScreen> createState() => _AddPlayerScreenState();
}

class _AddPlayerScreenState extends State<AddPlayerScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _peselController = TextEditingController();
  final _joinDateController = TextEditingController();
  final _medicalExpiryController = TextEditingController();

  DateTime? _birthDate;
  DateTime? _joinDate;
  DateTime? _medicalExpiryDate;

  bool _licensePaid = false;

  bool get _isActiveInSel {
    final today = DateTime.now();
    return _medicalExpiryDate != null &&
        _medicalExpiryDate!.isAfter(today) &&
        _licensePaid;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _peselController.dispose();
    _joinDateController.dispose();
    _medicalExpiryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context,
      TextEditingController controller,
      Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
        onDateSelected(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dodaj zawodnika')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Imię i nazwisko'),
                onChanged: (value) {
                  final capitalized = value
                      .split(' ')
                      .map((w) => w.isNotEmpty
                          ? w[0].toUpperCase() + w.substring(1).toLowerCase()
                          : '')
                      .join(' ');
                  if (capitalized != value) {
                    _nameController.value = TextEditingValue(
                      text: capitalized,
                      selection:
                          TextSelection.collapsed(offset: capitalized.length),
                    );
                  }
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Podaj imię i nazwisko'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _peselController,
                decoration: InputDecoration(
                  labelText: 'PESEL',
                  suffixIcon: _peselController.text.length == 11 &&
                          RegExp(r'^[0-9]{11}$').hasMatch(_peselController.text)
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Podaj PESEL';
                  if (!RegExp(r'^[0-9]{11}$').hasMatch(value))
                    return 'PESEL musi mieć 11 cyfr';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _birthDateController,
                decoration: const InputDecoration(labelText: 'Data urodzenia'),
                readOnly: true,
                onTap: () => _selectDate(
                    context, _birthDateController, (date) => _birthDate = date),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _joinDateController,
                decoration:
                    const InputDecoration(labelText: 'Data przyjęcia do klubu'),
                readOnly: true,
                onTap: () => _selectDate(
                    context, _joinDateController, (date) => _joinDate = date),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _medicalExpiryController,
                decoration: const InputDecoration(
                    labelText: 'Termin ważności badań lekarskich'),
                readOnly: true,
                onTap: () =>
                    _selectDate(context, _medicalExpiryController, (date) {
                  _medicalExpiryDate = date;
                  setState(
                      () {}); // TU dodajemy setState, by odświeżyć status SEL
                }),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Licencja zawodnicza opłacona'),
                  const Spacer(),
                  Switch(
                    value: _licensePaid,
                    onChanged: (value) => setState(() => _licensePaid = value),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Aktywny w systemie SEL:'),
                  const SizedBox(width: 10),
                  Icon(
                    _isActiveInSel ? Icons.check_circle : Icons.cancel,
                    color: _isActiveInSel ? Colors.green : Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Zapisz dane zawodnika
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Zawodnik zapisany!')),
                    );
                  }
                },
                child: const Text('Zapisz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
