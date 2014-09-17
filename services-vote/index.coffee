bodyParser = require 'body-parser'
express = require 'express'
environment = require 'mi9-environment'

# Env must be set up before
environment.setup {appConfigPath: "#{__dirname}/config/environments"}

routes = require './src/routes'
debugRoutes = require './debug'

# Setup app and middleware
app = express()
app.use bodyParser.json()

# Catch errors and do stuff with them
app.use (err, req, res, next) ->
    # Maybe we should be logging the error here or something?
    if err instanceof SyntaxError
        return res.status(400).json error: 'Invalid JSON'
    else
        next()

# todo: this isnt optimal and doesnt work in all situations.
process.on 'uncaughtException', (error) ->
    console.log error
    try
        resp = app.get 'response'
        resp.status(400).send error: message
    catch
        console.log 'Error making exception:'
        console.log _error

# Connect routes to app
routes app
debugRoutes app

# This must always be last, after all middleware and routes
app.use (req, res) -> res.status(404).json error: 'Route not found'

# Run application
port = process.env.PORT or 1337
app.listen port
console.log "Listening on port #{port}"
