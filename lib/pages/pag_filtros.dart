// Tela de filtros: seleciona raça e afiliação e mostra resultados em cards (sem paginação)
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../service/api_service.dart';
import '../model/personagem.dart';
import 'pag_detalhes.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  
  final List<String> races = [
    'Human',
    'Saiyan',
    'Namekuseijin',
    'Majin',
    'Freeza Race',
    'Android',
    'Jiren Race',
    'God',
    'Angel',
    'Unknown'
  ];

  final List<String> affiliations = [
    'Z Fighter',
    'Red Ribbon Army',
    'Freelancer',
    'Frieza Force',
    'Pride Troopers',
    'Other'
  ];

  String? selectedRace;
  String? selectedAffiliation;

 
  Future<List<Character>>? _futureFiltered;

  void _applyFilters() {
    if ((selectedRace == null || selectedRace!.isEmpty) &&
        (selectedAffiliation == null || selectedAffiliation!.isEmpty)) {
    
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione ao menos um filtro.')),
      );
      return;
    }

    setState(() {
      _futureFiltered = ApiService.fetchFiltered(
        race: selectedRace ?? '',
        affiliation: selectedAffiliation ?? '',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtros'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
          
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Raça'),
              items: races
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              value: selectedRace,
              onChanged: (v) => setState(() => selectedRace = v),
            ),
            const SizedBox(height: 12),
           
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Afiliação'),
              items: affiliations
                  .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                  .toList(),
              value: selectedAffiliation,
              onChanged: (v) => setState(() => selectedAffiliation = v),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _applyFilters,
              child: const Text('Aplicar filtros'),
            ),
            const SizedBox(height: 16),

        
            Expanded(
              child: _futureFiltered == null
                  ? const Center(child: Text('Aplique filtros para ver resultados.'))
                  : FutureBuilder<List<Character>>(
                      future: _futureFiltered,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const Center(child: SpinKitCircle(color: Colors.orange));
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Erro: ${snapshot.error}'));
                        }
                        final results = snapshot.data!;
                        if (results.isEmpty) {
                          return const Center(child: Text('Nenhum resultado.'));
                        }
                        return ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final c = results[index];
                            return Card(
                              child: ListTile(
                                leading: c.image != null
                                    ? Image.network(
                                        c.image!,
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stack) =>
                                            const Icon(Icons.person),
                                      )
                                    : const Icon(Icons.person),
                                title: Text(c.name),
                                subtitle: Text(c.race ?? 'Desconhecida'),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => PagDetalhes(id: c.id),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}