import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

/// Service class encapsulating Firebase Authentication operations.
class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();
  factory AuthService() => instance;

  FirebaseAuth? get _auth {
    if (Firebase.apps.isEmpty) {
      return null;
    }
    return FirebaseAuth.instance;
  }

  /// Current user stream, safely handling cases where Firebase is not initialized.
  Stream<User?> get authStateChanges {
    final auth = _auth;
    if (auth == null) {
      return Stream.value(null);
    }
    return auth.authStateChanges();
  }

  /// Get currently signed-in user.
  User? get currentUser => _auth?.currentUser;

  /// Whether Firebase has been properly initialized in the app.
  bool get isFirebaseInitialized => Firebase.apps.isNotEmpty;

  /// Sign in with email or username and password.
  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final auth = _auth;
    if (auth == null) {
      throw FirebaseAuthException(
        code: 'app-not-initialized',
        message: 'Firebase is not initialized. Please run flutterfire configure.',
      );
    }

    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown-error',
        message: e.toString(),
      );
    }
  }

  /// Register a new user with email, password, and optional display name.
  Future<UserCredential> registerWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final auth = _auth;
    if (auth == null) {
      throw FirebaseAuthException(
        code: 'app-not-initialized',
        message: 'Firebase is not initialized. Please run flutterfire configure.',
      );
    }

    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (displayName != null && displayName.trim().isNotEmpty) {
        await userCredential.user?.updateDisplayName(displayName.trim());
        await userCredential.user?.reload();
      }

      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown-error',
        message: e.toString(),
      );
    }
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    final auth = _auth;
    if (auth != null) {
      await auth.signOut();
    }
  }

  /// Convert Firebase error codes into clean, user-friendly messages.
  static String getReadableErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No account found with this credential. Please sign up.';
        case 'wrong-password':
          return 'Incorrect password. Please verify and try again.';
        case 'invalid-credential':
          return 'Invalid credentials. Please check your username/email and password.';
        case 'email-already-in-use':
          return 'This username/email is already registered. Try logging in.';
        case 'invalid-email':
          return 'The email format is invalid.';
        case 'weak-password':
          return 'Password is too weak. Please use at least 6 characters.';
        case 'user-disabled':
          return 'This account has been disabled. Please contact support.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again after a few minutes.';
        case 'operation-not-allowed':
          return 'Email/Password sign-in is not enabled in Firebase Console.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        case 'app-not-initialized':
          return error.message ?? 'Firebase is not initialized.';
        default:
          return error.message ?? 'Authentication error occurred (${error.code}).';
      }
    }
    return error?.toString() ?? 'An unexpected error occurred. Please try again.';
  }
}
