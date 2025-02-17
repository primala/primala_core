import 'package:nokhte/app/core/error/failure.dart';

class FailureConstants {
  static const authFailureMsg = "Authentication Failure, Please Try Again.";
  static const internetConnectionFailureMsg =
      "Check Your Internet Connection, and Try Again.";
  static const serverFailureMsg =
      "Something's Wrong with our Servers, Try Again.";
  static const genericFailureMsg = "Unexpected Error, Try Again.";
  static const lookedThemselvesUpMsg =
      "You can't invite yourself to the group again";
  static const cancelledPurchaseFailureMsg = "Cancelled Purchase";
  static const groupCreationFailureMsg = "Group Creation Failure";
  static const addContentErrorMsg = "Error Adding Content";
  static const updateContentErrorMsg = "Error Updating Content";

  static const internetConnectionFailure = Failure(
      message: "Internet Connection Error", failureCode: "INTERNET_FAILURE");
  static const addContentFailure = Failure(
    message: addContentErrorMsg,
    failureCode: "ADD_CONTENT_FAILURE",
  );
  static const updateContentFailure = Failure(
    message: updateContentErrorMsg,
    failureCode: "UPDATE_CONTENT_FAILURE",
  );
  static const serverFailure =
      Failure(message: "Supabase Failure", failureCode: "SUPABASE_FAILURE");
  static const genericFailure =
      Failure(message: "Generic Failure", failureCode: "GENERIC_FAILURE");
  static const authFailure =
      Failure(message: "Authentication Failure", failureCode: "AUTH_FAILURE");
  static const dbFailure =
      Failure(message: "Database Failure", failureCode: "DATABASE_FAILURE");

  static const lookedThemselvesUpFailure = Failure(
    message: lookedThemselvesUpMsg,
    failureCode: "LOOKED_THEMSELVES_UP",
  );
  static const groupCreationFailure = Failure(
    message: groupCreationFailureMsg,
    failureCode: "GROUP_CREATION_FAILURE",
  );

  static const cancelledPurchaseFailure = Failure(
    message: cancelledPurchaseFailureMsg,
    failureCode: "CANCELLED_PURCHASE",
  );
}
