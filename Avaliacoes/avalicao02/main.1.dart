import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }

  String get nome => _nome;

  Map<String, dynamic> toJson() => {
    'nome': _nome,
  };
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }

  String get nome => _nome;
  List<Dependente> get dependentes => _dependentes;

  Map<String, dynamic> toJson() => {
    'nome': _nome,
    'dependentes': _dependentes.map((d) => d.toJson()).toList(),
  };
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }

  Map<String, dynamic> toJson() => {
    'nomeProjeto': _nomeProjeto,
    'funcionarios': _funcionarios.map((f) => f.toJson()).toList(),
  };
}

void main() {
  // 1. Criar vários objetos Dependentes
  final dep1 = Dependente('Patricia');
  final dep2 = Dependente('Sergio');
  final dep3 = Dependente('Anderson');
  final dep4 = Dependente('Francisco Klayton');

  // 2. Criar vários objetos Funcionario
  final func1 = Funcionario('Pamela Layla', [dep1, dep2]);
  final func2 = Funcionario('Lucas Guedes', [dep3, dep4]);

  // 4. Criar uma lista de Funcionarios
  final funcionarios = [func1, func2];

  // 5. Criar um objeto Equipe Projeto
  final equipe = EquipeProjeto('Sistema de Vendas', funcionarios);

  // 6. Printar no formato JSON o objeto Equipe Projeto.
  print(jsonEncode(equipe.toJson()));
}