// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

mixin HomeConstants {
  static const needsToUpdateGrad = [
    Color(0xFF52F3F3),
    Color(0xFF52F3A5),
    Color(0xFF5262F3),
    Color(0xFF52D6F3),
  ];

  static const QUICK_ACTIONS_ROUTE = 'quickActionsRoute';

  static const module = '/home';
  static const relativeRouter = "/router";
  static const relativeHome = "/home_screen";
  static const relativeQuickActionsRouter = "/quick_actions_router";
  static const relativeNeedsToUpdate = "/needs_to_update";
  static const relativeSessionStarter = "/session_starter";
  static const relativeEntry = "/entry";

  static const router = "$module$relativeRouter";
  static const quickActionsRouter = "$module$relativeQuickActionsRouter";
  static const entry = "$module$relativeEntry";
  static const sessionStarter = "$module$relativeSessionStarter";
  static const home = "$module$relativeHome";
  static const needsToUpdate = "$module$relativeNeedsToUpdate";

  static const RESUME_ON_SHORE_PARAMS = "resumeOnShoreParams";
}
