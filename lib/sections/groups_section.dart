import 'package:flutter/material.dart';
import '../models/group_model.dart';
import '../services/group_storage_service.dart';
import '../screens/create_group_screen.dart';
import 'package:fair_share/l10n/app_localizations.dart';

class GroupsSection extends StatefulWidget {
  const GroupsSection({super.key});

  @override
  State<GroupsSection> createState() => _GroupsSectionState();
}

class _GroupsSectionState extends State<GroupsSection> {
  List<Group> _groups = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadGroups();
  }

  Future<void> loadGroups() async {
    setState(() => _isLoading = true);
    final groups = await GroupStorageService.loadGroups();
    setState(() {
      _groups = groups;
      _isLoading = false;
    });
  }

  void _startGroupCreation(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateGroupScreen(
          onGroupCreated: (newGroup) {
            // Save the group and set as current
            GroupStorageService.saveGroup(newGroup);
            GroupStorageService.saveCurrentGroupId(newGroup.id);
          },
        ),
      ),
    );

    if (result == true) {
      loadGroups();
    }
  }

  void _showGroupDetails(BuildContext context, Group group) {
    showDialog(
      context: context,
      builder: (context) => _GroupDetailsDialog(group: group),
    );
  }

  void _editGroup(BuildContext context, Group group) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateGroupScreen(editingGroup: group),
      ),
    );

    if (result == true) {
      loadGroups();
    }
  }

  Future<void> _deleteGroup(String groupId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.groupsDeleteTitle),
        content: Text(AppLocalizations.of(context)!.groupsDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.groupsCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppLocalizations.of(context)!.groupsDelete,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await GroupStorageService.deleteGroup(groupId);
      loadGroups();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.groupsTitle,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(top: 16, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.orange.withAlpha(51),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange),
            ),
            child: Text(
              AppLocalizations.of(context)!.groupsWarning,
              style: TextStyle(color: Colors.orange),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 20),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_groups.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.groupsEmptyTitle,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.groupsEmptySubtitle,
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _groups.length,
                itemBuilder: (context, index) {
                  final group = _groups[index];
                  return _buildGroupCard(group);
                },
              ),
            ),

          const SizedBox(height: 20),

          Center(
            child: ElevatedButton(
              onPressed: () => _startGroupCreation(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
              child: Text(AppLocalizations.of(context)!.groupsCreateButton),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(Group group) {
    return Card(
      color: const Color(0xFF063a60),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getGroupColor(group),
          child: Text(
            group.name[0],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          group.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.groupsMembers(group.members.length),
            ),
            Text(
              '${AppLocalizations.of(context)!.groupInfoActiveDays} ${_getDaysText(group.activeDays)}',
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.lightBlue),
              onPressed: () => _editGroup(context, group),
              tooltip: AppLocalizations.of(context)!.groupsEditTooltip,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteGroup(group.id),
              tooltip: AppLocalizations.of(context)!.groupsDeleteTooltip,
            ),
          ],
        ),
        onTap: () => _showGroupDetails(context, group),
      ),
    );
  }

  Color _getGroupColor(Group group) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];
    return colors[group.name.length % colors.length];
  }

  String _getDaysText(List<int> days) {
    final dayNames = [
      AppLocalizations.of(context)!.dayMon,
      AppLocalizations.of(context)!.dayTue,
      AppLocalizations.of(context)!.dayWed,
      AppLocalizations.of(context)!.dayThu,
      AppLocalizations.of(context)!.dayFri,
      AppLocalizations.of(context)!.daySat,
      AppLocalizations.of(context)!.daySun,
    ];
    return days.map((day) => dayNames[day - 1]).join(', ');
  }
}

// Group Details Dialog
class _GroupDetailsDialog extends StatelessWidget {
  final Group group;

  const _GroupDetailsDialog({required this.group});

  @override
  Widget build(BuildContext context) {
    // First, calculate the total available time
    final totalAvailableMinutes = 24 * 60; // 1440 minutes
    final timeBlockMinutes = group.timeBlocks.fold(
      0,
      (sum, block) =>
          block.pausesTimer ? sum + block.timeRange.durationMinutes : sum,
    );
    final netAvailableMinutes = totalAvailableMinutes - timeBlockMinutes;
    final totalShares = group.members.fold(
      0.0,
      (sum, member) => sum + member.shares,
    );
    final minutesPerShare = totalShares > 0
        ? netAvailableMinutes / totalShares
        : 0;
    return Dialog(
      backgroundColor: const Color(0xFF063a60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _getGroupColor(group),
                    child: Text(
                      group.name[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      group.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Group Info
              _buildInfoRow(
                AppLocalizations.of(context)!.groupInfoStartDate,
                '${group.startDate.day}/${group.startDate.month}/${group.startDate.year}',
              ),
              _buildInfoRow(
                AppLocalizations.of(context)!.groupInfoActiveDays,
                _getDaysText(context, group.activeDays),
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Members
              Text(
                AppLocalizations.of(context)!.groupMembersTitle,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              if (group.members.isEmpty)
                Text(
                  AppLocalizations.of(context)!.groupMembersEmpty,
                  style: TextStyle(color: Colors.grey),
                )
              else
                Column(
                  children: group.members
                      .map(
                        (member) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person,
                                size: 16,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(member.name)),
                              Text(
                                AppLocalizations.of(context)!.groupShares(
                                  member.shares.toString(),
                                  _formatMinutes(
                                    (minutesPerShare * member.shares).round(),
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Time Blocks
              Text(
                AppLocalizations.of(context)!.groupTimeBlocksTitle,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              if (group.timeBlocks.isEmpty)
                Text(
                  AppLocalizations.of(context)!.groupTimeBlocksEmpty,
                  style: TextStyle(color: Colors.grey),
                )
              else
                Column(
                  children: group.timeBlocks
                      .map(
                        (block) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                block.pausesTimer
                                    ? Icons.pause
                                    : Icons.schedule,
                                size: 16,
                                color: block.pausesTimer
                                    ? Colors.green
                                    : Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(block.name)),
                              Text(
                                '${_formatTimeOfDay(block.timeRange.start)}-${_formatTimeOfDay(block.timeRange.end)}',
                                style: TextStyle(
                                  color: block.pausesTimer
                                      ? Colors.green
                                      : Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),

              const SizedBox(height: 24),

              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.dialogClose),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  String _getDaysText(BuildContext context, List<int> days) {
    final dayNames = [
      AppLocalizations.of(context)!.dayMon,
      AppLocalizations.of(context)!.dayTue,
      AppLocalizations.of(context)!.dayWed,
      AppLocalizations.of(context)!.dayThu,
      AppLocalizations.of(context)!.dayFri,
      AppLocalizations.of(context)!.daySat,
      AppLocalizations.of(context)!.daySun,
    ];
    return days.map((day) => dayNames[day - 1]).join(', ');
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Color _getGroupColor(Group group) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];
    return colors[group.name.length % colors.length];
  }

  String _formatMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (hours > 0) {
      return '${hours}h ${remainingMinutes}m';
    } else {
      return '${remainingMinutes}m';
    }
  }
}
