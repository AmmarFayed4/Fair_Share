// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'فير شير';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get navGroups => 'المجموعات';

  @override
  String get navUser => 'المستخدم';

  @override
  String get navSchedule => 'الجدول';

  @override
  String get groupsTitle => 'إدارة المجموعات';

  @override
  String get groupsWarning => '⚠️ يجب أن تحتوي كل مجموعة على أيام فريدة لتجنب تعارض الجداول';

  @override
  String get groupsEmptyTitle => 'لا توجد مجموعات بعد';

  @override
  String get groupsEmptySubtitle => 'أنشئ أول مجموعة للبدء';

  @override
  String get groupsCreateButton => 'إنشاء مجموعة جديدة';

  @override
  String get groupsDeleteTitle => 'حذف المجموعة';

  @override
  String get groupsDeleteConfirm => 'هل أنت متأكد أنك تريد حذف هذه المجموعة؟';

  @override
  String get groupsCancel => 'إلغاء';

  @override
  String get groupsDelete => 'حذف';

  @override
  String get groupsEditTooltip => 'تعديل المجموعة';

  @override
  String get groupsDeleteTooltip => 'حذف المجموعة';

  @override
  String get groupInfoStartDate => 'تاريخ البدء';

  @override
  String get groupInfoActiveDays => 'أيام النشاط';

  @override
  String get groupMembersTitle => 'الأعضاء:';

  @override
  String get groupMembersEmpty => 'لا يوجد أعضاء بعد';

  @override
  String groupShares(Object shares, Object duration) {
    return '$shares حصة ($duration)';
  }

  @override
  String get groupTimeBlocksTitle => 'فترات الوقت:';

  @override
  String get groupTimeBlocksEmpty => 'لا توجد فترات وقت';

  @override
  String groupsMembers(Object count) {
    return '$count عضو';
  }

  @override
  String get dialogClose => 'إغلاق';

  @override
  String get dayMon => 'الإثنين';

  @override
  String get dayTue => 'الثلاثاء';

  @override
  String get dayWed => 'الأربعاء';

  @override
  String get dayThu => 'الخميس';

  @override
  String get dayFri => 'الجمعة';

  @override
  String get daySat => 'السبت';

  @override
  String get daySun => 'الأحد';

  @override
  String get prayerFajr => 'صلاة الفجر ';

  @override
  String get prayerDhuhr => 'صلاة الظهر';

  @override
  String get prayerAsr => 'صلاة العصر';

  @override
  String get prayerMaghrib => 'صلاة المغرب';

  @override
  String get prayerIsha => 'صلاة العشاء';

  @override
  String lastUpdated(Object time) {
    return 'آخر تحديث: $time';
  }

  @override
  String get lastUpdatedNever => 'آخر تحديث: لم يتم';

  @override
  String get fajrTomorrow => 'الفجر (غداً)';

  @override
  String durationHours(Object hours) {
    return '$hoursس';
  }

  @override
  String durationMinutes(Object minutes) {
    return '$minutesد';
  }

  @override
  String durationSeconds(Object seconds) {
    return '$secondsث';
  }

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get pausedSuffix => '(متوقف مؤقتًا)';

  @override
  String get noUserSelected => 'لم يتم اختيار مستخدم';

  @override
  String sharesCountLabel(Object shares) {
    return '$shares حصة';
  }

  @override
  String get sharesInputLabel => 'الحصص (مثال: 1.0، 1.5، 2.0)';

  @override
  String get notActiveToday => 'غير نشط اليوم';

  @override
  String get activeSessionTitle => '⏰ جلسة نشطة';

  @override
  String pausedWithBlock(Object blockName) {
    return '⏸️ متوقف: $blockName';
  }

  @override
  String get sessionWillStart => 'ستبدأ الجلسة تلقائيًا';

  @override
  String get sessionPaused => 'الجلسة متوقفة';

  @override
  String get noActiveUserToday => 'لا يوجد مستخدم نشط مجدول لليوم';

  @override
  String get prayerTimesTitle => '🕌 أوقات الصلاة';

  @override
  String get refreshTimesTooltip => 'تحديث الأوقات';

  @override
  String get usingCachedData => '📦 يتم استخدام البيانات المخزنة';

  @override
  String get timerPausedForPrayer => '⏸️ المؤقت متوقف للصلاة';

  @override
  String get noPrayerTimes => 'لا توجد أوقات صلاة متاحة';

  @override
  String nextPrayer(Object prayerName, Object time) {
    return 'التالي: $prayerName في $time';
  }

  @override
  String timerPausedWithBlock(Object blockName) {
    return 'المؤقت متوقف: $blockName';
  }

  @override
  String get timeBlockFallback => 'فترة توقف زمنية';

  @override
  String get noGroupSelected => 'لم يتم اختيار مجموعة';

  @override
  String pausedBlockLabel(Object blockName) {
    return '⏸ $blockName';
  }

  @override
  String get timeAM => 'ص';

  @override
  String get timePM => 'م';

  @override
  String get editGroupTitle => 'تعديل المجموعة';

  @override
  String get createGroupTitle => 'إنشاء مجموعة جديدة';

  @override
  String get continueButton => 'متابعة';

  @override
  String get backButton => 'رجوع';

  @override
  String get groupInfoStep => 'معلومات المجموعة';

  @override
  String get groupNameLabel => 'اسم المجموعة';

  @override
  String get startDateLabel => 'تاريخ البدء';

  @override
  String get startTimeLabel => 'وقت البدء';

  @override
  String get addMembersStep => 'إضافة أعضاء';

  @override
  String get membersTitle => 'الأعضاء:';

  @override
  String get timeBlocksStep => 'فترات توقف الوقت';

  @override
  String get prayerTimesLoaded => '✅ تم تحميل أوقات الصلاة تلقائيًا';

  @override
  String get usingCachedPrayerTimes => '⚠️ يتم استخدام أوقات الصلاة المخزنة';

  @override
  String get timeBlocksSectionTitle => 'فترات توقف الوقت (أوقات الصلاة مضافة تلقائيًا):';

  @override
  String get addCustomTimeBlock => 'إضافة فترة توقف وقت مخصصة';

  @override
  String get activeDaysStep => 'أيام النشاط';

  @override
  String get selectActiveDays => 'اختر أيام النشاط لهذه المجموعة:';

  @override
  String get reviewStep => 'مراجعة';

  @override
  String daysConflictWarning(Object days) {
    return '⚠️ الأيام $days مخصصة بالفعل لمجموعات أخرى';
  }

  @override
  String get dayUnavailableTooltip => 'هذا اليوم مخصص بالفعل لمجموعة أخرى';

  @override
  String reviewGroup(Object groupName) {
    return 'المجموعة: $groupName';
  }

  @override
  String reviewStartDate(Object date) {
    return 'تاريخ البدء: $date';
  }

  @override
  String reviewActiveDays(Object days) {
    return 'أيام النشاط: $days';
  }

  @override
  String get timeAllocationSummary => 'ملخص تخصيص الوقت:';

  @override
  String totalShares(Object count) {
    return '• إجمالي الحصص: $count';
  }

  @override
  String totalDayTime(Object duration) {
    return '• إجمالي وقت اليوم: $duration (24 ساعة)';
  }

  @override
  String timeBlocksLabel(Object duration) {
    return '• فترات توقف الوقت: $duration';
  }

  @override
  String netAvailable(Object duration) {
    return '• الوقت المتاح: $duration';
  }

  @override
  String minutesPerShare(Object minutes) {
    return '• الدقائق لكل حصة: $minutes دقيقة';
  }

  @override
  String get timeBlocksTitle => 'فترات توقف الوقت:';

  @override
  String get pausesLabel => '(إيقاف مؤقت)';

  @override
  String get memberScheduleTitle => 'جدول الأعضاء:';

  @override
  String get noTimeAllocated => '- لم يتم تخصيص وقت';

  @override
  String memberScheduleLine(Object name, Object shares, Object duration) {
    return '$name ($shares حصص - $duration):';
  }

  @override
  String get dayConflictTitle => 'تعارض في الأيام';

  @override
  String dayConflictContent(Object days) {
    return 'بعض الأيام مخصصة بالفعل لمجموعات أخرى.\n\nالأيام المتاحة: $days\n\nيرجى اختيار أيام مختلفة أو تعديل المجموعات الحالية.';
  }

  @override
  String get okButton => 'حسناً';

  @override
  String get missingInfoTitle => 'معلومات ناقصة';

  @override
  String get missingInfoContent => 'يرجى إدخال اسم المجموعة.';

  @override
  String get noMembersTitle => 'لا يوجد أعضاء';

  @override
  String get noMembersContent => 'يرجى إضافة عضو واحد على الأقل إلى المجموعة.';

  @override
  String get memberNameLabel => 'اسم العضو';

  @override
  String get addMemberButton => 'إضافة عضو';

  @override
  String get addCustomTimeBlockTitle => 'إضافة فترة وقت مخصصة';

  @override
  String get blockNameLabel => 'اسم فترة التوقف (مثال: نوم، دراسة)';

  @override
  String get fromLabel => 'من';

  @override
  String get toLabel => 'إلى';

  @override
  String get pauseUserTimersLabel => 'إيقاف مؤقت لمؤقتات المستخدم';

  @override
  String get cancelButton => 'إلغاء';

  @override
  String get addButton => 'إضافة';

  @override
  String get prayerLabel => '';

  @override
  String get hoursSuffix => 'س';

  @override
  String get minutesSuffix => 'د';

  @override
  String get starterTitle => 'مرحباً بك في فير شير';

  @override
  String get starterInstructions => 'يساعدك فير شير على تقسيم الوقت والمسؤوليات بشكل عادل بين أعضاء المجموعة. اتباع الجدول، وتتبع أوقات الصلاة، وأدر مجموعتك بسهولة.';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get setPasswordTitle => 'تعيين كلمة المرور';

  @override
  String get passwordHint => 'كلمة المرور';

  @override
  String get confirmPasswordHint => 'تأكيد كلمة المرور';

  @override
  String get passwordEmptyError => 'لا يمكن أن تكون كلمة المرور فارغة';

  @override
  String get passwordMismatchError => 'كلمتا المرور غير متطابقتين';

  @override
  String get saveLabel => 'حفظ';

  @override
  String get enterPasswordTitle => 'أدخل كلمة المرور';

  @override
  String get incorrectPassword => 'كلمة المرور غير صحيحة';

  @override
  String get unlockLabel => 'فتح';

  @override
  String get passwordUpdated => 'تم تحديث كلمة المرور بنجاح';

  @override
  String get notificationTimerTitle => 'المؤقت يعمل';

  @override
  String notificationTimerRemaining(String time) {
    return 'متبقي $time';
  }

  @override
  String get notificationOneMinute => 'متبقي دقيقة واحدة';

  @override
  String get notificationTimeUp => 'انتهى الوقت!';

  @override
  String get notificationPaused => 'الوقت متوقف مؤقتًا';
}
