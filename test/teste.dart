void main() {
  String cpf = '549.305.358-67';
  final newCpf = cpf.replaceAll(RegExp('[.-]'), '');
  print(newCpf);
}
