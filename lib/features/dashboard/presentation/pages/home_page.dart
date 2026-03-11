import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../atendimento/domain/usecases/atualizar_status_atendimento.dart';
import '../../../atendimento/domain/usecases/criar_atendimento.dart';
import '../../../atendimento/domain/usecases/listar_atendimentos.dart';
import '../../../atendimento/presentation/bloc/atendimento_bloc.dart';
import '../../../atendimento/presentation/pages/lista_atendimentos_page.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../base/domain/usecases/criar_base.dart';
import '../../../base/domain/usecases/definir_base_principal.dart';
import '../../../base/domain/usecases/listar_bases.dart';
import '../../../base/presentation/bloc/base_bloc.dart';
import '../../../base/presentation/pages/gestao_bases_page.dart';
import '../../../cliente/domain/usecases/atualizar_cliente.dart';
import '../../../cliente/domain/usecases/buscar_clientes.dart';
import '../../../cliente/domain/usecases/criar_cliente.dart';
import '../../../cliente/presentation/bloc/cliente_bloc.dart';
import '../../../cliente/presentation/pages/buscar_cliente_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;
    final nomeUsuario =
        state is AuthAutenticado ? state.usuario.nome : 'Usuário';

    return Scaffold(
      appBar: AppBar(
        title: const Text('GuinchoApp'),
        actions: [
          IconButton(
            key: const Key('logoutButton'),
            icon: const Icon(Icons.logout),
            onPressed: () =>
                context.read<AuthBloc>().add(const LogoutSolicitado()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bem-vindo, $nomeUsuario!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            _MenuCard(
              key: const Key('menuAtendimentos'),
              icon: Icons.local_shipping,
              title: 'Atendimentos',
              subtitle: 'Gerenciar ordens de serviço',
              onTap: () => _abrirAtendimentos(context),
            ),
            const SizedBox(height: 12),
            _MenuCard(
              key: const Key('menuClientes'),
              icon: Icons.people,
              title: 'Clientes',
              subtitle: 'Buscar e cadastrar clientes',
              onTap: () => _abrirClientes(context),
            ),
            const SizedBox(height: 12),
            _MenuCard(
              key: const Key('menuBases'),
              icon: Icons.warehouse,
              title: 'Bases / Garagens',
              subtitle: 'Gerenciar pontos de saída',
              onTap: () => _abrirBases(context),
            ),
          ],
        ),
      ),
    );
  }

  void _abrirAtendimentos(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => AtendimentoBloc(
          criarAtendimento: GetIt.I<CriarAtendimento>(),
          listarAtendimentos: GetIt.I<ListarAtendimentos>(),
          atualizarStatusAtendimento: GetIt.I<AtualizarStatusAtendimento>(),
        ),
        child: const ListaAtendimentosPage(),
      ),
    ));
  }

  void _abrirClientes(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => ClienteBloc(
          criarCliente: GetIt.I<CriarCliente>(),
          buscarClientes: GetIt.I<BuscarClientes>(),
          atualizarCliente: GetIt.I<AtualizarCliente>(),
        ),
        child: const BuscarClientePage(),
      ),
    ));
  }

  void _abrirBases(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => BaseBloc(
          criarBase: GetIt.I<CriarBase>(),
          listarBases: GetIt.I<ListarBases>(),
          definirBasePrincipal: GetIt.I<DefinirBasePrincipal>(),
        ),
        child: const GestaoBasesPage(),
      ),
    ));
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
