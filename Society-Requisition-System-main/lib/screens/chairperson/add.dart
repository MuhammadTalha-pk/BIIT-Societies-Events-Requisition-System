import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/custom_text_field4form.dart'; // Keep this import for other text fields

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  // Controllers for the fields
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeFromController = TextEditingController();
  final TextEditingController _timeToController = TextEditingController();
  final TextEditingController _staffExtraRequirementsController =
      TextEditingController();
  final TextEditingController _itExtraRequirementsController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // State variables
  DateTime? _eventDate;
  TimeOfDay? _timeFrom;
  TimeOfDay? _timeTo;
  String? _selectedEventType;

  // Checkbox states for Staff Requirements
  final Map<String, bool> _staffRequirements = {
    'Mic/Speaker': false,
    'Chairs': false,
    'Guest Sofas': false,
    'Stage': false,
    'Backdrop Adjustment': false,
    'AC/Fan': false,
    'Guest Parking': false,
  };

  // Checkbox states for IT Requirements
  final Map<String, bool> _itRequirements = {
    'Internet': false,
    'Projector/Screen': false,
  };

  // Colors
  final Color primaryColor = const Color(0xFF00D09E);
  final Color backgroundColor = const Color(0xFFEFFEF5);
  final Color textFieldBackgroundColor = const Color(0xFFF0FAF6);

  @override
  void dispose() {
    _eventNameController.dispose();
    _venueController.dispose();
    _budgetController.dispose();
    _dateController.dispose();
    _timeFromController.dispose();
    _timeToController.dispose();
    _staffExtraRequirementsController.dispose();
    _itExtraRequirementsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _eventDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: primaryColor),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _eventDate) {
      setState(() {
        _eventDate = picked;
        _dateController.text = DateFormat('MMMM d, yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    TextEditingController controller,
    Function(TimeOfDay?) onTimeSelected,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: primaryColor),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        onTimeSelected(picked);
        controller.text = picked.format(context);
      });
    }
  }

  void _submitForm() {
    // Your submission logic here
    print("Form Submitted!");
    print("Event Name: ${_eventNameController.text}");
    print("Venue: ${_venueController.text}");
    print("Budget: ${_budgetController.text}");
    print("Date: ${_dateController.text}");
    print("Time From: ${_timeFromController.text}");
    print("Time To: ${_timeToController.text}");
    print("Event Type: $_selectedEventType");
    print("Staff Requirements: $_staffRequirements");
    print("Staff Extra: ${_staffExtraRequirementsController.text}");
    print("IT Requirements: $_itRequirements");
    print("IT Extra: ${_itExtraRequirementsController.text}");
    print("Description: ${_descriptionController.text}");

    // Clear all fields after submission
    setState(() {
      _eventNameController.clear();
      _venueController.clear();
      _budgetController.clear();
      _dateController.clear();
      _timeFromController.clear();
      _timeToController.clear();
      _staffExtraRequirementsController.clear();
      _itExtraRequirementsController.clear();
      _descriptionController.clear();
      _eventDate = null;
      _timeFrom = null;
      _timeTo = null;
      _selectedEventType = null;
      _staffRequirements.updateAll((key, value) => false);
      _itRequirements.updateAll((key, value) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Text(
                'Add Requisition',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Form Fields
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField4form(
                      label: 'Event Name',
                      hintText: 'Enter Event Name',
                      controller: _eventNameController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField4form(
                      label: 'Event Venue',
                      hintText: 'Enter Event Venue',
                      controller: _venueController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField4form(
                      label: 'Budget Required',
                      hintText: 'Enter the Budget',
                      controller: _budgetController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField4form(
                      label: 'Event Date',
                      hintText: 'Select Date',
                      controller: _dateController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField4form(
                            label: 'Time From',
                            hintText: 'Select Time',
                            controller: _timeFromController,
                            readOnly: true,
                            onTap: () => _selectTime(
                              context,
                              _timeFromController,
                              (time) => _timeFrom = time,
                            ),
                            suffixIcon: Icon(
                              Icons.access_time,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField4form(
                            label: 'Time To',
                            hintText: 'Select Time',
                            controller: _timeToController,
                            readOnly: true,
                            onTap: () => _selectTime(
                              context,
                              _timeToController,
                              (time) => _timeTo = time,
                            ),
                            suffixIcon: Icon(
                              Icons.access_time,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildEventTypeDropdown(), // This is where the dropdown is built
                    const SizedBox(height: 24),
                    _buildStaffRequirementsSection(),
                    const SizedBox(height: 24),
                    _buildITRequirementsSection(),
                    const SizedBox(height: 24),
                    CustomTextField4form(
                      label: 'Description',
                      hintText: 'Enter detailed notes for the event...',
                      controller: _descriptionController,
                      maxLines: 6,
                    ),
                    const SizedBox(height: 32),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for the event type dropdown
  Widget _buildEventTypeDropdown() {
    final List<String> eventTypes = [
      'Workshop / Training',
      'Seminar / Guest Lecture',
      'Cultural Event / Fest',
      'Sports Event / Tournament',
      'Technical Event / Hackathon',
      'Social Service / Community Outreach',
      'Competition',
      'Exhibition / Expo',
      'Field Trip / Industrial Visit',
      'Recreational / Informal Event',
      'Other',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Type',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedEventType,
          onChanged: (String? newValue) {
            setState(() {
              _selectedEventType = newValue;
            });
          },
          // ✨ Add this line to make the dropdown expand to fill available width
          isExpanded: true,
          items: eventTypes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              // ✨ Keep Expanded here to handle text overflow within each item
              child: Expanded(
                child: Text(value, overflow: TextOverflow.ellipsis),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            hintText: 'Select Event Type',
            filled: true,
            fillColor: textFieldBackgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            // Add a focused border for consistency with other text fields
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
        ),
      ],
    );
  }

  /// Helper for Staff Level Requirements
  Widget _buildStaffRequirementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Staff Level Requirements',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: textFieldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: _staffRequirements.keys.map((String key) {
              return CheckboxListTile(
                title: Text(key),
                value: _staffRequirements[key],
                onChanged: (bool? value) {
                  setState(() {
                    _staffRequirements[key] = value!;
                  });
                },
                dense: true,
                contentPadding: EdgeInsets.zero,
                activeColor: primaryColor,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField4form(
          label: 'Extra Requirements (Staff Head)',
          hintText: 'Add comments for Staff Head...',
          controller: _staffExtraRequirementsController,
          maxLines: 3,
        ),
      ],
    );
  }

  /// Helper for IT Head Requirements
  Widget _buildITRequirementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'IT Head Requirements',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: textFieldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: _itRequirements.keys.map((String key) {
              return CheckboxListTile(
                title: Text(key),
                value: _itRequirements[key],
                onChanged: (bool? value) {
                  setState(() {
                    _itRequirements[key] = value!;
                  });
                },
                dense: true,
                contentPadding: EdgeInsets.zero,
                activeColor: primaryColor,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField4form(
          label: 'Extra Requirements (IT Head)',
          hintText: 'Add comments for IT Head...',
          controller: _itExtraRequirementsController,
          maxLines: 3,
        ),
      ],
    );
  }

  /// Helper for the submit button
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Submit',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
