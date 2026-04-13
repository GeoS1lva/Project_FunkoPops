<h1 align="center">
  🎭 Pop!Collector
</h1>

<p align="center">
  <em>Sua prateleira digital de Funko Pops — organize, explore e exiba sua coleção com estilo!</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/REST%20API-MockAPI-orange?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Projeto-Faculdade-blueviolet?style=for-the-badge"/>
</p>

---

## 🧸 Sobre o Projeto

O **Pop!Collector** é um aplicativo mobile desenvolvido em **Flutter** como projeto acadêmico. Ele permite que colecionadores de **Funko Pops** gerenciem sua coleção de forma prática e divertida — cadastrando, visualizando, editando e removendo bonecos com todas as suas informações importantes.

---

## ✨ Funcionalidades

- 🔐 **Login** — Tela de autenticação para acesso ao app
- 🏠 **Home** — Visualização dos Funko Pops adicionados mais recentemente
- 📋 **Listagem Completa** — Veja todos os itens da sua coleção em um só lugar
- 🔍 **Busca** — Encontre rapidamente um Funko pelo nome
- ➕ **Adicionar Funko Pop** — Cadastre novos itens com nome, número, raridade, categoria, imagem e se é *Glow in the Dark*
- ✏️ **Editar Funko Pop** — Atualize as informações de qualquer item da coleção
- 🗑️ **Remover Funko Pop** — Exclua itens com um diálogo de confirmação estilizado
- 🏷️ **Gerenciar Categorias** — Crie e organize categorias para seus Funkos (Marvel, DC, Disney, Anime...)

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia | Uso |
|---|---|
| [Flutter](https://flutter.dev/) | Framework principal para UI mobile |
| [Dart](https://dart.dev/) | Linguagem de programação |
| [http](https://pub.dev/packages/http) | Requisições HTTP para a API REST |
| [url_launcher](https://pub.dev/packages/url_launcher) | Abertura de URLs externas |
| [MockAPI](https://mockapi.io/) | Backend simulado para persistência dos dados |

---

## 🗂️ Estrutura do Projeto

```
lib/
├── main.dart                  # Ponto de entrada da aplicação
├── models/
│   ├── funko_model.dart        # Modelo de dados do Funko Pop
│   ├── category_model.dart     # Modelo de dados de Categoria
│   └── user_model.dart         # Modelo de dados do Usuário
├── services/
│   ├── funko_service.dart      # Serviço CRUD para Funko Pops
│   ├── category_service.dart   # Serviço CRUD para Categorias
│   └── auth_service.dart       # Serviço de autenticação
└── ui/
    ├── app_colors.dart         # Paleta de cores do app
    ├── screens/
    │   ├── login_screen.dart        # Tela de login
    │   ├── home_screen.dart         # Tela inicial
    │   ├── funko_listing_screen.dart # Listagem completa
    │   ├── funko_search_screen.dart  # Busca de Funkos
    │   ├── add_funko_screen.dart    # Adicionar Funko Pop
    │   ├── add_category_screen.dart # Adicionar Categoria
    │   └── update_screen.dart       # Editar Funko Pop
    └── widgets/
        ├── funko_card.dart          # Card de exibição do Funko
        ├── funko_list_card.dart     # Card na listagem
        ├── category_card.dart       # Card de categoria
        ├── custom_bottom_nav.dart   # Navegação inferior
        ├── custom_fab_menu.dart     # Menu de ação flutuante
        ├── custom_button.dart       # Botão estilizado
        ├── custom_input.dart        # Campo de entrada
        ├── custom_search_bar.dart   # Barra de busca
        ├── custom_menubar.dart      # Barra de menu
        ├── custom_label.dart        # Labels customizados
        ├── epic_delete_dialog.dart  # Diálogo de exclusão
        └── app_logo.dart            # Logo do aplicativo
```

---

## 🧩 Modelo de Dados — Funko Pop

Cada item da coleção possui os seguintes atributos:

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | String | Identificador único |
| `name` | String | Nome do Funko Pop |
| `categoryName` | String | Categoria (ex: Marvel, Anime) |
| `number` | int | Número da coleção |
| `rarity` | String | Raridade (Comum, Raro, Chase...) |
| `isGlowInTheDark` | bool | Edição especial Glow in the Dark |
| `image` | String | URL da imagem |
| `createdAt` | int | Data de cadastro (timestamp) |

---

## 🚀 Como Executar

### Pré-requisitos

- [Flutter SDK](https://flutter.dev/docs/get-started/install) instalado (versão compatível com Dart `^3.11.4`)
- Emulador Android/iOS ou dispositivo físico conectado

### Passos

```bash
# 1. Clone o repositório
git clone https://github.com/GeoS1lva/Project_FunkoPops.git

# 2. Acesse o diretório do projeto
cd Project_FunkoPops

# 3. Instale as dependências
flutter pub get

# 4. Execute o aplicativo
flutter run
```

---

## 👩‍💻 Desenvolvedores

<table>
  <tr>
    <td align="center">
      <b>Geovana Paula da Silva</b><br/>
      <sub>RA: 170610-2024</sub>
    </td>
    <td align="center">
      <b>Eduardo Bernardes Zanin</b><br/>
      <sub>RA: 183624-2024</sub>
    </td>
  </tr>
</table>

---

## 🏫 Informações Acadêmicas

Projeto desenvolvido como atividade avaliativa da disciplina de desenvolvimento mobile.

---

<p align="center">
  Feito com 💙 e muito Flutter — e claro, inspirado pelos melhores bonecos do mundo! 🎭
</p>
