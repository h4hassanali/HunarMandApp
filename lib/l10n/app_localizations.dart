import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Skilled Workers Pakistan'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'HunarMand Pakistan'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recognize your skills or find the one you need'**
  String get homeSubtitle;

  /// No description provided for @homeTagline.
  ///
  /// In en, this message translates to:
  /// **'HunarMand Pakistan - Your Skill, Your Identity'**
  String get homeTagline;

  /// No description provided for @btnNeedWork.
  ///
  /// In en, this message translates to:
  /// **'I Need Work'**
  String get btnNeedWork;

  /// No description provided for @btnNeedWorker.
  ///
  /// In en, this message translates to:
  /// **'I Need a Worker'**
  String get btnNeedWorker;

  /// No description provided for @findWorkerTitle.
  ///
  /// In en, this message translates to:
  /// **'Find Worker'**
  String get findWorkerTitle;

  /// No description provided for @findWorkerInstruction.
  ///
  /// In en, this message translates to:
  /// **'Select information according to your needs'**
  String get findWorkerInstruction;

  /// No description provided for @selectProvince.
  ///
  /// In en, this message translates to:
  /// **'Select Province'**
  String get selectProvince;

  /// No description provided for @selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get selectCity;

  /// No description provided for @selectWorkerType.
  ///
  /// In en, this message translates to:
  /// **'Select Worker Type'**
  String get selectWorkerType;

  /// No description provided for @btnSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get btnSearch;

  /// No description provided for @errorLoadingCities.
  ///
  /// In en, this message translates to:
  /// **'Problem loading cities'**
  String get errorLoadingCities;

  /// No description provided for @errorLoadingSkills.
  ///
  /// In en, this message translates to:
  /// **'Problem loading skills'**
  String get errorLoadingSkills;

  /// No description provided for @errorSelectProvince.
  ///
  /// In en, this message translates to:
  /// **'Please select a province'**
  String get errorSelectProvince;

  /// No description provided for @errorSelectCity.
  ///
  /// In en, this message translates to:
  /// **'Please select a city'**
  String get errorSelectCity;

  /// No description provided for @errorSelectSkill.
  ///
  /// In en, this message translates to:
  /// **'Please select a skill'**
  String get errorSelectSkill;

  /// No description provided for @workerRegistrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Worker Registration'**
  String get workerRegistrationTitle;

  /// No description provided for @labelName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get labelName;

  /// No description provided for @hintName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get hintName;

  /// No description provided for @errorName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get errorName;

  /// No description provided for @labelPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get labelPhone;

  /// No description provided for @hintPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get hintPhone;

  /// No description provided for @errorPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get errorPhone;

  /// No description provided for @errorPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number (11 digits)'**
  String get errorPhoneInvalid;

  /// No description provided for @labelProvince.
  ///
  /// In en, this message translates to:
  /// **'Province'**
  String get labelProvince;

  /// No description provided for @labelCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get labelCity;

  /// No description provided for @labelSkill.
  ///
  /// In en, this message translates to:
  /// **'Skill/Profession'**
  String get labelSkill;

  /// No description provided for @btnRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get btnRegister;

  /// No description provided for @btnSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get btnSubmitting;

  /// No description provided for @registrationSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration Successful'**
  String get registrationSuccessTitle;

  /// No description provided for @registrationSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your registration has been completed successfully!'**
  String get registrationSuccessMessage;

  /// No description provided for @registrationSuccessDetail.
  ///
  /// In en, this message translates to:
  /// **'Your information has been saved. Customers will be able to find you now.'**
  String get registrationSuccessDetail;

  /// No description provided for @btnBackToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get btnBackToHome;

  /// No description provided for @btnRegisterAnother.
  ///
  /// In en, this message translates to:
  /// **'Register Another Worker'**
  String get btnRegisterAnother;

  /// No description provided for @workerResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get workerResultsTitle;

  /// No description provided for @loadingWorkers.
  ///
  /// In en, this message translates to:
  /// **'Loading workers...'**
  String get loadingWorkers;

  /// No description provided for @noWorkersFound.
  ///
  /// In en, this message translates to:
  /// **'No workers found'**
  String get noWorkersFound;

  /// No description provided for @noWorkersFoundDetail.
  ///
  /// In en, this message translates to:
  /// **'No workers found matching your search criteria. Please try different filters.'**
  String get noWorkersFoundDetail;

  /// No description provided for @workersFound.
  ///
  /// In en, this message translates to:
  /// **'workers found'**
  String get workersFound;

  /// No description provided for @btnCopyPhone.
  ///
  /// In en, this message translates to:
  /// **'Copy Phone Number'**
  String get btnCopyPhone;

  /// No description provided for @phoneCopied.
  ///
  /// In en, this message translates to:
  /// **'Phone number copied!'**
  String get phoneCopied;

  /// No description provided for @footerNote.
  ///
  /// In en, this message translates to:
  /// **'This app was created by Hassan Ali'**
  String get footerNote;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageUrdu.
  ///
  /// In en, this message translates to:
  /// **'اردو'**
  String get languageUrdu;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsAppInfo.
  ///
  /// In en, this message translates to:
  /// **'App Info'**
  String get settingsAppInfo;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsContact.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get settingsContact;

  /// No description provided for @settingsVision.
  ///
  /// In en, this message translates to:
  /// **'Vision'**
  String get settingsVision;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get navRegister;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Worker Profile'**
  String get profileTitle;

  /// No description provided for @profileExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get profileExperience;

  /// No description provided for @profileCallNow.
  ///
  /// In en, this message translates to:
  /// **'Call Now'**
  String get profileCallNow;

  /// No description provided for @profileShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get profileShare;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About HunarMand'**
  String get aboutTitle;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'HunarMand Pakistan is a platform dedicated to empowering local skilled workers by connecting them with people who need their services. Our mission is to recognize every skill and provide opportunities for growth.'**
  String get aboutDescription;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to HunarMand'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connecting Skills with Needs'**
  String get welcomeSubtitle;

  /// No description provided for @recentWorkers.
  ///
  /// In en, this message translates to:
  /// **'Recent Workers'**
  String get recentWorkers;

  /// No description provided for @featuredCategories.
  ///
  /// In en, this message translates to:
  /// **'Featured Categories'**
  String get featuredCategories;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
