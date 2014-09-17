// Main
requirejs.config({
    baseUrl: '../src',
    paths: {
        'jquery': 'thirdParty/jquery/jquery-1.8.3',
        'jquery/cookie': 'thirdParty/jquery/cookie/jquery.cookie',
        'hbs': 'thirdParty/handlebars/hbs',
    },
});

require(['index'], function (index) {
    index.configure({
        site: 'news',
        section: 'home',
        subsection: undefined
    });
});
