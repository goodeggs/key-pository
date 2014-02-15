fibrous = require 'fibrous'
Heroku = require 'heroku-client'

COMMIT = false

COLLABORATORS = [
  'admin@goodeggsinc.com'
  'aaron@goodeggs.com'
  'adam@hmlad.com'
  'alex@goodeggs.com'
  'alon@salant.org'
  'bob@zoller.us'
  'brian@goodeggs.com'
  'brianu@goodeggs.com'
  'deploy@goodeggsinc.com'
  'joe@goodeggs.com'
  'lei@goodeggs.com'
  'max@goodeggs.com'
  'randypuro@gmail.com'
  'rob@goodeggsinc.com'
  'sherman.mui@goodeggs.com'
]

fibrous.run  ->

  heroku = new Heroku token: process.env.HEROKU_API_TOKEN
  
  for app in heroku.apps().sync.list()
    console.log app.name
    app = heroku.apps(app.name)
    hash = {}
    (hash[email] = 1 for email in COLLABORATORS)
    for collaborator in app.collaborators().sync.list()
      if hash[collaborator.user.email]?
        console.log "    #{collaborator.user.email}"
        delete hash[collaborator.user.email]
      else
        console.log "  - #{collaborator.user.email}"
        app.collaborators(collaborator.user.email).sync.delete() if COMMIT
    # hash now contains collaborators we need to add
    for email of hash
      console.log "  + #{email}"
      app.collaborators().sync.create user: {email} if COMMIT

