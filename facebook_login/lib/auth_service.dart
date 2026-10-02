import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

/// Service class encapsulating Firebase Authentication operations.
class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();
  factory AuthService() => instance;

  /// Temporary storage for multi-step signup flow.
  String? pendingEmail;
  String? pendingPassword;
  String? pendingDisplayName;

  void clearPendingSignup() {
    pendingEmail = null;
    pendingPassword = null;
    pendingDisplayName = null;
  }

  FirebaseAuth? get _auth {
    if (Firebase.apps.isEmpty) return null;
    return FirebaseAuth.instance;
  }

  Stream<User?> get authStateChanges {
    final auth = _auth;
    if (auth == null) return Stream.value(null);
    return auth.authStateChanges();
  }

  User? get currentUser => _auth?.currentUser;
  bool get isFirebaseInitialized => Firebase.apps.isNotEmpty;

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
      return await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(code: 'unknown-error', message: e.toString());
    }
  }

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
      final credential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (displayName != null && displayName.trim().isNotEmpty) {
        await credential.user?.updateDisplayName(displayName.trim());
        await credential.user?.reload();
      }
      return credential;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(code: 'unknown-error', message: e.toString());
    }
  }

  Future<void> signOut() async {
    await _auth?.signOut();
  }

  static String getReadableErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No account found with this email. Please create an account.';
        case 'wrong-password':
          return 'Incorrect password. Please verify and try again.';
        case 'invalid-credential':
          return 'Invalid credentials. Please check your email and password.';
        case 'email-already-in-use':
          return 'This email is already registered. Try logging in.';
        case 'invalid-email':
          return 'The email address is invalid.';
        case 'weak-password':
          return 'Password is too weak. Use at least 6 characters.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        case 'operation-not-allowed':
          return 'Email/Password sign-in is not enabled in Firebase Console.';
        case 'network-request-failed':
          return 'Network error. Check your internet connection.';
        case 'app-not-initialized':
          return error.message ?? 'Firebase is not initialized.';
        default:
          return error.message ?? 'Authentication error (${error.code}).';
      }
    }
    return error?.toString() ?? 'An unexpected error occurred.';
  }
}
