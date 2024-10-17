import 'package:doinikcakri/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doinikcakri/component/colors.dart';
import 'package:doinikcakri/widgets/texts.dart';

class AgeCalculatorScreen extends StatefulWidget {
  @override
  _AgeCalculatorScreenState createState() => _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends State<AgeCalculatorScreen> {
  TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  String? _age;

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  // Method to open date picker and select date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // Method to calculate age in years, months, and days
  void _calculateAge() {
    if (_selectedDate == null) {
      return;
    }

    DateTime today = DateTime.now();
    int years = today.year - _selectedDate!.year;
    int months = today.month - _selectedDate!.month;
    int days = today.day - _selectedDate!.day;

    if (days < 0) {
      months -= 1;
      days += DateTime(today.year, today.month, 0).day;
    }

    if (months < 0) {
      years -= 1;
      months += 12;
    }

    setState(() {
      _age = 'Your age is $years years, $months months, and $days days';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textPoppins(
            text: 'Age Calculator', color: textColor, isTile: false, fontSize: 18),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Date of Birth",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(onPressed: _calculateAge, title: 'Calculate Age'),
            const SizedBox(height: 20),
            _age != null
                ? textPoppins(text: _age!, color: primaryColor, isTile: false, fontSize: 18)
                : Container(),
          
          ],
        ),
      ),
    );
  }
}
