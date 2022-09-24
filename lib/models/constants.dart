abstract class Constants {
  static const baseUrl = "https://spacepay-b6a8c-default-rtdb.firebaseio.com";
  static const webApiKey = "AIzaSyByV3D72eMpkPN8oKa2XyIQoCXdFeiWvFM";
  static const signUpUrl =
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${Constants.webApiKey}";
  static const signInUrl =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${Constants.webApiKey}";
  static const urlExistingCards =
      "https://spacepay-b6a8c-default-rtdb.firebaseio.com/existingCards.json";
  static const urlCreatedCards =
      "https://spacepay-b6a8c-default-rtdb.firebaseio.com/createdCards.json";

  static const clientsUrl = "$baseUrl/clients.json";
  static const adminsUrl = "$baseUrl/admins.json";
}
