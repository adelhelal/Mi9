/* Global Declarations */
define(['jquery', './common'], function ($, common) {

    window.ads = [];
    window.hasGutters = false;
    window.leftGutterId = 'ninemsn_ads_leftGutter';
    window.rightGutterId = 'ninemsn_ads_rightGutter';
    window.hasBackground = $('body').css('background-image') !== 'none';

    window.adLoaded = function (adFrame) {

        var adsChange = ads.filter(function (ad) {
            return ad.ninemsnId === adFrame.parent().parent().attr('id');
        });

        if (adsChange.length > 0) {

            var ad = adsChange[0];

            var $target = $(ad.target);
            $target.width(adFrame.width());

            if (!window.hasGutters) {
                window.hasGutters = $('#' + window.rightGutterId).length > 0;
                ad.hasGutters = window.hasGutters;
            }

            if (!window.hasBackground) {
                window.hasBackground = $('body').css('background-image') !== 'none';
                ad.hasBackground = window.hasBackground;
            }

            //hide the toggle button if the ad has rendered but is not visible
            if (adFrame.width() <= 1 || adFrame.height() <= 1) {
                var $adToggle = null;
                $.when(
                    $adToggle = $target.find('#adToggle')
                ).then(function () {
                    if ($adToggle) {
                        $adToggle.remove();
                    }
                });
            }
        }
    }

    window.onresize = function () {

        var adsChange = ads.filter(function (ad) {
            return common.adVisible(ad);
        });

        $.each(ads, function (index, ad) {
            var responsive = $.inArray(ad, adsChange) >= 0;
            var shown = $(ad.target).children().length > 0;

            if (responsive && !shown) {

                common.renderAd(ad);

                if (ad.hasToggle) {
                    common.toggleAd(ad);
                }
            }
            else if (!responsive && shown) {
                common.clearAd(ad);
            }
        });
    };

    //Ads Visualizer
    window.ninemsn = {
        ads: {
            AdManager: {
                getStoredAdCalls: function () {
                    var visualizer = [];
                    $.each(ads, function (index, ad) {
                        var $target = $(ad.target);
                        if ($target.children().length > 0) {
                            visualizer.push({
                                $target: $target,
                                adType: ad.type,
                                loc: ad.location,
                                adPlacement: ad.placement,
                                pageGroup: ad.pageGroup,
                                divId: ad.ninemsnId,
                                siteHierarchy: [ad.site, ad.section, ad.subsection],
                                //siteInfo:
                                //callback:
                                //deferred:
                                //randomPageId:
                            });
                        }
                    });
                    return visualizer;
                }
            }
        }
    };

    //override dap logger
    dapMgr.lg = function (log) {
        var message = 'checkViewability; ifrmId: ';
        value = log.indexOf(message)
        if (value != -1) {
            window.adLoaded($('#' + log.substring(message.length, log.length)));
        }
    };

    //IE8 support for JSON Array.filter()
    if (!Array.prototype.filter) {
        Array.prototype.filter = function (callback) {
            "use strict";

            if (this == null) {
                throw new TypeError();
            }

            var type = Object(this);

            if (typeof callback != "function") {
                throw new TypeError();
            }

            var array = [];
            var argument = arguments[1];

            for (var i = 0; i < (type.length >>> 0) ; i++) {
                if (i in type) {
                    var value = type[i]; // in case callback mutates this
                    if (callback.call(argument, value, i, type)) {
                        array.push(value);
                    }
                }
            }

            return array;
        };
    }
});
