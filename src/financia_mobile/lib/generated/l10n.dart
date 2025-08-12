// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome`
  String get welcome {
    return Intl.message('Welcome', name: 'welcome', desc: '', args: []);
  }

  /// `FinancIA is the app that helps you manage your personal finances.`
  String get intro_text {
    return Intl.message(
      'FinancIA is the app that helps you manage your personal finances.',
      name: 'intro_text',
      desc: '',
      args: [],
    );
  }

  /// `Control your expenses`
  String get control_expenses {
    return Intl.message(
      'Control your expenses',
      name: 'control_expenses',
      desc: '',
      args: [],
    );
  }

  /// `Add and classify your expenses easily.`
  String get add_and_classify {
    return Intl.message(
      'Add and classify your expenses easily.',
      name: 'add_and_classify',
      desc: '',
      args: [],
    );
  }

  /// `Smart predictions and suggestions`
  String get smart_predictions {
    return Intl.message(
      'Smart predictions and suggestions',
      name: 'smart_predictions',
      desc: '',
      args: [],
    );
  }

  /// `Our AI helps you predict future finances and receive recommendations to improve your finances`
  String get ai_help {
    return Intl.message(
      'Our AI helps you predict future finances and receive recommendations to improve your finances',
      name: 'ai_help',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get get_started {
    return Intl.message('Get Started', name: 'get_started', desc: '', args: []);
  }

  /// `Please type a valid email`
  String get validations_login_email {
    return Intl.message(
      'Please type a valid email',
      name: 'validations_login_email',
      desc: '',
      args: [],
    );
  }

  /// `Type your password`
  String get validations_login_password {
    return Intl.message(
      'Type your password',
      name: 'validations_login_password',
      desc: '',
      args: [],
    );
  }

  /// `That email is already taken`
  String get validations_signup_email_taken {
    return Intl.message(
      'That email is already taken',
      name: 'validations_signup_email_taken',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Salary`
  String get salary {
    return Intl.message('Salary', name: 'salary', desc: '', args: []);
  }

  /// `Supermarket`
  String get supermarket {
    return Intl.message('Supermarket', name: 'supermarket', desc: '', args: []);
  }

  /// `Apr 25 2024`
  String get apr_25 {
    return Intl.message('Apr 25 2024', name: 'apr_25', desc: '', args: []);
  }

  /// `Transfer`
  String get transfer {
    return Intl.message('Transfer', name: 'transfer', desc: '', args: []);
  }

  /// `Apr 24 2024`
  String get apr_24 {
    return Intl.message('Apr 24 2024', name: 'apr_24', desc: '', args: []);
  }

  /// `Restaurant`
  String get restaurant {
    return Intl.message('Restaurant', name: 'restaurant', desc: '', args: []);
  }

  /// `Apr 23 2024`
  String get apr_23 {
    return Intl.message('Apr 23 2024', name: 'apr_23', desc: '', args: []);
  }

  /// `Transport`
  String get transport {
    return Intl.message('Transport', name: 'transport', desc: '', args: []);
  }

  /// `Transaction History`
  String get transaction_history {
    return Intl.message(
      'Transaction History',
      name: 'transaction_history',
      desc: '',
      args: [],
    );
  }

  /// `Add Transaction`
  String get add_transaction {
    return Intl.message(
      'Add Transaction',
      name: 'add_transaction',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `Amount`
  String get amount {
    return Intl.message('Amount', name: 'amount', desc: '', args: []);
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Jan`
  String get month_jan {
    return Intl.message('Jan', name: 'month_jan', desc: '', args: []);
  }

  /// `Feb`
  String get month_feb {
    return Intl.message('Feb', name: 'month_feb', desc: '', args: []);
  }

  /// `Mar`
  String get month_mar {
    return Intl.message('Mar', name: 'month_mar', desc: '', args: []);
  }

  /// `Apr`
  String get month_apr {
    return Intl.message('Apr', name: 'month_apr', desc: '', args: []);
  }

  /// `May`
  String get month_may {
    return Intl.message('May', name: 'month_may', desc: '', args: []);
  }

  /// `Jun`
  String get month_jun {
    return Intl.message('Jun', name: 'month_jun', desc: '', args: []);
  }

  /// `Jul`
  String get month_jul {
    return Intl.message('Jul', name: 'month_jul', desc: '', args: []);
  }

  /// `Aug`
  String get month_aug {
    return Intl.message('Aug', name: 'month_aug', desc: '', args: []);
  }

  /// `Sep`
  String get month_sep {
    return Intl.message('Sep', name: 'month_sep', desc: '', args: []);
  }

  /// `Oct`
  String get month_oct {
    return Intl.message('Oct', name: 'month_oct', desc: '', args: []);
  }

  /// `Nov`
  String get month_nov {
    return Intl.message('Nov', name: 'month_nov', desc: '', args: []);
  }

  /// `Dec`
  String get month_dec {
    return Intl.message('Dec', name: 'month_dec', desc: '', args: []);
  }

  /// `April 2024`
  String get apr_2024 {
    return Intl.message('April 2024', name: 'apr_2024', desc: '', args: []);
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Light`
  String get light {
    return Intl.message('Light', name: 'light', desc: '', args: []);
  }

  /// `Dark`
  String get dark {
    return Intl.message('Dark', name: 'dark', desc: '', args: []);
  }

  /// `System`
  String get system {
    return Intl.message('System', name: 'system', desc: '', args: []);
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `Personal Data`
  String get personal_data {
    return Intl.message(
      'Personal Data',
      name: 'personal_data',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get full_name {
    return Intl.message('Full Name', name: 'full_name', desc: '', args: []);
  }

  /// `Birth Date`
  String get birth_date {
    return Intl.message('Birth Date', name: 'birth_date', desc: '', args: []);
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Spanish`
  String get spanish {
    return Intl.message('Spanish', name: 'spanish', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Current Balance`
  String get current_balance {
    return Intl.message(
      'Current Balance',
      name: 'current_balance',
      desc: '',
      args: [],
    );
  }

  /// `Income`
  String get income {
    return Intl.message('Income', name: 'income', desc: '', args: []);
  }

  /// `Expenses`
  String get expenses {
    return Intl.message('Expenses', name: 'expenses', desc: '', args: []);
  }

  /// `Latest Transactions`
  String get latest_transactions {
    return Intl.message(
      'Latest Transactions',
      name: 'latest_transactions',
      desc: '',
      args: [],
    );
  }

  /// `Analysis`
  String get analysis {
    return Intl.message('Analysis', name: 'analysis', desc: '', args: []);
  }

  /// `Suggestions`
  String get suggestions {
    return Intl.message('Suggestions', name: 'suggestions', desc: '', args: []);
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `Transactions`
  String get transactions {
    return Intl.message(
      'Transactions',
      name: 'transactions',
      desc: '',
      args: [],
    );
  }

  /// `Full name is required`
  String get name_required {
    return Intl.message(
      'Full name is required',
      name: 'name_required',
      desc: '',
      args: [],
    );
  }

  /// `Full name must be at least\n5 characters long`
  String get name_min_length {
    return Intl.message(
      'Full name must be at least\n5 characters long',
      name: 'name_min_length',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email address`
  String get invalid_email {
    return Intl.message(
      'Invalid email address',
      name: 'invalid_email',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get password_required {
    return Intl.message(
      'Password is required',
      name: 'password_required',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least\n6 characters long, include an uppercase,\na lowercase and a number`
  String get invalid_password {
    return Intl.message(
      'Password must be at least\n6 characters long, include an uppercase,\na lowercase and a number',
      name: 'invalid_password',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwords_not_match {
    return Intl.message(
      'Passwords do not match',
      name: 'passwords_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Invalid credentials`
  String get invalid_credentials {
    return Intl.message(
      'Invalid credentials',
      name: 'invalid_credentials',
      desc: '',
      args: [],
    );
  }

  /// `Please fill out the fields correctly`
  String get fill_fields_correctly {
    return Intl.message(
      'Please fill out the fields correctly',
      name: 'fill_fields_correctly',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get enter_email {
    return Intl.message(
      'Enter your email',
      name: 'enter_email',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get enter_valid_email {
    return Intl.message(
      'Please enter a valid email address',
      name: 'enter_valid_email',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enter_password {
    return Intl.message(
      'Enter your password',
      name: 'enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get sign_up {
    return Intl.message('Sign Up', name: 'sign_up', desc: '', args: []);
  }

  /// `June Summary`
  String get june_summary {
    return Intl.message(
      'June Summary',
      name: 'june_summary',
      desc: '',
      args: [],
    );
  }

  /// `Expenses`
  String get expenses_2 {
    return Intl.message('Expenses', name: 'expenses_2', desc: '', args: []);
  }

  /// `Expenses by Category`
  String get expenses_by_category {
    return Intl.message(
      'Expenses by Category',
      name: 'expenses_by_category',
      desc: '',
      args: [],
    );
  }

  /// `Restaurants`
  String get restaurants {
    return Intl.message('Restaurants', name: 'restaurants', desc: '', args: []);
  }

  /// `Entertainment`
  String get entertainment {
    return Intl.message(
      'Entertainment',
      name: 'entertainment',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Trend`
  String get monthly_trend {
    return Intl.message(
      'Monthly Trend',
      name: 'monthly_trend',
      desc: '',
      args: [],
    );
  }

  /// `Saving goals`
  String get savings_goals {
    return Intl.message(
      'Saving goals',
      name: 'savings_goals',
      desc: '',
      args: [],
    );
  }

  /// `Vacation`
  String get vacation {
    return Intl.message('Vacation', name: 'vacation', desc: '', args: []);
  }

  /// `Emergency Fund`
  String get emergency_fund {
    return Intl.message(
      'Emergency Fund',
      name: 'emergency_fund',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get confirm_password {
    return Intl.message(
      'Confirm password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Create account`
  String get create_account {
    return Intl.message(
      'Create account',
      name: 'create_account',
      desc: '',
      args: [],
    );
  }

  /// `Saved`
  String get data_saved {
    return Intl.message('Saved', name: 'data_saved', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Budget`
  String get budget {
    return Intl.message('Budget', name: 'budget', desc: '', args: []);
  }

  /// `Log out`
  String get logout {
    return Intl.message('Log out', name: 'logout', desc: '', args: []);
  }

  /// `Transaction created successfully`
  String get transaction_created_successfully {
    return Intl.message(
      'Transaction created successfully',
      name: 'transaction_created_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Please complete all fields`
  String get please_fill_all_fields {
    return Intl.message(
      'Please complete all fields',
      name: 'please_fill_all_fields',
      desc: '',
      args: [],
    );
  }

  /// `Please select a category`
  String get select_a_category {
    return Intl.message(
      'Please select a category',
      name: 'select_a_category',
      desc: '',
      args: [],
    );
  }

  /// `Field is required`
  String get field_is_required {
    return Intl.message(
      'Field is required',
      name: 'field_is_required',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid number`
  String get enter_a_valid_number {
    return Intl.message(
      'Enter a valid number',
      name: 'enter_a_valid_number',
      desc: '',
      args: [],
    );
  }

  /// `Error loading categories`
  String get error_loading_categories {
    return Intl.message(
      'Error loading categories',
      name: 'error_loading_categories',
      desc: '',
      args: [],
    );
  }

  /// `There are no transactions`
  String get no_transactions {
    return Intl.message(
      'There are no transactions',
      name: 'no_transactions',
      desc: '',
      args: [],
    );
  }

  /// `Financial AI`
  String get financial_ai {
    return Intl.message(
      'Financial AI',
      name: 'financial_ai',
      desc: '',
      args: [],
    );
  }

  /// `Suggestions`
  String get suggestions_tab {
    return Intl.message(
      'Suggestions',
      name: 'suggestions_tab',
      desc: '',
      args: [],
    );
  }

  /// `Predictions`
  String get predictions_tab {
    return Intl.message(
      'Predictions',
      name: 'predictions_tab',
      desc: '',
      args: [],
    );
  }

  /// `AI Chat`
  String get ai_chat_tab {
    return Intl.message('AI Chat', name: 'ai_chat_tab', desc: '', args: []);
  }

  /// `Error loading suggestions`
  String get error_loading_suggestions {
    return Intl.message(
      'Error loading suggestions',
      name: 'error_loading_suggestions',
      desc: '',
      args: [],
    );
  }

  /// `Could not load suggestions`
  String get no_suggestions_loaded {
    return Intl.message(
      'Could not load suggestions',
      name: 'no_suggestions_loaded',
      desc: '',
      args: [],
    );
  }

  /// `Additional Suggestions`
  String get additional_suggestions {
    return Intl.message(
      'Additional Suggestions',
      name: 'additional_suggestions',
      desc: '',
      args: [],
    );
  }

  /// `Additional Prediction`
  String get additional_predictions {
    return Intl.message(
      'Additional Prediction',
      name: 'additional_predictions',
      desc: '',
      args: [],
    );
  }

  /// `Error loading predictions`
  String get error_loading_predictions {
    return Intl.message(
      'Error loading predictions',
      name: 'error_loading_predictions',
      desc: '',
      args: [],
    );
  }

  /// `Could not load predictions`
  String get no_predictions_loaded {
    return Intl.message(
      'Could not load predictions',
      name: 'no_predictions_loaded',
      desc: '',
      args: [],
    );
  }

  /// `Error: Could not process your message. Please try again.`
  String get chat_processing_error {
    return Intl.message(
      'Error: Could not process your message. Please try again.',
      name: 'chat_processing_error',
      desc: '',
      args: [],
    );
  }

  /// `Suggestion`
  String get main_ai_suggestion {
    return Intl.message(
      'Suggestion',
      name: 'main_ai_suggestion',
      desc: '',
      args: [],
    );
  }

  /// `Prediction`
  String get main_prediction {
    return Intl.message(
      'Prediction',
      name: 'main_prediction',
      desc: '',
      args: [],
    );
  }

  /// `Ask something about your finances...`
  String get ask_about_finances_hint {
    return Intl.message(
      'Ask something about your finances...',
      name: 'ask_about_finances_hint',
      desc: '',
      args: [],
    );
  }

  /// `To generate personalized suggestions, you need to record some transactions first. Start by adding your income and expenses!`
  String get no_transactions_suggestions_main {
    return Intl.message(
      'To generate personalized suggestions, you need to record some transactions first. Start by adding your income and expenses!',
      name: 'no_transactions_suggestions_main',
      desc: '',
      args: [],
    );
  }

  /// `Record your monthly income`
  String get no_transactions_suggestions_side1 {
    return Intl.message(
      'Record your monthly income',
      name: 'no_transactions_suggestions_side1',
      desc: '',
      args: [],
    );
  }

  /// `Note your main expenses`
  String get no_transactions_suggestions_side2 {
    return Intl.message(
      'Note your main expenses',
      name: 'no_transactions_suggestions_side2',
      desc: '',
      args: [],
    );
  }

  /// `Categorize your transactions correctly`
  String get no_transactions_suggestions_side3 {
    return Intl.message(
      'Categorize your transactions correctly',
      name: 'no_transactions_suggestions_side3',
      desc: '',
      args: [],
    );
  }

  /// `To generate accurate financial predictions, you need to have a transaction history. Start by recording your financial movements!`
  String get no_transactions_predictions_main {
    return Intl.message(
      'To generate accurate financial predictions, you need to have a transaction history. Start by recording your financial movements!',
      name: 'no_transactions_predictions_main',
      desc: '',
      args: [],
    );
  }

  /// `Record at least one month of transactions`
  String get no_transactions_predictions_side1 {
    return Intl.message(
      'Record at least one month of transactions',
      name: 'no_transactions_predictions_side1',
      desc: '',
      args: [],
    );
  }

  /// `Include both income and expenses`
  String get no_transactions_predictions_side2 {
    return Intl.message(
      'Include both income and expenses',
      name: 'no_transactions_predictions_side2',
      desc: '',
      args: [],
    );
  }

  /// `Maintain a consistent record for better predictions`
  String get no_transactions_predictions_side3 {
    return Intl.message(
      'Maintain a consistent record for better predictions',
      name: 'no_transactions_predictions_side3',
      desc: '',
      args: [],
    );
  }

  /// `To help you with personalized financial queries, you need to have transactions recorded in your account. Please add some transactions first, and then you can ask specific questions about your finances.`
  String get no_transactions_chat_response {
    return Intl.message(
      'To help you with personalized financial queries, you need to have transactions recorded in your account. Please add some transactions first, and then you can ask specific questions about your finances.',
      name: 'no_transactions_chat_response',
      desc: '',
      args: [],
    );
  }

  /// `Error loading analysis:`
  String get analysis_error_load {
    return Intl.message(
      'Error loading analysis:',
      name: 'analysis_error_load',
      desc: '',
      args: [],
    );
  }

  /// `New Saving Goal`
  String get new_saving_goal {
    return Intl.message(
      'New Saving Goal',
      name: 'new_saving_goal',
      desc: '',
      args: [],
    );
  }

  /// `Goal Title`
  String get goal_title {
    return Intl.message('Goal Title', name: 'goal_title', desc: '', args: []);
  }

  /// `Target amount`
  String get target_amount {
    return Intl.message(
      'Target amount',
      name: 'target_amount',
      desc: '',
      args: [],
    );
  }

  /// `Description (optional)`
  String get description_analysis {
    return Intl.message(
      'Description (optional)',
      name: 'description_analysis',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Error creating goal:`
  String get error_create_goal {
    return Intl.message(
      'Error creating goal:',
      name: 'error_create_goal',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message('Create', name: 'create', desc: '', args: []);
  }

  /// `Add goal`
  String get add_goal {
    return Intl.message('Add goal', name: 'add_goal', desc: '', args: []);
  }

  /// `You don't have savings goals`
  String get no_savings_goals {
    return Intl.message(
      'You don\'t have savings goals',
      name: 'no_savings_goals',
      desc: '',
      args: [],
    );
  }

  /// `Create your first savings goal to start planning your financial goals.`
  String get create_first_goal {
    return Intl.message(
      'Create your first savings goal to start planning your financial goals.',
      name: 'create_first_goal',
      desc: '',
      args: [],
    );
  }

  /// `Create goal`
  String get create_goal {
    return Intl.message('Create goal', name: 'create_goal', desc: '', args: []);
  }

  /// `There is no trend data available`
  String get no_trends {
    return Intl.message(
      'There is no trend data available',
      name: 'no_trends',
      desc: '',
      args: [],
    );
  }

  /// `Delete goal`
  String get delete_goal {
    return Intl.message('Delete goal', name: 'delete_goal', desc: '', args: []);
  }

  /// `Are you sure you want to delete?`
  String get delete_goal_ask {
    return Intl.message(
      'Are you sure you want to delete?',
      name: 'delete_goal_ask',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Error deleting:`
  String get error_to_delete {
    return Intl.message(
      'Error deleting:',
      name: 'error_to_delete',
      desc: '',
      args: [],
    );
  }

  /// `No analysis data available`
  String get no_analysis_data {
    return Intl.message(
      'No analysis data available',
      name: 'no_analysis_data',
      desc: '',
      args: [],
    );
  }

  /// `Add some transactions to see your financial analysis`
  String get add_transactions_analysis {
    return Intl.message(
      'Add some transactions to see your financial analysis',
      name: 'add_transactions_analysis',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Summary of {month}`
  String monthly_summary_text(Object month) {
    return Intl.message(
      'Summary of $month',
      name: 'monthly_summary_text',
      desc: '',
      args: [month],
    );
  }

  /// `January`
  String get january {
    return Intl.message('January', name: 'january', desc: '', args: []);
  }

  /// `February`
  String get february {
    return Intl.message('February', name: 'february', desc: '', args: []);
  }

  /// `March`
  String get march {
    return Intl.message('March', name: 'march', desc: '', args: []);
  }

  /// `April`
  String get april {
    return Intl.message('April', name: 'april', desc: '', args: []);
  }

  /// `May`
  String get may {
    return Intl.message('May', name: 'may', desc: '', args: []);
  }

  /// `June`
  String get june {
    return Intl.message('June', name: 'june', desc: '', args: []);
  }

  /// `July`
  String get july {
    return Intl.message('July', name: 'july', desc: '', args: []);
  }

  /// `August`
  String get august {
    return Intl.message('August', name: 'august', desc: '', args: []);
  }

  /// `September`
  String get september {
    return Intl.message('September', name: 'september', desc: '', args: []);
  }

  /// `October`
  String get october {
    return Intl.message('October', name: 'october', desc: '', args: []);
  }

  /// `November`
  String get november {
    return Intl.message('November', name: 'november', desc: '', args: []);
  }

  /// `December`
  String get december {
    return Intl.message('December', name: 'december', desc: '', args: []);
  }

  /// `Error while fetching savings`
  String get savings_error_while_fetching {
    return Intl.message(
      'Error while fetching savings',
      name: 'savings_error_while_fetching',
      desc: '',
      args: [],
    );
  }

  /// `My savings`
  String get savings_my_savings {
    return Intl.message(
      'My savings',
      name: 'savings_my_savings',
      desc: '',
      args: [],
    );
  }

  /// `You don't have any savings, create one!`
  String get savings_no_savings_created {
    return Intl.message(
      'You don\'t have any savings, create one!',
      name: 'savings_no_savings_created',
      desc: '',
      args: [],
    );
  }

  /// `Saved money`
  String get savings_total_saved {
    return Intl.message(
      'Saved money',
      name: 'savings_total_saved',
      desc: '',
      args: [],
    );
  }

  /// `% of $`
  String get savings_percentaje {
    return Intl.message(
      '% of \$',
      name: 'savings_percentaje',
      desc: '',
      args: [],
    );
  }

  /// `days left`
  String get savings_days_left {
    return Intl.message(
      'days left',
      name: 'savings_days_left',
      desc: '',
      args: [],
    );
  }

  /// `Add money`
  String get savings_add_money_to_saving {
    return Intl.message(
      'Add money',
      name: 'savings_add_money_to_saving',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get savings_edit {
    return Intl.message('Edit', name: 'savings_edit', desc: '', args: []);
  }

  /// `Delete`
  String get savings_delete {
    return Intl.message('Delete', name: 'savings_delete', desc: '', args: []);
  }

  /// `% completed`
  String get savings_completed_percentage {
    return Intl.message(
      '% completed',
      name: 'savings_completed_percentage',
      desc: '',
      args: [],
    );
  }

  /// `Edit saving`
  String get savings_edit_modal_title {
    return Intl.message(
      'Edit saving',
      name: 'savings_edit_modal_title',
      desc: '',
      args: [],
    );
  }

  /// `New saving goal`
  String get savings_add_modal_title {
    return Intl.message(
      'New saving goal',
      name: 'savings_add_modal_title',
      desc: '',
      args: [],
    );
  }

  /// `Name of the goal`
  String get savings_name_input {
    return Intl.message(
      'Name of the goal',
      name: 'savings_name_input',
      desc: '',
      args: [],
    );
  }

  /// `Target amount`
  String get savings_target_amount_input {
    return Intl.message(
      'Target amount',
      name: 'savings_target_amount_input',
      desc: '',
      args: [],
    );
  }

  /// `Deadline: `
  String get savings_deadline {
    return Intl.message(
      'Deadline: ',
      name: 'savings_deadline',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get savings_cancel {
    return Intl.message('Cancel', name: 'savings_cancel', desc: '', args: []);
  }

  /// `Update`
  String get savings_update {
    return Intl.message('Update', name: 'savings_update', desc: '', args: []);
  }

  /// `Create`
  String get savings_create {
    return Intl.message('Create', name: 'savings_create', desc: '', args: []);
  }

  /// `Add money`
  String get savings_add_money {
    return Intl.message(
      'Add money',
      name: 'savings_add_money',
      desc: '',
      args: [],
    );
  }

  /// `Amount to add`
  String get savings_amount_to_add {
    return Intl.message(
      'Amount to add',
      name: 'savings_amount_to_add',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get savings_add_money_button {
    return Intl.message(
      'Add',
      name: 'savings_add_money_button',
      desc: '',
      args: [],
    );
  }

  /// `Delete goal`
  String get savings_delete_saving {
    return Intl.message(
      'Delete goal',
      name: 'savings_delete_saving',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure about deleting `
  String get savings_delete_saving_confirmation {
    return Intl.message(
      'Are you sure about deleting ',
      name: 'savings_delete_saving_confirmation',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
