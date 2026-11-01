import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/firestore_paths.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_service.dart';
import '../../transport/data/transport_service.dart';
import '../../transport/domain/line_model.dart';
import '../data/schedule_service.dart';
import '../domain/schedule_model.dart';

class SubmitScheduleScreen extends StatefulWidget {
  const SubmitScheduleScreen({super.key});

  @override
  State<SubmitScheduleScreen> createState() => _SubmitScheduleScreenState();
}

class _SubmitScheduleScreenState extends State<SubmitScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _timeController = TextEditingController();

  final _scheduleService = ScheduleService();
  final _transportService = TransportService();
  final _authService = AuthService();

  String? _selectedLineId;
  final Set<int> _selectedDays = {};
  final _daysFieldKey = GlobalKey<FormFieldState<Set<int>>>();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selected == null || !mounted) return;

    final hour = selected.hour.toString().padLeft(2, '0');
    final minute = selected.minute.toString().padLeft(2, '0');

    setState(() {
      _timeController.text = '$hour:$minute';
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final userId = _authService.currentUser?.uid;

    if (userId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.scheduleSubmitError)));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final now = DateTime.now();
      final scheduleId = FirebaseFirestore.instance
          .collection(FirestorePaths.schedules)
          .doc()
          .id;

      final schedule = ScheduleModel(
        id: scheduleId,
        lineId: _selectedLineId!,
        departureTime: _timeController.text,
        days: _selectedDays.toList()..sort(),
        submittedBy: userId,
        createdAt: now,
        updatedAt: now,
      );

      await _scheduleService.submitSchedule(schedule);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.scheduleSubmitted)));

      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.scheduleSubmitError)));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String _dayName(AppLocalizations l10n, int day) {
    switch (day) {
      case 1:
        return l10n.monday;
      case 2:
        return l10n.tuesday;
      case 3:
        return l10n.wednesday;
      case 4:
        return l10n.thursday;
      case 5:
        return l10n.friday;
      case 6:
        return l10n.saturday;
      case 7:
        return l10n.sunday;
      default:
        return day.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.submitSchedule)),
      body: StreamBuilder<List<LineModel>>(
        stream: _transportService.watchLines(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(l10n.scheduleLoadError));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final activeLines = (snapshot.data ?? [])
              .where((line) => line.isActive)
              .toList();

          if (activeLines.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.noActiveLines, textAlign: TextAlign.center),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _selectedLineId,
                    decoration: InputDecoration(
                      labelText: l10n.selectLine,
                      border: const OutlineInputBorder(),
                    ),
                    items: activeLines.map((line) {
                      return DropdownMenuItem(
                        value: line.id,
                        child: Text('${line.code} - ${line.name}'),
                      );
                    }).toList(),
                    onChanged: _isSubmitting
                        ? null
                        : (value) {
                            setState(() => _selectedLineId = value);
                          },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.selectLine;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _timeController,
                    readOnly: true,
                    onTap: _isSubmitting ? null : _selectTime,
                    decoration: InputDecoration(
                      labelText: l10n.selectDepartureTime,
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.access_time),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.selectDepartureTime;
                      }
                      if (!RegExp(r'^([01][0-9]|2[0-3]):[0-5][0-9]$')
                          .hasMatch(value)) {
                        return l10n.selectDepartureTime;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.operatingDays,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  FormField<Set<int>>(
                    key: _daysFieldKey,
                    initialValue: _selectedDays,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.selectAtLeastOneDay;
                      }
                      return null;
                    },
                    builder: (field) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...List.generate(7, (index) {
                            final day = index + 1;

                            return CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(_dayName(l10n, day)),
                              value: _selectedDays.contains(day),
                              onChanged: _isSubmitting
                                  ? null
                                  : (checked) {
                                      setState(() {
                                        if (checked == true) {
                                          _selectedDays.add(day);
                                        } else {
                                          _selectedDays.remove(day);
                                        }
                                      });

                                      field.didChange(_selectedDays);
                                    },
                            );
                          }),
                          if (field.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                field.errorText!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.submitSchedule),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
