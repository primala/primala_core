/// authentication_module.dart
///
/// Author: Sonny Vesali
///  Proofreading Information:
///   - Proofreader: Sonny Vesali
///   - Date: July 23rd 2023
///
/// This file defines the [AuthenticationModule], which is a module within the
/// modular architecture of the Primala Flutter app. The module follows a
/// Domain-Driven Design (DDD) approach to organize its components into
/// different layers.
///
/// Module Overview:
/// - [AuthenticationModule]: A module responsible for handling
///   authentication-related functionality, including data sources, domain
///   logic, and presentation views.
///
/// DDD Approach:
/// The [AuthenticationModule] follows a Domain-Driven Design approach,
/// dividing its components into the following layers:
///
/// 1. DATA Layer:
///    - Sources: [AuthenticationRemoteSourceImpl] is the data source
///      responsible for fetching data from the Supabase backend and performing
///      authentication via the external providers Google & Apple.
///    - Models: Althought not directly injected, The Models are returned from
///              the [AuthenticationContractImpl] functions
///    - Contract Implementation: [AuthenticationContractImpl] implements the
///       contract interface for the authentication domain layer. It's the
///       brain of our Data Layer, the implementation determines whether an
///       Internet Connection Error or Some Other Error or Entity is
///       returned.
///
/// 2. DOMAIN Layer:
///    - Contract Interfaces: [AuthenticationContract] defines the contract
///      signature for the authentication domain layer. Each Function defined
///      here will have it's own Logic Function in the Domain Layer.
///    - Logic: [AddNameToDatabase], [GetAuthState], [SignInWithApple], and
///             [SignInWithGoogle] are domain logic classes that handle specific
///             authentication operations.
///
/// 3. PRESENTATION Layer:
///    - MobX Getter Stores: [AddNameToDatabaseGetterStore],
///                          [GetAuthStateStore], and
///                          [GetAuthProviderStateStore] are MobX getter stores
///                          responsible for interacting with our Logic
///                          functions for our Mother Stores.
///    - MobX Mother Stores: [AddNameToDatabaseStore], [AuthProviderStore], and
///                          [AuthStateStore] are MobX mother stores responsible
///                          for coordinating data and actions between different
///                          getter stores and UI components.
///    - Views: The [NewLoginScreen] is the main presentation view of the
///             authentication module. It displays the authentication UI and
///             interacts with the MobX mother stores for handling user actions
///             and state changes.
///
/// Additional Imports:
/// - Third-Party: The module imports the `supabase_flutter` and `flutter_modular` packages
///                to utilize Supabase client and modular-based routing and dependency injection.
/// - Core: The module imports the `network_info.dart` file to use the [NetworkInfoImpl]
///         for Internet Connection checks.
/// - Guard: The module imports the [AuthGuard] class to manage authentication
///          routing for authenticated or unauthenticated users.

import 'package:primala/app/modules/authentication/data/sources/auth_remote_source.dart';
import 'package:primala/app/modules/authentication/data/contracts/authentication_contract_impl.dart';
import 'package:primala/app/modules/authentication/domain/contracts/authentication_contract.dart';
import 'package:primala/app/modules/home/domain/logic/add_name_to_database.dart';
import 'package:primala/app/modules/authentication/domain/logic/get_auth_state.dart';
import 'package:primala/app/modules/authentication/domain/logic/sign_in_with_apple.dart';
import 'package:primala/app/modules/authentication/domain/logic/sign_in_with_google.dart';
import 'package:primala/app/modules/home/presentation/mobx/getter/add_name_to_database_getter_store.dart';
import 'package:primala/app/modules/authentication/presentation/mobx/getters/get_auth_provider_getter_store.dart';
import 'package:primala/app/modules/authentication/presentation/mobx/getters/get_auth_state_getter_store.dart';
import 'package:primala/app/modules/home/presentation/mobx/main/add_name_to_database_store.dart';
import 'package:primala/app/modules/authentication/presentation/mobx/main/auth_provider_store.dart';
import 'package:primala/app/modules/authentication/presentation/mobx/main/auth_state_store.dart';
import 'package:primala/app/modules/authentication/presentation/screens/new_login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:primala/app/core/network/network_info.dart';
import 'package:primala/app/core/guards/auth_guard.dart';

class AuthenticationModule extends Module {
  @override
  List<Bind> get binds => [
        // & Data Source
        Bind.singleton<AuthenticationRemoteSourceImpl>(
          (i) => AuthenticationRemoteSourceImpl(
            supabase: Modular.get<SupabaseClient>(),
          ),
        ),
        // & Contract Implementation
        Bind.singleton<AuthenticationContractImpl>(
          (i) => AuthenticationContractImpl(
            remoteSource: i<AuthenticationRemoteSourceImpl>(),
            networkInfo: Modular.get<NetworkInfoImpl>(),
          ),
        ),
        // & Logic
        Bind.singleton<GetAuthState>(
            (i) => GetAuthState(contract: i<AuthenticationContract>())),
        Bind.singleton<SignInWithApple>(
            (i) => SignInWithApple(contract: i<AuthenticationContract>())),
        Bind.singleton<SignInWithGoogle>(
            (i) => SignInWithGoogle(contract: i<AuthenticationContract>())),
        // & MobX Getter Stores
        Bind.singleton<GetAuthStateGetterStore>(
            (i) => GetAuthStateGetterStore(i<GetAuthState>())),
        Bind.singleton<GetAuthProviderStateGetterStore>(
          (i) => GetAuthProviderStateGetterStore(
            apple: i<SignInWithApple>(),
            google: i<SignInWithGoogle>(),
          ),
        ),
        // & Mobx Mother Stores
        Bind.singleton<AuthProviderStore>(
          (i) => AuthProviderStore(
            authProviderGetterStore: i<GetAuthProviderStateGetterStore>(),
          ),
        ),
        Bind.singleton<AuthStateStore>(
          (i) => AuthStateStore(
            authStateGetterStore: i<GetAuthStateGetterStore>(),
          ),
        ),
      ];

  @override
  List<ChildRoute> get routes => [
        ChildRoute(
          "/",
          child: (context, args) => NewLoginScreen(
            authStateStore: Modular.get<AuthStateStore>(),
            // addNameToDatabaseStore: Modular.get<AddNameToDatabaseStore>(),
            authProviderStore: Modular.get<AuthProviderStore>(),
            supabase: Modular.get<SupabaseClient>(),
          ),
          guards: [
            AuthGuard(
              supabase: Modular.get<SupabaseClient>(),
            ),
          ],
        )
      ];
}
