# Trove MCP - Préférences de développement

## Règles générales
- **Toujours utiliser la dernière version stable** des technologies
- Privilégier les solutions natives avant les gems tierces

## Stack technique
- **Backend**: Ruby 3.4+ / Rails 8.0+
- **Base de données**: PostgreSQL
- **Frontend**: Vite + React + TypeScript
- **Styling**: Tailwind CSS + Shadcn/ui
- **Tests**: RSpec + FactoryBot
- **Linting**: Rubocop (omakase) + rubocop-performance + rubocop-rspec

## Commandes utiles
```bash
# Tests
bundle exec rspec

# Linting
bundle exec rubocop

# Base de données
rails db:create db:migrate

# Serveur de développement
bin/dev
```

## Architecture
- Authentification Rails native (sans Devise)
- API pour intégration MCP
- Structure MVC classique Rails

## Objectif du projet
Espace de stockage personnel facilement accessible via IA pour :
- Données famille (passeports, dates de naissance)
- Données entreprise (KBIS, logos, statuts, factures, bilans)  
- Données foyer (garanties, manuels d'instruction)