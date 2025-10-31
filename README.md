# API App — Dragon Ball Characters

Resumo
---
Aplicativo Flutter que consome a API pública "Dragon Ball API" (https://dragonball-api.com) para listar personagens, ver detalhes e navegar por transformações. Projeto focado em UI limpa, tema claro/escuro com toggle no AppBar, paginação e fallback para desenvolvimento offline.

Principais recursos
---
- Listagem paginada de personagens (imagem, nome, raça, descrição curta).
- Tela de detalhes do personagem com imagem maior, resumo, planeta de origem e transformações.
- Visualização das transformações (miniaturas horizontais + tela com scroll vertical).
- Tema claro / escuro com botão para alternar no AppBar (seguindo escolha do usuário).
- Tratamento de imagens com boxFit e cache para reduzir uso de memória.
- Boas práticas: tratamento de erros de rede, mensagens ao usuário e componentes reaproveitáveis.

Pré-requisitos
---
- Flutter SDK instalado (recomendado: Flutter 3.x ou superior)
- Android SDK / emulador ou dispositivo físico conectado
- Conexão de internet para consumir a API (ou uso de mock local)

Instalação e execução
---
1. Clone o repositório:
   git clone <seu-repositorio>  
   cd api_app

2. Instale dependências:
   flutter pub get

3. Rode no dispositivo ou emulador:
   flutter run

Dicas:
- Para aplicar mudanças rápidas de UI: hot reload (press R no terminal) ou Hot Restart se alterar o estado inicial.
- Se der problemas com dependências: flutter clean && flutter pub get

Configurações importantes no projeto
---
- Tema: o toggle de tema está implementado em `lib/main.dart`. O botão no AppBar alterna entre claro/escuro (ThemeMode.light / ThemeMode.dark).
- Rotas: a Home é instanciada via `home: HomePage(...)` no `MaterialApp`.
- Permissão Android: confirme que `android/app/src/main/AndroidManifest.xml` contém:
  `<uses-permission android:name="android.permission.INTERNET"/>`

API e parâmetros
---
- Endpoint principal: `https://dragonball-api.com/api/characters`
- Parâmetros suportados:
  - `page` (número da página)
  - `limit` (itens por página)
  - Filtros por query (race, affiliation, gender, name) — quando filtros são usados a API retorna lista sem paginação.

Estrutura relevante do projeto
---
- lib/
  - main.dart — inicialização, temas e toggle
  - pages/
    - home_page.dart — listagem e navegação
    - pag_detalhes.dart — tela de detalhes e transformações
    - pag_filtros.dart — tela de filtros
  - service/
    - api_service.dart — chamadas HTTP e parsing
  - model/
    - personagem.dart — modelos: Character, Transformation, Planet

Modo offline / mock (para desenvolvimento quando a internet estiver instável)
---
1. Crie `assets/mock/characters.json` com um exemplo do payload da API.
2. Adicione em `pubspec.yaml`:
   ```yaml
   flutter:
     assets:
       - assets/mock/characters.json
   ```
3. Modifique temporariamente `ApiService.fetchCharacters` para ler do asset com `rootBundle.loadString('assets/mock/characters.json')` quando detectar falha de rede — assim a UI pode ser testada sem acesso à API.
