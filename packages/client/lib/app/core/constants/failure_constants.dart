import 'package:nokhte/app/core/error/failure.dart';

class FailureConstants {
  static String get androidPlatformFailureMsg => 'Not Available on Android';
  static String get authFailureMsg =>
      "Authentication Failure, Please Try Again.";
  static String get internetConnectionFailureMsg =>
      "Check Your Internet Connection, and Try Again.";
  static String get serverFailureMsg =>
      "Something's Wrong with our Servers, Try Again.";
  static String get genericFailureMsg => "Unexpected Error, Try Again.";
  static String get invalidDeepLinkMsg =>
      "Invalid invitation, try another invitation";
  static String get lookedThemselvesUpMsg =>
      "You can't invite yourself to the group again";
  static String get cancelledPurchaseFailureMsg => "Cancelled Purchase";
  static String get groupCreationFailureMsg => "Group Creation Failure";

  static NetworkConnectionFailure get internetConnectionFailure =>
      const NetworkConnectionFailure(
          message: "Internet Connection Error",
          failureCode: "INTERNET_FAILURE");
  static SupabaseFailure get serverFailure => const SupabaseFailure(
      message: "Supabase Failure", failureCode: "SUPABASE_FAILURE");
  static GenericFailure get genericFailure => const GenericFailure(
      message: "Generic Failure", failureCode: "GENERIC_FAILURE");
  static AuthenticationFailure get authFailure => const AuthenticationFailure(
      message: "Authentication Failure", failureCode: "AUTH_FAILURE");
  static DatabaseFailure get dbFailure => const DatabaseFailure(
      message: "Database Failure", failureCode: "DATABASE_FAILURE");
  static AndroidPlatformFailure get androidPlatformFailure =>
      AndroidPlatformFailure(
          failureCode: 'NOT_AVAILABLE_ON_ANDROID_ERROR',
          message: androidPlatformFailureMsg);
  static UserInputFailure get invalidDeepLinkFailure => UserInputFailure(
        message: invalidDeepLinkMsg,
        failureCode: "INVALID_DEEP_LINK",
      );

  static UserInputFailure get lookedThemselvesUpFailure => UserInputFailure(
        message: lookedThemselvesUpMsg,
        failureCode: "LOOKED_THEMSELVES_UP",
      );
  static UserInputFailure get groupCreationFailure => UserInputFailure(
        message: groupCreationFailureMsg,
        failureCode: "GROUP_CREATION_FAILURE",
      );

  static UserInputFailure get cancelledPurchaseFailure => UserInputFailure(
        message: cancelledPurchaseFailureMsg,
        failureCode: "CANCELLED_PURCHASE",
      );
}
