
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../service/api_service.dart';
import '../model/personagem.dart';
import 'pag_detalhes.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final bool? isDarkMode;

  const HomePage({super.key, this.onToggleTheme, this.isDarkMode});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<Map<String, dynamic>> _futurePage;
  Map<String, dynamic> _links = {};

 
  static const Color dbOrange = Color(0xFFFF8C00);
  static const Color dbBlue = Color(0xFF1E88E5);

  @override
  void initState() {
    super.initState();
    // carrega primeira pag
    _futurePage = ApiService.fetchCharacters(page: 1, limit: 10);
  }


  void _loadByUrl(String url) {
    setState(() {
      _futurePage = ApiService.fetchCharacters(url: url);
    });
  }

  void _openFilters() {
    Navigator.of(context).pushNamed('/filters');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dragon Ball Z'),
        
        actions: [
       
          IconButton(
            tooltip: widget.isDarkMode == true ? 'Ativar modo claro' : 'Ativar modo escuro',
            icon: Icon(widget.isDarkMode == true ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),

        
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilters,
            tooltip: 'Filtrar',
          )
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futurePage,
        builder: (context, snapshot) {
          
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: SpinKitCircle(color: Theme.of(context).colorScheme.primary),
            );
          }

          
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}', style: TextStyle(color: Theme.of(context).colorScheme.error)));
          }

          final data = snapshot.data;
          if (data == null) {
            return Center(child: Text('Resposta vazia da API.', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)));
          }

          
          final dynamic itemsRaw = data['items'];
          final List<Character> items = (itemsRaw is List<Character>)
              ? itemsRaw
              : (itemsRaw as List<dynamic>).map((e) => e as Character).toList();

          _links = Map<String, dynamic>.from(data['links'] ?? {});

          if (items.isEmpty) {
            return Center(child: Text('Nenhum personagem encontrado.', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)));
          }

          
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final c = items[index];

                    // usar cores do tema
                    final cardBg = Theme.of(context).colorScheme.surface;
                    final onSurface = Theme.of(context).colorScheme.onSurface;
                    final borderColor = Theme.of(context).colorScheme.outline.withOpacity(0.6);
                    final hintColor = Theme.of(context).hintColor;

                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PagDetalhes(id: c.id),
                            ),
                          );
                        },
                        child: Container(
                          height: 170, 
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor, width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.black.withOpacity(0.35) : Colors.black.withOpacity(0.10),
                                blurRadius: 10,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                            
                              Container(
                                margin: const EdgeInsets.all(12),
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    colors: [dbOrange.withOpacity(0.12), dbBlue.withOpacity(0.04)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(color: dbOrange.withOpacity(0.18)),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: c.image != null && c.image!.isNotEmpty
                                      ? Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.network(
                                              c.image!,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                              cacheWidth: 300,
                                              cacheHeight: 300,
                                              loadingBuilder: (context, child, loadingProgress) {
                                                if (loadingProgress == null) return child;
                                                return const Center(
                                                  child: SizedBox(
                                                    width: 28,
                                                    height: 28,
                                                    child: CircularProgressIndicator(strokeWidth: 2.5),
                                                  ),
                                                );
                                              },
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  color: Theme.of(context).dividerColor.withOpacity(0.08),
                                                  child: Center(
                                                    child: Icon(Icons.broken_image, size: 48, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                                                  ),
                                                );
                                              },
                                            ),
                                       
                                            Container(color: Colors.black.withOpacity(0.02)),
                                          ],
                                        )
                                      : Container(
                                          color: Theme.of(context).dividerColor.withOpacity(0.04),
                                          child: Center(
                                            child: Icon(Icons.person, size: 64, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                                          ),
                                        ),
                                ),
                              ),

                             
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(6, 16, 14, 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Nome em destaque
                                      Text(
                                        c.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: onSurface,
                                            ),
                                      ),
                                      const SizedBox(height: 10),

                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.18)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.self_improvement, size: 16, color: Theme.of(context).colorScheme.primary),
                                            const SizedBox(width: 8),
                                            Text(
                                              c.race ?? 'Desconhecida',
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    color: onSurface,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 12),

                                      
                                      if (c.affiliation != null && c.affiliation!.isNotEmpty)
                                        Text(
                                          c.affiliation!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: hintColor),
                                        ),

                                      
                                      const SizedBox(height: 8),
                                      if (c.description != null && c.description!.isNotEmpty)
                                        Expanded(
                                          child: Text(
                                            c.description!,
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: hintColor),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: (_links['previous'] != null && (_links['previous'] as String).isNotEmpty)
                          ? () => _loadByUrl(_links['previous'])
                          : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Página anterior'),
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
                    ),
                    ElevatedButton.icon(
                      onPressed: (_links['next'] != null && (_links['next'] as String).isNotEmpty)
                          ? () => _loadByUrl(_links['next'])
                          : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Próxima página'),
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}