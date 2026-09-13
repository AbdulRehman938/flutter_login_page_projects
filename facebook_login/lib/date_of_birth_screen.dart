import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gender_selection_screen.dart';
import 'find_account_screen.dart';

class DateOfBirthScreen extends StatefulWidget {
  const DateOfBirthScreen({super.key});

  @override
  State<DateOfBirthScreen> createState() => _DateOfBirthScreenState();
}

class _DateOfBirthScreenState extends State<DateOfBirthScreen> {
  late DateTime _selectedDate;
  late TextEditingController _dateController;
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastValidDate;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    DateTime oneWeekAgo = now.subtract(const Duration(days: 7));
    // Initialize with a valid date (one week before today minus one day)
    _selectedDate = oneWeekAgo.subtract(const Duration(days: 1));
    _lastValidDate = oneWeekAgo.subtract(const Duration(days: 1));
    _dateController = TextEditingController(
      text: _formatDate(_selectedDate),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age >= 0 ? age : 0;
  }

  bool _isValidDate(DateTime date) {
    DateTime now = DateTime.now();
    DateTime minDate = DateTime(1950, 1, 1);
    DateTime oneWeekAgo = now.subtract(const Duration(days: 7));

    // Check if date is before 1950
    if (date.isBefore(minDate)) {
      return false;
    }

    // Check if date is after current date
    if (date.isAfter(now)) {
      return false;
    }

    // Check if date is within the last week (inclusive)
    // i.e., dates from one week ago to today are invalid
    // if today is Sept 13, dates from Sept 6 to Sept 13 are invalid
    // so valid dates are before Sept 6
    if (!date.isBefore(oneWeekAgo)) {
      return false;
    }

    return true;
  }

  String? _validateDate(DateTime date) {
    DateTime now = DateTime.now();
    DateTime minDate = DateTime(1950, 1, 1);
    DateTime oneWeekAgo = now.subtract(const Duration(days: 7));

    if (date.year < 1950) {
      return 'Year must be 1950 or later';
    }

    if (date.year > now.year) {
      return 'Year cannot be in the future';
    }

    if (date.isBefore(minDate)) {
      return 'Date must be January 1, 1950 or later';
    }

    if (date.isAfter(now)) {
      return 'Date cannot be in the future';
    }

    if (!date.isBefore(oneWeekAgo)) {
      return 'Date cannot be within the last week';
    }

    return null;
  }

  void _showDatePicker() async {
    DateTime now = DateTime.now();
    DateTime minDate = DateTime(1950, 1, 1);
    DateTime oneWeekAgo = now.subtract(const Duration(days: 7));
    DateTime maxDate = oneWeekAgo.subtract(const Duration(days: 1));

    // Ensure initialDate is within valid range
    DateTime initialDate = _lastValidDate ?? minDate;
    if (initialDate.isAfter(maxDate)) {
      initialDate = maxDate;
    }
    if (initialDate.isBefore(minDate)) {
      initialDate = minDate;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: minDate,
      lastDate: maxDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF005FD5),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && _isValidDate(picked)) {
      setState(() {
        _selectedDate = picked;
        _lastValidDate = picked;
        _dateController.text = _formatDate(picked);
        _errorMessage = null;
      });
    }
  }

  void _validateAndSubmit() {
    setState(() {
      _errorMessage = _validateDate(_selectedDate);
    });

    if (_errorMessage == null) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GenderSelectionScreen(),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'assets/images/leftSideArrow.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
            
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Title
                    const Text(
                      "What's your date of birth?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Subtitle with link
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                        children: [
                          TextSpan(text: 'Choose your date of birth. You can always make this private later. '),
                          TextSpan(
                            text: 'Why do I need to provide my date of birth?',
                            style: TextStyle(
                              color: Color(0xFF005FD5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Date input label
                    Text(
                      'Date of birth (${_calculateAge(_selectedDate)} years old)',
                      style: const TextStyle(
                        color: Color(0xFF65676B),
                        fontSize: 12,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Date input field
                    GestureDetector(
                      onTap: _showDatePicker,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _errorMessage != null
                                ? Colors.red
                                : const Color(0xFFDADDE1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  children: [
                                    _DatePartSelector(
                                      value: _selectedDate.month,
                                      minValue: 1,
                                      maxValue: 12,
                                      format: (value) =>
                                          value.toString().padLeft(2, '0'),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedDate = DateTime(
                                            _selectedDate.year,
                                            value,
                                            _selectedDate.day,
                                          );
                                          if (_isValidDate(_selectedDate)) {
                                            _lastValidDate = _selectedDate;
                                            _dateController.text =
                                                _formatDate(_selectedDate);
                                            _errorMessage = null;
                                          } else {
                                            _errorMessage =
                                                _validateDate(_selectedDate);
                                          }
                                        });
                                      },
                                    ),
                                    const Text(
                                      '/',
                                      style: TextStyle(
                                        color: Color(0xFF65676B),
                                        fontSize: 16,
                                      ),
                                    ),
                                    _DatePartSelector(
                                      value: _selectedDate.day,
                                      minValue: 1,
                                      maxValue: 31,
                                      format: (value) =>
                                          value.toString().padLeft(2, '0'),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedDate = DateTime(
                                            _selectedDate.year,
                                            _selectedDate.month,
                                            value,
                                          );
                                          if (_isValidDate(_selectedDate)) {
                                            _lastValidDate = _selectedDate;
                                            _dateController.text =
                                                _formatDate(_selectedDate);
                                            _errorMessage = null;
                                          } else {
                                            _errorMessage =
                                                _validateDate(_selectedDate);
                                          }
                                        });
                                      },
                                    ),
                                    const Text(
                                      '/',
                                      style: TextStyle(
                                        color: Color(0xFF65676B),
                                        fontSize: 16,
                                      ),
                                    ),
                                    _DatePartSelector(
                                      value: _selectedDate.year,
                                      minValue: 1950,
                                      maxValue: DateTime.now().year,
                                      format: (value) => value.toString(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedDate = DateTime(
                                            value,
                                            _selectedDate.month,
                                            _selectedDate.day,
                                          );
                                          if (_isValidDate(_selectedDate)) {
                                            _lastValidDate = _selectedDate;
                                            _dateController.text =
                                                _formatDate(_selectedDate);
                                            _errorMessage = null;
                                          } else {
                                            _errorMessage =
                                                _validateDate(_selectedDate);
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _showDatePicker,
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: const Icon(
                                  Icons.calendar_today,
                                  color: Color(0xFF65676B),
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Error message
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 32),
                    
                    // Next button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _validateAndSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005FD5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            
            // Bottom link
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FindAccountScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Find my account',
                  style: TextStyle(
                    color: Color(0xFF005FD5),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatePartSelector extends StatefulWidget {
  final int value;
  final int minValue;
  final int maxValue;
  final String Function(int) format;
  final Function(int) onChanged;

  const _DatePartSelector({
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.format,
    required this.onChanged,
  });

  @override
  State<_DatePartSelector> createState() => _DatePartSelectorState();
}

class _DatePartSelectorState extends State<_DatePartSelector> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.format(widget.value));
    _focusNode = FocusNode();
    
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      }
    });
  }

  @override
  void didUpdateWidget(_DatePartSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.format(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleChanged(String text) {
    final intValue = int.tryParse(text);
    if (intValue != null &&
        intValue >= widget.minValue &&
        intValue <= widget.maxValue) {
      widget.onChanged(intValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
        ],
        onTap: () {
          _focusNode.requestFocus();
          _controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controller.text.length,
          );
        },
        onChanged: _handleChanged,
      ),
    );
  }
}
