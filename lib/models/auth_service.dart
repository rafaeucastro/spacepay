import 'package:spacepay/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spacepay/providers/users.dart';

class AuthFirebaseService {
  static Client? _currentClient;
  static Admin? _currentADM;

  // static final _clientStream = Stream<Client?>.multi((controller) async {
  //   final authChanges = FirebaseAuth.instance.authStateChanges();

  //   await for (final user in authChanges) {
  //     _currentClient = user == null ? null : _toClient(user);
  //     controller.add(_currentClient);
  //   }
  // });

  // Stream<Client?> get clientChanges => _clientStream;

  Client? get currentClient => _currentClient;
  Admin? get currentADM => _currentADM;

  Future<UserCredential> signIn(String cpf, String password, bool isADM) async {
    String email = '';

    if (isADM) {
      final adm = await Users.getAdmFromDB(cpf);
      email = adm.email;
      _currentADM = adm;
    } else {
      final client = await Users.getClientFromDB(cpf);
      email = client.email;
      _currentClient = client;
    }

    final userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    return userCredential;
  }

  Future<String> signUp(String name, String email, String password) async {
    final signUp = await Firebase.initializeApp(
      name: 'signUp',
      options: Firebase.app().options,
    );

    final auth = FirebaseAuth.instanceFor(app: signUp);

    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user == null) {
      await signUp.delete();
      return '';
    }

    //atualiza os atributos do usuário
    await credential.user?.updateDisplayName(name);

    //fazer login
    await signIn(email, password, false);

    return credential.user!.uid;
  }

  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  // static Client _toClient(User user) {
  //   return Client(
  //     email: user.email!,
  //     accountType: accountType,
  //     phone: phone,
  //     cpf: cpf,
  //     fullName: user.displayName!,
  //     address: address,
  //     password: password,
  //     databaseID: databaseID,
  //   );
  // }
}
