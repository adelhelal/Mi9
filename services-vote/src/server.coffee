Q = require 'q'
_ = require 'underscore'
request = require 'request'
jsonschema = require 'jsonschema'
env = require 'mi9-environment'

questionSchema = require '../resources/schemas/question.json'
answerSchema = require '../resources/schemas/answer.json'
mediaSchema = require '../resources/schemas/media.json'

validator = new jsonschema.Validator()
validator.addSchema mediaSchema, '/media'

contentApiUrl = env.get 'server:contentApi'

_whitelistArray = (arr, keys) ->
    _.map arr, (item) ->
        _.pick item, keys

formatQuestions = (questions) ->
    keys = ['id', 'header', 'text', 'media', 'active', 'canVote', 'hideResults', 'thankYouText', 'templateId', 'answers']
    _whitelistArray questions, keys

formatAnswers = (answers) ->
    keys = ['id', 'text', 'media', 'seed', 'templateId']
    _whitelistArray answers, keys

exports.getQuestionsByIds = (clientApp, ids, callback) ->

    getItems "#{contentApiUrl}/#{clientApp}/items/?ids=#{ids}", (questions) ->
        if questions.length is 0
            throw new Error 'No questions found'

        # Include only whitelisted fields
        questions = formatQuestions questions

        promises = []
        for question in questions
            promises.push getAnswers clientApp, question

        Q.all(promises).done callback

getAnswers = (clientApp, question) ->
    deferred = Q.defer()
    whitelistedFields = ['id', 'text', 'media', 'seed', 'templateId']

    getItems "#{contentApiUrl}/#{clientApp}/items/#{question.id}/children?templates=answer", (answers) ->
        # Include only whitelisted fields
        question.answers = formatAnswers answers
        deferred.resolve question

    deferred.promise

getItems = (url, callback) ->
    request url, (err, resp, itemData) ->
        if err or resp.statusCode isnt 200
            throw new Error "Unexpected HTTP Error, status code #{resp.statusCode}"

        validateItems itemData, callback

validateItems = (items, callback) ->
    if !items then throw new Error 'No questions found'
    items = JSON.parse items

    for item in items
        if !item.templateId then throw new Error 'No templateId found'

        schema = null
        switch item.templateId
            when env.get 'server:questionTemplateId' then schema = questionSchema
            when env.get 'server:answerTemplateId'   then schema = answerSchema

        result = validator.validate item, schema
        if result.errors.length > 0
            error = result.errors[0]
            throw new Error "#{error.property} #{error.message}"

    callback items
