Q = require 'q'
browser = require './helper/browser'

describe 'Ads Library', ->

    this.timeout 30000 # Increase the mocha timeout for this spec
    adverts = null

    before (done) ->
        browser.start '../../'
        done()

    context 'with general page checks', ->

        elements = null

        testTypeLocation = (element, type, location, done) ->
            (Q.all [
                element.getAttribute 'data-ad-type'
                element.getAttribute 'data-location'
            ]).done ([adType, location]) ->
                expect(adType).to.equal(type)
                expect(location).to.equal(location)
                done()

        before (done) ->
            browser.visit '/ads.html'
            adverts = browser.find '.advert'
            adverts.then (webElements) ->
                elements = webElements
                browser.timeout done

        beforeEach ->

        it 'should have correct number of ad elements', ->
            expect(elements).to.be.ok
            expect(elements.length).to.equal(11)

        it 'should have correct type and location of 1st ad element', (done) ->
            testTypeLocation elements[0], 'MASTHEAD', 'TOP', done

        it 'should have correct type and location of 2nd ad element', (done) ->
            testTypeLocation elements[1], 'BANNER', 'TOP', done

        it 'should have correct type and location of 3rd ad element', (done) ->
            testTypeLocation elements[2], 'MEDIUM', 'BOTTOM', done

        it 'should have correct type and location of 4th ad element', (done) ->
            testTypeLocation elements[3], 'MEDIUM', 'TOP', done

        it 'should have correct type and location of 5th ad element', (done) ->
            testTypeLocation elements[4], 'MEDIUM', 'TOP', done

        it 'should have correct type and location of 6th ad element', (done) ->
            testTypeLocation elements[5], 'MEDIUM', 'TOP', done

        it 'should have correct type and location of 7th ad element', (done) ->
            testTypeLocation elements[6], 'MEDIUM', 'TOP', done

        it 'should have correct type and location of 8th ad element', (done) ->
            testTypeLocation elements[7], 'MEDIUM', 'TOP', done

        it 'should have correct type and location of 9th ad element', (done) ->
            testTypeLocation elements[8], 'MEDIUM', 'TOP', done

        it 'should have correct type and location of 10th ad element', (done) ->
            testTypeLocation elements[9], 'MEDIUM', 'TOP', done

        it 'should have correct type and location of 11th ad element', (done) ->
            testTypeLocation elements[10], 'MEDIUM', 'TOP', done

        it 'should have correct has-toggle attributes', (done) ->
            (Q.all [
                elements[3].getAttribute 'data-has-toggle'
                elements[4].getAttribute 'data-has-toggle'
            ]).done ([div3, div4]) ->
                expect(div3).to.equal('true')
                expect(div4).to.equal('false')
                done()

        it 'should have correct has-toggle button', (done) ->
            element = elements[3].find '#adToggle'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                done()

        it 'should have correct device-hidden attributes', (done) ->
            (Q.all [
                elements[5].getAttribute 'data-device-hidden'
                elements[6].getAttribute 'data-device-hidden'
            ]).done ([div5, div6]) ->
                expect(div5).to.equal('true')
                expect(div6).to.equal('false')
                done()

        it 'should have correct width attributes', (done) ->
            (Q.all [
                elements[7].getAttribute 'data-min-width'
                elements[8].getAttribute 'data-max-width'
                elements[9].getAttribute 'data-min-width'
                elements[9].getAttribute 'data-max-width'
                elements[10].getAttribute 'data-min-width'
                elements[10].getAttribute 'data-max-width'
            ]).done ([div7, div8, div9min, div9max, div10min, div10max]) ->
                expect(div7).to.equal('500')
                expect(div8).to.equal('700')
                expect(div9min).to.equal('600')
                expect(div9max).to.equal('800')
                expect(div10min).to.equal('0')
                expect(div10max).to.equal('0')
                done()

        it 'should have correct excluded section & subsection attributes', (done) ->
            (Q.all [
                elements[1].getAttribute 'data-excluded-sections'
                elements[1].getAttribute 'data-excluded-subsections'
            ]).done ([section, subsection]) ->
                expect(section).to.equal('home,world')
                expect(subsection).to.equal('nsw')
                done()

        it 'should have correct body class names added', (done) ->
            body = browser.findTag 'body'
            body.then (webElements) ->
                webElements[0].getAttribute('class').then (attribute) ->
                    expect(attribute).to.contain('ads-medium-top')
                    done()

    context 'with all MEDIUM rectangles updated at 1000 x 600', ->

        elements = null
        mediumAdId = '64000000000184776' # AUXXAI

        before (done) -> 
            browser.visit '/ads.html?adx_medium=' + mediumAdId
            browser.resize 1000, 600
            adverts = browser.find '.advert'
            adverts.then (webElements) ->
                elements = webElements
                browser.timeout done

        beforeEach -> 

        it 'should have ad ninemsn_ad-2 displayed with the correct adId', (done) ->
            element = elements[2].find '#dapIfM100'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                browser.executeScriptInFrame 'dapIfM100', 'return getRADIds()', (result) ->
                    expect(result.adid).to.equal(mediumAdId)
                done()

        it 'should have ad ninemsn_ad-3 displayed with the correct adId', (done) ->
            element = elements[3].find '#dapIfM99'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                browser.executeScriptInFrame 'dapIfM99', 'return getRADIds()', (result) ->
                    expect(result.adid).to.equal(mediumAdId)
                done()

        it 'should have ad ninemsn_ad-4 displayed with the correct adId', (done) ->
            element = elements[4].find '#dapIfM98'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                browser.executeScriptInFrame 'dapIfM98', 'return getRADIds()', (result) ->
                    expect(result.adid).to.equal(mediumAdId)
                done()

        it 'should have ad ninemsn_ad-5 displayed with the correct adId', (done) ->
            element = elements[5].find '#dapIfM97'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                browser.executeScriptInFrame 'dapIfM97', 'return getRADIds()', (result) ->
                    expect(result.adid).to.equal(mediumAdId)
                done()

        it 'should have ad ninemsn_ad-6 displayed with the correct adId', (done) ->
            element = elements[6].find '#dapIfM96'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                browser.executeScriptInFrame 'dapIfM96', 'return getRADIds()', (result) ->
                    expect(result.adid).to.equal(mediumAdId)
                done()

        it 'should have ad ninemsn_ad-7 displayed with the correct adId', (done) ->
            element = elements[7].find '#dapIfM95'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                browser.executeScriptInFrame 'dapIfM95', 'return getRADIds()', (result) ->
                    expect(result.adid).to.equal(mediumAdId)
                done()

        it 'should not have ad ninemsn_ad-8 displayed', (done) ->
            element = elements[8].find '#ninemsn_ad-8'
            element.then (webElements) ->
                expect(webElements).to.be.empty
                done()

        it 'should not have ad ninemsn_ad-9 displayed', (done) ->
            element = elements[9].find '#ninemsn_ad-9'
            element.then (webElements) ->
                expect(webElements).to.be.empty
                done()

        it 'should have ad ninemsn_ad-10 displayed with the correct adId', (done) ->
            element = elements[10].find '#dapIfM94'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                browser.executeScriptInFrame 'dapIfM94', 'return getRADIds()', (result) ->
                    expect(result.adid).to.equal(mediumAdId)
                done()

    context 'with MEDIUM BOTTOM rectangle updated at 1000 x 600', ->

        elements = null
        mediumTopAdId = '64000000000184776' # AUXXAI
        mediumBottomAdId = '11000000000197650' # 

        before (done) -> 
            browser.visit '/ads.html?adx_medium_top=' + mediumTopAdId + '&' + 'adx_medium_bottom=' + mediumBottomAdId
            browser.resize 1000, 600
            adverts = browser.find '.advert'
            adverts.then (webElements) ->
                elements = webElements
                browser.timeout done

        beforeEach -> 

        it 'should have ad ninemsn_ad-2 displayed with the correct adId', (done) ->
            element = elements[2].find '#dapIfM100'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                browser.executeScriptInFrame 'dapIfM100', 'return getRADIds()', (result) ->
                    expect(result.adid).to.equal(mediumBottomAdId)
                done()

        it 'should have ad ninemsn_ad-3 displayed with the correct adId', (done) ->
            element = elements[3].find '#dapIfM99'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                browser.executeScriptInFrame 'dapIfM99', 'return getRADIds()', (result) ->
                    expect(result.adid).to.equal(mediumTopAdId)
                done()

        it 'should have ad ninemsn_ad-4 displayed with the correct adId', (done) ->
            element = elements[4].find '#dapIfM98'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                browser.executeScriptInFrame 'dapIfM98', 'return getRADIds()', (result) ->
                    expect(result.adid).to.equal(mediumTopAdId)
                done()

        it 'should have ad ninemsn_ad-5 displayed with the correct adId', (done) ->
            element = elements[5].find '#dapIfM97'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                browser.executeScriptInFrame 'dapIfM97', 'return getRADIds()', (result) ->
                    expect(result.adid).to.equal(mediumTopAdId)
                done()

        it 'should have ad ninemsn_ad-6 displayed with the correct adId', (done) ->
            element = elements[6].find '#dapIfM96'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                browser.executeScriptInFrame 'dapIfM96', 'return getRADIds()', (result) ->
                    expect(result.adid).to.equal(mediumTopAdId)
                done()

        it 'should have ad ninemsn_ad-7 displayed with the correct adId', (done) ->
            element = elements[7].find '#dapIfM95'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                browser.executeScriptInFrame 'dapIfM95', 'return getRADIds()', (result) ->
                    expect(result.adid).to.equal(mediumTopAdId)
                done()

        it 'should not have ad ninemsn_ad-8 displayed', (done) ->
            element = elements[8].find '#ninemsn_ad-8'
            element.then (webElements) ->
                expect(webElements).to.be.empty
                done()

        it 'should not have ad ninemsn_ad-9 displayed', (done) ->
            element = elements[9].find '#ninemsn_ad-9'
            element.then (webElements) ->
                expect(webElements).to.be.empty
                done()

        it 'should have ad ninemsn_ad-10 displayed with the correct adId', (done) ->
            element = elements[10].find '#dapIfM94'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                browser.executeScriptInFrame 'dapIfM94', 'return getRADIds()', (result) ->
                    expect(result.adid).to.equal(mediumTopAdId)
                done()

    context 'with MEDIUM TOP rectangle switched off at 1000 x 600', ->

        elements = null
        mediumBottomAdId = '64000000000184776' # AUXXAI

        before (done) -> 
            browser.visit '/ads.html?adx_medium_top=off&adx_medium_bottom=' + mediumBottomAdId
            browser.resize 1000, 600
            adverts = browser.find '.advert'
            adverts.then (webElements) ->
                elements = webElements
                browser.timeout done

        beforeEach -> 

        it 'should have ad ninemsn_ad-2 displayed', (done) ->
            element = elements[2].find '#ninemsn_ad-2'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                done()

        it 'should not have ad ninemsn_ad-3 displayed', (done) ->
            element = elements[3].find '#ninemsn_ad-3'
            element.then (webElements) ->
                expect(webElements).to.be.empty
                done()

        it 'should not have ad ninemsn_ad-4 displayed', (done) ->
            element = elements[4].find '#ninemsn_ad-4'
            element.then (webElements) ->
                expect(webElements).to.be.empty
                done()

        it 'should not have ad ninemsn_ad-5 displayed', (done) ->
            element = elements[5].find '#ninemsn_ad-5'
            element.then (webElements) ->
                expect(webElements).to.be.empty
                done()

        it 'should not have ad ninemsn_ad-6 displayed', (done) ->
            element = elements[6].find '#ninemsn_ad-6'
            element.then (webElements) ->
                expect(webElements).to.be.empty
                done()

        it 'should not have ad ninemsn_ad-7 displayed', (done) ->
            element = elements[7].find '#ninemsn_ad-7'
            element.then (webElements) ->
                expect(webElements).to.be.empty
                done()

        it 'should not have ad ninemsn_ad-8 displayed', (done) ->
            element = elements[8].find '#ninemsn_ad-8'
            element.then (webElements) ->
                expect(webElements).to.be.empty
                done()

        it 'should not have ad ninemsn_ad-9 displayed', (done) ->
            element = elements[9].find '#ninemsn_ad-9'
            element.then (webElements) ->
                expect(webElements).to.be.empty
                done()

        it 'should not have ad ninemsn_ad-10 displayed', (done) ->
            element = elements[10].find '#ninemsn_ad-10'
            element.then (webElements) ->
                expect(webElements).to.be.empty
                done()

    context 'with other ad types at 1000 x 600', ->

        elements = null
        bannerAdId = '101000000000187030' # AUXXAA
        mastheadAdId = '101000000000187030' # AUXXAB

        before (done) -> 
            browser.visit '/ads.html?adx_banner=' + bannerAdId + '&adx_masthead=' + mastheadAdId
            browser.resize 1000, 600
            adverts = browser.find '.advert'
            adverts.then (webElements) ->
                elements = webElements
                browser.timeout done

        beforeEach -> 

        it 'should display masthead with correct adId', (done) ->
            element = elements[0].find '#dapIfM100'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                browser.executeScriptInFrame 'dapIfM100', 'return getRADIds()', (result) ->
                    expect(result.adid).to.equal(mastheadAdId)
                done()

        it 'should not display banner from excluded section "news"', (done) ->
            element = elements[1].find '#ninemsn_ad-1'
            element.then (webElements) ->
                expect(webElements).to.be.empty
                done()

    context 'with responsive resizing at 750 x 600', ->

        elements = null
        mediumAdId = '64000000000184776' # AUXXAI

        before (done) -> 
            browser.visit '/ads.html?adx_medium=' + mediumAdId
            browser.resize 750, 600
            adverts = browser.find '.advert'
            adverts.then (webElements) ->
                elements = webElements
                browser.timeout done

        beforeEach -> 

        it 'should have ad ninemsn_ad-7 displayed', (done) ->
            element = elements[7].find '#ninemsn_ad-7'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                done()

        it 'should not have ad ninemsn_ad-8 displayed', (done) ->
            element = elements[8].find '#ninemsn_ad-8'
            element.then (webElements) ->
                expect(webElements).to.be.empty
                done()

        it 'should have ad ninemsn_ad-9 displayed', (done) ->
            element = elements[9].find '#ninemsn_ad-9'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                done()

        it 'should have ad ninemsn_ad-10 displayed', (done) ->
            element = elements[10].find '#ninemsn_ad-10'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                done()

    context 'with responsive resizing at 650 x 600', ->

        elements = null
        mediumAdId = '64000000000184776' # AUXXAI

        before (done) -> 
            browser.visit '/ads.html?adx_medium=' + mediumAdId
            browser.resize 650, 600
            adverts = browser.find '.advert'
            adverts.then (webElements) ->
                elements = webElements
                browser.timeout done

        beforeEach -> 

        it 'should have ad ninemsn_ad-7 displayed', (done) ->
            element = elements[7].find '#ninemsn_ad-7'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                done()

        it 'should have ad ninemsn_ad-8 displayed', (done) ->
            element = elements[8].find '#ninemsn_ad-8'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                done()

        it 'should have ad ninemsn_ad-9 displayed', (done) ->
            element = elements[9].find '#ninemsn_ad-9'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                done()

        it 'should have ad ninemsn_ad-10 displayed', (done) ->
            element = elements[10].find '#ninemsn_ad-10'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                done()

    context 'with responsive resizing at 550 x 600', ->

        elements = null
        mediumAdId = '64000000000184776' # AUXXAI

        before (done) -> 
            browser.visit '/ads.html?adx_medium=' + mediumAdId
            browser.resize 550, 600
            adverts = browser.find '.advert'
            adverts.then (webElements) ->
                elements = webElements
                browser.timeout done

        beforeEach -> 

        it 'should have ad ninemsn_ad-7 displayed', (done) ->
            element = elements[7].find '#ninemsn_ad-7'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                done()

        it 'should have ad ninemsn_ad-8 displayed', (done) ->
            element = elements[8].find '#ninemsn_ad-8'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                done()

        it 'should not have ad ninemsn_ad-9 displayed', (done) ->
            element = elements[9].find '#ninemsn_ad-9'
            element.then (webElements) ->
                expect(webElements).to.be.empty
                done()

        it 'should have ad ninemsn_ad-10 displayed', (done) ->
            element = elements[10].find '#ninemsn_ad-10'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                done()

    context 'with responsive resizing at 450 x 600', ->

        elements = null
        mediumAdId = '64000000000184776' # AUXXAI

        before (done) -> 
            browser.visit '/ads.html?adx_medium=' + mediumAdId
            browser.resize 450, 600
            adverts = browser.find '.advert'
            adverts.then (webElements) ->
                elements = webElements
                browser.timeout done

        beforeEach -> 

        it 'should not have ad ninemsn_ad-7 displayed', (done) ->
            element = elements[7].find '#ninemsn_ad-7'
            element.then (webElements) ->
                expect(webElements).to.be.empty
                done()

        it 'should have ad ninemsn_ad-8 displayed', (done) ->
            element = elements[8].find '#ninemsn_ad-8'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                done()

        it 'should not have ad ninemsn_ad-9 displayed', (done) ->
            element = elements[9].find '#ninemsn_ad-9'
            element.then (webElements) ->
                expect(webElements).to.be.empty
                done()

        it 'should have ad ninemsn_ad-10 displayed', (done) ->
            element = elements[10].find '#ninemsn_ad-10'
            element.then (webElements) ->
                expect(webElements).to.not.be.empty
                done()

    context 'with toggle button', ->

        elements = null
        mediumAdId = '64000000000184776' # AUXXAI

        before (done) -> 
            browser.visit '/ads.html?adx_medium=' + mediumAdId
            browser.resize 1000, 600
            adverts = browser.find '.advert'
            adverts.then (webElements) ->
                elements = webElements
                browser.timeout done

        beforeEach -> 

        it 'should hide and show ad when button is clicked', (done) ->
            (Q.all [
                elements[3].find '#adToggle'
                elements[3].find '#ninemsn_ad-3'
            ]).done ([buttons, webElements]) ->
                expect(buttons).to.not.be.empty
                expect(webElements).to.not.be.empty

                browser.executeScript('$(".medium-top #adToggle").attr("style", "position:absolute; top:0;");')
                .then (result) ->
                    buttons[0].click().then ->
                        browser.timeout -> 
                            elements[3].find('#ninemsn_ad-3').then (webElements) ->
                                expect(webElements).to.be.empty
                                buttons[0].click().then ->
                                    browser.timeout -> 
                                        elements[3].find('#ninemsn_ad-3').then (webElements) ->
                                            expect(webElements).to.not.be.empty
                                            done()
