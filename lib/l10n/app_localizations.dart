import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Fair Share'**
  String get appTitle;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @navGroups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get navGroups;

  /// No description provided for @navUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get navUser;

  /// No description provided for @navSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get navSchedule;

  /// No description provided for @groupsTitle.
  ///
  /// In en, this message translates to:
  /// **'Groups Management'**
  String get groupsTitle;

  /// No description provided for @groupsWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Each group should have unique days to avoid scheduling conflicts'**
  String get groupsWarning;

  /// No description provided for @groupsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No groups yet'**
  String get groupsEmptyTitle;

  /// No description provided for @groupsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first group to get started'**
  String get groupsEmptySubtitle;

  /// No description provided for @groupsCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create New Group'**
  String get groupsCreateButton;

  /// No description provided for @groupsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Group'**
  String get groupsDeleteTitle;

  /// No description provided for @groupsDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this group?'**
  String get groupsDeleteConfirm;

  /// No description provided for @groupsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get groupsCancel;

  /// No description provided for @groupsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get groupsDelete;

  /// No description provided for @groupsEditTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit Group'**
  String get groupsEditTooltip;

  /// No description provided for @groupsDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete Group'**
  String get groupsDeleteTooltip;

  /// No description provided for @groupInfoStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get groupInfoStartDate;

  /// No description provided for @groupInfoActiveDays.
  ///
  /// In en, this message translates to:
  /// **'Active Days'**
  String get groupInfoActiveDays;

  /// No description provided for @groupMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'Members:'**
  String get groupMembersTitle;

  /// No description provided for @groupMembersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No members yet'**
  String get groupMembersEmpty;

  /// No description provided for @groupShares.
  ///
  /// In en, this message translates to:
  /// **'{shares} shares ({duration})'**
  String groupShares(Object shares, Object duration);

  /// No description provided for @groupTimeBlocksTitle.
  ///
  /// In en, this message translates to:
  /// **'Time Blocks:'**
  String get groupTimeBlocksTitle;

  /// No description provided for @groupTimeBlocksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No time blocks'**
  String get groupTimeBlocksEmpty;

  /// No description provided for @groupsMembers.
  ///
  /// In en, this message translates to:
  /// **'{count} members'**
  String groupsMembers(Object count);

  /// No description provided for @dialogClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get dialogClose;

  /// No description provided for @dayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get daySun;

  /// No description provided for @prayerFajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get prayerFajr;

  /// No description provided for @prayerDhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get prayerDhuhr;

  /// No description provided for @prayerAsr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get prayerAsr;

  /// No description provided for @prayerMaghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get prayerMaghrib;

  /// No description provided for @prayerIsha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get prayerIsha;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {time}'**
  String lastUpdated(Object time);

  /// No description provided for @lastUpdatedNever.
  ///
  /// In en, this message translates to:
  /// **'Last updated: Never'**
  String get lastUpdatedNever;

  /// No description provided for @fajrTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Fajr (Tomorrow)'**
  String get fajrTomorrow;

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'{hours}h'**
  String durationHours(Object hours);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m'**
  String durationMinutes(Object minutes);

  /// No description provided for @durationSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String durationSeconds(Object seconds);

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @pausedSuffix.
  ///
  /// In en, this message translates to:
  /// **'(Paused)'**
  String get pausedSuffix;

  /// No description provided for @noUserSelected.
  ///
  /// In en, this message translates to:
  /// **'No user selected'**
  String get noUserSelected;

  /// No description provided for @sharesCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{shares} shares'**
  String sharesCountLabel(Object shares);

  /// No description provided for @sharesInputLabel.
  ///
  /// In en, this message translates to:
  /// **'Shares (e.g., 1.0, 1.5, 2.0)'**
  String get sharesInputLabel;

  /// No description provided for @notActiveToday.
  ///
  /// In en, this message translates to:
  /// **'Not active today'**
  String get notActiveToday;

  /// No description provided for @activeSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'⏰ Active Session'**
  String get activeSessionTitle;

  /// No description provided for @pausedWithBlock.
  ///
  /// In en, this message translates to:
  /// **'⏸️ Paused: {blockName}'**
  String pausedWithBlock(Object blockName);

  /// No description provided for @sessionWillStart.
  ///
  /// In en, this message translates to:
  /// **'Session will start automatically'**
  String get sessionWillStart;

  /// No description provided for @sessionPaused.
  ///
  /// In en, this message translates to:
  /// **'Session paused'**
  String get sessionPaused;

  /// No description provided for @noActiveUserToday.
  ///
  /// In en, this message translates to:
  /// **'No active user scheduled for today'**
  String get noActiveUserToday;

  /// No description provided for @prayerTimesTitle.
  ///
  /// In en, this message translates to:
  /// **'🕌 Prayer Times'**
  String get prayerTimesTitle;

  /// No description provided for @refreshTimesTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh Times'**
  String get refreshTimesTooltip;

  /// No description provided for @usingCachedData.
  ///
  /// In en, this message translates to:
  /// **'📦 Using cached data'**
  String get usingCachedData;

  /// No description provided for @timerPausedForPrayer.
  ///
  /// In en, this message translates to:
  /// **'⏸️ Timer Paused for Prayer'**
  String get timerPausedForPrayer;

  /// No description provided for @noPrayerTimes.
  ///
  /// In en, this message translates to:
  /// **'No prayer times available'**
  String get noPrayerTimes;

  /// No description provided for @nextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Next: {prayerName} at {time}'**
  String nextPrayer(Object prayerName, Object time);

  /// No description provided for @timerPausedWithBlock.
  ///
  /// In en, this message translates to:
  /// **'Timer paused: {blockName}'**
  String timerPausedWithBlock(Object blockName);

  /// No description provided for @timeBlockFallback.
  ///
  /// In en, this message translates to:
  /// **'Time Block'**
  String get timeBlockFallback;

  /// No description provided for @noGroupSelected.
  ///
  /// In en, this message translates to:
  /// **'No group selected'**
  String get noGroupSelected;

  /// No description provided for @pausedBlockLabel.
  ///
  /// In en, this message translates to:
  /// **'⏸ {blockName}'**
  String pausedBlockLabel(Object blockName);

  /// No description provided for @timeAM.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get timeAM;

  /// No description provided for @timePM.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get timePM;

  /// No description provided for @editGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Group'**
  String get editGroupTitle;

  /// No description provided for @createGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Group'**
  String get createGroupTitle;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// No description provided for @groupInfoStep.
  ///
  /// In en, this message translates to:
  /// **'Group Info'**
  String get groupInfoStep;

  /// No description provided for @groupNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get groupNameLabel;

  /// No description provided for @startDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDateLabel;

  /// No description provided for @startTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTimeLabel;

  /// No description provided for @addMembersStep.
  ///
  /// In en, this message translates to:
  /// **'Add Members'**
  String get addMembersStep;

  /// No description provided for @membersTitle.
  ///
  /// In en, this message translates to:
  /// **'Members:'**
  String get membersTitle;

  /// No description provided for @timeBlocksStep.
  ///
  /// In en, this message translates to:
  /// **'Time Blocks'**
  String get timeBlocksStep;

  /// No description provided for @prayerTimesLoaded.
  ///
  /// In en, this message translates to:
  /// **'✅ Prayer times loaded automatically'**
  String get prayerTimesLoaded;

  /// No description provided for @usingCachedPrayerTimes.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Using cached prayer times'**
  String get usingCachedPrayerTimes;

  /// No description provided for @timeBlocksSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Time Blocks (Prayer times auto-added):'**
  String get timeBlocksSectionTitle;

  /// No description provided for @addCustomTimeBlock.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Time Block'**
  String get addCustomTimeBlock;

  /// No description provided for @activeDaysStep.
  ///
  /// In en, this message translates to:
  /// **'Active Days'**
  String get activeDaysStep;

  /// No description provided for @selectActiveDays.
  ///
  /// In en, this message translates to:
  /// **'Select active days for this group:'**
  String get selectActiveDays;

  /// No description provided for @reviewStep.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewStep;

  /// No description provided for @daysConflictWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Days {days} are already assigned to other groups'**
  String daysConflictWarning(Object days);

  /// No description provided for @dayUnavailableTooltip.
  ///
  /// In en, this message translates to:
  /// **'This day is already assigned to another group'**
  String get dayUnavailableTooltip;

  /// No description provided for @reviewGroup.
  ///
  /// In en, this message translates to:
  /// **'Group: {groupName}'**
  String reviewGroup(Object groupName);

  /// No description provided for @reviewStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date: {date}'**
  String reviewStartDate(Object date);

  /// No description provided for @reviewActiveDays.
  ///
  /// In en, this message translates to:
  /// **'Active Days: {days}'**
  String reviewActiveDays(Object days);

  /// No description provided for @timeAllocationSummary.
  ///
  /// In en, this message translates to:
  /// **'Time Allocation Summary:'**
  String get timeAllocationSummary;

  /// No description provided for @totalShares.
  ///
  /// In en, this message translates to:
  /// **'• Total shares: {count}'**
  String totalShares(Object count);

  /// No description provided for @totalDayTime.
  ///
  /// In en, this message translates to:
  /// **'• Total day time: {duration} (24 hours)'**
  String totalDayTime(Object duration);

  /// No description provided for @timeBlocksLabel.
  ///
  /// In en, this message translates to:
  /// **'• Time blocks: {duration}'**
  String timeBlocksLabel(Object duration);

  /// No description provided for @netAvailable.
  ///
  /// In en, this message translates to:
  /// **'• Net available: {duration}'**
  String netAvailable(Object duration);

  /// No description provided for @minutesPerShare.
  ///
  /// In en, this message translates to:
  /// **'• Minutes per share: {minutes} minutes'**
  String minutesPerShare(Object minutes);

  /// No description provided for @timeBlocksTitle.
  ///
  /// In en, this message translates to:
  /// **'Time Blocks:'**
  String get timeBlocksTitle;

  /// No description provided for @pausesLabel.
  ///
  /// In en, this message translates to:
  /// **'(Pauses)'**
  String get pausesLabel;

  /// No description provided for @memberScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Member Schedule:'**
  String get memberScheduleTitle;

  /// No description provided for @noTimeAllocated.
  ///
  /// In en, this message translates to:
  /// **'- No time allocated'**
  String get noTimeAllocated;

  /// No description provided for @memberScheduleLine.
  ///
  /// In en, this message translates to:
  /// **'{name} ({shares} shares - {duration}):'**
  String memberScheduleLine(Object name, Object shares, Object duration);

  /// No description provided for @dayConflictTitle.
  ///
  /// In en, this message translates to:
  /// **'Day Conflict'**
  String get dayConflictTitle;

  /// No description provided for @dayConflictContent.
  ///
  /// In en, this message translates to:
  /// **'Some days are already assigned to other groups.\n\nAvailable days: {days}\n\nPlease select different days or edit existing groups.'**
  String dayConflictContent(Object days);

  /// No description provided for @okButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButton;

  /// No description provided for @missingInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Missing Information'**
  String get missingInfoTitle;

  /// No description provided for @missingInfoContent.
  ///
  /// In en, this message translates to:
  /// **'Please enter a group name.'**
  String get missingInfoContent;

  /// No description provided for @noMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'No Members'**
  String get noMembersTitle;

  /// No description provided for @noMembersContent.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one member to the group.'**
  String get noMembersContent;

  /// No description provided for @memberNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Member Name'**
  String get memberNameLabel;

  /// No description provided for @addMemberButton.
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get addMemberButton;

  /// No description provided for @addCustomTimeBlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Time Block'**
  String get addCustomTimeBlockTitle;

  /// No description provided for @blockNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Block Name (e.g., Sleep, Study)'**
  String get blockNameLabel;

  /// No description provided for @fromLabel.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromLabel;

  /// No description provided for @toLabel.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toLabel;

  /// No description provided for @pauseUserTimersLabel.
  ///
  /// In en, this message translates to:
  /// **'Pause User Timers'**
  String get pauseUserTimersLabel;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @addButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButton;

  /// No description provided for @prayerLabel.
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get prayerLabel;

  /// No description provided for @hoursSuffix.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get hoursSuffix;

  /// No description provided for @minutesSuffix.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get minutesSuffix;

  /// No description provided for @starterTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Fair Share'**
  String get starterTitle;

  /// No description provided for @starterInstructions.
  ///
  /// In en, this message translates to:
  /// **'Fair Share helps you divide time and responsibilities fairly among group members. Follow the schedule, track prayer times, and manage your group with ease.'**
  String get starterInstructions;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @setPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a Password'**
  String get setPasswordTitle;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordHint;

  /// No description provided for @passwordEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get passwordEmptyError;

  /// No description provided for @passwordMismatchError.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatchError;

  /// No description provided for @saveLabel.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveLabel;

  /// No description provided for @enterPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterPasswordTitle;

  /// No description provided for @incorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get incorrectPassword;

  /// No description provided for @unlockLabel.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlockLabel;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get passwordUpdated;

  /// No description provided for @notificationTimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Timer Running'**
  String get notificationTimerTitle;

  /// Shows the remaining time in the persistent timer notification
  ///
  /// In en, this message translates to:
  /// **'{time} remaining'**
  String notificationTimerRemaining(String time);

  /// No description provided for @notificationOneMinute.
  ///
  /// In en, this message translates to:
  /// **'1 minute remaining'**
  String get notificationOneMinute;

  /// No description provided for @notificationTimeUp.
  ///
  /// In en, this message translates to:
  /// **'Time is up!'**
  String get notificationTimeUp;

  /// No description provided for @notificationPaused.
  ///
  /// In en, this message translates to:
  /// **'Time is paused'**
  String get notificationPaused;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
