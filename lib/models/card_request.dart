class CardRequest {
  String cardType;
  String name;
  String id;
  String userID;
  String validity;
  String status;
  String? refusalReason;

  CardRequest(
      {required this.id,
      required this.userID,
      required this.cardType,
      required this.name,
      required this.validity,
      required this.status,
      this.refusalReason});
}
