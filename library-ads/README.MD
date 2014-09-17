# Mi9 - Ads

## Process

* Ads team use AdExpert to create a unique ad with a *Page Group* identifier and an *Ad Placement* identifier

* Ad Library makes a call to the Mi9 service http://data.9msn.com.au to retrieve all *Page Groups* and *Ad Placements*

* Each Ad then makes a call to the Microsoft Ad service http://rad.msn.com passing in *Page Group* and *Ad Placement*

* Response contains javascript or flash object tags that are then injected into an iFrame which is programmatically appended to each respective div tag

## Prerequisites

- [Require.js](http://requirejs.org/)
- [JQuery](http://jquery.com/download/)
- [JQuery Cookie](http://plugins.jquery.com/cookie/)
- [Handlebars - require-handlebars-plugin](https://github.com/SlexAxton/require-handlebars-plugin)

## Specifications

<pre>
    &lt;div class="advert" 
        data-ad-type="MEDIUM" 
        data-location="TOP"
        data-has-toggle="true"
        data-device-hidden="true" 
        data-min-width="400" 
        data-max-width="500" 
        data-excluded-sections="home,world"
        data-excluded-subsections="nsw"
    &gt;&lt;/div&gt;
</pre>

* **class** must be "advert"
* **data-ad-type** is mandatory and is defined by Ad-Ops (e.g. "MEDIUM")
* **data-location** is mandatory and is defined by Ad-Ops (e.g. "TOP")
* **data-has-toggle** allows ad to have a hide/show button (boolean)
* **data-device-hidden** hides ad on any device or tablet (boolean)
* **data-min-width** displays ad if greater than specified width in pixels
* **data-max-width** displays ad if smaller than specified width in pixels
* **data-excluded-sections** comma separated list of sections to hide the ad
* **data-excluded-subsections** comma separated list of subsections to hide the ad

## Integration

* npm install mi9-ads from submodule .\custom_modules

* Require js configuration:

<pre>
    paths:
        'jquery': "#{path}/jquery/dist/jquery",
        'jquery/cookie': "#{path}/jquery.cookie/jquery.cookie",
        'hbs': "#{path}/require-handlebars-plugin/hbs"
    packages: [
        {
            name: 'mi9-ads',
            location: "#{npm}/mi9-ads/src/",
            main: 'index'
        }
    ]
</pre>

* Main js of Require:

<pre>
    define(['mi9-ads], function(mi9Ads) {
        mi9Ads.configure({
            site: 'news',
            section: 'home',
            subsection: undefined,
        });
    }); 
</pre>
