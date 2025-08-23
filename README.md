# Trove MCP

Espace de stockage personnel facilement accessible via IA pour organiser et retrouver vos données importantes.

## 📋 Objectif

Centraliser et rendre facilement accessible via intelligence artificielle :
- **Données famille** : passeports, dates de naissance, documents personnels
- **Données entreprise** : KBIS, logos, statuts, factures, bilans
- **Données foyer** : garanties, manuels d'instruction, contrats

## 🛠 Stack technique

- **Backend** : Ruby 3.4+ / Rails 8.0+
- **Base de données** : PostgreSQL
- **Frontend** : Vite + React + TypeScript
- **Styling** : Tailwind CSS v4 + Shadcn/ui
- **Tests** : RSpec + FactoryBot
- **Linting** : Rubocop (omakase) + rubocop-performance + rubocop-rspec

## 🚀 Installation

```bash
# Cloner le repository
git clone https://github.com/imagine-app/trove-mcp.git
cd trove-mcp

# Installer les dépendances
bundle install
npm install

# Configurer la base de données
rails db:create db:migrate

# Démarrer le serveur de développement
bin/dev
```

## 🧪 Tests

```bash
# Lancer tous les tests
bundle exec rspec

# Linting
bundle exec rubocop
```

## 🏗 Architecture

- **Authentification** : Rails native (sans Devise)
- **API** : Pour intégration MCP
- **Structure** : MVC classique Rails avec frontend React moderne

## 📚 Documentation

Voir [CLAUDE.md](./CLAUDE.md) pour les préférences de développement et conventions du projet.
