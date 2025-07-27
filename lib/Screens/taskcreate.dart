import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shakti/Utils/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskCreateScreen extends StatefulWidget {
  @override
  _TaskCreateScreenState createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String _priority = 'Medium';

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? DateTime.now() : (_startDate ?? DateTime.now()),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Scolor.secondry,
              onPrimary: Scolor.dark,
              surface: Scolor.primary,
              onSurface: Scolor.white,
            ),
            dialogBackgroundColor: Scolor.primary,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _createTask() async {
    if (_formKey.currentState!.validate() &&
        _startDate != null &&
        _endDate != null) {
      final url = Uri.parse('http://13.233.25.114:5000/tasks/create');

      // 🔐 Get the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("🔐 Token not found. Please login again.")),
        );
        return;
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'startDate': DateFormat('yyyy-MM-dd').format(_startDate!),
          'endDate': DateFormat('yyyy-MM-dd').format(_endDate!),
          'priority': _priority,
        }),
      );

      if (response.statusCode == 201) {
        // ✅ Task creation successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Task Created Successfully")),
        );
        Navigator.pop(context);
      } else {
        // ❌ Handle failure
        final res = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed: ${res['message']}")),
        );
      }
    } else {
      // ⚠️ Validation failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❗ Please fill all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F1125),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Create Task", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow.shade700,
        child: Icon(Icons.check, color: Colors.black),
        onPressed: _createTask,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildInput("Task Title", _titleController),
              SizedBox(height: 16),
              buildInput("Description", _descriptionController, maxLines: 3),
              SizedBox(height: 16),
              buildDatePicker(
                  "Start Date", _startDate, () => _pickDate(context, true)),
              SizedBox(height: 16),
              buildDatePicker(
                  "End Date", _endDate, () => _pickDate(context, false)),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _priority,
                dropdownColor: Color(0xFF1E1E2F),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF1E1E2F),
                  labelText: 'Priority',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                items: ['Low', 'Medium', 'High']
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level,
                              style: TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInput(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      maxLines: maxLines,
      validator: (value) => value!.isEmpty ? '$label is required' : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Color(0xFF1E1E2F),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget buildDatePicker(String label, DateTime? date, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Color(0xFF1E1E2F),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date != null ? DateFormat('yyyy-MM-dd').format(date) : label,
              style: TextStyle(color: Colors.white),
            ),
            Icon(Icons.calendar_today, color: Colors.yellow.shade700),
          ],
        ),
      ),
    );
  }
}
