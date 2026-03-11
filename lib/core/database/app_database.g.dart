// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ClientesTable extends Clientes with TableInfo<$ClientesTable, Cliente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _telefoneMeta =
      const VerificationMeta('telefone');
  @override
  late final GeneratedColumn<String> telefone = GeneratedColumn<String>(
      'telefone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _documentoMeta =
      const VerificationMeta('documento');
  @override
  late final GeneratedColumn<String> documento = GeneratedColumn<String>(
      'documento', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _enderecoDefaultJsonMeta =
      const VerificationMeta('enderecoDefaultJson');
  @override
  late final GeneratedColumn<String> enderecoDefaultJson =
      GeneratedColumn<String>('endereco_default_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _criadoEmMeta =
      const VerificationMeta('criadoEm');
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
      'criado_em', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _atualizadoEmMeta =
      const VerificationMeta('atualizadoEm');
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
      'atualizado_em', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sincronizadoEmMeta =
      const VerificationMeta('sincronizadoEm');
  @override
  late final GeneratedColumn<DateTime> sincronizadoEm =
      GeneratedColumn<DateTime>('sincronizado_em', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nome,
        telefone,
        documento,
        enderecoDefaultJson,
        criadoEm,
        atualizadoEm,
        sincronizadoEm
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clientes';
  @override
  VerificationContext validateIntegrity(Insertable<Cliente> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('telefone')) {
      context.handle(_telefoneMeta,
          telefone.isAcceptableOrUnknown(data['telefone']!, _telefoneMeta));
    } else if (isInserting) {
      context.missing(_telefoneMeta);
    }
    if (data.containsKey('documento')) {
      context.handle(_documentoMeta,
          documento.isAcceptableOrUnknown(data['documento']!, _documentoMeta));
    }
    if (data.containsKey('endereco_default_json')) {
      context.handle(
          _enderecoDefaultJsonMeta,
          enderecoDefaultJson.isAcceptableOrUnknown(
              data['endereco_default_json']!, _enderecoDefaultJsonMeta));
    }
    if (data.containsKey('criado_em')) {
      context.handle(_criadoEmMeta,
          criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta));
    } else if (isInserting) {
      context.missing(_criadoEmMeta);
    }
    if (data.containsKey('atualizado_em')) {
      context.handle(
          _atualizadoEmMeta,
          atualizadoEm.isAcceptableOrUnknown(
              data['atualizado_em']!, _atualizadoEmMeta));
    } else if (isInserting) {
      context.missing(_atualizadoEmMeta);
    }
    if (data.containsKey('sincronizado_em')) {
      context.handle(
          _sincronizadoEmMeta,
          sincronizadoEm.isAcceptableOrUnknown(
              data['sincronizado_em']!, _sincronizadoEmMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cliente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cliente(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      telefone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telefone'])!,
      documento: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}documento']),
      enderecoDefaultJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}endereco_default_json']),
      criadoEm: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}criado_em'])!,
      atualizadoEm: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}atualizado_em'])!,
      sincronizadoEm: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}sincronizado_em']),
    );
  }

  @override
  $ClientesTable createAlias(String alias) {
    return $ClientesTable(attachedDatabase, alias);
  }
}

class Cliente extends DataClass implements Insertable<Cliente> {
  final String id;
  final String nome;
  final String telefone;
  final String? documento;
  final String? enderecoDefaultJson;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
  final DateTime? sincronizadoEm;
  const Cliente(
      {required this.id,
      required this.nome,
      required this.telefone,
      this.documento,
      this.enderecoDefaultJson,
      required this.criadoEm,
      required this.atualizadoEm,
      this.sincronizadoEm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nome'] = Variable<String>(nome);
    map['telefone'] = Variable<String>(telefone);
    if (!nullToAbsent || documento != null) {
      map['documento'] = Variable<String>(documento);
    }
    if (!nullToAbsent || enderecoDefaultJson != null) {
      map['endereco_default_json'] = Variable<String>(enderecoDefaultJson);
    }
    map['criado_em'] = Variable<DateTime>(criadoEm);
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    if (!nullToAbsent || sincronizadoEm != null) {
      map['sincronizado_em'] = Variable<DateTime>(sincronizadoEm);
    }
    return map;
  }

  ClientesCompanion toCompanion(bool nullToAbsent) {
    return ClientesCompanion(
      id: Value(id),
      nome: Value(nome),
      telefone: Value(telefone),
      documento: documento == null && nullToAbsent
          ? const Value.absent()
          : Value(documento),
      enderecoDefaultJson: enderecoDefaultJson == null && nullToAbsent
          ? const Value.absent()
          : Value(enderecoDefaultJson),
      criadoEm: Value(criadoEm),
      atualizadoEm: Value(atualizadoEm),
      sincronizadoEm: sincronizadoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(sincronizadoEm),
    );
  }

  factory Cliente.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cliente(
      id: serializer.fromJson<String>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      telefone: serializer.fromJson<String>(json['telefone']),
      documento: serializer.fromJson<String?>(json['documento']),
      enderecoDefaultJson:
          serializer.fromJson<String?>(json['enderecoDefaultJson']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
      sincronizadoEm: serializer.fromJson<DateTime?>(json['sincronizadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nome': serializer.toJson<String>(nome),
      'telefone': serializer.toJson<String>(telefone),
      'documento': serializer.toJson<String?>(documento),
      'enderecoDefaultJson': serializer.toJson<String?>(enderecoDefaultJson),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
      'sincronizadoEm': serializer.toJson<DateTime?>(sincronizadoEm),
    };
  }

  Cliente copyWith(
          {String? id,
          String? nome,
          String? telefone,
          Value<String?> documento = const Value.absent(),
          Value<String?> enderecoDefaultJson = const Value.absent(),
          DateTime? criadoEm,
          DateTime? atualizadoEm,
          Value<DateTime?> sincronizadoEm = const Value.absent()}) =>
      Cliente(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        telefone: telefone ?? this.telefone,
        documento: documento.present ? documento.value : this.documento,
        enderecoDefaultJson: enderecoDefaultJson.present
            ? enderecoDefaultJson.value
            : this.enderecoDefaultJson,
        criadoEm: criadoEm ?? this.criadoEm,
        atualizadoEm: atualizadoEm ?? this.atualizadoEm,
        sincronizadoEm:
            sincronizadoEm.present ? sincronizadoEm.value : this.sincronizadoEm,
      );
  Cliente copyWithCompanion(ClientesCompanion data) {
    return Cliente(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      telefone: data.telefone.present ? data.telefone.value : this.telefone,
      documento: data.documento.present ? data.documento.value : this.documento,
      enderecoDefaultJson: data.enderecoDefaultJson.present
          ? data.enderecoDefaultJson.value
          : this.enderecoDefaultJson,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
      sincronizadoEm: data.sincronizadoEm.present
          ? data.sincronizadoEm.value
          : this.sincronizadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cliente(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('telefone: $telefone, ')
          ..write('documento: $documento, ')
          ..write('enderecoDefaultJson: $enderecoDefaultJson, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('sincronizadoEm: $sincronizadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, telefone, documento,
      enderecoDefaultJson, criadoEm, atualizadoEm, sincronizadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cliente &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.telefone == this.telefone &&
          other.documento == this.documento &&
          other.enderecoDefaultJson == this.enderecoDefaultJson &&
          other.criadoEm == this.criadoEm &&
          other.atualizadoEm == this.atualizadoEm &&
          other.sincronizadoEm == this.sincronizadoEm);
}

class ClientesCompanion extends UpdateCompanion<Cliente> {
  final Value<String> id;
  final Value<String> nome;
  final Value<String> telefone;
  final Value<String?> documento;
  final Value<String?> enderecoDefaultJson;
  final Value<DateTime> criadoEm;
  final Value<DateTime> atualizadoEm;
  final Value<DateTime?> sincronizadoEm;
  final Value<int> rowid;
  const ClientesCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.telefone = const Value.absent(),
    this.documento = const Value.absent(),
    this.enderecoDefaultJson = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
    this.sincronizadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientesCompanion.insert({
    required String id,
    required String nome,
    required String telefone,
    this.documento = const Value.absent(),
    this.enderecoDefaultJson = const Value.absent(),
    required DateTime criadoEm,
    required DateTime atualizadoEm,
    this.sincronizadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nome = Value(nome),
        telefone = Value(telefone),
        criadoEm = Value(criadoEm),
        atualizadoEm = Value(atualizadoEm);
  static Insertable<Cliente> custom({
    Expression<String>? id,
    Expression<String>? nome,
    Expression<String>? telefone,
    Expression<String>? documento,
    Expression<String>? enderecoDefaultJson,
    Expression<DateTime>? criadoEm,
    Expression<DateTime>? atualizadoEm,
    Expression<DateTime>? sincronizadoEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (telefone != null) 'telefone': telefone,
      if (documento != null) 'documento': documento,
      if (enderecoDefaultJson != null)
        'endereco_default_json': enderecoDefaultJson,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
      if (sincronizadoEm != null) 'sincronizado_em': sincronizadoEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClientesCompanion copyWith(
      {Value<String>? id,
      Value<String>? nome,
      Value<String>? telefone,
      Value<String?>? documento,
      Value<String?>? enderecoDefaultJson,
      Value<DateTime>? criadoEm,
      Value<DateTime>? atualizadoEm,
      Value<DateTime?>? sincronizadoEm,
      Value<int>? rowid}) {
    return ClientesCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      documento: documento ?? this.documento,
      enderecoDefaultJson: enderecoDefaultJson ?? this.enderecoDefaultJson,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      sincronizadoEm: sincronizadoEm ?? this.sincronizadoEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (telefone.present) {
      map['telefone'] = Variable<String>(telefone.value);
    }
    if (documento.present) {
      map['documento'] = Variable<String>(documento.value);
    }
    if (enderecoDefaultJson.present) {
      map['endereco_default_json'] =
          Variable<String>(enderecoDefaultJson.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    if (sincronizadoEm.present) {
      map['sincronizado_em'] = Variable<DateTime>(sincronizadoEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientesCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('telefone: $telefone, ')
          ..write('documento: $documento, ')
          ..write('enderecoDefaultJson: $enderecoDefaultJson, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('sincronizadoEm: $sincronizadoEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsuariosTable extends Usuarios with TableInfo<$UsuariosTable, Usuario> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsuariosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _telefoneMeta =
      const VerificationMeta('telefone');
  @override
  late final GeneratedColumn<String> telefone = GeneratedColumn<String>(
      'telefone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valorPorKmDefaultMeta =
      const VerificationMeta('valorPorKmDefault');
  @override
  late final GeneratedColumn<double> valorPorKmDefault =
      GeneratedColumn<double>('valor_por_km_default', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(5.0));
  static const VerificationMeta _criadoEmMeta =
      const VerificationMeta('criadoEm');
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
      'criado_em', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sincronizadoEmMeta =
      const VerificationMeta('sincronizadoEm');
  @override
  late final GeneratedColumn<DateTime> sincronizadoEm =
      GeneratedColumn<DateTime>('sincronizado_em', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nome,
        telefone,
        email,
        role,
        valorPorKmDefault,
        criadoEm,
        sincronizadoEm
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usuarios';
  @override
  VerificationContext validateIntegrity(Insertable<Usuario> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('telefone')) {
      context.handle(_telefoneMeta,
          telefone.isAcceptableOrUnknown(data['telefone']!, _telefoneMeta));
    } else if (isInserting) {
      context.missing(_telefoneMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('valor_por_km_default')) {
      context.handle(
          _valorPorKmDefaultMeta,
          valorPorKmDefault.isAcceptableOrUnknown(
              data['valor_por_km_default']!, _valorPorKmDefaultMeta));
    }
    if (data.containsKey('criado_em')) {
      context.handle(_criadoEmMeta,
          criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta));
    } else if (isInserting) {
      context.missing(_criadoEmMeta);
    }
    if (data.containsKey('sincronizado_em')) {
      context.handle(
          _sincronizadoEmMeta,
          sincronizadoEm.isAcceptableOrUnknown(
              data['sincronizado_em']!, _sincronizadoEmMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Usuario map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Usuario(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      telefone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telefone'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      valorPorKmDefault: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}valor_por_km_default'])!,
      criadoEm: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}criado_em'])!,
      sincronizadoEm: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}sincronizado_em']),
    );
  }

  @override
  $UsuariosTable createAlias(String alias) {
    return $UsuariosTable(attachedDatabase, alias);
  }
}

class Usuario extends DataClass implements Insertable<Usuario> {
  final String id;
  final String nome;
  final String telefone;
  final String email;
  final String role;
  final double valorPorKmDefault;
  final DateTime criadoEm;
  final DateTime? sincronizadoEm;
  const Usuario(
      {required this.id,
      required this.nome,
      required this.telefone,
      required this.email,
      required this.role,
      required this.valorPorKmDefault,
      required this.criadoEm,
      this.sincronizadoEm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nome'] = Variable<String>(nome);
    map['telefone'] = Variable<String>(telefone);
    map['email'] = Variable<String>(email);
    map['role'] = Variable<String>(role);
    map['valor_por_km_default'] = Variable<double>(valorPorKmDefault);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    if (!nullToAbsent || sincronizadoEm != null) {
      map['sincronizado_em'] = Variable<DateTime>(sincronizadoEm);
    }
    return map;
  }

  UsuariosCompanion toCompanion(bool nullToAbsent) {
    return UsuariosCompanion(
      id: Value(id),
      nome: Value(nome),
      telefone: Value(telefone),
      email: Value(email),
      role: Value(role),
      valorPorKmDefault: Value(valorPorKmDefault),
      criadoEm: Value(criadoEm),
      sincronizadoEm: sincronizadoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(sincronizadoEm),
    );
  }

  factory Usuario.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Usuario(
      id: serializer.fromJson<String>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      telefone: serializer.fromJson<String>(json['telefone']),
      email: serializer.fromJson<String>(json['email']),
      role: serializer.fromJson<String>(json['role']),
      valorPorKmDefault: serializer.fromJson<double>(json['valorPorKmDefault']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
      sincronizadoEm: serializer.fromJson<DateTime?>(json['sincronizadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nome': serializer.toJson<String>(nome),
      'telefone': serializer.toJson<String>(telefone),
      'email': serializer.toJson<String>(email),
      'role': serializer.toJson<String>(role),
      'valorPorKmDefault': serializer.toJson<double>(valorPorKmDefault),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
      'sincronizadoEm': serializer.toJson<DateTime?>(sincronizadoEm),
    };
  }

  Usuario copyWith(
          {String? id,
          String? nome,
          String? telefone,
          String? email,
          String? role,
          double? valorPorKmDefault,
          DateTime? criadoEm,
          Value<DateTime?> sincronizadoEm = const Value.absent()}) =>
      Usuario(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        telefone: telefone ?? this.telefone,
        email: email ?? this.email,
        role: role ?? this.role,
        valorPorKmDefault: valorPorKmDefault ?? this.valorPorKmDefault,
        criadoEm: criadoEm ?? this.criadoEm,
        sincronizadoEm:
            sincronizadoEm.present ? sincronizadoEm.value : this.sincronizadoEm,
      );
  Usuario copyWithCompanion(UsuariosCompanion data) {
    return Usuario(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      telefone: data.telefone.present ? data.telefone.value : this.telefone,
      email: data.email.present ? data.email.value : this.email,
      role: data.role.present ? data.role.value : this.role,
      valorPorKmDefault: data.valorPorKmDefault.present
          ? data.valorPorKmDefault.value
          : this.valorPorKmDefault,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
      sincronizadoEm: data.sincronizadoEm.present
          ? data.sincronizadoEm.value
          : this.sincronizadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Usuario(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('telefone: $telefone, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('valorPorKmDefault: $valorPorKmDefault, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('sincronizadoEm: $sincronizadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, telefone, email, role,
      valorPorKmDefault, criadoEm, sincronizadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Usuario &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.telefone == this.telefone &&
          other.email == this.email &&
          other.role == this.role &&
          other.valorPorKmDefault == this.valorPorKmDefault &&
          other.criadoEm == this.criadoEm &&
          other.sincronizadoEm == this.sincronizadoEm);
}

class UsuariosCompanion extends UpdateCompanion<Usuario> {
  final Value<String> id;
  final Value<String> nome;
  final Value<String> telefone;
  final Value<String> email;
  final Value<String> role;
  final Value<double> valorPorKmDefault;
  final Value<DateTime> criadoEm;
  final Value<DateTime?> sincronizadoEm;
  final Value<int> rowid;
  const UsuariosCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.telefone = const Value.absent(),
    this.email = const Value.absent(),
    this.role = const Value.absent(),
    this.valorPorKmDefault = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.sincronizadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsuariosCompanion.insert({
    required String id,
    required String nome,
    required String telefone,
    required String email,
    required String role,
    this.valorPorKmDefault = const Value.absent(),
    required DateTime criadoEm,
    this.sincronizadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nome = Value(nome),
        telefone = Value(telefone),
        email = Value(email),
        role = Value(role),
        criadoEm = Value(criadoEm);
  static Insertable<Usuario> custom({
    Expression<String>? id,
    Expression<String>? nome,
    Expression<String>? telefone,
    Expression<String>? email,
    Expression<String>? role,
    Expression<double>? valorPorKmDefault,
    Expression<DateTime>? criadoEm,
    Expression<DateTime>? sincronizadoEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (telefone != null) 'telefone': telefone,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
      if (valorPorKmDefault != null) 'valor_por_km_default': valorPorKmDefault,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (sincronizadoEm != null) 'sincronizado_em': sincronizadoEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsuariosCompanion copyWith(
      {Value<String>? id,
      Value<String>? nome,
      Value<String>? telefone,
      Value<String>? email,
      Value<String>? role,
      Value<double>? valorPorKmDefault,
      Value<DateTime>? criadoEm,
      Value<DateTime?>? sincronizadoEm,
      Value<int>? rowid}) {
    return UsuariosCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      role: role ?? this.role,
      valorPorKmDefault: valorPorKmDefault ?? this.valorPorKmDefault,
      criadoEm: criadoEm ?? this.criadoEm,
      sincronizadoEm: sincronizadoEm ?? this.sincronizadoEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (telefone.present) {
      map['telefone'] = Variable<String>(telefone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (valorPorKmDefault.present) {
      map['valor_por_km_default'] = Variable<double>(valorPorKmDefault.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (sincronizadoEm.present) {
      map['sincronizado_em'] = Variable<DateTime>(sincronizadoEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsuariosCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('telefone: $telefone, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('valorPorKmDefault: $valorPorKmDefault, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('sincronizadoEm: $sincronizadoEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BasesTable extends Bases with TableInfo<$BasesTable, Base> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localJsonMeta =
      const VerificationMeta('localJson');
  @override
  late final GeneratedColumn<String> localJson = GeneratedColumn<String>(
      'local_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isPrincipalMeta =
      const VerificationMeta('isPrincipal');
  @override
  late final GeneratedColumn<bool> isPrincipal = GeneratedColumn<bool>(
      'is_principal', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_principal" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _criadoEmMeta =
      const VerificationMeta('criadoEm');
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
      'criado_em', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sincronizadoEmMeta =
      const VerificationMeta('sincronizadoEm');
  @override
  late final GeneratedColumn<DateTime> sincronizadoEm =
      GeneratedColumn<DateTime>('sincronizado_em', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, nome, localJson, isPrincipal, criadoEm, sincronizadoEm];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bases';
  @override
  VerificationContext validateIntegrity(Insertable<Base> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('local_json')) {
      context.handle(_localJsonMeta,
          localJson.isAcceptableOrUnknown(data['local_json']!, _localJsonMeta));
    } else if (isInserting) {
      context.missing(_localJsonMeta);
    }
    if (data.containsKey('is_principal')) {
      context.handle(
          _isPrincipalMeta,
          isPrincipal.isAcceptableOrUnknown(
              data['is_principal']!, _isPrincipalMeta));
    }
    if (data.containsKey('criado_em')) {
      context.handle(_criadoEmMeta,
          criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta));
    } else if (isInserting) {
      context.missing(_criadoEmMeta);
    }
    if (data.containsKey('sincronizado_em')) {
      context.handle(
          _sincronizadoEmMeta,
          sincronizadoEm.isAcceptableOrUnknown(
              data['sincronizado_em']!, _sincronizadoEmMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Base map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Base(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      localJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_json'])!,
      isPrincipal: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_principal'])!,
      criadoEm: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}criado_em'])!,
      sincronizadoEm: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}sincronizado_em']),
    );
  }

  @override
  $BasesTable createAlias(String alias) {
    return $BasesTable(attachedDatabase, alias);
  }
}

class Base extends DataClass implements Insertable<Base> {
  final String id;
  final String nome;
  final String localJson;
  final bool isPrincipal;
  final DateTime criadoEm;
  final DateTime? sincronizadoEm;
  const Base(
      {required this.id,
      required this.nome,
      required this.localJson,
      required this.isPrincipal,
      required this.criadoEm,
      this.sincronizadoEm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nome'] = Variable<String>(nome);
    map['local_json'] = Variable<String>(localJson);
    map['is_principal'] = Variable<bool>(isPrincipal);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    if (!nullToAbsent || sincronizadoEm != null) {
      map['sincronizado_em'] = Variable<DateTime>(sincronizadoEm);
    }
    return map;
  }

  BasesCompanion toCompanion(bool nullToAbsent) {
    return BasesCompanion(
      id: Value(id),
      nome: Value(nome),
      localJson: Value(localJson),
      isPrincipal: Value(isPrincipal),
      criadoEm: Value(criadoEm),
      sincronizadoEm: sincronizadoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(sincronizadoEm),
    );
  }

  factory Base.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Base(
      id: serializer.fromJson<String>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      localJson: serializer.fromJson<String>(json['localJson']),
      isPrincipal: serializer.fromJson<bool>(json['isPrincipal']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
      sincronizadoEm: serializer.fromJson<DateTime?>(json['sincronizadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nome': serializer.toJson<String>(nome),
      'localJson': serializer.toJson<String>(localJson),
      'isPrincipal': serializer.toJson<bool>(isPrincipal),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
      'sincronizadoEm': serializer.toJson<DateTime?>(sincronizadoEm),
    };
  }

  Base copyWith(
          {String? id,
          String? nome,
          String? localJson,
          bool? isPrincipal,
          DateTime? criadoEm,
          Value<DateTime?> sincronizadoEm = const Value.absent()}) =>
      Base(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        localJson: localJson ?? this.localJson,
        isPrincipal: isPrincipal ?? this.isPrincipal,
        criadoEm: criadoEm ?? this.criadoEm,
        sincronizadoEm:
            sincronizadoEm.present ? sincronizadoEm.value : this.sincronizadoEm,
      );
  Base copyWithCompanion(BasesCompanion data) {
    return Base(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      localJson: data.localJson.present ? data.localJson.value : this.localJson,
      isPrincipal:
          data.isPrincipal.present ? data.isPrincipal.value : this.isPrincipal,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
      sincronizadoEm: data.sincronizadoEm.present
          ? data.sincronizadoEm.value
          : this.sincronizadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Base(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('localJson: $localJson, ')
          ..write('isPrincipal: $isPrincipal, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('sincronizadoEm: $sincronizadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nome, localJson, isPrincipal, criadoEm, sincronizadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Base &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.localJson == this.localJson &&
          other.isPrincipal == this.isPrincipal &&
          other.criadoEm == this.criadoEm &&
          other.sincronizadoEm == this.sincronizadoEm);
}

class BasesCompanion extends UpdateCompanion<Base> {
  final Value<String> id;
  final Value<String> nome;
  final Value<String> localJson;
  final Value<bool> isPrincipal;
  final Value<DateTime> criadoEm;
  final Value<DateTime?> sincronizadoEm;
  final Value<int> rowid;
  const BasesCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.localJson = const Value.absent(),
    this.isPrincipal = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.sincronizadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BasesCompanion.insert({
    required String id,
    required String nome,
    required String localJson,
    this.isPrincipal = const Value.absent(),
    required DateTime criadoEm,
    this.sincronizadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nome = Value(nome),
        localJson = Value(localJson),
        criadoEm = Value(criadoEm);
  static Insertable<Base> custom({
    Expression<String>? id,
    Expression<String>? nome,
    Expression<String>? localJson,
    Expression<bool>? isPrincipal,
    Expression<DateTime>? criadoEm,
    Expression<DateTime>? sincronizadoEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (localJson != null) 'local_json': localJson,
      if (isPrincipal != null) 'is_principal': isPrincipal,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (sincronizadoEm != null) 'sincronizado_em': sincronizadoEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BasesCompanion copyWith(
      {Value<String>? id,
      Value<String>? nome,
      Value<String>? localJson,
      Value<bool>? isPrincipal,
      Value<DateTime>? criadoEm,
      Value<DateTime?>? sincronizadoEm,
      Value<int>? rowid}) {
    return BasesCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      localJson: localJson ?? this.localJson,
      isPrincipal: isPrincipal ?? this.isPrincipal,
      criadoEm: criadoEm ?? this.criadoEm,
      sincronizadoEm: sincronizadoEm ?? this.sincronizadoEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (localJson.present) {
      map['local_json'] = Variable<String>(localJson.value);
    }
    if (isPrincipal.present) {
      map['is_principal'] = Variable<bool>(isPrincipal.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (sincronizadoEm.present) {
      map['sincronizado_em'] = Variable<DateTime>(sincronizadoEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BasesCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('localJson: $localJson, ')
          ..write('isPrincipal: $isPrincipal, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('sincronizadoEm: $sincronizadoEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AtendimentosTable extends Atendimentos
    with TableInfo<$AtendimentosTable, Atendimento> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AtendimentosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _clienteIdMeta =
      const VerificationMeta('clienteId');
  @override
  late final GeneratedColumn<String> clienteId = GeneratedColumn<String>(
      'cliente_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES clientes (id)'));
  static const VerificationMeta _usuarioIdMeta =
      const VerificationMeta('usuarioId');
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
      'usuario_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES usuarios (id)'));
  static const VerificationMeta _pontoDeSaidaJsonMeta =
      const VerificationMeta('pontoDeSaidaJson');
  @override
  late final GeneratedColumn<String> pontoDeSaidaJson = GeneratedColumn<String>(
      'ponto_de_saida_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localDeColetaJsonMeta =
      const VerificationMeta('localDeColetaJson');
  @override
  late final GeneratedColumn<String> localDeColetaJson =
      GeneratedColumn<String>('local_de_coleta_json', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localDeEntregaJsonMeta =
      const VerificationMeta('localDeEntregaJson');
  @override
  late final GeneratedColumn<String> localDeEntregaJson =
      GeneratedColumn<String>('local_de_entrega_json', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localDeRetornoJsonMeta =
      const VerificationMeta('localDeRetornoJson');
  @override
  late final GeneratedColumn<String> localDeRetornoJson =
      GeneratedColumn<String>('local_de_retorno_json', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valorPorKmMeta =
      const VerificationMeta('valorPorKm');
  @override
  late final GeneratedColumn<double> valorPorKm = GeneratedColumn<double>(
      'valor_por_km', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _distanciaEstimadaKmMeta =
      const VerificationMeta('distanciaEstimadaKm');
  @override
  late final GeneratedColumn<double> distanciaEstimadaKm =
      GeneratedColumn<double>('distancia_estimada_km', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _distanciaRealKmMeta =
      const VerificationMeta('distanciaRealKm');
  @override
  late final GeneratedColumn<double> distanciaRealKm = GeneratedColumn<double>(
      'distancia_real_km', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _valorCobradoMeta =
      const VerificationMeta('valorCobrado');
  @override
  late final GeneratedColumn<double> valorCobrado = GeneratedColumn<double>(
      'valor_cobrado', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _tipoValorMeta =
      const VerificationMeta('tipoValor');
  @override
  late final GeneratedColumn<String> tipoValor = GeneratedColumn<String>(
      'tipo_valor', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _observacoesMeta =
      const VerificationMeta('observacoes');
  @override
  late final GeneratedColumn<String> observacoes = GeneratedColumn<String>(
      'observacoes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _criadoEmMeta =
      const VerificationMeta('criadoEm');
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
      'criado_em', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _atualizadoEmMeta =
      const VerificationMeta('atualizadoEm');
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
      'atualizado_em', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _iniciadoEmMeta =
      const VerificationMeta('iniciadoEm');
  @override
  late final GeneratedColumn<DateTime> iniciadoEm = GeneratedColumn<DateTime>(
      'iniciado_em', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _chegadaColetaEmMeta =
      const VerificationMeta('chegadaColetaEm');
  @override
  late final GeneratedColumn<DateTime> chegadaColetaEm =
      GeneratedColumn<DateTime>('chegada_coleta_em', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _chegadaEntregaEmMeta =
      const VerificationMeta('chegadaEntregaEm');
  @override
  late final GeneratedColumn<DateTime> chegadaEntregaEm =
      GeneratedColumn<DateTime>('chegada_entrega_em', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _inicioRetornoEmMeta =
      const VerificationMeta('inicioRetornoEm');
  @override
  late final GeneratedColumn<DateTime> inicioRetornoEm =
      GeneratedColumn<DateTime>('inicio_retorno_em', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _concluidoEmMeta =
      const VerificationMeta('concluidoEm');
  @override
  late final GeneratedColumn<DateTime> concluidoEm = GeneratedColumn<DateTime>(
      'concluido_em', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _sincronizadoEmMeta =
      const VerificationMeta('sincronizadoEm');
  @override
  late final GeneratedColumn<DateTime> sincronizadoEm =
      GeneratedColumn<DateTime>('sincronizado_em', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        clienteId,
        usuarioId,
        pontoDeSaidaJson,
        localDeColetaJson,
        localDeEntregaJson,
        localDeRetornoJson,
        valorPorKm,
        distanciaEstimadaKm,
        distanciaRealKm,
        valorCobrado,
        tipoValor,
        status,
        observacoes,
        criadoEm,
        atualizadoEm,
        iniciadoEm,
        chegadaColetaEm,
        chegadaEntregaEm,
        inicioRetornoEm,
        concluidoEm,
        sincronizadoEm
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'atendimentos';
  @override
  VerificationContext validateIntegrity(Insertable<Atendimento> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cliente_id')) {
      context.handle(_clienteIdMeta,
          clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta));
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(_usuarioIdMeta,
          usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta));
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('ponto_de_saida_json')) {
      context.handle(
          _pontoDeSaidaJsonMeta,
          pontoDeSaidaJson.isAcceptableOrUnknown(
              data['ponto_de_saida_json']!, _pontoDeSaidaJsonMeta));
    } else if (isInserting) {
      context.missing(_pontoDeSaidaJsonMeta);
    }
    if (data.containsKey('local_de_coleta_json')) {
      context.handle(
          _localDeColetaJsonMeta,
          localDeColetaJson.isAcceptableOrUnknown(
              data['local_de_coleta_json']!, _localDeColetaJsonMeta));
    } else if (isInserting) {
      context.missing(_localDeColetaJsonMeta);
    }
    if (data.containsKey('local_de_entrega_json')) {
      context.handle(
          _localDeEntregaJsonMeta,
          localDeEntregaJson.isAcceptableOrUnknown(
              data['local_de_entrega_json']!, _localDeEntregaJsonMeta));
    } else if (isInserting) {
      context.missing(_localDeEntregaJsonMeta);
    }
    if (data.containsKey('local_de_retorno_json')) {
      context.handle(
          _localDeRetornoJsonMeta,
          localDeRetornoJson.isAcceptableOrUnknown(
              data['local_de_retorno_json']!, _localDeRetornoJsonMeta));
    } else if (isInserting) {
      context.missing(_localDeRetornoJsonMeta);
    }
    if (data.containsKey('valor_por_km')) {
      context.handle(
          _valorPorKmMeta,
          valorPorKm.isAcceptableOrUnknown(
              data['valor_por_km']!, _valorPorKmMeta));
    } else if (isInserting) {
      context.missing(_valorPorKmMeta);
    }
    if (data.containsKey('distancia_estimada_km')) {
      context.handle(
          _distanciaEstimadaKmMeta,
          distanciaEstimadaKm.isAcceptableOrUnknown(
              data['distancia_estimada_km']!, _distanciaEstimadaKmMeta));
    } else if (isInserting) {
      context.missing(_distanciaEstimadaKmMeta);
    }
    if (data.containsKey('distancia_real_km')) {
      context.handle(
          _distanciaRealKmMeta,
          distanciaRealKm.isAcceptableOrUnknown(
              data['distancia_real_km']!, _distanciaRealKmMeta));
    }
    if (data.containsKey('valor_cobrado')) {
      context.handle(
          _valorCobradoMeta,
          valorCobrado.isAcceptableOrUnknown(
              data['valor_cobrado']!, _valorCobradoMeta));
    }
    if (data.containsKey('tipo_valor')) {
      context.handle(_tipoValorMeta,
          tipoValor.isAcceptableOrUnknown(data['tipo_valor']!, _tipoValorMeta));
    } else if (isInserting) {
      context.missing(_tipoValorMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('observacoes')) {
      context.handle(
          _observacoesMeta,
          observacoes.isAcceptableOrUnknown(
              data['observacoes']!, _observacoesMeta));
    }
    if (data.containsKey('criado_em')) {
      context.handle(_criadoEmMeta,
          criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta));
    } else if (isInserting) {
      context.missing(_criadoEmMeta);
    }
    if (data.containsKey('atualizado_em')) {
      context.handle(
          _atualizadoEmMeta,
          atualizadoEm.isAcceptableOrUnknown(
              data['atualizado_em']!, _atualizadoEmMeta));
    } else if (isInserting) {
      context.missing(_atualizadoEmMeta);
    }
    if (data.containsKey('iniciado_em')) {
      context.handle(
          _iniciadoEmMeta,
          iniciadoEm.isAcceptableOrUnknown(
              data['iniciado_em']!, _iniciadoEmMeta));
    }
    if (data.containsKey('chegada_coleta_em')) {
      context.handle(
          _chegadaColetaEmMeta,
          chegadaColetaEm.isAcceptableOrUnknown(
              data['chegada_coleta_em']!, _chegadaColetaEmMeta));
    }
    if (data.containsKey('chegada_entrega_em')) {
      context.handle(
          _chegadaEntregaEmMeta,
          chegadaEntregaEm.isAcceptableOrUnknown(
              data['chegada_entrega_em']!, _chegadaEntregaEmMeta));
    }
    if (data.containsKey('inicio_retorno_em')) {
      context.handle(
          _inicioRetornoEmMeta,
          inicioRetornoEm.isAcceptableOrUnknown(
              data['inicio_retorno_em']!, _inicioRetornoEmMeta));
    }
    if (data.containsKey('concluido_em')) {
      context.handle(
          _concluidoEmMeta,
          concluidoEm.isAcceptableOrUnknown(
              data['concluido_em']!, _concluidoEmMeta));
    }
    if (data.containsKey('sincronizado_em')) {
      context.handle(
          _sincronizadoEmMeta,
          sincronizadoEm.isAcceptableOrUnknown(
              data['sincronizado_em']!, _sincronizadoEmMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Atendimento map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Atendimento(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      clienteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cliente_id'])!,
      usuarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_id'])!,
      pontoDeSaidaJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}ponto_de_saida_json'])!,
      localDeColetaJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}local_de_coleta_json'])!,
      localDeEntregaJson: attachedDatabase.typeMapping.read(DriftSqlType.string,
          data['${effectivePrefix}local_de_entrega_json'])!,
      localDeRetornoJson: attachedDatabase.typeMapping.read(DriftSqlType.string,
          data['${effectivePrefix}local_de_retorno_json'])!,
      valorPorKm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}valor_por_km'])!,
      distanciaEstimadaKm: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}distancia_estimada_km'])!,
      distanciaRealKm: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}distancia_real_km']),
      valorCobrado: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}valor_cobrado']),
      tipoValor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo_valor'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      observacoes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observacoes']),
      criadoEm: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}criado_em'])!,
      atualizadoEm: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}atualizado_em'])!,
      iniciadoEm: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}iniciado_em']),
      chegadaColetaEm: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}chegada_coleta_em']),
      chegadaEntregaEm: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}chegada_entrega_em']),
      inicioRetornoEm: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}inicio_retorno_em']),
      concluidoEm: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}concluido_em']),
      sincronizadoEm: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}sincronizado_em']),
    );
  }

  @override
  $AtendimentosTable createAlias(String alias) {
    return $AtendimentosTable(attachedDatabase, alias);
  }
}

class Atendimento extends DataClass implements Insertable<Atendimento> {
  final String id;
  final String clienteId;
  final String usuarioId;
  final String pontoDeSaidaJson;
  final String localDeColetaJson;
  final String localDeEntregaJson;
  final String localDeRetornoJson;
  final double valorPorKm;
  final double distanciaEstimadaKm;
  final double? distanciaRealKm;
  final double? valorCobrado;
  final String tipoValor;
  final String status;
  final String? observacoes;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
  final DateTime? iniciadoEm;
  final DateTime? chegadaColetaEm;
  final DateTime? chegadaEntregaEm;
  final DateTime? inicioRetornoEm;
  final DateTime? concluidoEm;
  final DateTime? sincronizadoEm;
  const Atendimento(
      {required this.id,
      required this.clienteId,
      required this.usuarioId,
      required this.pontoDeSaidaJson,
      required this.localDeColetaJson,
      required this.localDeEntregaJson,
      required this.localDeRetornoJson,
      required this.valorPorKm,
      required this.distanciaEstimadaKm,
      this.distanciaRealKm,
      this.valorCobrado,
      required this.tipoValor,
      required this.status,
      this.observacoes,
      required this.criadoEm,
      required this.atualizadoEm,
      this.iniciadoEm,
      this.chegadaColetaEm,
      this.chegadaEntregaEm,
      this.inicioRetornoEm,
      this.concluidoEm,
      this.sincronizadoEm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cliente_id'] = Variable<String>(clienteId);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['ponto_de_saida_json'] = Variable<String>(pontoDeSaidaJson);
    map['local_de_coleta_json'] = Variable<String>(localDeColetaJson);
    map['local_de_entrega_json'] = Variable<String>(localDeEntregaJson);
    map['local_de_retorno_json'] = Variable<String>(localDeRetornoJson);
    map['valor_por_km'] = Variable<double>(valorPorKm);
    map['distancia_estimada_km'] = Variable<double>(distanciaEstimadaKm);
    if (!nullToAbsent || distanciaRealKm != null) {
      map['distancia_real_km'] = Variable<double>(distanciaRealKm);
    }
    if (!nullToAbsent || valorCobrado != null) {
      map['valor_cobrado'] = Variable<double>(valorCobrado);
    }
    map['tipo_valor'] = Variable<String>(tipoValor);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || observacoes != null) {
      map['observacoes'] = Variable<String>(observacoes);
    }
    map['criado_em'] = Variable<DateTime>(criadoEm);
    map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    if (!nullToAbsent || iniciadoEm != null) {
      map['iniciado_em'] = Variable<DateTime>(iniciadoEm);
    }
    if (!nullToAbsent || chegadaColetaEm != null) {
      map['chegada_coleta_em'] = Variable<DateTime>(chegadaColetaEm);
    }
    if (!nullToAbsent || chegadaEntregaEm != null) {
      map['chegada_entrega_em'] = Variable<DateTime>(chegadaEntregaEm);
    }
    if (!nullToAbsent || inicioRetornoEm != null) {
      map['inicio_retorno_em'] = Variable<DateTime>(inicioRetornoEm);
    }
    if (!nullToAbsent || concluidoEm != null) {
      map['concluido_em'] = Variable<DateTime>(concluidoEm);
    }
    if (!nullToAbsent || sincronizadoEm != null) {
      map['sincronizado_em'] = Variable<DateTime>(sincronizadoEm);
    }
    return map;
  }

  AtendimentosCompanion toCompanion(bool nullToAbsent) {
    return AtendimentosCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      usuarioId: Value(usuarioId),
      pontoDeSaidaJson: Value(pontoDeSaidaJson),
      localDeColetaJson: Value(localDeColetaJson),
      localDeEntregaJson: Value(localDeEntregaJson),
      localDeRetornoJson: Value(localDeRetornoJson),
      valorPorKm: Value(valorPorKm),
      distanciaEstimadaKm: Value(distanciaEstimadaKm),
      distanciaRealKm: distanciaRealKm == null && nullToAbsent
          ? const Value.absent()
          : Value(distanciaRealKm),
      valorCobrado: valorCobrado == null && nullToAbsent
          ? const Value.absent()
          : Value(valorCobrado),
      tipoValor: Value(tipoValor),
      status: Value(status),
      observacoes: observacoes == null && nullToAbsent
          ? const Value.absent()
          : Value(observacoes),
      criadoEm: Value(criadoEm),
      atualizadoEm: Value(atualizadoEm),
      iniciadoEm: iniciadoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(iniciadoEm),
      chegadaColetaEm: chegadaColetaEm == null && nullToAbsent
          ? const Value.absent()
          : Value(chegadaColetaEm),
      chegadaEntregaEm: chegadaEntregaEm == null && nullToAbsent
          ? const Value.absent()
          : Value(chegadaEntregaEm),
      inicioRetornoEm: inicioRetornoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(inicioRetornoEm),
      concluidoEm: concluidoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(concluidoEm),
      sincronizadoEm: sincronizadoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(sincronizadoEm),
    );
  }

  factory Atendimento.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Atendimento(
      id: serializer.fromJson<String>(json['id']),
      clienteId: serializer.fromJson<String>(json['clienteId']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      pontoDeSaidaJson: serializer.fromJson<String>(json['pontoDeSaidaJson']),
      localDeColetaJson: serializer.fromJson<String>(json['localDeColetaJson']),
      localDeEntregaJson:
          serializer.fromJson<String>(json['localDeEntregaJson']),
      localDeRetornoJson:
          serializer.fromJson<String>(json['localDeRetornoJson']),
      valorPorKm: serializer.fromJson<double>(json['valorPorKm']),
      distanciaEstimadaKm:
          serializer.fromJson<double>(json['distanciaEstimadaKm']),
      distanciaRealKm: serializer.fromJson<double?>(json['distanciaRealKm']),
      valorCobrado: serializer.fromJson<double?>(json['valorCobrado']),
      tipoValor: serializer.fromJson<String>(json['tipoValor']),
      status: serializer.fromJson<String>(json['status']),
      observacoes: serializer.fromJson<String?>(json['observacoes']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
      atualizadoEm: serializer.fromJson<DateTime>(json['atualizadoEm']),
      iniciadoEm: serializer.fromJson<DateTime?>(json['iniciadoEm']),
      chegadaColetaEm: serializer.fromJson<DateTime?>(json['chegadaColetaEm']),
      chegadaEntregaEm:
          serializer.fromJson<DateTime?>(json['chegadaEntregaEm']),
      inicioRetornoEm: serializer.fromJson<DateTime?>(json['inicioRetornoEm']),
      concluidoEm: serializer.fromJson<DateTime?>(json['concluidoEm']),
      sincronizadoEm: serializer.fromJson<DateTime?>(json['sincronizadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clienteId': serializer.toJson<String>(clienteId),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'pontoDeSaidaJson': serializer.toJson<String>(pontoDeSaidaJson),
      'localDeColetaJson': serializer.toJson<String>(localDeColetaJson),
      'localDeEntregaJson': serializer.toJson<String>(localDeEntregaJson),
      'localDeRetornoJson': serializer.toJson<String>(localDeRetornoJson),
      'valorPorKm': serializer.toJson<double>(valorPorKm),
      'distanciaEstimadaKm': serializer.toJson<double>(distanciaEstimadaKm),
      'distanciaRealKm': serializer.toJson<double?>(distanciaRealKm),
      'valorCobrado': serializer.toJson<double?>(valorCobrado),
      'tipoValor': serializer.toJson<String>(tipoValor),
      'status': serializer.toJson<String>(status),
      'observacoes': serializer.toJson<String?>(observacoes),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
      'atualizadoEm': serializer.toJson<DateTime>(atualizadoEm),
      'iniciadoEm': serializer.toJson<DateTime?>(iniciadoEm),
      'chegadaColetaEm': serializer.toJson<DateTime?>(chegadaColetaEm),
      'chegadaEntregaEm': serializer.toJson<DateTime?>(chegadaEntregaEm),
      'inicioRetornoEm': serializer.toJson<DateTime?>(inicioRetornoEm),
      'concluidoEm': serializer.toJson<DateTime?>(concluidoEm),
      'sincronizadoEm': serializer.toJson<DateTime?>(sincronizadoEm),
    };
  }

  Atendimento copyWith(
          {String? id,
          String? clienteId,
          String? usuarioId,
          String? pontoDeSaidaJson,
          String? localDeColetaJson,
          String? localDeEntregaJson,
          String? localDeRetornoJson,
          double? valorPorKm,
          double? distanciaEstimadaKm,
          Value<double?> distanciaRealKm = const Value.absent(),
          Value<double?> valorCobrado = const Value.absent(),
          String? tipoValor,
          String? status,
          Value<String?> observacoes = const Value.absent(),
          DateTime? criadoEm,
          DateTime? atualizadoEm,
          Value<DateTime?> iniciadoEm = const Value.absent(),
          Value<DateTime?> chegadaColetaEm = const Value.absent(),
          Value<DateTime?> chegadaEntregaEm = const Value.absent(),
          Value<DateTime?> inicioRetornoEm = const Value.absent(),
          Value<DateTime?> concluidoEm = const Value.absent(),
          Value<DateTime?> sincronizadoEm = const Value.absent()}) =>
      Atendimento(
        id: id ?? this.id,
        clienteId: clienteId ?? this.clienteId,
        usuarioId: usuarioId ?? this.usuarioId,
        pontoDeSaidaJson: pontoDeSaidaJson ?? this.pontoDeSaidaJson,
        localDeColetaJson: localDeColetaJson ?? this.localDeColetaJson,
        localDeEntregaJson: localDeEntregaJson ?? this.localDeEntregaJson,
        localDeRetornoJson: localDeRetornoJson ?? this.localDeRetornoJson,
        valorPorKm: valorPorKm ?? this.valorPorKm,
        distanciaEstimadaKm: distanciaEstimadaKm ?? this.distanciaEstimadaKm,
        distanciaRealKm: distanciaRealKm.present
            ? distanciaRealKm.value
            : this.distanciaRealKm,
        valorCobrado:
            valorCobrado.present ? valorCobrado.value : this.valorCobrado,
        tipoValor: tipoValor ?? this.tipoValor,
        status: status ?? this.status,
        observacoes: observacoes.present ? observacoes.value : this.observacoes,
        criadoEm: criadoEm ?? this.criadoEm,
        atualizadoEm: atualizadoEm ?? this.atualizadoEm,
        iniciadoEm: iniciadoEm.present ? iniciadoEm.value : this.iniciadoEm,
        chegadaColetaEm: chegadaColetaEm.present
            ? chegadaColetaEm.value
            : this.chegadaColetaEm,
        chegadaEntregaEm: chegadaEntregaEm.present
            ? chegadaEntregaEm.value
            : this.chegadaEntregaEm,
        inicioRetornoEm: inicioRetornoEm.present
            ? inicioRetornoEm.value
            : this.inicioRetornoEm,
        concluidoEm: concluidoEm.present ? concluidoEm.value : this.concluidoEm,
        sincronizadoEm:
            sincronizadoEm.present ? sincronizadoEm.value : this.sincronizadoEm,
      );
  Atendimento copyWithCompanion(AtendimentosCompanion data) {
    return Atendimento(
      id: data.id.present ? data.id.value : this.id,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      pontoDeSaidaJson: data.pontoDeSaidaJson.present
          ? data.pontoDeSaidaJson.value
          : this.pontoDeSaidaJson,
      localDeColetaJson: data.localDeColetaJson.present
          ? data.localDeColetaJson.value
          : this.localDeColetaJson,
      localDeEntregaJson: data.localDeEntregaJson.present
          ? data.localDeEntregaJson.value
          : this.localDeEntregaJson,
      localDeRetornoJson: data.localDeRetornoJson.present
          ? data.localDeRetornoJson.value
          : this.localDeRetornoJson,
      valorPorKm:
          data.valorPorKm.present ? data.valorPorKm.value : this.valorPorKm,
      distanciaEstimadaKm: data.distanciaEstimadaKm.present
          ? data.distanciaEstimadaKm.value
          : this.distanciaEstimadaKm,
      distanciaRealKm: data.distanciaRealKm.present
          ? data.distanciaRealKm.value
          : this.distanciaRealKm,
      valorCobrado: data.valorCobrado.present
          ? data.valorCobrado.value
          : this.valorCobrado,
      tipoValor: data.tipoValor.present ? data.tipoValor.value : this.tipoValor,
      status: data.status.present ? data.status.value : this.status,
      observacoes:
          data.observacoes.present ? data.observacoes.value : this.observacoes,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
      iniciadoEm:
          data.iniciadoEm.present ? data.iniciadoEm.value : this.iniciadoEm,
      chegadaColetaEm: data.chegadaColetaEm.present
          ? data.chegadaColetaEm.value
          : this.chegadaColetaEm,
      chegadaEntregaEm: data.chegadaEntregaEm.present
          ? data.chegadaEntregaEm.value
          : this.chegadaEntregaEm,
      inicioRetornoEm: data.inicioRetornoEm.present
          ? data.inicioRetornoEm.value
          : this.inicioRetornoEm,
      concluidoEm:
          data.concluidoEm.present ? data.concluidoEm.value : this.concluidoEm,
      sincronizadoEm: data.sincronizadoEm.present
          ? data.sincronizadoEm.value
          : this.sincronizadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Atendimento(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('pontoDeSaidaJson: $pontoDeSaidaJson, ')
          ..write('localDeColetaJson: $localDeColetaJson, ')
          ..write('localDeEntregaJson: $localDeEntregaJson, ')
          ..write('localDeRetornoJson: $localDeRetornoJson, ')
          ..write('valorPorKm: $valorPorKm, ')
          ..write('distanciaEstimadaKm: $distanciaEstimadaKm, ')
          ..write('distanciaRealKm: $distanciaRealKm, ')
          ..write('valorCobrado: $valorCobrado, ')
          ..write('tipoValor: $tipoValor, ')
          ..write('status: $status, ')
          ..write('observacoes: $observacoes, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('iniciadoEm: $iniciadoEm, ')
          ..write('chegadaColetaEm: $chegadaColetaEm, ')
          ..write('chegadaEntregaEm: $chegadaEntregaEm, ')
          ..write('inicioRetornoEm: $inicioRetornoEm, ')
          ..write('concluidoEm: $concluidoEm, ')
          ..write('sincronizadoEm: $sincronizadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        clienteId,
        usuarioId,
        pontoDeSaidaJson,
        localDeColetaJson,
        localDeEntregaJson,
        localDeRetornoJson,
        valorPorKm,
        distanciaEstimadaKm,
        distanciaRealKm,
        valorCobrado,
        tipoValor,
        status,
        observacoes,
        criadoEm,
        atualizadoEm,
        iniciadoEm,
        chegadaColetaEm,
        chegadaEntregaEm,
        inicioRetornoEm,
        concluidoEm,
        sincronizadoEm
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Atendimento &&
          other.id == this.id &&
          other.clienteId == this.clienteId &&
          other.usuarioId == this.usuarioId &&
          other.pontoDeSaidaJson == this.pontoDeSaidaJson &&
          other.localDeColetaJson == this.localDeColetaJson &&
          other.localDeEntregaJson == this.localDeEntregaJson &&
          other.localDeRetornoJson == this.localDeRetornoJson &&
          other.valorPorKm == this.valorPorKm &&
          other.distanciaEstimadaKm == this.distanciaEstimadaKm &&
          other.distanciaRealKm == this.distanciaRealKm &&
          other.valorCobrado == this.valorCobrado &&
          other.tipoValor == this.tipoValor &&
          other.status == this.status &&
          other.observacoes == this.observacoes &&
          other.criadoEm == this.criadoEm &&
          other.atualizadoEm == this.atualizadoEm &&
          other.iniciadoEm == this.iniciadoEm &&
          other.chegadaColetaEm == this.chegadaColetaEm &&
          other.chegadaEntregaEm == this.chegadaEntregaEm &&
          other.inicioRetornoEm == this.inicioRetornoEm &&
          other.concluidoEm == this.concluidoEm &&
          other.sincronizadoEm == this.sincronizadoEm);
}

class AtendimentosCompanion extends UpdateCompanion<Atendimento> {
  final Value<String> id;
  final Value<String> clienteId;
  final Value<String> usuarioId;
  final Value<String> pontoDeSaidaJson;
  final Value<String> localDeColetaJson;
  final Value<String> localDeEntregaJson;
  final Value<String> localDeRetornoJson;
  final Value<double> valorPorKm;
  final Value<double> distanciaEstimadaKm;
  final Value<double?> distanciaRealKm;
  final Value<double?> valorCobrado;
  final Value<String> tipoValor;
  final Value<String> status;
  final Value<String?> observacoes;
  final Value<DateTime> criadoEm;
  final Value<DateTime> atualizadoEm;
  final Value<DateTime?> iniciadoEm;
  final Value<DateTime?> chegadaColetaEm;
  final Value<DateTime?> chegadaEntregaEm;
  final Value<DateTime?> inicioRetornoEm;
  final Value<DateTime?> concluidoEm;
  final Value<DateTime?> sincronizadoEm;
  final Value<int> rowid;
  const AtendimentosCompanion({
    this.id = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.pontoDeSaidaJson = const Value.absent(),
    this.localDeColetaJson = const Value.absent(),
    this.localDeEntregaJson = const Value.absent(),
    this.localDeRetornoJson = const Value.absent(),
    this.valorPorKm = const Value.absent(),
    this.distanciaEstimadaKm = const Value.absent(),
    this.distanciaRealKm = const Value.absent(),
    this.valorCobrado = const Value.absent(),
    this.tipoValor = const Value.absent(),
    this.status = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
    this.iniciadoEm = const Value.absent(),
    this.chegadaColetaEm = const Value.absent(),
    this.chegadaEntregaEm = const Value.absent(),
    this.inicioRetornoEm = const Value.absent(),
    this.concluidoEm = const Value.absent(),
    this.sincronizadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AtendimentosCompanion.insert({
    required String id,
    required String clienteId,
    required String usuarioId,
    required String pontoDeSaidaJson,
    required String localDeColetaJson,
    required String localDeEntregaJson,
    required String localDeRetornoJson,
    required double valorPorKm,
    required double distanciaEstimadaKm,
    this.distanciaRealKm = const Value.absent(),
    this.valorCobrado = const Value.absent(),
    required String tipoValor,
    required String status,
    this.observacoes = const Value.absent(),
    required DateTime criadoEm,
    required DateTime atualizadoEm,
    this.iniciadoEm = const Value.absent(),
    this.chegadaColetaEm = const Value.absent(),
    this.chegadaEntregaEm = const Value.absent(),
    this.inicioRetornoEm = const Value.absent(),
    this.concluidoEm = const Value.absent(),
    this.sincronizadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        clienteId = Value(clienteId),
        usuarioId = Value(usuarioId),
        pontoDeSaidaJson = Value(pontoDeSaidaJson),
        localDeColetaJson = Value(localDeColetaJson),
        localDeEntregaJson = Value(localDeEntregaJson),
        localDeRetornoJson = Value(localDeRetornoJson),
        valorPorKm = Value(valorPorKm),
        distanciaEstimadaKm = Value(distanciaEstimadaKm),
        tipoValor = Value(tipoValor),
        status = Value(status),
        criadoEm = Value(criadoEm),
        atualizadoEm = Value(atualizadoEm);
  static Insertable<Atendimento> custom({
    Expression<String>? id,
    Expression<String>? clienteId,
    Expression<String>? usuarioId,
    Expression<String>? pontoDeSaidaJson,
    Expression<String>? localDeColetaJson,
    Expression<String>? localDeEntregaJson,
    Expression<String>? localDeRetornoJson,
    Expression<double>? valorPorKm,
    Expression<double>? distanciaEstimadaKm,
    Expression<double>? distanciaRealKm,
    Expression<double>? valorCobrado,
    Expression<String>? tipoValor,
    Expression<String>? status,
    Expression<String>? observacoes,
    Expression<DateTime>? criadoEm,
    Expression<DateTime>? atualizadoEm,
    Expression<DateTime>? iniciadoEm,
    Expression<DateTime>? chegadaColetaEm,
    Expression<DateTime>? chegadaEntregaEm,
    Expression<DateTime>? inicioRetornoEm,
    Expression<DateTime>? concluidoEm,
    Expression<DateTime>? sincronizadoEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clienteId != null) 'cliente_id': clienteId,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (pontoDeSaidaJson != null) 'ponto_de_saida_json': pontoDeSaidaJson,
      if (localDeColetaJson != null) 'local_de_coleta_json': localDeColetaJson,
      if (localDeEntregaJson != null)
        'local_de_entrega_json': localDeEntregaJson,
      if (localDeRetornoJson != null)
        'local_de_retorno_json': localDeRetornoJson,
      if (valorPorKm != null) 'valor_por_km': valorPorKm,
      if (distanciaEstimadaKm != null)
        'distancia_estimada_km': distanciaEstimadaKm,
      if (distanciaRealKm != null) 'distancia_real_km': distanciaRealKm,
      if (valorCobrado != null) 'valor_cobrado': valorCobrado,
      if (tipoValor != null) 'tipo_valor': tipoValor,
      if (status != null) 'status': status,
      if (observacoes != null) 'observacoes': observacoes,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
      if (iniciadoEm != null) 'iniciado_em': iniciadoEm,
      if (chegadaColetaEm != null) 'chegada_coleta_em': chegadaColetaEm,
      if (chegadaEntregaEm != null) 'chegada_entrega_em': chegadaEntregaEm,
      if (inicioRetornoEm != null) 'inicio_retorno_em': inicioRetornoEm,
      if (concluidoEm != null) 'concluido_em': concluidoEm,
      if (sincronizadoEm != null) 'sincronizado_em': sincronizadoEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AtendimentosCompanion copyWith(
      {Value<String>? id,
      Value<String>? clienteId,
      Value<String>? usuarioId,
      Value<String>? pontoDeSaidaJson,
      Value<String>? localDeColetaJson,
      Value<String>? localDeEntregaJson,
      Value<String>? localDeRetornoJson,
      Value<double>? valorPorKm,
      Value<double>? distanciaEstimadaKm,
      Value<double?>? distanciaRealKm,
      Value<double?>? valorCobrado,
      Value<String>? tipoValor,
      Value<String>? status,
      Value<String?>? observacoes,
      Value<DateTime>? criadoEm,
      Value<DateTime>? atualizadoEm,
      Value<DateTime?>? iniciadoEm,
      Value<DateTime?>? chegadaColetaEm,
      Value<DateTime?>? chegadaEntregaEm,
      Value<DateTime?>? inicioRetornoEm,
      Value<DateTime?>? concluidoEm,
      Value<DateTime?>? sincronizadoEm,
      Value<int>? rowid}) {
    return AtendimentosCompanion(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      usuarioId: usuarioId ?? this.usuarioId,
      pontoDeSaidaJson: pontoDeSaidaJson ?? this.pontoDeSaidaJson,
      localDeColetaJson: localDeColetaJson ?? this.localDeColetaJson,
      localDeEntregaJson: localDeEntregaJson ?? this.localDeEntregaJson,
      localDeRetornoJson: localDeRetornoJson ?? this.localDeRetornoJson,
      valorPorKm: valorPorKm ?? this.valorPorKm,
      distanciaEstimadaKm: distanciaEstimadaKm ?? this.distanciaEstimadaKm,
      distanciaRealKm: distanciaRealKm ?? this.distanciaRealKm,
      valorCobrado: valorCobrado ?? this.valorCobrado,
      tipoValor: tipoValor ?? this.tipoValor,
      status: status ?? this.status,
      observacoes: observacoes ?? this.observacoes,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
      iniciadoEm: iniciadoEm ?? this.iniciadoEm,
      chegadaColetaEm: chegadaColetaEm ?? this.chegadaColetaEm,
      chegadaEntregaEm: chegadaEntregaEm ?? this.chegadaEntregaEm,
      inicioRetornoEm: inicioRetornoEm ?? this.inicioRetornoEm,
      concluidoEm: concluidoEm ?? this.concluidoEm,
      sincronizadoEm: sincronizadoEm ?? this.sincronizadoEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<String>(clienteId.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (pontoDeSaidaJson.present) {
      map['ponto_de_saida_json'] = Variable<String>(pontoDeSaidaJson.value);
    }
    if (localDeColetaJson.present) {
      map['local_de_coleta_json'] = Variable<String>(localDeColetaJson.value);
    }
    if (localDeEntregaJson.present) {
      map['local_de_entrega_json'] = Variable<String>(localDeEntregaJson.value);
    }
    if (localDeRetornoJson.present) {
      map['local_de_retorno_json'] = Variable<String>(localDeRetornoJson.value);
    }
    if (valorPorKm.present) {
      map['valor_por_km'] = Variable<double>(valorPorKm.value);
    }
    if (distanciaEstimadaKm.present) {
      map['distancia_estimada_km'] =
          Variable<double>(distanciaEstimadaKm.value);
    }
    if (distanciaRealKm.present) {
      map['distancia_real_km'] = Variable<double>(distanciaRealKm.value);
    }
    if (valorCobrado.present) {
      map['valor_cobrado'] = Variable<double>(valorCobrado.value);
    }
    if (tipoValor.present) {
      map['tipo_valor'] = Variable<String>(tipoValor.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (observacoes.present) {
      map['observacoes'] = Variable<String>(observacoes.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    if (iniciadoEm.present) {
      map['iniciado_em'] = Variable<DateTime>(iniciadoEm.value);
    }
    if (chegadaColetaEm.present) {
      map['chegada_coleta_em'] = Variable<DateTime>(chegadaColetaEm.value);
    }
    if (chegadaEntregaEm.present) {
      map['chegada_entrega_em'] = Variable<DateTime>(chegadaEntregaEm.value);
    }
    if (inicioRetornoEm.present) {
      map['inicio_retorno_em'] = Variable<DateTime>(inicioRetornoEm.value);
    }
    if (concluidoEm.present) {
      map['concluido_em'] = Variable<DateTime>(concluidoEm.value);
    }
    if (sincronizadoEm.present) {
      map['sincronizado_em'] = Variable<DateTime>(sincronizadoEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AtendimentosCompanion(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('pontoDeSaidaJson: $pontoDeSaidaJson, ')
          ..write('localDeColetaJson: $localDeColetaJson, ')
          ..write('localDeEntregaJson: $localDeEntregaJson, ')
          ..write('localDeRetornoJson: $localDeRetornoJson, ')
          ..write('valorPorKm: $valorPorKm, ')
          ..write('distanciaEstimadaKm: $distanciaEstimadaKm, ')
          ..write('distanciaRealKm: $distanciaRealKm, ')
          ..write('valorCobrado: $valorCobrado, ')
          ..write('tipoValor: $tipoValor, ')
          ..write('status: $status, ')
          ..write('observacoes: $observacoes, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm, ')
          ..write('iniciadoEm: $iniciadoEm, ')
          ..write('chegadaColetaEm: $chegadaColetaEm, ')
          ..write('chegadaEntregaEm: $chegadaEntregaEm, ')
          ..write('inicioRetornoEm: $inicioRetornoEm, ')
          ..write('concluidoEm: $concluidoEm, ')
          ..write('sincronizadoEm: $sincronizadoEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PontosRastreamentoTable extends PontosRastreamento
    with TableInfo<$PontosRastreamentoTable, PontosRastreamentoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PontosRastreamentoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _atendimentoIdMeta =
      const VerificationMeta('atendimentoId');
  @override
  late final GeneratedColumn<String> atendimentoId = GeneratedColumn<String>(
      'atendimento_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES atendimentos (id)'));
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _accuracyMeta =
      const VerificationMeta('accuracy');
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
      'accuracy', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _velocidadeMeta =
      const VerificationMeta('velocidade');
  @override
  late final GeneratedColumn<double> velocidade = GeneratedColumn<double>(
      'velocidade', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        atendimentoId,
        latitude,
        longitude,
        accuracy,
        velocidade,
        timestamp,
        synced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pontos_rastreamento';
  @override
  VerificationContext validateIntegrity(
      Insertable<PontosRastreamentoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('atendimento_id')) {
      context.handle(
          _atendimentoIdMeta,
          atendimentoId.isAcceptableOrUnknown(
              data['atendimento_id']!, _atendimentoIdMeta));
    } else if (isInserting) {
      context.missing(_atendimentoIdMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('accuracy')) {
      context.handle(_accuracyMeta,
          accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta));
    } else if (isInserting) {
      context.missing(_accuracyMeta);
    }
    if (data.containsKey('velocidade')) {
      context.handle(
          _velocidadeMeta,
          velocidade.isAcceptableOrUnknown(
              data['velocidade']!, _velocidadeMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PontosRastreamentoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PontosRastreamentoData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      atendimentoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}atendimento_id'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      accuracy: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}accuracy'])!,
      velocidade: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}velocidade']),
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $PontosRastreamentoTable createAlias(String alias) {
    return $PontosRastreamentoTable(attachedDatabase, alias);
  }
}

class PontosRastreamentoData extends DataClass
    implements Insertable<PontosRastreamentoData> {
  final String id;
  final String atendimentoId;
  final double latitude;
  final double longitude;
  final double accuracy;
  final double? velocidade;
  final DateTime timestamp;
  final bool synced;
  const PontosRastreamentoData(
      {required this.id,
      required this.atendimentoId,
      required this.latitude,
      required this.longitude,
      required this.accuracy,
      this.velocidade,
      required this.timestamp,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['atendimento_id'] = Variable<String>(atendimentoId);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['accuracy'] = Variable<double>(accuracy);
    if (!nullToAbsent || velocidade != null) {
      map['velocidade'] = Variable<double>(velocidade);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  PontosRastreamentoCompanion toCompanion(bool nullToAbsent) {
    return PontosRastreamentoCompanion(
      id: Value(id),
      atendimentoId: Value(atendimentoId),
      latitude: Value(latitude),
      longitude: Value(longitude),
      accuracy: Value(accuracy),
      velocidade: velocidade == null && nullToAbsent
          ? const Value.absent()
          : Value(velocidade),
      timestamp: Value(timestamp),
      synced: Value(synced),
    );
  }

  factory PontosRastreamentoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PontosRastreamentoData(
      id: serializer.fromJson<String>(json['id']),
      atendimentoId: serializer.fromJson<String>(json['atendimentoId']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      accuracy: serializer.fromJson<double>(json['accuracy']),
      velocidade: serializer.fromJson<double?>(json['velocidade']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'atendimentoId': serializer.toJson<String>(atendimentoId),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'accuracy': serializer.toJson<double>(accuracy),
      'velocidade': serializer.toJson<double?>(velocidade),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  PontosRastreamentoData copyWith(
          {String? id,
          String? atendimentoId,
          double? latitude,
          double? longitude,
          double? accuracy,
          Value<double?> velocidade = const Value.absent(),
          DateTime? timestamp,
          bool? synced}) =>
      PontosRastreamentoData(
        id: id ?? this.id,
        atendimentoId: atendimentoId ?? this.atendimentoId,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        accuracy: accuracy ?? this.accuracy,
        velocidade: velocidade.present ? velocidade.value : this.velocidade,
        timestamp: timestamp ?? this.timestamp,
        synced: synced ?? this.synced,
      );
  PontosRastreamentoData copyWithCompanion(PontosRastreamentoCompanion data) {
    return PontosRastreamentoData(
      id: data.id.present ? data.id.value : this.id,
      atendimentoId: data.atendimentoId.present
          ? data.atendimentoId.value
          : this.atendimentoId,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
      velocidade:
          data.velocidade.present ? data.velocidade.value : this.velocidade,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PontosRastreamentoData(')
          ..write('id: $id, ')
          ..write('atendimentoId: $atendimentoId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracy: $accuracy, ')
          ..write('velocidade: $velocidade, ')
          ..write('timestamp: $timestamp, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, atendimentoId, latitude, longitude,
      accuracy, velocidade, timestamp, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PontosRastreamentoData &&
          other.id == this.id &&
          other.atendimentoId == this.atendimentoId &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.accuracy == this.accuracy &&
          other.velocidade == this.velocidade &&
          other.timestamp == this.timestamp &&
          other.synced == this.synced);
}

class PontosRastreamentoCompanion
    extends UpdateCompanion<PontosRastreamentoData> {
  final Value<String> id;
  final Value<String> atendimentoId;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double> accuracy;
  final Value<double?> velocidade;
  final Value<DateTime> timestamp;
  final Value<bool> synced;
  final Value<int> rowid;
  const PontosRastreamentoCompanion({
    this.id = const Value.absent(),
    this.atendimentoId = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.velocidade = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PontosRastreamentoCompanion.insert({
    required String id,
    required String atendimentoId,
    required double latitude,
    required double longitude,
    required double accuracy,
    this.velocidade = const Value.absent(),
    required DateTime timestamp,
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        atendimentoId = Value(atendimentoId),
        latitude = Value(latitude),
        longitude = Value(longitude),
        accuracy = Value(accuracy),
        timestamp = Value(timestamp);
  static Insertable<PontosRastreamentoData> custom({
    Expression<String>? id,
    Expression<String>? atendimentoId,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? accuracy,
    Expression<double>? velocidade,
    Expression<DateTime>? timestamp,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (atendimentoId != null) 'atendimento_id': atendimentoId,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (accuracy != null) 'accuracy': accuracy,
      if (velocidade != null) 'velocidade': velocidade,
      if (timestamp != null) 'timestamp': timestamp,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PontosRastreamentoCompanion copyWith(
      {Value<String>? id,
      Value<String>? atendimentoId,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<double>? accuracy,
      Value<double?>? velocidade,
      Value<DateTime>? timestamp,
      Value<bool>? synced,
      Value<int>? rowid}) {
    return PontosRastreamentoCompanion(
      id: id ?? this.id,
      atendimentoId: atendimentoId ?? this.atendimentoId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      velocidade: velocidade ?? this.velocidade,
      timestamp: timestamp ?? this.timestamp,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (atendimentoId.present) {
      map['atendimento_id'] = Variable<String>(atendimentoId.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (velocidade.present) {
      map['velocidade'] = Variable<double>(velocidade.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PontosRastreamentoCompanion(')
          ..write('id: $id, ')
          ..write('atendimentoId: $atendimentoId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracy: $accuracy, ')
          ..write('velocidade: $velocidade, ')
          ..write('timestamp: $timestamp, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTableTable extends SyncQueueTable
    with TableInfo<$SyncQueueTableTable, SyncQueueEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entidadeMeta =
      const VerificationMeta('entidade');
  @override
  late final GeneratedColumn<String> entidade = GeneratedColumn<String>(
      'entidade', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operacaoMeta =
      const VerificationMeta('operacao');
  @override
  late final GeneratedColumn<String> operacao = GeneratedColumn<String>(
      'operacao', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tentativasMeta =
      const VerificationMeta('tentativas');
  @override
  late final GeneratedColumn<int> tentativas = GeneratedColumn<int>(
      'tentativas', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _criadoEmMeta =
      const VerificationMeta('criadoEm');
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
      'criado_em', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _proximaTentativaEmMeta =
      const VerificationMeta('proximaTentativaEm');
  @override
  late final GeneratedColumn<DateTime> proximaTentativaEm =
      GeneratedColumn<DateTime>('proxima_tentativa_em', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entidade,
        operacao,
        payload,
        tentativas,
        criadoEm,
        proximaTentativaEm
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entidade')) {
      context.handle(_entidadeMeta,
          entidade.isAcceptableOrUnknown(data['entidade']!, _entidadeMeta));
    } else if (isInserting) {
      context.missing(_entidadeMeta);
    }
    if (data.containsKey('operacao')) {
      context.handle(_operacaoMeta,
          operacao.isAcceptableOrUnknown(data['operacao']!, _operacaoMeta));
    } else if (isInserting) {
      context.missing(_operacaoMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('tentativas')) {
      context.handle(
          _tentativasMeta,
          tentativas.isAcceptableOrUnknown(
              data['tentativas']!, _tentativasMeta));
    }
    if (data.containsKey('criado_em')) {
      context.handle(_criadoEmMeta,
          criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta));
    } else if (isInserting) {
      context.missing(_criadoEmMeta);
    }
    if (data.containsKey('proxima_tentativa_em')) {
      context.handle(
          _proximaTentativaEmMeta,
          proximaTentativaEm.isAcceptableOrUnknown(
              data['proxima_tentativa_em']!, _proximaTentativaEmMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entidade: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entidade'])!,
      operacao: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operacao'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      tentativas: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tentativas'])!,
      criadoEm: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}criado_em'])!,
      proximaTentativaEm: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}proxima_tentativa_em']),
    );
  }

  @override
  $SyncQueueTableTable createAlias(String alias) {
    return $SyncQueueTableTable(attachedDatabase, alias);
  }
}

class SyncQueueEntry extends DataClass implements Insertable<SyncQueueEntry> {
  final String id;
  final String entidade;
  final String operacao;
  final String payload;
  final int tentativas;
  final DateTime criadoEm;
  final DateTime? proximaTentativaEm;
  const SyncQueueEntry(
      {required this.id,
      required this.entidade,
      required this.operacao,
      required this.payload,
      required this.tentativas,
      required this.criadoEm,
      this.proximaTentativaEm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entidade'] = Variable<String>(entidade);
    map['operacao'] = Variable<String>(operacao);
    map['payload'] = Variable<String>(payload);
    map['tentativas'] = Variable<int>(tentativas);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    if (!nullToAbsent || proximaTentativaEm != null) {
      map['proxima_tentativa_em'] = Variable<DateTime>(proximaTentativaEm);
    }
    return map;
  }

  SyncQueueTableCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueTableCompanion(
      id: Value(id),
      entidade: Value(entidade),
      operacao: Value(operacao),
      payload: Value(payload),
      tentativas: Value(tentativas),
      criadoEm: Value(criadoEm),
      proximaTentativaEm: proximaTentativaEm == null && nullToAbsent
          ? const Value.absent()
          : Value(proximaTentativaEm),
    );
  }

  factory SyncQueueEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueEntry(
      id: serializer.fromJson<String>(json['id']),
      entidade: serializer.fromJson<String>(json['entidade']),
      operacao: serializer.fromJson<String>(json['operacao']),
      payload: serializer.fromJson<String>(json['payload']),
      tentativas: serializer.fromJson<int>(json['tentativas']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
      proximaTentativaEm:
          serializer.fromJson<DateTime?>(json['proximaTentativaEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entidade': serializer.toJson<String>(entidade),
      'operacao': serializer.toJson<String>(operacao),
      'payload': serializer.toJson<String>(payload),
      'tentativas': serializer.toJson<int>(tentativas),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
      'proximaTentativaEm': serializer.toJson<DateTime?>(proximaTentativaEm),
    };
  }

  SyncQueueEntry copyWith(
          {String? id,
          String? entidade,
          String? operacao,
          String? payload,
          int? tentativas,
          DateTime? criadoEm,
          Value<DateTime?> proximaTentativaEm = const Value.absent()}) =>
      SyncQueueEntry(
        id: id ?? this.id,
        entidade: entidade ?? this.entidade,
        operacao: operacao ?? this.operacao,
        payload: payload ?? this.payload,
        tentativas: tentativas ?? this.tentativas,
        criadoEm: criadoEm ?? this.criadoEm,
        proximaTentativaEm: proximaTentativaEm.present
            ? proximaTentativaEm.value
            : this.proximaTentativaEm,
      );
  SyncQueueEntry copyWithCompanion(SyncQueueTableCompanion data) {
    return SyncQueueEntry(
      id: data.id.present ? data.id.value : this.id,
      entidade: data.entidade.present ? data.entidade.value : this.entidade,
      operacao: data.operacao.present ? data.operacao.value : this.operacao,
      payload: data.payload.present ? data.payload.value : this.payload,
      tentativas:
          data.tentativas.present ? data.tentativas.value : this.tentativas,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
      proximaTentativaEm: data.proximaTentativaEm.present
          ? data.proximaTentativaEm.value
          : this.proximaTentativaEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueEntry(')
          ..write('id: $id, ')
          ..write('entidade: $entidade, ')
          ..write('operacao: $operacao, ')
          ..write('payload: $payload, ')
          ..write('tentativas: $tentativas, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('proximaTentativaEm: $proximaTentativaEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entidade, operacao, payload, tentativas,
      criadoEm, proximaTentativaEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueEntry &&
          other.id == this.id &&
          other.entidade == this.entidade &&
          other.operacao == this.operacao &&
          other.payload == this.payload &&
          other.tentativas == this.tentativas &&
          other.criadoEm == this.criadoEm &&
          other.proximaTentativaEm == this.proximaTentativaEm);
}

class SyncQueueTableCompanion extends UpdateCompanion<SyncQueueEntry> {
  final Value<String> id;
  final Value<String> entidade;
  final Value<String> operacao;
  final Value<String> payload;
  final Value<int> tentativas;
  final Value<DateTime> criadoEm;
  final Value<DateTime?> proximaTentativaEm;
  final Value<int> rowid;
  const SyncQueueTableCompanion({
    this.id = const Value.absent(),
    this.entidade = const Value.absent(),
    this.operacao = const Value.absent(),
    this.payload = const Value.absent(),
    this.tentativas = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.proximaTentativaEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueTableCompanion.insert({
    required String id,
    required String entidade,
    required String operacao,
    required String payload,
    this.tentativas = const Value.absent(),
    required DateTime criadoEm,
    this.proximaTentativaEm = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entidade = Value(entidade),
        operacao = Value(operacao),
        payload = Value(payload),
        criadoEm = Value(criadoEm);
  static Insertable<SyncQueueEntry> custom({
    Expression<String>? id,
    Expression<String>? entidade,
    Expression<String>? operacao,
    Expression<String>? payload,
    Expression<int>? tentativas,
    Expression<DateTime>? criadoEm,
    Expression<DateTime>? proximaTentativaEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entidade != null) 'entidade': entidade,
      if (operacao != null) 'operacao': operacao,
      if (payload != null) 'payload': payload,
      if (tentativas != null) 'tentativas': tentativas,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (proximaTentativaEm != null)
        'proxima_tentativa_em': proximaTentativaEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? entidade,
      Value<String>? operacao,
      Value<String>? payload,
      Value<int>? tentativas,
      Value<DateTime>? criadoEm,
      Value<DateTime?>? proximaTentativaEm,
      Value<int>? rowid}) {
    return SyncQueueTableCompanion(
      id: id ?? this.id,
      entidade: entidade ?? this.entidade,
      operacao: operacao ?? this.operacao,
      payload: payload ?? this.payload,
      tentativas: tentativas ?? this.tentativas,
      criadoEm: criadoEm ?? this.criadoEm,
      proximaTentativaEm: proximaTentativaEm ?? this.proximaTentativaEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entidade.present) {
      map['entidade'] = Variable<String>(entidade.value);
    }
    if (operacao.present) {
      map['operacao'] = Variable<String>(operacao.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (tentativas.present) {
      map['tentativas'] = Variable<int>(tentativas.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (proximaTentativaEm.present) {
      map['proxima_tentativa_em'] =
          Variable<DateTime>(proximaTentativaEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueTableCompanion(')
          ..write('id: $id, ')
          ..write('entidade: $entidade, ')
          ..write('operacao: $operacao, ')
          ..write('payload: $payload, ')
          ..write('tentativas: $tentativas, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('proximaTentativaEm: $proximaTentativaEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GeocodingCacheTable extends GeocodingCache
    with TableInfo<$GeocodingCacheTable, GeocodingCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GeocodingCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _enderecoTextoMeta =
      const VerificationMeta('enderecoTexto');
  @override
  late final GeneratedColumn<String> enderecoTexto = GeneratedColumn<String>(
      'endereco_texto', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _criadoEmMeta =
      const VerificationMeta('criadoEm');
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
      'criado_em', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [enderecoTexto, latitude, longitude, criadoEm];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'geocoding_cache';
  @override
  VerificationContext validateIntegrity(Insertable<GeocodingCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('endereco_texto')) {
      context.handle(
          _enderecoTextoMeta,
          enderecoTexto.isAcceptableOrUnknown(
              data['endereco_texto']!, _enderecoTextoMeta));
    } else if (isInserting) {
      context.missing(_enderecoTextoMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('criado_em')) {
      context.handle(_criadoEmMeta,
          criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta));
    } else if (isInserting) {
      context.missing(_criadoEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {enderecoTexto};
  @override
  GeocodingCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GeocodingCacheData(
      enderecoTexto: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}endereco_texto'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      criadoEm: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}criado_em'])!,
    );
  }

  @override
  $GeocodingCacheTable createAlias(String alias) {
    return $GeocodingCacheTable(attachedDatabase, alias);
  }
}

class GeocodingCacheData extends DataClass
    implements Insertable<GeocodingCacheData> {
  final String enderecoTexto;
  final double latitude;
  final double longitude;
  final DateTime criadoEm;
  const GeocodingCacheData(
      {required this.enderecoTexto,
      required this.latitude,
      required this.longitude,
      required this.criadoEm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['endereco_texto'] = Variable<String>(enderecoTexto);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    return map;
  }

  GeocodingCacheCompanion toCompanion(bool nullToAbsent) {
    return GeocodingCacheCompanion(
      enderecoTexto: Value(enderecoTexto),
      latitude: Value(latitude),
      longitude: Value(longitude),
      criadoEm: Value(criadoEm),
    );
  }

  factory GeocodingCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GeocodingCacheData(
      enderecoTexto: serializer.fromJson<String>(json['enderecoTexto']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'enderecoTexto': serializer.toJson<String>(enderecoTexto),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
    };
  }

  GeocodingCacheData copyWith(
          {String? enderecoTexto,
          double? latitude,
          double? longitude,
          DateTime? criadoEm}) =>
      GeocodingCacheData(
        enderecoTexto: enderecoTexto ?? this.enderecoTexto,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        criadoEm: criadoEm ?? this.criadoEm,
      );
  GeocodingCacheData copyWithCompanion(GeocodingCacheCompanion data) {
    return GeocodingCacheData(
      enderecoTexto: data.enderecoTexto.present
          ? data.enderecoTexto.value
          : this.enderecoTexto,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GeocodingCacheData(')
          ..write('enderecoTexto: $enderecoTexto, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(enderecoTexto, latitude, longitude, criadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GeocodingCacheData &&
          other.enderecoTexto == this.enderecoTexto &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.criadoEm == this.criadoEm);
}

class GeocodingCacheCompanion extends UpdateCompanion<GeocodingCacheData> {
  final Value<String> enderecoTexto;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<DateTime> criadoEm;
  final Value<int> rowid;
  const GeocodingCacheCompanion({
    this.enderecoTexto = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GeocodingCacheCompanion.insert({
    required String enderecoTexto,
    required double latitude,
    required double longitude,
    required DateTime criadoEm,
    this.rowid = const Value.absent(),
  })  : enderecoTexto = Value(enderecoTexto),
        latitude = Value(latitude),
        longitude = Value(longitude),
        criadoEm = Value(criadoEm);
  static Insertable<GeocodingCacheData> custom({
    Expression<String>? enderecoTexto,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<DateTime>? criadoEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (enderecoTexto != null) 'endereco_texto': enderecoTexto,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GeocodingCacheCompanion copyWith(
      {Value<String>? enderecoTexto,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<DateTime>? criadoEm,
      Value<int>? rowid}) {
    return GeocodingCacheCompanion(
      enderecoTexto: enderecoTexto ?? this.enderecoTexto,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      criadoEm: criadoEm ?? this.criadoEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (enderecoTexto.present) {
      map['endereco_texto'] = Variable<String>(enderecoTexto.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GeocodingCacheCompanion(')
          ..write('enderecoTexto: $enderecoTexto, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientesTable clientes = $ClientesTable(this);
  late final $UsuariosTable usuarios = $UsuariosTable(this);
  late final $BasesTable bases = $BasesTable(this);
  late final $AtendimentosTable atendimentos = $AtendimentosTable(this);
  late final $PontosRastreamentoTable pontosRastreamento =
      $PontosRastreamentoTable(this);
  late final $SyncQueueTableTable syncQueueTable = $SyncQueueTableTable(this);
  late final $GeocodingCacheTable geocodingCache = $GeocodingCacheTable(this);
  late final Index idxAtendimentosStatus = Index('idx_atendimentos_status',
      'CREATE INDEX idx_atendimentos_status ON atendimentos (status)');
  late final Index idxAtendimentosCliente = Index('idx_atendimentos_cliente',
      'CREATE INDEX idx_atendimentos_cliente ON atendimentos (cliente_id)');
  late final Index idxAtendimentosCriado = Index('idx_atendimentos_criado',
      'CREATE INDEX idx_atendimentos_criado ON atendimentos (criado_em)');
  late final Index idxPontosAtendimento = Index('idx_pontos_atendimento',
      'CREATE INDEX idx_pontos_atendimento ON pontos_rastreamento (atendimento_id)');
  late final Index idxPontosSynced = Index('idx_pontos_synced',
      'CREATE INDEX idx_pontos_synced ON pontos_rastreamento (synced)');
  late final Index idxSyncProximaTentativa = Index('idx_sync_proxima_tentativa',
      'CREATE INDEX idx_sync_proxima_tentativa ON sync_queue (proxima_tentativa_em)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        clientes,
        usuarios,
        bases,
        atendimentos,
        pontosRastreamento,
        syncQueueTable,
        geocodingCache,
        idxAtendimentosStatus,
        idxAtendimentosCliente,
        idxAtendimentosCriado,
        idxPontosAtendimento,
        idxPontosSynced,
        idxSyncProximaTentativa
      ];
}

typedef $$ClientesTableCreateCompanionBuilder = ClientesCompanion Function({
  required String id,
  required String nome,
  required String telefone,
  Value<String?> documento,
  Value<String?> enderecoDefaultJson,
  required DateTime criadoEm,
  required DateTime atualizadoEm,
  Value<DateTime?> sincronizadoEm,
  Value<int> rowid,
});
typedef $$ClientesTableUpdateCompanionBuilder = ClientesCompanion Function({
  Value<String> id,
  Value<String> nome,
  Value<String> telefone,
  Value<String?> documento,
  Value<String?> enderecoDefaultJson,
  Value<DateTime> criadoEm,
  Value<DateTime> atualizadoEm,
  Value<DateTime?> sincronizadoEm,
  Value<int> rowid,
});

final class $$ClientesTableReferences
    extends BaseReferences<_$AppDatabase, $ClientesTable, Cliente> {
  $$ClientesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AtendimentosTable, List<Atendimento>>
      _atendimentosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.atendimentos,
          aliasName:
              $_aliasNameGenerator(db.clientes.id, db.atendimentos.clienteId));

  $$AtendimentosTableProcessedTableManager get atendimentosRefs {
    final manager = $$AtendimentosTableTableManager($_db, $_db.atendimentos)
        .filter((f) => f.clienteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_atendimentosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ClientesTableFilterComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telefone => $composableBuilder(
      column: $table.telefone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get documento => $composableBuilder(
      column: $table.documento, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get enderecoDefaultJson => $composableBuilder(
      column: $table.enderecoDefaultJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
      column: $table.atualizadoEm, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get sincronizadoEm => $composableBuilder(
      column: $table.sincronizadoEm,
      builder: (column) => ColumnFilters(column));

  Expression<bool> atendimentosRefs(
      Expression<bool> Function($$AtendimentosTableFilterComposer f) f) {
    final $$AtendimentosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.atendimentos,
        getReferencedColumn: (t) => t.clienteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AtendimentosTableFilterComposer(
              $db: $db,
              $table: $db.atendimentos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClientesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telefone => $composableBuilder(
      column: $table.telefone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get documento => $composableBuilder(
      column: $table.documento, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get enderecoDefaultJson => $composableBuilder(
      column: $table.enderecoDefaultJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
      column: $table.atualizadoEm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get sincronizadoEm => $composableBuilder(
      column: $table.sincronizadoEm,
      builder: (column) => ColumnOrderings(column));
}

class $$ClientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get telefone =>
      $composableBuilder(column: $table.telefone, builder: (column) => column);

  GeneratedColumn<String> get documento =>
      $composableBuilder(column: $table.documento, builder: (column) => column);

  GeneratedColumn<String> get enderecoDefaultJson => $composableBuilder(
      column: $table.enderecoDefaultJson, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
      column: $table.atualizadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get sincronizadoEm => $composableBuilder(
      column: $table.sincronizadoEm, builder: (column) => column);

  Expression<T> atendimentosRefs<T extends Object>(
      Expression<T> Function($$AtendimentosTableAnnotationComposer a) f) {
    final $$AtendimentosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.atendimentos,
        getReferencedColumn: (t) => t.clienteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AtendimentosTableAnnotationComposer(
              $db: $db,
              $table: $db.atendimentos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClientesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ClientesTable,
    Cliente,
    $$ClientesTableFilterComposer,
    $$ClientesTableOrderingComposer,
    $$ClientesTableAnnotationComposer,
    $$ClientesTableCreateCompanionBuilder,
    $$ClientesTableUpdateCompanionBuilder,
    (Cliente, $$ClientesTableReferences),
    Cliente,
    PrefetchHooks Function({bool atendimentosRefs})> {
  $$ClientesTableTableManager(_$AppDatabase db, $ClientesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String> telefone = const Value.absent(),
            Value<String?> documento = const Value.absent(),
            Value<String?> enderecoDefaultJson = const Value.absent(),
            Value<DateTime> criadoEm = const Value.absent(),
            Value<DateTime> atualizadoEm = const Value.absent(),
            Value<DateTime?> sincronizadoEm = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ClientesCompanion(
            id: id,
            nome: nome,
            telefone: telefone,
            documento: documento,
            enderecoDefaultJson: enderecoDefaultJson,
            criadoEm: criadoEm,
            atualizadoEm: atualizadoEm,
            sincronizadoEm: sincronizadoEm,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nome,
            required String telefone,
            Value<String?> documento = const Value.absent(),
            Value<String?> enderecoDefaultJson = const Value.absent(),
            required DateTime criadoEm,
            required DateTime atualizadoEm,
            Value<DateTime?> sincronizadoEm = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ClientesCompanion.insert(
            id: id,
            nome: nome,
            telefone: telefone,
            documento: documento,
            enderecoDefaultJson: enderecoDefaultJson,
            criadoEm: criadoEm,
            atualizadoEm: atualizadoEm,
            sincronizadoEm: sincronizadoEm,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ClientesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({atendimentosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (atendimentosRefs) db.atendimentos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (atendimentosRefs)
                    await $_getPrefetchedData<Cliente, $ClientesTable,
                            Atendimento>(
                        currentTable: table,
                        referencedTable: $$ClientesTableReferences
                            ._atendimentosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ClientesTableReferences(db, table, p0)
                                .atendimentosRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.clienteId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ClientesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ClientesTable,
    Cliente,
    $$ClientesTableFilterComposer,
    $$ClientesTableOrderingComposer,
    $$ClientesTableAnnotationComposer,
    $$ClientesTableCreateCompanionBuilder,
    $$ClientesTableUpdateCompanionBuilder,
    (Cliente, $$ClientesTableReferences),
    Cliente,
    PrefetchHooks Function({bool atendimentosRefs})>;
typedef $$UsuariosTableCreateCompanionBuilder = UsuariosCompanion Function({
  required String id,
  required String nome,
  required String telefone,
  required String email,
  required String role,
  Value<double> valorPorKmDefault,
  required DateTime criadoEm,
  Value<DateTime?> sincronizadoEm,
  Value<int> rowid,
});
typedef $$UsuariosTableUpdateCompanionBuilder = UsuariosCompanion Function({
  Value<String> id,
  Value<String> nome,
  Value<String> telefone,
  Value<String> email,
  Value<String> role,
  Value<double> valorPorKmDefault,
  Value<DateTime> criadoEm,
  Value<DateTime?> sincronizadoEm,
  Value<int> rowid,
});

final class $$UsuariosTableReferences
    extends BaseReferences<_$AppDatabase, $UsuariosTable, Usuario> {
  $$UsuariosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AtendimentosTable, List<Atendimento>>
      _atendimentosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.atendimentos,
          aliasName:
              $_aliasNameGenerator(db.usuarios.id, db.atendimentos.usuarioId));

  $$AtendimentosTableProcessedTableManager get atendimentosRefs {
    final manager = $$AtendimentosTableTableManager($_db, $_db.atendimentos)
        .filter((f) => f.usuarioId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_atendimentosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsuariosTableFilterComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telefone => $composableBuilder(
      column: $table.telefone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get valorPorKmDefault => $composableBuilder(
      column: $table.valorPorKmDefault,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get sincronizadoEm => $composableBuilder(
      column: $table.sincronizadoEm,
      builder: (column) => ColumnFilters(column));

  Expression<bool> atendimentosRefs(
      Expression<bool> Function($$AtendimentosTableFilterComposer f) f) {
    final $$AtendimentosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.atendimentos,
        getReferencedColumn: (t) => t.usuarioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AtendimentosTableFilterComposer(
              $db: $db,
              $table: $db.atendimentos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsuariosTableOrderingComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telefone => $composableBuilder(
      column: $table.telefone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get valorPorKmDefault => $composableBuilder(
      column: $table.valorPorKmDefault,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get sincronizadoEm => $composableBuilder(
      column: $table.sincronizadoEm,
      builder: (column) => ColumnOrderings(column));
}

class $$UsuariosTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get telefone =>
      $composableBuilder(column: $table.telefone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<double> get valorPorKmDefault => $composableBuilder(
      column: $table.valorPorKmDefault, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get sincronizadoEm => $composableBuilder(
      column: $table.sincronizadoEm, builder: (column) => column);

  Expression<T> atendimentosRefs<T extends Object>(
      Expression<T> Function($$AtendimentosTableAnnotationComposer a) f) {
    final $$AtendimentosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.atendimentos,
        getReferencedColumn: (t) => t.usuarioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AtendimentosTableAnnotationComposer(
              $db: $db,
              $table: $db.atendimentos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsuariosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsuariosTable,
    Usuario,
    $$UsuariosTableFilterComposer,
    $$UsuariosTableOrderingComposer,
    $$UsuariosTableAnnotationComposer,
    $$UsuariosTableCreateCompanionBuilder,
    $$UsuariosTableUpdateCompanionBuilder,
    (Usuario, $$UsuariosTableReferences),
    Usuario,
    PrefetchHooks Function({bool atendimentosRefs})> {
  $$UsuariosTableTableManager(_$AppDatabase db, $UsuariosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsuariosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsuariosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsuariosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String> telefone = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<double> valorPorKmDefault = const Value.absent(),
            Value<DateTime> criadoEm = const Value.absent(),
            Value<DateTime?> sincronizadoEm = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsuariosCompanion(
            id: id,
            nome: nome,
            telefone: telefone,
            email: email,
            role: role,
            valorPorKmDefault: valorPorKmDefault,
            criadoEm: criadoEm,
            sincronizadoEm: sincronizadoEm,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nome,
            required String telefone,
            required String email,
            required String role,
            Value<double> valorPorKmDefault = const Value.absent(),
            required DateTime criadoEm,
            Value<DateTime?> sincronizadoEm = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsuariosCompanion.insert(
            id: id,
            nome: nome,
            telefone: telefone,
            email: email,
            role: role,
            valorPorKmDefault: valorPorKmDefault,
            criadoEm: criadoEm,
            sincronizadoEm: sincronizadoEm,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UsuariosTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({atendimentosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (atendimentosRefs) db.atendimentos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (atendimentosRefs)
                    await $_getPrefetchedData<Usuario, $UsuariosTable,
                            Atendimento>(
                        currentTable: table,
                        referencedTable: $$UsuariosTableReferences
                            ._atendimentosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsuariosTableReferences(db, table, p0)
                                .atendimentosRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.usuarioId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsuariosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsuariosTable,
    Usuario,
    $$UsuariosTableFilterComposer,
    $$UsuariosTableOrderingComposer,
    $$UsuariosTableAnnotationComposer,
    $$UsuariosTableCreateCompanionBuilder,
    $$UsuariosTableUpdateCompanionBuilder,
    (Usuario, $$UsuariosTableReferences),
    Usuario,
    PrefetchHooks Function({bool atendimentosRefs})>;
typedef $$BasesTableCreateCompanionBuilder = BasesCompanion Function({
  required String id,
  required String nome,
  required String localJson,
  Value<bool> isPrincipal,
  required DateTime criadoEm,
  Value<DateTime?> sincronizadoEm,
  Value<int> rowid,
});
typedef $$BasesTableUpdateCompanionBuilder = BasesCompanion Function({
  Value<String> id,
  Value<String> nome,
  Value<String> localJson,
  Value<bool> isPrincipal,
  Value<DateTime> criadoEm,
  Value<DateTime?> sincronizadoEm,
  Value<int> rowid,
});

class $$BasesTableFilterComposer extends Composer<_$AppDatabase, $BasesTable> {
  $$BasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localJson => $composableBuilder(
      column: $table.localJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPrincipal => $composableBuilder(
      column: $table.isPrincipal, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get sincronizadoEm => $composableBuilder(
      column: $table.sincronizadoEm,
      builder: (column) => ColumnFilters(column));
}

class $$BasesTableOrderingComposer
    extends Composer<_$AppDatabase, $BasesTable> {
  $$BasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localJson => $composableBuilder(
      column: $table.localJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPrincipal => $composableBuilder(
      column: $table.isPrincipal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get sincronizadoEm => $composableBuilder(
      column: $table.sincronizadoEm,
      builder: (column) => ColumnOrderings(column));
}

class $$BasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BasesTable> {
  $$BasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get localJson =>
      $composableBuilder(column: $table.localJson, builder: (column) => column);

  GeneratedColumn<bool> get isPrincipal => $composableBuilder(
      column: $table.isPrincipal, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get sincronizadoEm => $composableBuilder(
      column: $table.sincronizadoEm, builder: (column) => column);
}

class $$BasesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BasesTable,
    Base,
    $$BasesTableFilterComposer,
    $$BasesTableOrderingComposer,
    $$BasesTableAnnotationComposer,
    $$BasesTableCreateCompanionBuilder,
    $$BasesTableUpdateCompanionBuilder,
    (Base, BaseReferences<_$AppDatabase, $BasesTable, Base>),
    Base,
    PrefetchHooks Function()> {
  $$BasesTableTableManager(_$AppDatabase db, $BasesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String> localJson = const Value.absent(),
            Value<bool> isPrincipal = const Value.absent(),
            Value<DateTime> criadoEm = const Value.absent(),
            Value<DateTime?> sincronizadoEm = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BasesCompanion(
            id: id,
            nome: nome,
            localJson: localJson,
            isPrincipal: isPrincipal,
            criadoEm: criadoEm,
            sincronizadoEm: sincronizadoEm,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nome,
            required String localJson,
            Value<bool> isPrincipal = const Value.absent(),
            required DateTime criadoEm,
            Value<DateTime?> sincronizadoEm = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BasesCompanion.insert(
            id: id,
            nome: nome,
            localJson: localJson,
            isPrincipal: isPrincipal,
            criadoEm: criadoEm,
            sincronizadoEm: sincronizadoEm,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BasesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BasesTable,
    Base,
    $$BasesTableFilterComposer,
    $$BasesTableOrderingComposer,
    $$BasesTableAnnotationComposer,
    $$BasesTableCreateCompanionBuilder,
    $$BasesTableUpdateCompanionBuilder,
    (Base, BaseReferences<_$AppDatabase, $BasesTable, Base>),
    Base,
    PrefetchHooks Function()>;
typedef $$AtendimentosTableCreateCompanionBuilder = AtendimentosCompanion
    Function({
  required String id,
  required String clienteId,
  required String usuarioId,
  required String pontoDeSaidaJson,
  required String localDeColetaJson,
  required String localDeEntregaJson,
  required String localDeRetornoJson,
  required double valorPorKm,
  required double distanciaEstimadaKm,
  Value<double?> distanciaRealKm,
  Value<double?> valorCobrado,
  required String tipoValor,
  required String status,
  Value<String?> observacoes,
  required DateTime criadoEm,
  required DateTime atualizadoEm,
  Value<DateTime?> iniciadoEm,
  Value<DateTime?> chegadaColetaEm,
  Value<DateTime?> chegadaEntregaEm,
  Value<DateTime?> inicioRetornoEm,
  Value<DateTime?> concluidoEm,
  Value<DateTime?> sincronizadoEm,
  Value<int> rowid,
});
typedef $$AtendimentosTableUpdateCompanionBuilder = AtendimentosCompanion
    Function({
  Value<String> id,
  Value<String> clienteId,
  Value<String> usuarioId,
  Value<String> pontoDeSaidaJson,
  Value<String> localDeColetaJson,
  Value<String> localDeEntregaJson,
  Value<String> localDeRetornoJson,
  Value<double> valorPorKm,
  Value<double> distanciaEstimadaKm,
  Value<double?> distanciaRealKm,
  Value<double?> valorCobrado,
  Value<String> tipoValor,
  Value<String> status,
  Value<String?> observacoes,
  Value<DateTime> criadoEm,
  Value<DateTime> atualizadoEm,
  Value<DateTime?> iniciadoEm,
  Value<DateTime?> chegadaColetaEm,
  Value<DateTime?> chegadaEntregaEm,
  Value<DateTime?> inicioRetornoEm,
  Value<DateTime?> concluidoEm,
  Value<DateTime?> sincronizadoEm,
  Value<int> rowid,
});

final class $$AtendimentosTableReferences
    extends BaseReferences<_$AppDatabase, $AtendimentosTable, Atendimento> {
  $$AtendimentosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientesTable _clienteIdTable(_$AppDatabase db) =>
      db.clientes.createAlias(
          $_aliasNameGenerator(db.atendimentos.clienteId, db.clientes.id));

  $$ClientesTableProcessedTableManager get clienteId {
    final $_column = $_itemColumn<String>('cliente_id')!;

    final manager = $$ClientesTableTableManager($_db, $_db.clientes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsuariosTable _usuarioIdTable(_$AppDatabase db) =>
      db.usuarios.createAlias(
          $_aliasNameGenerator(db.atendimentos.usuarioId, db.usuarios.id));

  $$UsuariosTableProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<String>('usuario_id')!;

    final manager = $$UsuariosTableTableManager($_db, $_db.usuarios)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PontosRastreamentoTable,
      List<PontosRastreamentoData>> _pontosRastreamentoRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.pontosRastreamento,
          aliasName: $_aliasNameGenerator(
              db.atendimentos.id, db.pontosRastreamento.atendimentoId));

  $$PontosRastreamentoTableProcessedTableManager get pontosRastreamentoRefs {
    final manager = $$PontosRastreamentoTableTableManager(
            $_db, $_db.pontosRastreamento)
        .filter(
            (f) => f.atendimentoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_pontosRastreamentoRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AtendimentosTableFilterComposer
    extends Composer<_$AppDatabase, $AtendimentosTable> {
  $$AtendimentosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pontoDeSaidaJson => $composableBuilder(
      column: $table.pontoDeSaidaJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localDeColetaJson => $composableBuilder(
      column: $table.localDeColetaJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localDeEntregaJson => $composableBuilder(
      column: $table.localDeEntregaJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localDeRetornoJson => $composableBuilder(
      column: $table.localDeRetornoJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get valorPorKm => $composableBuilder(
      column: $table.valorPorKm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get distanciaEstimadaKm => $composableBuilder(
      column: $table.distanciaEstimadaKm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get distanciaRealKm => $composableBuilder(
      column: $table.distanciaRealKm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get valorCobrado => $composableBuilder(
      column: $table.valorCobrado, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipoValor => $composableBuilder(
      column: $table.tipoValor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
      column: $table.atualizadoEm, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get iniciadoEm => $composableBuilder(
      column: $table.iniciadoEm, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get chegadaColetaEm => $composableBuilder(
      column: $table.chegadaColetaEm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get chegadaEntregaEm => $composableBuilder(
      column: $table.chegadaEntregaEm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get inicioRetornoEm => $composableBuilder(
      column: $table.inicioRetornoEm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get concluidoEm => $composableBuilder(
      column: $table.concluidoEm, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get sincronizadoEm => $composableBuilder(
      column: $table.sincronizadoEm,
      builder: (column) => ColumnFilters(column));

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clienteId,
        referencedTable: $db.clientes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientesTableFilterComposer(
              $db: $db,
              $table: $db.clientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsuariosTableFilterComposer get usuarioId {
    final $$UsuariosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.usuarioId,
        referencedTable: $db.usuarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsuariosTableFilterComposer(
              $db: $db,
              $table: $db.usuarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> pontosRastreamentoRefs(
      Expression<bool> Function($$PontosRastreamentoTableFilterComposer f) f) {
    final $$PontosRastreamentoTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.pontosRastreamento,
        getReferencedColumn: (t) => t.atendimentoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PontosRastreamentoTableFilterComposer(
              $db: $db,
              $table: $db.pontosRastreamento,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AtendimentosTableOrderingComposer
    extends Composer<_$AppDatabase, $AtendimentosTable> {
  $$AtendimentosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pontoDeSaidaJson => $composableBuilder(
      column: $table.pontoDeSaidaJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localDeColetaJson => $composableBuilder(
      column: $table.localDeColetaJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localDeEntregaJson => $composableBuilder(
      column: $table.localDeEntregaJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localDeRetornoJson => $composableBuilder(
      column: $table.localDeRetornoJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get valorPorKm => $composableBuilder(
      column: $table.valorPorKm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get distanciaEstimadaKm => $composableBuilder(
      column: $table.distanciaEstimadaKm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get distanciaRealKm => $composableBuilder(
      column: $table.distanciaRealKm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get valorCobrado => $composableBuilder(
      column: $table.valorCobrado,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipoValor => $composableBuilder(
      column: $table.tipoValor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
      column: $table.atualizadoEm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get iniciadoEm => $composableBuilder(
      column: $table.iniciadoEm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get chegadaColetaEm => $composableBuilder(
      column: $table.chegadaColetaEm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get chegadaEntregaEm => $composableBuilder(
      column: $table.chegadaEntregaEm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get inicioRetornoEm => $composableBuilder(
      column: $table.inicioRetornoEm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get concluidoEm => $composableBuilder(
      column: $table.concluidoEm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get sincronizadoEm => $composableBuilder(
      column: $table.sincronizadoEm,
      builder: (column) => ColumnOrderings(column));

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clienteId,
        referencedTable: $db.clientes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientesTableOrderingComposer(
              $db: $db,
              $table: $db.clientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsuariosTableOrderingComposer get usuarioId {
    final $$UsuariosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.usuarioId,
        referencedTable: $db.usuarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsuariosTableOrderingComposer(
              $db: $db,
              $table: $db.usuarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AtendimentosTableAnnotationComposer
    extends Composer<_$AppDatabase, $AtendimentosTable> {
  $$AtendimentosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pontoDeSaidaJson => $composableBuilder(
      column: $table.pontoDeSaidaJson, builder: (column) => column);

  GeneratedColumn<String> get localDeColetaJson => $composableBuilder(
      column: $table.localDeColetaJson, builder: (column) => column);

  GeneratedColumn<String> get localDeEntregaJson => $composableBuilder(
      column: $table.localDeEntregaJson, builder: (column) => column);

  GeneratedColumn<String> get localDeRetornoJson => $composableBuilder(
      column: $table.localDeRetornoJson, builder: (column) => column);

  GeneratedColumn<double> get valorPorKm => $composableBuilder(
      column: $table.valorPorKm, builder: (column) => column);

  GeneratedColumn<double> get distanciaEstimadaKm => $composableBuilder(
      column: $table.distanciaEstimadaKm, builder: (column) => column);

  GeneratedColumn<double> get distanciaRealKm => $composableBuilder(
      column: $table.distanciaRealKm, builder: (column) => column);

  GeneratedColumn<double> get valorCobrado => $composableBuilder(
      column: $table.valorCobrado, builder: (column) => column);

  GeneratedColumn<String> get tipoValor =>
      $composableBuilder(column: $table.tipoValor, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get observacoes => $composableBuilder(
      column: $table.observacoes, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
      column: $table.atualizadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get iniciadoEm => $composableBuilder(
      column: $table.iniciadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get chegadaColetaEm => $composableBuilder(
      column: $table.chegadaColetaEm, builder: (column) => column);

  GeneratedColumn<DateTime> get chegadaEntregaEm => $composableBuilder(
      column: $table.chegadaEntregaEm, builder: (column) => column);

  GeneratedColumn<DateTime> get inicioRetornoEm => $composableBuilder(
      column: $table.inicioRetornoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get concluidoEm => $composableBuilder(
      column: $table.concluidoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get sincronizadoEm => $composableBuilder(
      column: $table.sincronizadoEm, builder: (column) => column);

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clienteId,
        referencedTable: $db.clientes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientesTableAnnotationComposer(
              $db: $db,
              $table: $db.clientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsuariosTableAnnotationComposer get usuarioId {
    final $$UsuariosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.usuarioId,
        referencedTable: $db.usuarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsuariosTableAnnotationComposer(
              $db: $db,
              $table: $db.usuarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> pontosRastreamentoRefs<T extends Object>(
      Expression<T> Function($$PontosRastreamentoTableAnnotationComposer a) f) {
    final $$PontosRastreamentoTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.pontosRastreamento,
            getReferencedColumn: (t) => t.atendimentoId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PontosRastreamentoTableAnnotationComposer(
                  $db: $db,
                  $table: $db.pontosRastreamento,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$AtendimentosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AtendimentosTable,
    Atendimento,
    $$AtendimentosTableFilterComposer,
    $$AtendimentosTableOrderingComposer,
    $$AtendimentosTableAnnotationComposer,
    $$AtendimentosTableCreateCompanionBuilder,
    $$AtendimentosTableUpdateCompanionBuilder,
    (Atendimento, $$AtendimentosTableReferences),
    Atendimento,
    PrefetchHooks Function(
        {bool clienteId, bool usuarioId, bool pontosRastreamentoRefs})> {
  $$AtendimentosTableTableManager(_$AppDatabase db, $AtendimentosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AtendimentosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AtendimentosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AtendimentosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> clienteId = const Value.absent(),
            Value<String> usuarioId = const Value.absent(),
            Value<String> pontoDeSaidaJson = const Value.absent(),
            Value<String> localDeColetaJson = const Value.absent(),
            Value<String> localDeEntregaJson = const Value.absent(),
            Value<String> localDeRetornoJson = const Value.absent(),
            Value<double> valorPorKm = const Value.absent(),
            Value<double> distanciaEstimadaKm = const Value.absent(),
            Value<double?> distanciaRealKm = const Value.absent(),
            Value<double?> valorCobrado = const Value.absent(),
            Value<String> tipoValor = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> observacoes = const Value.absent(),
            Value<DateTime> criadoEm = const Value.absent(),
            Value<DateTime> atualizadoEm = const Value.absent(),
            Value<DateTime?> iniciadoEm = const Value.absent(),
            Value<DateTime?> chegadaColetaEm = const Value.absent(),
            Value<DateTime?> chegadaEntregaEm = const Value.absent(),
            Value<DateTime?> inicioRetornoEm = const Value.absent(),
            Value<DateTime?> concluidoEm = const Value.absent(),
            Value<DateTime?> sincronizadoEm = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AtendimentosCompanion(
            id: id,
            clienteId: clienteId,
            usuarioId: usuarioId,
            pontoDeSaidaJson: pontoDeSaidaJson,
            localDeColetaJson: localDeColetaJson,
            localDeEntregaJson: localDeEntregaJson,
            localDeRetornoJson: localDeRetornoJson,
            valorPorKm: valorPorKm,
            distanciaEstimadaKm: distanciaEstimadaKm,
            distanciaRealKm: distanciaRealKm,
            valorCobrado: valorCobrado,
            tipoValor: tipoValor,
            status: status,
            observacoes: observacoes,
            criadoEm: criadoEm,
            atualizadoEm: atualizadoEm,
            iniciadoEm: iniciadoEm,
            chegadaColetaEm: chegadaColetaEm,
            chegadaEntregaEm: chegadaEntregaEm,
            inicioRetornoEm: inicioRetornoEm,
            concluidoEm: concluidoEm,
            sincronizadoEm: sincronizadoEm,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String clienteId,
            required String usuarioId,
            required String pontoDeSaidaJson,
            required String localDeColetaJson,
            required String localDeEntregaJson,
            required String localDeRetornoJson,
            required double valorPorKm,
            required double distanciaEstimadaKm,
            Value<double?> distanciaRealKm = const Value.absent(),
            Value<double?> valorCobrado = const Value.absent(),
            required String tipoValor,
            required String status,
            Value<String?> observacoes = const Value.absent(),
            required DateTime criadoEm,
            required DateTime atualizadoEm,
            Value<DateTime?> iniciadoEm = const Value.absent(),
            Value<DateTime?> chegadaColetaEm = const Value.absent(),
            Value<DateTime?> chegadaEntregaEm = const Value.absent(),
            Value<DateTime?> inicioRetornoEm = const Value.absent(),
            Value<DateTime?> concluidoEm = const Value.absent(),
            Value<DateTime?> sincronizadoEm = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AtendimentosCompanion.insert(
            id: id,
            clienteId: clienteId,
            usuarioId: usuarioId,
            pontoDeSaidaJson: pontoDeSaidaJson,
            localDeColetaJson: localDeColetaJson,
            localDeEntregaJson: localDeEntregaJson,
            localDeRetornoJson: localDeRetornoJson,
            valorPorKm: valorPorKm,
            distanciaEstimadaKm: distanciaEstimadaKm,
            distanciaRealKm: distanciaRealKm,
            valorCobrado: valorCobrado,
            tipoValor: tipoValor,
            status: status,
            observacoes: observacoes,
            criadoEm: criadoEm,
            atualizadoEm: atualizadoEm,
            iniciadoEm: iniciadoEm,
            chegadaColetaEm: chegadaColetaEm,
            chegadaEntregaEm: chegadaEntregaEm,
            inicioRetornoEm: inicioRetornoEm,
            concluidoEm: concluidoEm,
            sincronizadoEm: sincronizadoEm,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AtendimentosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {clienteId = false,
              usuarioId = false,
              pontosRastreamentoRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (pontosRastreamentoRefs) db.pontosRastreamento
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (clienteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.clienteId,
                    referencedTable:
                        $$AtendimentosTableReferences._clienteIdTable(db),
                    referencedColumn:
                        $$AtendimentosTableReferences._clienteIdTable(db).id,
                  ) as T;
                }
                if (usuarioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.usuarioId,
                    referencedTable:
                        $$AtendimentosTableReferences._usuarioIdTable(db),
                    referencedColumn:
                        $$AtendimentosTableReferences._usuarioIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (pontosRastreamentoRefs)
                    await $_getPrefetchedData<Atendimento, $AtendimentosTable,
                            PontosRastreamentoData>(
                        currentTable: table,
                        referencedTable: $$AtendimentosTableReferences
                            ._pontosRastreamentoRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AtendimentosTableReferences(db, table, p0)
                                .pontosRastreamentoRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.atendimentoId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AtendimentosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AtendimentosTable,
    Atendimento,
    $$AtendimentosTableFilterComposer,
    $$AtendimentosTableOrderingComposer,
    $$AtendimentosTableAnnotationComposer,
    $$AtendimentosTableCreateCompanionBuilder,
    $$AtendimentosTableUpdateCompanionBuilder,
    (Atendimento, $$AtendimentosTableReferences),
    Atendimento,
    PrefetchHooks Function(
        {bool clienteId, bool usuarioId, bool pontosRastreamentoRefs})>;
typedef $$PontosRastreamentoTableCreateCompanionBuilder
    = PontosRastreamentoCompanion Function({
  required String id,
  required String atendimentoId,
  required double latitude,
  required double longitude,
  required double accuracy,
  Value<double?> velocidade,
  required DateTime timestamp,
  Value<bool> synced,
  Value<int> rowid,
});
typedef $$PontosRastreamentoTableUpdateCompanionBuilder
    = PontosRastreamentoCompanion Function({
  Value<String> id,
  Value<String> atendimentoId,
  Value<double> latitude,
  Value<double> longitude,
  Value<double> accuracy,
  Value<double?> velocidade,
  Value<DateTime> timestamp,
  Value<bool> synced,
  Value<int> rowid,
});

final class $$PontosRastreamentoTableReferences extends BaseReferences<
    _$AppDatabase, $PontosRastreamentoTable, PontosRastreamentoData> {
  $$PontosRastreamentoTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $AtendimentosTable _atendimentoIdTable(_$AppDatabase db) =>
      db.atendimentos.createAlias($_aliasNameGenerator(
          db.pontosRastreamento.atendimentoId, db.atendimentos.id));

  $$AtendimentosTableProcessedTableManager get atendimentoId {
    final $_column = $_itemColumn<String>('atendimento_id')!;

    final manager = $$AtendimentosTableTableManager($_db, $_db.atendimentos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_atendimentoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PontosRastreamentoTableFilterComposer
    extends Composer<_$AppDatabase, $PontosRastreamentoTable> {
  $$PontosRastreamentoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get accuracy => $composableBuilder(
      column: $table.accuracy, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get velocidade => $composableBuilder(
      column: $table.velocidade, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));

  $$AtendimentosTableFilterComposer get atendimentoId {
    final $$AtendimentosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.atendimentoId,
        referencedTable: $db.atendimentos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AtendimentosTableFilterComposer(
              $db: $db,
              $table: $db.atendimentos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PontosRastreamentoTableOrderingComposer
    extends Composer<_$AppDatabase, $PontosRastreamentoTable> {
  $$PontosRastreamentoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get accuracy => $composableBuilder(
      column: $table.accuracy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get velocidade => $composableBuilder(
      column: $table.velocidade, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));

  $$AtendimentosTableOrderingComposer get atendimentoId {
    final $$AtendimentosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.atendimentoId,
        referencedTable: $db.atendimentos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AtendimentosTableOrderingComposer(
              $db: $db,
              $table: $db.atendimentos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PontosRastreamentoTableAnnotationComposer
    extends Composer<_$AppDatabase, $PontosRastreamentoTable> {
  $$PontosRastreamentoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => column);

  GeneratedColumn<double> get velocidade => $composableBuilder(
      column: $table.velocidade, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  $$AtendimentosTableAnnotationComposer get atendimentoId {
    final $$AtendimentosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.atendimentoId,
        referencedTable: $db.atendimentos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AtendimentosTableAnnotationComposer(
              $db: $db,
              $table: $db.atendimentos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PontosRastreamentoTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PontosRastreamentoTable,
    PontosRastreamentoData,
    $$PontosRastreamentoTableFilterComposer,
    $$PontosRastreamentoTableOrderingComposer,
    $$PontosRastreamentoTableAnnotationComposer,
    $$PontosRastreamentoTableCreateCompanionBuilder,
    $$PontosRastreamentoTableUpdateCompanionBuilder,
    (PontosRastreamentoData, $$PontosRastreamentoTableReferences),
    PontosRastreamentoData,
    PrefetchHooks Function({bool atendimentoId})> {
  $$PontosRastreamentoTableTableManager(
      _$AppDatabase db, $PontosRastreamentoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PontosRastreamentoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PontosRastreamentoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PontosRastreamentoTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> atendimentoId = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<double> accuracy = const Value.absent(),
            Value<double?> velocidade = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PontosRastreamentoCompanion(
            id: id,
            atendimentoId: atendimentoId,
            latitude: latitude,
            longitude: longitude,
            accuracy: accuracy,
            velocidade: velocidade,
            timestamp: timestamp,
            synced: synced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String atendimentoId,
            required double latitude,
            required double longitude,
            required double accuracy,
            Value<double?> velocidade = const Value.absent(),
            required DateTime timestamp,
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PontosRastreamentoCompanion.insert(
            id: id,
            atendimentoId: atendimentoId,
            latitude: latitude,
            longitude: longitude,
            accuracy: accuracy,
            velocidade: velocidade,
            timestamp: timestamp,
            synced: synced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PontosRastreamentoTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({atendimentoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (atendimentoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.atendimentoId,
                    referencedTable: $$PontosRastreamentoTableReferences
                        ._atendimentoIdTable(db),
                    referencedColumn: $$PontosRastreamentoTableReferences
                        ._atendimentoIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PontosRastreamentoTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PontosRastreamentoTable,
    PontosRastreamentoData,
    $$PontosRastreamentoTableFilterComposer,
    $$PontosRastreamentoTableOrderingComposer,
    $$PontosRastreamentoTableAnnotationComposer,
    $$PontosRastreamentoTableCreateCompanionBuilder,
    $$PontosRastreamentoTableUpdateCompanionBuilder,
    (PontosRastreamentoData, $$PontosRastreamentoTableReferences),
    PontosRastreamentoData,
    PrefetchHooks Function({bool atendimentoId})>;
typedef $$SyncQueueTableTableCreateCompanionBuilder = SyncQueueTableCompanion
    Function({
  required String id,
  required String entidade,
  required String operacao,
  required String payload,
  Value<int> tentativas,
  required DateTime criadoEm,
  Value<DateTime?> proximaTentativaEm,
  Value<int> rowid,
});
typedef $$SyncQueueTableTableUpdateCompanionBuilder = SyncQueueTableCompanion
    Function({
  Value<String> id,
  Value<String> entidade,
  Value<String> operacao,
  Value<String> payload,
  Value<int> tentativas,
  Value<DateTime> criadoEm,
  Value<DateTime?> proximaTentativaEm,
  Value<int> rowid,
});

class $$SyncQueueTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entidade => $composableBuilder(
      column: $table.entidade, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operacao => $composableBuilder(
      column: $table.operacao, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tentativas => $composableBuilder(
      column: $table.tentativas, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get proximaTentativaEm => $composableBuilder(
      column: $table.proximaTentativaEm,
      builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entidade => $composableBuilder(
      column: $table.entidade, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operacao => $composableBuilder(
      column: $table.operacao, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tentativas => $composableBuilder(
      column: $table.tentativas, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get proximaTentativaEm => $composableBuilder(
      column: $table.proximaTentativaEm,
      builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entidade =>
      $composableBuilder(column: $table.entidade, builder: (column) => column);

  GeneratedColumn<String> get operacao =>
      $composableBuilder(column: $table.operacao, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get tentativas => $composableBuilder(
      column: $table.tentativas, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get proximaTentativaEm => $composableBuilder(
      column: $table.proximaTentativaEm, builder: (column) => column);
}

class $$SyncQueueTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTableTable,
    SyncQueueEntry,
    $$SyncQueueTableTableFilterComposer,
    $$SyncQueueTableTableOrderingComposer,
    $$SyncQueueTableTableAnnotationComposer,
    $$SyncQueueTableTableCreateCompanionBuilder,
    $$SyncQueueTableTableUpdateCompanionBuilder,
    (
      SyncQueueEntry,
      BaseReferences<_$AppDatabase, $SyncQueueTableTable, SyncQueueEntry>
    ),
    SyncQueueEntry,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableTableManager(
      _$AppDatabase db, $SyncQueueTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entidade = const Value.absent(),
            Value<String> operacao = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<int> tentativas = const Value.absent(),
            Value<DateTime> criadoEm = const Value.absent(),
            Value<DateTime?> proximaTentativaEm = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueTableCompanion(
            id: id,
            entidade: entidade,
            operacao: operacao,
            payload: payload,
            tentativas: tentativas,
            criadoEm: criadoEm,
            proximaTentativaEm: proximaTentativaEm,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entidade,
            required String operacao,
            required String payload,
            Value<int> tentativas = const Value.absent(),
            required DateTime criadoEm,
            Value<DateTime?> proximaTentativaEm = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueTableCompanion.insert(
            id: id,
            entidade: entidade,
            operacao: operacao,
            payload: payload,
            tentativas: tentativas,
            criadoEm: criadoEm,
            proximaTentativaEm: proximaTentativaEm,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTableTable,
    SyncQueueEntry,
    $$SyncQueueTableTableFilterComposer,
    $$SyncQueueTableTableOrderingComposer,
    $$SyncQueueTableTableAnnotationComposer,
    $$SyncQueueTableTableCreateCompanionBuilder,
    $$SyncQueueTableTableUpdateCompanionBuilder,
    (
      SyncQueueEntry,
      BaseReferences<_$AppDatabase, $SyncQueueTableTable, SyncQueueEntry>
    ),
    SyncQueueEntry,
    PrefetchHooks Function()>;
typedef $$GeocodingCacheTableCreateCompanionBuilder = GeocodingCacheCompanion
    Function({
  required String enderecoTexto,
  required double latitude,
  required double longitude,
  required DateTime criadoEm,
  Value<int> rowid,
});
typedef $$GeocodingCacheTableUpdateCompanionBuilder = GeocodingCacheCompanion
    Function({
  Value<String> enderecoTexto,
  Value<double> latitude,
  Value<double> longitude,
  Value<DateTime> criadoEm,
  Value<int> rowid,
});

class $$GeocodingCacheTableFilterComposer
    extends Composer<_$AppDatabase, $GeocodingCacheTable> {
  $$GeocodingCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get enderecoTexto => $composableBuilder(
      column: $table.enderecoTexto, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnFilters(column));
}

class $$GeocodingCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $GeocodingCacheTable> {
  $$GeocodingCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get enderecoTexto => $composableBuilder(
      column: $table.enderecoTexto,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
      column: $table.criadoEm, builder: (column) => ColumnOrderings(column));
}

class $$GeocodingCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $GeocodingCacheTable> {
  $$GeocodingCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get enderecoTexto => $composableBuilder(
      column: $table.enderecoTexto, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);
}

class $$GeocodingCacheTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GeocodingCacheTable,
    GeocodingCacheData,
    $$GeocodingCacheTableFilterComposer,
    $$GeocodingCacheTableOrderingComposer,
    $$GeocodingCacheTableAnnotationComposer,
    $$GeocodingCacheTableCreateCompanionBuilder,
    $$GeocodingCacheTableUpdateCompanionBuilder,
    (
      GeocodingCacheData,
      BaseReferences<_$AppDatabase, $GeocodingCacheTable, GeocodingCacheData>
    ),
    GeocodingCacheData,
    PrefetchHooks Function()> {
  $$GeocodingCacheTableTableManager(
      _$AppDatabase db, $GeocodingCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GeocodingCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GeocodingCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GeocodingCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> enderecoTexto = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<DateTime> criadoEm = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GeocodingCacheCompanion(
            enderecoTexto: enderecoTexto,
            latitude: latitude,
            longitude: longitude,
            criadoEm: criadoEm,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String enderecoTexto,
            required double latitude,
            required double longitude,
            required DateTime criadoEm,
            Value<int> rowid = const Value.absent(),
          }) =>
              GeocodingCacheCompanion.insert(
            enderecoTexto: enderecoTexto,
            latitude: latitude,
            longitude: longitude,
            criadoEm: criadoEm,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GeocodingCacheTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GeocodingCacheTable,
    GeocodingCacheData,
    $$GeocodingCacheTableFilterComposer,
    $$GeocodingCacheTableOrderingComposer,
    $$GeocodingCacheTableAnnotationComposer,
    $$GeocodingCacheTableCreateCompanionBuilder,
    $$GeocodingCacheTableUpdateCompanionBuilder,
    (
      GeocodingCacheData,
      BaseReferences<_$AppDatabase, $GeocodingCacheTable, GeocodingCacheData>
    ),
    GeocodingCacheData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db, _db.clientes);
  $$UsuariosTableTableManager get usuarios =>
      $$UsuariosTableTableManager(_db, _db.usuarios);
  $$BasesTableTableManager get bases =>
      $$BasesTableTableManager(_db, _db.bases);
  $$AtendimentosTableTableManager get atendimentos =>
      $$AtendimentosTableTableManager(_db, _db.atendimentos);
  $$PontosRastreamentoTableTableManager get pontosRastreamento =>
      $$PontosRastreamentoTableTableManager(_db, _db.pontosRastreamento);
  $$SyncQueueTableTableTableManager get syncQueueTable =>
      $$SyncQueueTableTableTableManager(_db, _db.syncQueueTable);
  $$GeocodingCacheTableTableManager get geocodingCache =>
      $$GeocodingCacheTableTableManager(_db, _db.geocodingCache);
}
