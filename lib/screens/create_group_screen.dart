import 'package:fair_share/services/prayer_time_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/group_model.dart';
import '../services/group_storage_service.dart';
import '../services/time_scheduler.dart';
import 'package:fair_share/l10n/app_localizations.dart';

class CreateGroupScreen extends StatefulWidget {
  final Function(Group)? onGroupCreated;
  final Group? editingGroup;

  const CreateGroupScreen({super.key, this.onGroupCreated, this.editingGroup});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  int _currentStep = 0;
  final _groupNameController = TextEditingController();
  final List<Member> _members = [];
  final List<TimeBlock> _timeBlocks = [];
  final List<int> _selectedDays = [1, 2, 3, 4, 5, 6, 7];
  DateTime _startDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0); // default 8:00 AM
  Map<String, String> _prayerTimes = {};
  bool _isLoadingPrayerTimes = false;

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();

    if (widget.editingGroup != null) {
      _groupNameController.text = widget.editingGroup!.name;

      _members
        ..clear()
        ..addAll(widget.editingGroup!.members);

      _timeBlocks
        ..clear()
        ..addAll(widget.editingGroup!.timeBlocks);

      _selectedDays
        ..clear()
        ..addAll(widget.editingGroup!.activeDays);

      _startDate = widget.editingGroup!.startDate;
    }
  }

  Future<void> _loadPrayerTimes() async {
    setState(() => _isLoadingPrayerTimes = true);
    try {
      _prayerTimes = await PrayerTimesService.getPrayerTimes(context);
      _createPrayerTimeBlocks();
    } catch (e) {
      // If API fails, we'll still allow manual time blocks
    }
    setState(() => _isLoadingPrayerTimes = false);
  }

  void _createPrayerTimeBlocks() {
    // Clear existing prayer time blocks

    _timeBlocks.removeWhere((block) => block.id.contains('prayer_'));

    // Create time blocks from API prayer times
    for (final entry in _prayerTimes.entries) {
      final prayerTime = entry.value;
      final timeParts = prayerTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      // Calculate end time properly (handle minute overflow)
      int endHour = hour;
      int endMinute = minute + 30;

      if (endMinute >= 60) {
        endHour += endMinute ~/ 60;
        endMinute = endMinute % 60;
      }

      // Handle hour overflow (overnight)
      if (endHour >= 24) {
        endHour = endHour % 24;
      }

      _timeBlocks.add(
        TimeBlock(
          id: 'prayer_${entry.key}',
          name: '${entry.key} ${AppLocalizations.of(context)!.prayerLabel}',
          timeRange: TimeRange(
            start: TimeOfDay(hour: hour, minute: minute),
            end: TimeOfDay(hour: endHour, minute: endMinute),
          ),
          pausesTimer: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.editingGroup != null
              ? AppLocalizations.of(context)!.editGroupTitle
              : AppLocalizations.of(context)!.createGroupTitle,
        ),
        backgroundColor: const Color(0xFF021a30),
      ),
      body: Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: Colors.lightBlue),
        ),
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: _continue,
          onStepCancel: _cancel,
          onStepTapped: (step) => setState(() => _currentStep = step),
          steps: _buildSteps(),
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Row(
              children: <Widget>[
                TextButton(
                  onPressed: details.onStepContinue,
                  child: Text(AppLocalizations.of(context)!.continueButton),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: details.onStepCancel,
                  child: Text(
                    AppLocalizations.of(context)!.backButton,
                  ), // ✅ changed from Cancel to Back
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: Text(AppLocalizations.of(context)!.groupInfoStep),
        content: Column(
          children: [
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.groupNameLabel,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(AppLocalizations.of(context)!.startDateLabel),
              subtitle: Text(
                '${_startDate.day}/${_startDate.month}/${_startDate.year}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _pickStartDate,
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.startTimeLabel),
              subtitle: Text(_startTime.format(context)),
              trailing: IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: _pickStartTime,
              ),
            ),
          ],
        ),
      ),

      Step(
        title: Text(AppLocalizations.of(context)!.addMembersStep),
        content: _buildMembersStep(),
      ),

      Step(
        title: Text(AppLocalizations.of(context)!.timeBlocksStep),
        content: _buildTimeBlocksStep(),
      ),

      Step(
        title: Text(AppLocalizations.of(context)!.activeDaysStep),
        content: _buildActiveDaysStep(),
      ),

      Step(
        title: Text(AppLocalizations.of(context)!.reviewStep),
        content: _buildReviewStep(),
      ),
    ];
  }

  Widget _buildMembersStep() {
    return Column(
      children: [
        _MemberForm(onMemberAdded: _addMember),
        const SizedBox(height: 20),
        Text(
          AppLocalizations.of(context)!.membersTitle,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ..._members.map((member) => _buildMemberCard(member)).toList(),
      ],
    );
  }

  Widget _buildMemberCard(Member member) {
    return Card(
      color: const Color(0xFF063a60),
      child: ListTile(
        title: Text(member.name),
        subtitle: Text(
          AppLocalizations.of(context)!.sharesCountLabel(member.shares),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _removeMember(member.id),
        ),
      ),
    );
  }

  Widget _buildTimeBlocksStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isLoadingPrayerTimes)
          const CircularProgressIndicator()
        else if (_prayerTimes.isNotEmpty)
          Text(
            AppLocalizations.of(context)!.prayerTimesLoaded,
            style: TextStyle(color: Colors.green),
          )
        else
          Text(
            AppLocalizations.of(context)!.usingCachedPrayerTimes,
            style: TextStyle(color: Colors.orange),
          ),

        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context)!.timeBlocksSectionTitle,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        ..._timeBlocks.map((block) => _buildTimeBlockCard(block)).toList(),

        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _addCustomTimeBlock,
          child: Text(AppLocalizations.of(context)!.addCustomTimeBlock),
        ),
      ],
    );
  }

  Widget _buildTimeBlockCard(TimeBlock block) {
    return Card(
      color: const Color(0xFF063a60),
      child: ListTile(
        title: Text(block.name),
        subtitle: Text(
          '${_formatTimeOfDay(block.timeRange.start)} - ${_formatTimeOfDay(block.timeRange.end)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: block.pausesTimer,
              onChanged: (value) => _updateTimeBlockPause(block.id, value),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeTimeBlock(block.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveDaysStep() {
    Step(
      title: Text(AppLocalizations.of(context)!.activeDaysStep),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.selectActiveDays,
            style: TextStyle(fontSize: 16),
          ),

          // Add warning message
          FutureBuilder<List<int>>(
            future: GroupStorageService.getAvailableDays(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final availableDays = snapshot.data!;
                final conflictingDays = _selectedDays
                    .where((day) => !availableDays.contains(day))
                    .toList();

                if (conflictingDays.isNotEmpty) {
                  final dayNames = [
                    AppLocalizations.of(context)!.dayMon,
                    AppLocalizations.of(context)!.dayTue,
                    AppLocalizations.of(context)!.dayWed,
                    AppLocalizations.of(context)!.dayThu,
                    AppLocalizations.of(context)!.dayFri,
                    AppLocalizations.of(context)!.daySat,
                    AppLocalizations.of(context)!.daySun,
                  ];
                  final conflictNames = conflictingDays
                      .map((day) => dayNames[day - 1])
                      .join(', ');

                  return Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withAlpha(51),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Text(
                      AppLocalizations.of(
                        context,
                      )!.daysConflictWarning(conflictNames),
                      style: const TextStyle(color: Colors.orange),
                    ),
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),

          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: List.generate(7, (index) {
              final dayNumber = index + 1;
              final isSelected = _selectedDays.contains(dayNumber);

              return FutureBuilder<List<int>>(
                future: GroupStorageService.getAvailableDays(),
                builder: (context, snapshot) {
                  final isAvailable = snapshot.hasData
                      ? snapshot.data!.contains(dayNumber)
                      : true;

                  return FilterChip(
                    label: Text(_getDayName(dayNumber)),
                    selected: isSelected,
                    selectedColor: isAvailable
                        ? Colors.lightBlue
                        : Colors.orange,
                    checkmarkColor: Colors.white,
                    onSelected: isAvailable
                        ? (selected) {
                            _toggleDaySelection(dayNumber, selected);
                          }
                        : null,
                    tooltip: isAvailable
                        ? null
                        : AppLocalizations.of(context)!.dayUnavailableTooltip,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.selectActiveDays,
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: List.generate(7, (index) {
            final dayNumber = index + 1;
            final isSelected = _selectedDays.contains(dayNumber);
            return FilterChip(
              label: Text(_getDayName(dayNumber)),
              selected: isSelected,
              onSelected: (selected) =>
                  _toggleDaySelection(dayNumber, selected),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildReviewStep() {
    final scheduledMembers = TimeScheduler.calculateTimeSlots(
      Group(
        id: 'temp',
        name: _groupNameController.text,
        members: _members,
        timeBlocks: _timeBlocks,
        activeDays: _selectedDays,
        startDate: _startDate,
        startTime: _startTime,
      ),
    );

    // Calculate total shares and time allocation - WHOLE DAY
    final totalShares = _members.fold(
      0.0,
      (sum, member) => sum + member.shares,
    );
    final totalAvailableMinutes = 24 * 60; // 24 hours = 1440 minutes
    final timeBlockMinutes = _timeBlocks.fold(
      0,
      (sum, block) =>
          block.pausesTimer ? sum + block.timeRange.durationMinutes : sum,
    );
    final netAvailableMinutes = totalAvailableMinutes - timeBlockMinutes;
    final minutesPerShare = totalShares > 0
        ? netAvailableMinutes / totalShares
        : 0;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(
              context,
            )!.reviewGroup(_groupNameController.text),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            AppLocalizations.of(context)!.reviewStartDate(
              '${_startDate.day}/${_startDate.month}/${_startDate.year}',
            ),
          ),
          Text(
            AppLocalizations.of(
              context,
            )!.reviewActiveDays(_selectedDays.map(_getDayName).join(', ')),
          ),

          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.timeAllocationSummary,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(AppLocalizations.of(context)!.totalShares(totalShares)),
          Text(
            AppLocalizations.of(
              context,
            )!.totalDayTime(_formatMinutes(totalAvailableMinutes)),
          ),
          Text(
            AppLocalizations.of(
              context,
            )!.timeBlocksLabel(_formatMinutes(timeBlockMinutes)),
          ),
          Text(
            AppLocalizations.of(
              context,
            )!.netAvailable(_formatMinutes(netAvailableMinutes)),
          ),
          Text(
            AppLocalizations.of(
              context,
            )!.minutesPerShare(minutesPerShare.toStringAsFixed(1)),
          ),

          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.timeBlocksStep,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ..._timeBlocks.map<Widget>(
            (block) => block.pausesTimer
                ? Text(
                    '${AppLocalizations.of(context)!.pausesLabel} '
                    '${block.name}  '
                    '${_formatTimeOfDay(block.timeRange.start)} '
                    '${AppLocalizations.of(context)!.toLabel} '
                    '${_formatTimeOfDay(block.timeRange.end)}',
                  )
                : const SizedBox.shrink(),
          ),

          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.memberScheduleTitle,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ...scheduledMembers.map(
            (member) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.memberScheduleLine(
                    member.name,
                    member.shares,
                    member.scheduledSlots.length,
                  ),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (member.scheduledSlots.isEmpty)
                  Text(
                    AppLocalizations.of(context)!.noTimeAllocated,
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  ...member.scheduledSlots.map(
                    (slot) => Text(
                      '  - ${_formatTimeOfDay(slot.start)} ${AppLocalizations.of(context)!.toLabel} ${_formatTimeOfDay(slot.end)}',
                    ),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours}${AppLocalizations.of(context)!.hoursSuffix} ${remainingMinutes}${AppLocalizations.of(context)!.minutesSuffix}';
  }

  String _getDayName(int dayNumber) {
    final dayNames = [
      AppLocalizations.of(context)!.dayMon,
      AppLocalizations.of(context)!.dayTue,
      AppLocalizations.of(context)!.dayWed,
      AppLocalizations.of(context)!.dayThu,
      AppLocalizations.of(context)!.dayFri,
      AppLocalizations.of(context)!.daySat,
      AppLocalizations.of(context)!.daySun,
    ];
    return dayNames[dayNumber - 1];
  }

  void _toggleDaySelection(int dayNumber, bool selected) {
    setState(() {
      if (selected) {
        _selectedDays.add(dayNumber);
      } else {
        _selectedDays.remove(dayNumber);
      }
    });
  }

  void _addMember(String name, double shares) {
    setState(() {
      _members.add(
        Member(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          shares: shares,
          scheduledSlots: [],
        ),
      );
    });
  }

  void _removeMember(String memberId) {
    setState(() {
      _members.removeWhere((member) => member.id == memberId);
    });
  }

  void _addCustomTimeBlock() {
    showDialog(
      context: context,
      builder: (context) => _CustomTimeBlockDialog(
        onTimeBlockAdded: (name, timeRange, pausesTimer) {
          setState(() {
            _timeBlocks.add(
              TimeBlock(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                timeRange: timeRange,
                pausesTimer: pausesTimer,
              ),
            );
          });
        },
      ),
    );
  }

  void _updateTimeBlockPause(String blockId, bool pausesTimer) {
    setState(() {
      final index = _timeBlocks.indexWhere((block) => block.id == blockId);
      if (index >= 0) {
        _timeBlocks[index] = TimeBlock(
          id: blockId,
          name: _timeBlocks[index].name,
          timeRange: _timeBlocks[index].timeRange,
          pausesTimer: pausesTimer,
        );
      }
    });
  }

  void _removeTimeBlock(String blockId) {
    setState(() {
      _timeBlocks.removeWhere((block) => block.id == blockId);
    });
  }

  Future<void> _pickStartDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() => _startDate = pickedDate);
    }
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  void _continue() async {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    } else {
      // Validate before creating group
      final isValid = await _validateGroup();
      if (isValid) {
        _createGroup();
      }
    }
  }

  void _cancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  void _createGroup() {
    final group = Group(
      id:
          widget.editingGroup?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _groupNameController.text,
      members: _members,
      timeBlocks: _timeBlocks,
      activeDays: _selectedDays,
      startDate: _startDate,
      startTime: _startTime,
    );

    if (widget.onGroupCreated != null) {
      widget.onGroupCreated!(group);
    }

    // Save the group to storage
    GroupStorageService.saveGroup(group);

    // Return true to indicate success
    Navigator.pop(context, true);
  }

  Future<bool> _validateGroup() async {
    // Check for day conflicts
    final hasConflict = await GroupStorageService.hasDayConflict(
      _selectedDays,
      excludeGroupId: widget.editingGroup?.id, // pass current ID if editing
    );

    if (hasConflict) {
      final availableDays = await GroupStorageService.getAvailableDays();
      final dayNames = [
        AppLocalizations.of(context)!.dayMon,
        AppLocalizations.of(context)!.dayTue,
        AppLocalizations.of(context)!.dayWed,
        AppLocalizations.of(context)!.dayThu,
        AppLocalizations.of(context)!.dayFri,
        AppLocalizations.of(context)!.daySat,
        AppLocalizations.of(context)!.daySun,
      ];
      final availableDayNames = availableDays
          .map((day) => dayNames[day - 1])
          .join(', ');

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.dayConflictTitle),
          content: Text(
            AppLocalizations.of(context)!.dayConflictContent(availableDayNames),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.okButton),
            ),
          ],
        ),
      );
      return false;
    }

    // Check if group name is empty
    if (_groupNameController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.missingInfoTitle),
          content: Text(AppLocalizations.of(context)!.missingInfoContent),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.okButton),
            ),
          ],
        ),
      );
      return false;
    }

    // Check if at least one member exists
    if (_members.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.noMembersTitle),
          content: Text(AppLocalizations.of(context)!.noMembersContent),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.okButton),
            ),
          ],
        ),
      );
      return false;
    }

    return true;
  }
}

// Member Form Dialog (Updated for shares)
class _MemberForm extends StatefulWidget {
  final Function(String, double) onMemberAdded;

  const _MemberForm({required this.onMemberAdded});

  @override
  State<_MemberForm> createState() => _MemberFormState();
}

class _MemberFormState extends State<_MemberForm> {
  final _nameController = TextEditingController();
  final _sharesController = TextEditingController(text: '1.0');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.memberNameLabel,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _sharesController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.sharesInputLabel,
            border: OutlineInputBorder(),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _addMember,
          child: Text(AppLocalizations.of(context)!.addMemberButton),
        ),
      ],
    );
  }

  void _addMember() {
    if (_nameController.text.isNotEmpty && _sharesController.text.isNotEmpty) {
      final shares = double.tryParse(_sharesController.text) ?? 1.0;
      widget.onMemberAdded(_nameController.text, shares);
      _nameController.clear();
      _sharesController.text = '1.0';
    }
  }
}

// Custom Time Block Dialog
class _CustomTimeBlockDialog extends StatefulWidget {
  final Function(String, TimeRange, bool) onTimeBlockAdded;

  const _CustomTimeBlockDialog({required this.onTimeBlockAdded});

  @override
  State<_CustomTimeBlockDialog> createState() => _CustomTimeBlockDialogState();
}

class _CustomTimeBlockDialogState extends State<_CustomTimeBlockDialog> {
  final _nameController = TextEditingController();
  TimeOfDay _startTime = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 13, minute: 0);
  bool _pausesTimer = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.addCustomTimeBlockTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.blockNameLabel,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(AppLocalizations.of(context)!.fromLabel),
                  subtitle: Text(_startTime.format(context)),
                  trailing: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _startTime,
                      );
                      if (time != null) setState(() => _startTime = time);
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text(AppLocalizations.of(context)!.toLabel),
                  subtitle: Text(_endTime.format(context)),
                  trailing: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _endTime,
                      );
                      if (time != null) setState(() => _endTime = time);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(AppLocalizations.of(context)!.pauseUserTimersLabel),
              Switch(
                value: _pausesTimer,
                onChanged: (value) => setState(() => _pausesTimer = value),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancelButton),
        ),
        ElevatedButton(
          onPressed: _addTimeBlock,
          child: Text(AppLocalizations.of(context)!.addButton),
        ),
      ],
    );
  }

  void _addTimeBlock() {
    if (_nameController.text.isNotEmpty) {
      widget.onTimeBlockAdded(
        _nameController.text,
        TimeRange(start: _startTime, end: _endTime),
        _pausesTimer,
      );
      Navigator.pop(context);
    }
  }
}
