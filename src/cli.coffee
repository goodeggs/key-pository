fs = require 'fs'
path = require 'path'
glob = require 'glob'
fibrous = require 'fibrous'
Heroku = require 'heroku-client'

argv = require('yargs')
  .options 'token',
    alias: 't'
    demand: true
  .options 'commit',
    alias: 'c'
    boolean: true
    default: false
  .usage 'Synchronizes all of the heroku app collaborators using email addresses in the local key files.\nUsage: $0'
  .argv

EMAIL_REGEXP = /^[^@]+@[^@.]+[.][^@]+$/
EXPECTED_OWNER = 'admin@goodeggsinc.com'

fibrous.run  ->

  collaborators = []

  pubfiles = glob.sync path.resolve(path.join(__dirname, '..', 'keys', '*.pub'))
  for pubfile in pubfiles
    content = fs.sync.readFile pubfile
    [type, key, comment...] = content.toString().split ' '
    comment = comment.join(' ').trim()
    if not comment.match EMAIL_REGEXP
      console.log "ignoring #{pubfile}: comment isn't an email address"
      continue
    collaborators.push comment

  heroku = new Heroku token: argv.token

  for app in heroku.apps().sync.list()
    owner = app.owner.email

    if owner isnt EXPECTED_OWNER
      console.error "skipping #{app.name} because owner is #{owner} (expected: #{EXPECTED_OWNER})"
      continue
    else
      console.log app.name

    app = heroku.apps(app.name)
    hash = {}
    (hash[email] = 1 for email in collaborators)
    for collaborator in app.collaborators().sync.list()
      if hash[collaborator.user.email]? or collaborator.user.email is owner
        console.log "    #{collaborator.user.email}"
        delete hash[collaborator.user.email]
      else
        console.log "  - #{collaborator.user.email}"
        app.collaborators(collaborator.user.email).sync.delete() if argv.commit
    # hash now contains collaborators we need to add
    for email of hash
      console.log "  + #{email}"
      app.collaborators().sync.create user: {email} if argv.commit

