import 'dart:convert';
import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';


// Defina seu e-mail aqui
const String gmailUsername = 'pamela.layla.freitas07@aluno.ifce.edu.br';
// Senha de app gerada pelo Google
const String gmailAppPassword = 'okwn yzrj fbyj dtif';

class Cliente {
  int codigo;
  String nome;
  int tipoCliente;

  Cliente({required this.codigo, required this.nome, required this.tipoCliente});

  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        'nome': nome,
        'tipoCliente': tipoCliente,
      };
}

class Vendedor {
  int codigo;
  String nome;
  double comissao;

  Vendedor({required this.codigo, required this.nome, required this.comissao});

  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        'nome': nome,
        'comissao': comissao,
      };
}

class Veiculo {
  int codigo;
  String descricao;
  double valor;

  Veiculo({required this.codigo, required this.descricao, required this.valor});

  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        'descricao': descricao,
        'valor': valor,
      };
}

class ItemPedido {
  int sequencial;
  String descricao;
  int quantidade;
  double valor;

  ItemPedido({
    required this.sequencial,
    required this.descricao,
    required this.quantidade,
    required this.valor,
  });

  Map<String, dynamic> toJson() => {
        'sequencial': sequencial,
        'descricao': descricao,
        'quantidade': quantidade,
        'valor': valor,
      };
}

class PedidoVenda {
  String codigo;
  DateTime data;
  double valorPedido;
  Cliente cliente;
  Vendedor vendedor;
  Veiculo veiculo;
  List<ItemPedido> items;

  PedidoVenda({
    required this.codigo,
    required this.data,
    required this.valorPedido,
    required this.cliente,
    required this.vendedor,
    required this.veiculo,
    required this.items,
  });

  double calcularPedido() {
    valorPedido =
        items.fold(0.0, (total, item) => total + (item.valor * item.quantidade));
    return valorPedido;
  }

  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        'data': data.toIso8601String(),
        'valorPedido': calcularPedido(),
        'cliente': cliente.toJson(),
        'vendedor': vendedor.toJson(),
        'veiculo': veiculo.toJson(),
        'items': items.map((item) => item.toJson()).toList(),
      };
}

void main() async {
  // Dados de exemplo
  var cliente = Cliente(codigo: 1, nome: 'Pedro', tipoCliente: 0);
  var vendedor = Vendedor(codigo: 1, nome: 'Klayrton', comissao: 5.6);
  var veiculo = Veiculo(codigo: 101, descricao: 'Carro Fiat Uno', valor: 14000.00);
  var itens = [
    ItemPedido(sequencial: 1, descricao: 'Pneu', quantidade: 1, valor: 500.0),
    ItemPedido(sequencial: 2, descricao: 'Farol de Milha', quantidade: 1, valor: 800.0),
  ];

  var pedido = PedidoVenda(
    codigo: 'PDV001',
    data: DateTime.now(),
    valorPedido: 0.0,
    cliente: cliente,
    vendedor: vendedor,
    veiculo: veiculo,
    items: itens,
  );

  var encoder = JsonEncoder.withIndent('  ');
  var jsonFormatado = encoder.convert(pedido.toJson());

  final arquivoJson = File('pedido_venda.json');
  await arquivoJson.writeAsString(jsonFormatado);
  print('\n📁 Arquivo JSON salvo como "pedido_venda.json".');

  stdout.write('Digite o e-mail do destinatário: ');
  String destinatario = stdin.readLineSync()?.trim() ?? '';

  stdout.write('Digite o assunto: ');
  String assunto = stdin.readLineSync()?.trim() ?? 'Pedido de Venda JSON';

  stdout.write('Digite a mensagem: ');
  String corpoMensagem = stdin.readLineSync()?.trim() ?? 'Segue o pedido em anexo.';

  if (destinatario.isEmpty) {
    print('❌ E-mail do destinatário não informado.');
    return;
  }

  if (!await arquivoJson.exists()) {
    print('❌ Arquivo JSON não encontrado.');
    return;
  }

  final smtpServer = gmail(gmailUsername, gmailAppPassword);

  final message = Message()
    ..from = Address(gmailUsername, 'Pedido de Venda IFCE')
    ..recipients.add(destinatario)
    ..subject = assunto
    ..text = corpoMensagem
    ..attachments = [FileAttachment(arquivoJson)];

  try {
    final sendReport = await send(message, smtpServer);
    print('\n E-mail enviado com sucesso!');
    print('📬 Destinatário: $destinatario');
    print('📝 Assunto: $assunto');
  } catch (e) {
    print('\n Erro ao enviar o e-mail: $e');
  }
}
