path = require 'path'
httpServer = require 'http-server'
chromedriver = require 'chromedriver'
webdriver = require 'selenium-webdriver'

port = 8080
server = null

separator = if process.platform.match(/^win/) then ';' else ':'

# Ensure that the correct chromedriver executable will be found on the path
process.env.PATH = "#{path.dirname chromedriver.path}#{separator}#{process.env.PATH}"

# Build and expose a webdriver instance
module.exports = driver = new webdriver.Builder().withCapabilities(webdriver.Capabilities.chrome()).build()

# Start a server to listen on
driver.start = (root) ->
    server = httpServer.createServer root: __dirname + '../' + root
    server.listen port

# Visit a relative path
driver.visit = (path) ->
    this.get "http://localhost:#{port}#{path}"

# Resize the window
driver.resize = (width, height) ->
    this.manage().window().setSize(width, height)

# Simplify element location using css selectors
driver.find = webdriver.WebElement.prototype.find = (css) ->
    this.findElements(webdriver.By.css css).then (elements) ->
        elements

driver.findTag = webdriver.WebElement.prototype.findTag = (tag) ->
    this.findElements(webdriver.By.tagName tag).then (elements) ->
        elements

driver.isPresent = webdriver.WebElement.prototype.isPresent = (css) ->
    this.isElementPresent(webdriver.By.css css).then (elements) ->
        elements

driver.timeout = (callback) ->
    setTimeout -> callback(),
    2000

driver.executeScriptInFrame = (id, script, callback) ->
    driver.switchTo().frame(id).then ->
        driver.executeScript(script).then (result) ->
            try
                callback(result)
            catch
            finally
                driver.switchTo().defaultContent().then ->
                    callback(result)

# Tear down driver at end of test run
after (next) ->
    this.timeout(60000)
    driver.quit().then -> 
        next()
        server.close()
