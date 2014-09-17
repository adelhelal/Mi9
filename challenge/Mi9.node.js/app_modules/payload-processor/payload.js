var taffy = require('taffy');
var jsonschema = require('jsonschema');

var payloadsSchema = require("./resources/payloads.json");
var payloadSchema = require("./resources/payload.json");
var episodeSchema = require("./resources/episode.json");
var imageSchema = require("./resources/image.json");
var seasonSchema = require("./resources/season.json");

var validator = new jsonschema.Validator();

function process(payloads) {

    validator.addSchema(seasonSchema, "/season");
    validator.addSchema(imageSchema, "/image");
    validator.addSchema(episodeSchema, "/episode");
    validator.addSchema(payloadSchema, "/payload");

    var result = validator.validate(payloads, payloadsSchema)

    if (result.errors.length > 0) {
        var error = result.errors[0];
        throw error.property + " " + error.message;
    }
}

function filter(payloads) {

    var result = {
        response: []
    };

    var query = taffy(payloads.payload);

    query({ "drm": true, "episodeCount": { gt: 0 } }).each(
        function (payload) {
            result.response.push({
                image: payload.image.showImage,
                slug: payload.slug,
                title: payload.title
            })
        });

    return result;
}

module.exports.process = process;
module.exports.filter = filter;
