// To see this message, add the following to the `<head>` section in your
// views/layouts/application.html.erb
//
//    <%= vite_client_tag %>
//    <%= vite_javascript_tag 'application' %>
import '../stylesheets/application.css'

// Load Rails libraries
import * as Turbo from '@hotwired/turbo'
Turbo.start()

import * as ActiveStorage from '@rails/activestorage'
ActiveStorage.start()

console.log('Vite ⚡️ Rails - Trove MCP')
