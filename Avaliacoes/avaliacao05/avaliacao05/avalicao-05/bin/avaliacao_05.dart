import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void main() async {
  String username = 'pamela.layla.freitas07@aluno.ifce.edu.br';
  String password = 'obfr kmfr husk fooj';

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'Pamela Layla ')
    ..recipients.add('taveira@ifce.edu.br')
    ..subject = 'avaliacao-05'
    ..text = 'Realizando avaliacao'
    ..html = "<h1>Corpo do e-mail em HTML</h1>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Mensagem enviada: ' + sendReport.toString());
  } catch (e) {
    print('Erro ao enviar mensagem: $e');
  }
}