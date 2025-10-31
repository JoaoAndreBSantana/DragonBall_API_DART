
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../service/api_service.dart';
import '../model/personagem.dart';

class PagDetalhes extends StatelessWidget {
  final int id;

  const PagDetalhes({super.key, required this.id});

  
  void _showTransformationDialog(BuildContext context, Transformation t) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (t.image != null && t.image!.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  t.image!,
                  width: double.infinity,
                  height: 260,
                  fit: BoxFit.cover,
                  cacheWidth: 800,
                  errorBuilder: (c, e, s) => Container(
                    height: 260,
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.broken_image, size: 56)),
                  ),
                ),
              )
            else
              Container(
                height: 180,
                alignment: Alignment.center,
                child: const Icon(Icons.flash_on, size: 72, color: Colors.grey),
              ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Text(t.name ?? 'Sem nome', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Fechar')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildHeader(BuildContext context, Character c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      child: Column(
        children: [
          if (c.image != null && c.image!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                c.image!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.contain,
                cacheWidth: 800,
                loadingBuilder: (ctx, child, progress) {
                  if (progress == null) return child;
                  return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (ctx, err, st) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.broken_image, size: 84)),
                ),
              ),
            )
          else
            const SizedBox(
              height: 200,
              child: Center(child: Icon(Icons.person, size: 84, color: Colors.grey)),
            ),
          const SizedBox(height: 12),
          Text(
            c.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        elevation: 1,
      ),
      body: FutureBuilder<Character>(
        future: ApiService.fetchCharacterById(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: SpinKitCircle(color: Colors.orange));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final Character c = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, c),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      if (c.description != null && c.description!.isNotEmpty) ...[
                        _sectionTitle('Resumo'),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              c.description!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                            ),
                          ),
                        ),
                      ],

                      
                      if (c.originPlanet != null) ...[
                        _sectionTitle('Planeta de origem'),
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 1,
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: c.originPlanet!.image != null && c.originPlanet!.image!.isNotEmpty
                                  ? Image.network(c.originPlanet!.image!, width: 64, height: 64, fit: BoxFit.cover, cacheWidth: 300)
                                  : Container(width: 64, height: 64, color: Colors.grey[200], child: const Icon(Icons.public)),
                            ),
                            title: Text(c.originPlanet!.name ?? 'Desconhecido'),
                            subtitle: Text(c.originPlanet!.description ?? ''),
                          ),
                        ),
                      ],

                      
                      _sectionTitle('Transformações'),
                      if (c.transformations != null && c.transformations!.isNotEmpty) ...[
                        SizedBox(
                          height: 120,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(left: 4, right: 8),
                            itemCount: c.transformations!.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                            itemBuilder: (context, i) {
                              final t = c.transformations![i];
                              return GestureDetector(
                                onTap: () => _showTransformationDialog(context, t),
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.6)),
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                        child: t.image != null && t.image!.isNotEmpty
                                            ? Image.network(
                                                t.image!,
                                                width: 100,
                                                height: 70,
                                                fit: BoxFit.cover,
                                                cacheWidth: 300,
                                                errorBuilder: (c, e, s) =>
                                                    Container(height: 70, color: Theme.of(context).dividerColor.withOpacity(0.08), child: const Icon(Icons.flash_on)),
                                              )
                                            : Container(height: 70, color: Colors.grey[200], child: const Icon(Icons.flash_on)),
                                      ),
                                      const SizedBox(height: 6),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 6),
                                        child: Text(
                                          t.name ?? 'Sem nome',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        // botao para abrir tela com todas as transformaçoes
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => TransformationsListPage(transformations: c.transformations!)));
                            },
                            icon: const Icon(Icons.list),
                            label: const Text('Ver todas'),
                          ),
                        ),
                      ] else
                        const Text('Nenhuma transformação disponível.'),

                      const SizedBox(height: 16),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


class TransformationsListPage extends StatelessWidget {
  final List<Transformation> transformations;

  const TransformationsListPage({super.key, required this.transformations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transformações')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: transformations.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final t = transformations[i];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: t.image != null && t.image!.isNotEmpty
                    ? Image.network(t.image!, width: 72, height: 72, fit: BoxFit.cover, cacheWidth: 300, errorBuilder: (c, e, s) => Container(width: 72, height: 72, color: Colors.grey[200], child: const Icon(Icons.flash_on)))
                    : Container(width: 72, height: 72, color: Colors.grey[200], child: const Icon(Icons.flash_on)),
              ),
              title: Text(t.name ?? 'Sem nome', style: const TextStyle(fontWeight: FontWeight.w700)),
              onTap: () {
                
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (t.image != null && t.image!.isNotEmpty)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(t.image!, width: double.infinity, height: 300, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(height: 300, color: Colors.grey[200], child: const Icon(Icons.broken_image))),
                          )
                        else
                          Container(height: 200, alignment: Alignment.center, child: const Icon(Icons.flash_on, size: 80)),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Text(t.name ?? 'Sem nome', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 8),
                              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Fechar')),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}