
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/personagem.dart';

class ApiService {
  static const String baseHost = 'dragonball-api.com';
  static const String basePath = '/api/characters';
  static const String baseUrl = 'https://dragonball-api.com/api/characters';

 
  static Future<Map<String, dynamic>> fetchCharacters({
    String? url,
    int page = 1,
    int limit = 10,
  }) async {
    Uri uri;

    try {
     
      if (url != null && url.trim().isNotEmpty) {
        final safe = url.trim().replaceAll(' ', '%20');
        if (safe.startsWith('/')) {
        
          uri = Uri.https(baseHost, safe);
        } else {
          
          uri = Uri.tryParse(safe) ?? Uri.parse(Uri.encodeFull(safe));
        }
      } else {
        
        uri = Uri.https(baseHost, basePath, {
          'page': page.toString(),
          'limit': limit.toString(),
        });
      }

      

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('Erro ao buscar personagens: ${response.statusCode}');
      }

      final Map<String, dynamic> data = jsonDecode(response.body);

      final items = data['items'] ?? [];
      final List<Character> characters = Character.listFromJson(items);

      final links = Map<String, dynamic>.from(data['links'] ?? {});

      return {
        'items': characters,
        'links': links,
        'meta': data['meta'] ?? {},
      };
    } on SocketException catch (e) {
      
      throw Exception('Falha de rede ou DNS: ${e.message}');
    } catch (e) {
     
      rethrow;
    }
  }

  
  static Future<Character> fetchCharacterById(int id) async {
    final Uri uri = Uri.parse('$baseUrl/$id');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar personagem: ${response.statusCode}');
    }
    final Map<String, dynamic> data = jsonDecode(response.body);
    return Character.fromJson(data);
  }

  static Future<List<Character>> fetchFiltered({
    required String race,
    required String affiliation,
  }) async {
   
    final Uri uri = Uri.parse(
        '$baseUrl?race=${Uri.encodeComponent(race)}&affiliation=${Uri.encodeComponent(affiliation)}');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar filtros: ${response.statusCode}');
    }
    final dynamic data = jsonDecode(response.body);
    
    return Character.listFromJson(data);
  }
}