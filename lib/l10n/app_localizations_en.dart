// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Fair Share';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get changePassword => 'Change Password';

  @override
  String get navGroups => 'Groups';

  @override
  String get navUser => 'User';

  @override
  String get navSchedule => 'Schedule';

  @override
  String get groupsTitle => 'Groups Management';

  @override
  String get groupsWarning => '⚠️ Each group should have unique days to avoid scheduling conflicts';

  @override
  String get groupsEmptyTitle => 'No groups yet';

  @override
  String get groupsEmptySubtitle => 'Create your first group to get started';

  @override
  String get groupsCreateButton => 'Create New Group';

  @override
  String get groupsDeleteTitle => 'Delete Group';

  @override
  String get groupsDeleteConfirm => 'Are you sure you want to delete this group?';

  @override
  String get groupsCancel => 'Cancel';

  @override
  String get groupsDelete => 'Delete';

  @override
  String get groupsEditTooltip => 'Edit Group';

  @override
  String get groupsDeleteTooltip => 'Delete Group';

  @override
  String get groupInfoStartDate => 'Start Date';

  @override
  String get groupInfoActiveDays => 'Active Days';

  @override
  String get groupMembersTitle => 'Members:';

  @override
  String get groupMembersEmpty => 'No members yet';

  @override
  String groupShares(Object shares, Object duration) {
    return '$shares shares ($duration)';
  }

  @override
  String get groupTimeBlocksTitle => 'Time Blocks:';

  @override
  String get groupTimeBlocksEmpty => 'No time blocks';

  @override
  String groupsMembers(Object count) {
    return '$count members';
  }

  @override
  String get dialogClose => 'Close';

  @override
  String get dayMon => 'Mon';

  @override
  String get dayTue => 'Tue';

  @override
  String get dayWed => 'Wed';

  @override
  String get dayThu => 'Thu';

  @override
  String get dayFri => 'Fri';

  @override
  String get daySat => 'Sat';

  @override
  String get daySun => 'Sun';

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerDhuhr => 'Dhuhr';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isha';

  @override
  String lastUpdated(Object time) {
    return 'Last updated: $time';
  }

  @override
  String get lastUpdatedNever => 'Last updated: Never';

  @override
  String get fajrTomorrow => 'Fajr (Tomorrow)';

  @override
  String durationHours(Object hours) {
    return '${hours}h';
  }

  @override
  String durationMinutes(Object minutes) {
    return '${minutes}m';
  }

  @override
  String durationSeconds(Object seconds) {
    return '${seconds}s';
  }

  @override
  String get loading => 'Loading...';

  @override
  String get noData => 'No data';

  @override
  String get pausedSuffix => '(Paused)';

  @override
  String get noUserSelected => 'No user selected';

  @override
  String sharesCountLabel(Object shares) {
    return '$shares shares';
  }

  @override
  String get sharesInputLabel => 'Shares (e.g., 1.0, 1.5, 2.0)';

  @override
  String get notActiveToday => 'Not active today';

  @override
  String get activeSessionTitle => '⏰ Active Session';

  @override
  String pausedWithBlock(Object blockName) {
    return '⏸️ Paused: $blockName';
  }

  @override
  String get sessionWillStart => 'Session will start automatically';

  @override
  String get sessionPaused => 'Session paused';

  @override
  String get noActiveUserToday => 'No active user scheduled for today';

  @override
  String get prayerTimesTitle => '🕌 Prayer Times';

  @override
  String get refreshTimesTooltip => 'Refresh Times';

  @override
  String get usingCachedData => '📦 Using cached data';

  @override
  String get timerPausedForPrayer => '⏸️ Timer Paused for Prayer';

  @override
  String get noPrayerTimes => 'No prayer times available';

  @override
  String nextPrayer(Object prayerName, Object time) {
    return 'Next: $prayerName at $time';
  }

  @override
  String timerPausedWithBlock(Object blockName) {
    return 'Timer paused: $blockName';
  }

  @override
  String get timeBlockFallback => 'Time Block';

  @override
  String get noGroupSelected => 'No group selected';

  @override
  String pausedBlockLabel(Object blockName) {
    return '⏸ $blockName';
  }

  @override
  String get timeAM => 'AM';

  @override
  String get timePM => 'PM';

  @override
  String get editGroupTitle => 'Edit Group';

  @override
  String get createGroupTitle => 'Create New Group';

  @override
  String get continueButton => 'Continue';

  @override
  String get backButton => 'Back';

  @override
  String get groupInfoStep => 'Group Info';

  @override
  String get groupNameLabel => 'Group Name';

  @override
  String get startDateLabel => 'Start Date';

  @override
  String get startTimeLabel => 'Start Time';

  @override
  String get addMembersStep => 'Add Members';

  @override
  String get membersTitle => 'Members:';

  @override
  String get timeBlocksStep => 'Time Blocks';

  @override
  String get prayerTimesLoaded => '✅ Prayer times loaded automatically';

  @override
  String get usingCachedPrayerTimes => '⚠️ Using cached prayer times';

  @override
  String get timeBlocksSectionTitle => 'Time Blocks (Prayer times auto-added):';

  @override
  String get addCustomTimeBlock => 'Add Custom Time Block';

  @override
  String get activeDaysStep => 'Active Days';

  @override
  String get selectActiveDays => 'Select active days for this group:';

  @override
  String get reviewStep => 'Review';

  @override
  String daysConflictWarning(Object days) {
    return '⚠️ Days $days are already assigned to other groups';
  }

  @override
  String get dayUnavailableTooltip => 'This day is already assigned to another group';

  @override
  String reviewGroup(Object groupName) {
    return 'Group: $groupName';
  }

  @override
  String reviewStartDate(Object date) {
    return 'Start Date: $date';
  }

  @override
  String reviewActiveDays(Object days) {
    return 'Active Days: $days';
  }

  @override
  String get timeAllocationSummary => 'Time Allocation Summary:';

  @override
  String totalShares(Object count) {
    return '• Total shares: $count';
  }

  @override
  String totalDayTime(Object duration) {
    return '• Total day time: $duration (24 hours)';
  }

  @override
  String timeBlocksLabel(Object duration) {
    return '• Time blocks: $duration';
  }

  @override
  String netAvailable(Object duration) {
    return '• Net available: $duration';
  }

  @override
  String minutesPerShare(Object minutes) {
    return '• Minutes per share: $minutes minutes';
  }

  @override
  String get timeBlocksTitle => 'Time Blocks:';

  @override
  String get pausesLabel => '(Pauses)';

  @override
  String get memberScheduleTitle => 'Member Schedule:';

  @override
  String get noTimeAllocated => '- No time allocated';

  @override
  String memberScheduleLine(Object name, Object shares, Object duration) {
    return '$name ($shares shares - $duration):';
  }

  @override
  String get dayConflictTitle => 'Day Conflict';

  @override
  String dayConflictContent(Object days) {
    return 'Some days are already assigned to other groups.\n\nAvailable days: $days\n\nPlease select different days or edit existing groups.';
  }

  @override
  String get okButton => 'OK';

  @override
  String get missingInfoTitle => 'Missing Information';

  @override
  String get missingInfoContent => 'Please enter a group name.';

  @override
  String get noMembersTitle => 'No Members';

  @override
  String get noMembersContent => 'Please add at least one member to the group.';

  @override
  String get memberNameLabel => 'Member Name';

  @override
  String get addMemberButton => 'Add Member';

  @override
  String get addCustomTimeBlockTitle => 'Add Custom Time Block';

  @override
  String get blockNameLabel => 'Block Name (e.g., Sleep, Study)';

  @override
  String get fromLabel => 'From';

  @override
  String get toLabel => 'To';

  @override
  String get pauseUserTimersLabel => 'Pause User Timers';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get addButton => 'Add';

  @override
  String get prayerLabel => 'Prayer';

  @override
  String get hoursSuffix => 'h';

  @override
  String get minutesSuffix => 'm';

  @override
  String get starterTitle => 'Welcome to Fair Share';

  @override
  String get starterInstructions => 'Fair Share helps you divide time and responsibilities fairly among group members. Follow the schedule, track prayer times, and manage your group with ease.';

  @override
  String get continueLabel => 'Continue';

  @override
  String get setPasswordTitle => 'Set a Password';

  @override
  String get passwordHint => 'Password';

  @override
  String get confirmPasswordHint => 'Confirm Password';

  @override
  String get passwordEmptyError => 'Password cannot be empty';

  @override
  String get passwordMismatchError => 'Passwords do not match';

  @override
  String get saveLabel => 'Save';

  @override
  String get enterPasswordTitle => 'Enter Password';

  @override
  String get incorrectPassword => 'Incorrect password';

  @override
  String get unlockLabel => 'Unlock';

  @override
  String get passwordUpdated => 'Password updated successfully';

  @override
  String get notificationTimerTitle => 'Timer Running';

  @override
  String notificationTimerRemaining(String time) {
    return '$time remaining';
  }

  @override
  String get notificationOneMinute => '1 minute remaining';

  @override
  String get notificationTimeUp => 'Time is up!';

  @override
  String get notificationPaused => 'Time is paused';
}
