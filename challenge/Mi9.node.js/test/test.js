var assert = require("assert");
var payload = require("../app_modules/payload-processor/payload.js");

describe('Payload', function () {

    before(function (done) {
        done();
    });

    it("request from Mi9 example", function () {
        var request = require("./request-OK.json");
        payload.process(request);
    });

    it("request with no image", function () {
        var request = require("./request-OK-no_image.json");
        payload.process(request);
    });

    it("request with no results", function () {
        var request = require("./request-OK-no_results.json");
        payload.process(request);
    });

    it("request 'payload' is required", function () {
        assert.throws(function () {
            payload.process({ paylsoad: [] })
        });
    });

    it("request has bad JSON", function () {
        assert.throws(function () {
            var request = require("./request-Error-bad_JSON.json");
            payload.process(request);
        });
    });

    it("request has wrong JSON format", function () {
        assert.throws(function () {
            var request = require("./request-Error-wrong_JSON_format.json");
            payload.process(request);
        });
    });

    it("request has wrong JSON payload format", function () {
        assert.throws(function () {
            var request = require("./request-Error-wrong_JSON_payload_format.json");
            payload.process(request);
        });
    });
});