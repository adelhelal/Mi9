var fs = require('fs');
var bodyParser = require("body-parser");
var express = require("express");

var configuration = require("./configuration.json");
var payload = require("./app_modules/payload-processor/payload.js");

var app = express();

app.use(bodyParser.json());

app.use(function (error, request, response, next) {

    response.contentType("application/json");

    if (!error) {
        return next();
    }

    errorResponse(response);
});

app.get('/', function (request, response) {
    fs.readFile('./resources/index.html', function (error, data) {
        if (error) throw error;
        response.send(data.toString().replace("{0}", configuration.server));
    });
});

app.post('/', function (request, response) {

    try {
        payload.process(request.body);
        response.send(payload.filter(request.body));
    } catch (e) {
        console.log(e);
        errorResponse(response);
    }
});

function errorResponse(response) {

    return response.send(400, {
        "error": "Could not decode request: JSON parsing failed"
    });
}
var port = process.env.PORT || 1337;
app.listen(port);
console.log("Listening on port " + port);
