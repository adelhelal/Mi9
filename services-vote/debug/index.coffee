request = require 'request'
handlebars = require 'express-handlebars'

module.exports = (app) ->

    app.engine 'hbs', handlebars()
    app.set 'view engine', 'hbs'
    app.set 'views', "#{__dirname}/views"

    app.get '/test/*', (req, res) ->
        request "http://#{req.get 'host'}/#{req.param(0)}", (err, resp, itemData) ->
            if err then throw err
            res.render 'index', 
                questions: JSON.parse itemData
                host: req.get 'host'
