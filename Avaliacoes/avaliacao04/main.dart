import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() {
  final db = sqlite3.open('alunos.db');
  
  db.execute('''
    CREATE TABLE IF NOT EXISTS TB_ALUNO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL CHECK(LENGTH(nome) <= 50)
    );
  ''');

  print('=== Sistema de Cadastro de Alunos ===');

  while (true) {
    print('\nMenu:');
    print('1 - Cadastrar aluno');
    print('2 - Listar alunos');
    print('3 - Sair');
    stdout.write('Opção: ');
    
    final opcao = stdin.readLineSync()?.trim();

    switch (opcao) {
      case '1':
        stdout.write('Nome do aluno: ');
        final nome = stdin.readLineSync()?.trim();
        if (nome != null && nome.isNotEmpty) {
          db.execute('INSERT INTO TB_ALUNO (nome) VALUES (?)', [nome]);
          print('Aluno cadastrado!');
        } else {
          print('Nome inválido!');
        }
        break;
      case '2':
        final alunos = db.select('SELECT * FROM TB_ALUNO');
        if (alunos.isEmpty) {
          print('Nenhum aluno cadastrado.');
        } else {
          print('\nLista de Alunos:');
          for (var aluno in alunos) {
            print('${aluno['id']}: ${aluno['nome']}');
          }
        }
        break;
      case '3':
        db.dispose();
        print('Saindo...');
        exit(0);
      default:
        print('Opção inválida!');
    }
  }
}
