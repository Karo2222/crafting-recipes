class InputFields {
  final String accountName;
  final String email;
  final String hostCode;

  InputFields({
    required this.accountName,
    required this.email,
    required this.hostCode,
  });

  @override
  String toString() {
    return "ACCOUNT_NAME: $accountName, EMAIL: $email, HOST_CODE: $hostCode";
  }
}
