# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clean database
puts "Cleaning database..."
Entry.destroy_all
Context.destroy_all
Mailbox.destroy_all
ExternalApiKey.destroy_all
ApiKey.destroy_all
Vault.destroy_all
User.destroy_all

# Create users
puts "Creating users..."
user_raphael = User.create!(
  email: "raphael@example.com",
  password: "password123"
)

user_marie = User.create!(
  email: "marie@example.com",
  password: "password123"
)

# Create vaults
puts "Creating vaults..."
vault_famille = Vault.create!(
  name: "Famille Dupont"
)

vault_entreprise = Vault.create!(
  name: "Tech Solutions SARL"
)

vault_foyer = Vault.create!(
  name: "Maison - 12 rue de la Paix"
)

# Create memberships
puts "Creating memberships..."
Membership.create!(user: user_raphael, vault: vault_famille, role: "manager")
Membership.create!(user: user_marie, vault: vault_famille, role: "reader")
Membership.create!(user: user_raphael, vault: vault_entreprise, role: "manager")
Membership.create!(user: user_raphael, vault: vault_foyer, role: "manager")
Membership.create!(user: user_marie, vault: vault_foyer, role: "reader")

# Create mailboxes
puts "Creating mailboxes..."
mailbox_famille = Mailbox.create!(
  vault: vault_famille
)

mailbox_entreprise = Mailbox.create!(
  vault: vault_entreprise
)

# Create contexts
puts "Creating contexts..."
context_passeports = Context.create!(
  vault: vault_famille,
  name: "Passeports",
  description: "Informations des passeports de la famille",
  autotag: true
)

context_naissance = Context.create!(
  vault: vault_famille,
  name: "Dates de naissance",
  description: "Dates de naissance et actes de naissance",
  autotag: true
)

context_kbis = Context.create!(
  vault: vault_entreprise,
  name: "KBIS",
  description: "Extrait KBIS et informations légales",
  autotag: true
)

context_factures = Context.create!(
  vault: vault_entreprise,
  name: "Factures",
  description: "Factures clients et fournisseurs",
  autotag: true
)

context_garanties = Context.create!(
  vault: vault_foyer,
  name: "Garanties",
  description: "Garanties des équipements",
  autotag: true
)

context_manuels = Context.create!(
  vault: vault_foyer,
  name: "Manuels",
  description: "Manuels d'instruction des appareils",
  autotag: true
)

# Create entries - Messages
puts "Creating message entries..."
entry_passeport_raphael = Entry.create!(
  vault: vault_famille,
  title: "Passeport Raphaël",
  description: "Informations passeport de Raphaël",
  entriable: Entry::Message.create!(
    text: "Passeport n°: 23FR456789\nDate de délivrance: 15/03/2022\nDate d'expiration: 15/03/2032\nLieu de naissance: Paris, France\nAutorité: Préfecture de Paris"
  )
)
entry_passeport_raphael.contexts << context_passeports

entry_passeport_marie = Entry.create!(
  vault: vault_famille,
  title: "Passeport Marie",
  description: "Informations passeport de Marie",
  entriable: Entry::Message.create!(
    text: "Passeport n°: 23FR987654\nDate de délivrance: 20/06/2023\nDate d'expiration: 20/06/2033\nLieu de naissance: Lyon, France\nAutorité: Préfecture du Rhône"
  )
)
entry_passeport_marie.contexts << context_passeports

entry_naissance_raphael = Entry.create!(
  vault: vault_famille,
  title: "Naissance Raphaël",
  description: "Date et lieu de naissance Raphaël",
  entriable: Entry::Message.create!(
    text: "Date de naissance: 12/08/1985\nLieu: Paris 14ème\nHeure: 14h32\nActe n°: 1985-14-2345"
  )
)
entry_naissance_raphael.contexts << context_naissance

entry_naissance_marie = Entry.create!(
  vault: vault_famille,
  title: "Naissance Marie",
  description: "Date et lieu de naissance Marie",
  entriable: Entry::Message.create!(
    text: "Date de naissance: 25/11/1987\nLieu: Lyon 3ème\nHeure: 09h15\nActe n°: 1987-03-4567"
  )
)
entry_naissance_marie.contexts << context_naissance

entry_kbis = Entry.create!(
  vault: vault_entreprise,
  title: "Extrait KBIS Tech Solutions",
  description: "Informations légales de l'entreprise",
  entriable: Entry::Message.create!(
    text: "Tech Solutions SARL\nSIREN: 890 123 456\nSIRET (siège): 890 123 456 00014\nCapital social: 10 000€\nAdresse siège: 42 rue de l'Innovation, 75011 Paris\nDate création: 15/01/2021\nActivité: Conseil en systèmes informatiques (6202A)\nGérant: Raphaël Dupont"
  )
)
entry_kbis.contexts << context_kbis

entry_garantie_lave_vaisselle = Entry.create!(
  vault: vault_foyer,
  title: "Garantie lave-vaisselle Bosch",
  description: "Garantie constructeur lave-vaisselle",
  entriable: Entry::Message.create!(
    text: "Modèle: Bosch SMS46MI05E\nN° série: WZ123456789\nDate achat: 15/09/2023\nGarantie: 2 ans pièces et main d'œuvre\nExpiration garantie: 15/09/2025\nRevendeur: Darty Paris République\nN° facture: DRT-2023-456789"
  )
)
entry_garantie_lave_vaisselle.contexts << context_garanties

entry_manuel_four = Entry.create!(
  vault: vault_foyer,
  title: "Instructions four Whirlpool",
  description: "Principales instructions du four",
  entriable: Entry::Message.create!(
    text: "Four Whirlpool AKZ96230NB\n\nProgrammes principaux:\n- Chaleur tournante: 50-250°C\n- Gril: 3 niveaux\n- Pyrolyse: 2h30 à 500°C\n\nNettoyage pyrolyse:\n1. Retirer tous les accessoires\n2. Fermer la porte\n3. Sélectionner Pyrolyse\n4. Attendre refroidissement complet\n5. Essuyer les cendres\n\nSécurité enfants: Maintenir bouton cadenas 3 sec"
  )
)
entry_manuel_four.contexts << context_manuels

# Create entries - Links
puts "Creating link entries..."
entry_logo = Entry.create!(
  vault: vault_entreprise,
  title: "Logo Tech Solutions",
  description: "Logo officiel de l'entreprise",
  entriable: Entry::Link.create!(
    url: "https://drive.google.com/file/d/1234567890/logo-tech-solutions.png",
    title: "Logo haute résolution format PNG"
  )
)

entry_statuts = Entry.create!(
  vault: vault_entreprise,
  title: "Statuts Tech Solutions",
  description: "Statuts juridiques de la SARL",
  entriable: Entry::Link.create!(
    url: "https://drive.google.com/file/d/0987654321/statuts-tech-solutions-2021.pdf",
    title: "Statuts signés du 15/01/2021"
  )
)

entry_bilan = Entry.create!(
  vault: vault_entreprise,
  title: "Bilan 2023",
  description: "Bilan comptable exercice 2023",
  entriable: Entry::Link.create!(
    url: "https://drive.google.com/file/d/1122334455/bilan-2023-tech-solutions.pdf",
    title: "Bilan certifié par le cabinet comptable"
  )
)

entry_contrat_assurance = Entry.create!(
  vault: vault_foyer,
  title: "Contrat assurance habitation",
  description: "Police d'assurance multirisque habitation",
  entriable: Entry::Link.create!(
    url: "https://espace-client.maif.fr/documents/contrat-MRH-2024.pdf",
    title: "Contrat MAIF n°1234567 - échéance 01/03/2025"
  )
)

# Create entries - Emails
puts "Creating email entries..."
entry_email_facture = Entry.create!(
  vault: vault_entreprise,
  title: "Facture client DataCorp",
  description: "Facture prestation janvier 2024",
  entriable: Entry::Email.create!(
    mailbox: mailbox_entreprise,
    to: "tech.solutions@inbox.trove.com",
    from: "comptabilite@datacorp.fr",
    subject: "Facture n°2024-001 - Prestation janvier",
    body: "Bonjour,\n\nVeuillez trouver ci-joint la facture pour les prestations de conseil du mois de janvier 2024.\n\nMontant HT: 8 500€\nTVA 20%: 1 700€\nMontant TTC: 10 200€\n\nÉchéance: 30 jours\n\nCordialement,\nService comptabilité DataCorp",
    received_at: 1.week.ago
  )
)
entry_email_facture.contexts << context_factures

entry_email_ecole = Entry.create!(
  vault: vault_famille,
  title: "Inscription scolaire Lucas",
  description: "Confirmation inscription école",
  entriable: Entry::Email.create!(
    mailbox: mailbox_famille,
    to: "famille.dupont@inbox.trove.com",
    from: "secretariat@ecole-voltaire.fr",
    subject: "Confirmation inscription Lucas Dupont - Rentrée 2024",
    body: "Madame, Monsieur,\n\nNous avons le plaisir de confirmer l'inscription de Lucas Dupont pour la rentrée scolaire 2024-2025.\n\nClasse: CE2\nEnseignante: Mme Martin\nRentrée: Lundi 2 septembre 2024 à 8h30\n\nDocuments à fournir:\n- Certificat médical\n- Attestation d'assurance\n- Photo d'identité\n\nCordialement,\nLe secrétariat",
    received_at: 2.weeks.ago
  )
)

entry_email_garantie = Entry.create!(
  vault: vault_foyer,
  title: "Extension garantie TV Samsung",
  description: "Proposition extension de garantie",
  entriable: Entry::Email.create!(
    mailbox: mailbox_famille,
    to: "famille.dupont@inbox.trove.com",
    from: "service@samsung.fr",
    subject: "Votre garantie TV expire bientôt",
    body: "Cher client,\n\nVotre garantie pour le téléviseur Samsung QE55Q80T (n° série: ABC123DEF456) expire le 31/03/2024.\n\nNous vous proposons une extension de garantie de 2 ans pour 149€.\n\nCette extension couvre:\n- Pannes électroniques\n- Défauts de pixels\n- Intervention à domicile\n- Prêt d'un TV de remplacement\n\nPour souscrire: https://samsung.fr/extension-garantie\n\nCordialement,\nSamsung Services",
    received_at: 3.days.ago
  )
)
entry_email_garantie.contexts << context_garanties

# Create API keys
puts "Creating API keys..."
ApiKey.create!(
  vault: vault_famille,
  token: SecureRandom.hex(32),
  expires_at: 1.year.from_now
)

ApiKey.create!(
  vault: vault_entreprise,
  token: SecureRandom.hex(32),
  expires_at: 1.year.from_now
)

# Create external API keys
puts "Creating external API keys..."
ExternalApiKey.create!(
  vault: vault_entreprise,
  name: "OpenAI",
  service_key: "sk-proj-" + SecureRandom.alphanumeric(48),
  expires_at: 1.year.from_now
)

ExternalApiKey.create!(
  vault: vault_entreprise,
  name: "Stripe",
  service_key: "sk_live_" + SecureRandom.alphanumeric(32),
  expires_at: 1.year.from_now
)

# Create prompts for contexts
puts "Creating prompts..."
Prompt.create!(
  context: context_passeports,
  text: "Quand expire le passeport de {{name}}?"
)

Prompt.create!(
  context: context_garanties,
  text: "Quelle est la procédure pour faire jouer la garantie de {{device}}?"
)

Prompt.create!(
  context: context_factures,
  text: "Quel est le montant total des factures de {{client}} pour {{period}}?"
)

puts "Seeds completed!"
puts "Created:"
puts "  - #{User.count} users"
puts "  - #{Vault.count} vaults"
puts "  - #{Entry.count} entries"
puts "  - #{Context.count} contexts"
puts "  - #{Mailbox.count} mailboxes"
puts "  - #{ApiKey.count} API keys"
puts "  - #{ExternalApiKey.count} external API keys"
puts "  - #{Prompt.count} prompts"
