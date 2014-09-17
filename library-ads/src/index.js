define(['jquery', './environment', './setup', './common', 'hbs!./templates/style', './thirdParty/dap/dapmsn'],
    function ($, environment, setup, common, hbsStyle, dapmsn) {
        var adIndex = -1;
        var adCall;
        var index;
        var globalConfig;
        var queuedAds = $('.advert');

        return {

            configure: function (configuration) {
                this.callAdExpert(configuration);
            },

            callAdExpert: function (configuration) {

                var date = new Date();

                configuration.site = configuration.site === null || configuration.site === '' ? undefined : configuration.site;
                configuration.section = configuration.section === null || configuration.section === '' ? undefined : configuration.section;
                configuration.subsection = configuration.subsection === null || configuration.subsection === '' ? undefined : configuration.subsection;

                $('body').append($(hbsStyle()));

                $.ajax({
                    type: 'GET',
                    url: environment.serviceUrl,
                    cache: true,
                    context: this,
                    dataType: 'jsonp',
                    data: {
                        serviceName: 'AdExpert',
                        serviceAction: 'GetAdExpertList',
                        serviceFormat: 'JSONAUTO',
                        type: 'both',
                        v: date.getDate().toString() + date.getMonth().toString() + date.getFullYear().toString() + (configuration.site.toLowerCase() === 'news' ? date.getHours() <= 12 ? '0' : '12' : ''),
                        siteName: configuration.site
                    },
                    success: function (data) {
                        this.responseCallback(data, configuration);
                    }
                });
            },

            responseCallback: function (data, configuration) {

                index = this;
                globalData = data;
                globalConfig = configuration;

                adCall = this.flattenAdCalls(data.AdExpert.AdCalls, 0)
                        .filter(function (flattenedAd) {
                            return flattenedAd.site === configuration.site
                                && (!flattenedAd.section || flattenedAd.section === configuration.section)
                                && (!flattenedAd.subsection || flattenedAd.subsection === configuration.subsection);
                        }).sort(function (previous, next) {
                            //subsection and sections with values take precedence over undefined subsection and sections
                            return !previous.subsection && next.subsection ? 1 : !previous.section && next.section ? 1 : -1;
                        });

                var tags = this.flattenTagCalls(data.AdExpert.RetargetingCalls, 0)
                        .filter(function (flattenedTag) {
                            return flattenedTag.site === configuration.site
                                && (!flattenedTag.section || flattenedTag.section === configuration.section)
                                && (!flattenedTag.subsection || flattenedTag.subsection === configuration.subsection);
                        }).sort(function (previous, next) {
                            //subsection and sections with values take precedence over undefined subsection and sections
                            return !previous.subsection && next.subsection ? 1 : !previous.section && next.section ? 1 : -1;
                        });

                // only insert ads that were queued while AdExpert was responding
                $.each(queuedAds, function (key, div) {
                    index.writeAd($(div));
                });

                //display retargeting tags
                if (tags.length > 0) {
                    $('body').append(tags[0].Tag);
                }
            },

            writeAd: function (div) {
                //to prevent ad injections through decorator to be called before the call to AdExpert has been successful
                if(typeof(globalConfig) === 'undefined'){
                    queuedAds.push(div);
                    return;
                }

                adIndex++;

                var ads = window.ads;
                var $div = $(div);
                var adType = $div.data('adType').toLowerCase();
                var adLocation = $div.data('location').toLowerCase();
                var isExcluded = index.isExcluded(globalConfig, $div.data('excludedSections'), $div.data('excludedSubsections'));

                //filter adCall JSON for the correct adType and loc
                var adTypeLocations = $.grep(adCall, function (ad, i) {
                    return adType === ad.AdType.toLowerCase() && adLocation === ad.loc.toLowerCase() && !isExcluded;
                });

                if (!adTypeLocations || adTypeLocations.length === 0) {

                    //if there is an ad override in the query string
                    var override = index.getOverride(adType, adLocation);
                    if (override && !isExcluded) {
                        adTypeLocations[0] = {
                            AdType: adType,
                            loc: adLocation,
                            PG: override,
                            AP: override
                        }
                    }
                    else {
                        return;
                    }
                }

                //add ad to ads collection
                var adTypeLocation = adTypeLocations[0];
                var ad = {
                    id: adIndex,
                    ninemsnId: 'ninemsn_ad-' + adIndex,
                    type: adTypeLocation.AdType.toLowerCase(),
                    location: adTypeLocation.loc.toLowerCase(),
                    pageGroup: adTypeLocation.PG,
                    placement: adTypeLocation.AP,
                    hasToggle: $div.data('hasToggle'),
                    deviceHidden: $div.data('deviceHidden'),
                    minWidth: $div.data('minWidth'),
                    maxWidth: $div.data('maxWidth'),
                    site: globalConfig.site,
                    section: globalConfig.section,
                    subsection: globalConfig.subsection,
                    target: div,
                    url: '&PG=' + adTypeLocation.PG + '&AP=' + adTypeLocation.AP
                };

                ads.push(ad);

                index.adOverride(ad);

                //display the ad
                if (common.adVisible(ad)) {

                    common.renderAd(ad);

                    if (ad.hasToggle) {
                        common.toggleAd(ad);
                    }
                }

            },

            flattenAdCalls: function (adCalls, level, adSite, adSection, adSubsection) {

                var flattenedAds = [];

                switch (level) {
                    case 0:
                        adSite = adCalls.Name;
                        break;
                    case 1:
                        adSection = adCalls.Name;
                        break;
                    case 2:
                        adSubsection = adCalls.Name;
                        break;
                    default:
                }

                if (adCalls.AdxCalls && adCalls.AdxCalls.AdCall) {

                    var adx = adCalls.AdxCalls.AdCall.length ? adCalls.AdxCalls.AdCall : [adCalls.AdxCalls.AdCall];

                    for (var i = 0 ; i < adx.length; i++) {
                        flattenedAd = adx[i];
                        flattenedAd.level = level;
                        flattenedAd.site = adSite ? adSite.toLowerCase() : undefined;
                        flattenedAd.section = adSection ? adSection.toLowerCase() : undefined;
                        flattenedAd.subsection = adSubsection ? adSubsection.toLowerCase() : undefined;
                        flattenedAds.push(flattenedAd);
                    }
                }

                if (adCalls.SubLevels && adCalls.SubLevels.AdxNodeOfAdCall) {

                    var adxNodes = adCalls.SubLevels.AdxNodeOfAdCall.length ? adCalls.SubLevels.AdxNodeOfAdCall : [adCalls.SubLevels.AdxNodeOfAdCall];

                    for (var i = 0 ; i < adxNodes.length; i++) {
                        flattenedAds = flattenedAds.concat(this.flattenAdCalls(adxNodes[i], level + 1, adSite, adSection, adSubsection));
                    }
                }

                return flattenedAds;
            },

            flattenTagCalls: function (retargetingCalls, level, adSite, adSection, adSubsection) {

                var flattenedTags = [];

                switch (level) {
                    case 0:
                        adSite = retargetingCalls.Name;
                        break;
                    case 1:
                        adSection = retargetingCalls.Name;
                        break;
                    case 2:
                        adSubsection = retargetingCalls.Name;
                        break;
                    default:
                }

                if (retargetingCalls.AdxCalls && retargetingCalls.AdxCalls.RetargetingCall) {

                    var tags = retargetingCalls.AdxCalls.RetargetingCall.length ? retargetingCalls.AdxCalls.RetargetingCall : [retargetingCalls.AdxCalls.RetargetingCall];

                    for (var i = 0 ; i < tags.length; i++) {
                        flattenedTag = tags[i];
                        flattenedTag.level = level;
                        flattenedTag.site = adSite ? adSite.toLowerCase() : undefined;
                        flattenedTag.section = adSection ? adSection.toLowerCase() : undefined;
                        flattenedTag.subsection = adSubsection ? adSubsection.toLowerCase() : undefined;
                        flattenedTags.push(flattenedTag);
                    }
                }

                if (retargetingCalls.SubLevels && retargetingCalls.SubLevels.AdxNodeOfRetargetingCall) {

                    var adxNodes = retargetingCalls.SubLevels.AdxNodeOfRetargetingCall.length ? retargetingCalls.SubLevels.AdxNodeOfRetargetingCall : [retargetingCalls.SubLevels.AdxNodeOfRetargetingCall];

                    for (var i = 0 ; i < adxNodes.length; i++) {
                        flattenedTags = flattenedTags.concat(this.flattenTagCalls(adxNodes[i], level + 1, adSite, adSection, adSubsection));
                    }
                }

                return flattenedTags;
            },

            isExcluded: function (configuration, excludedSections, excludedSubsections) {
                return !(
                    (!excludedSections || $.inArray(configuration.section, excludedSections.toLowerCase().split(',')) === -1)
                     && (!excludedSubsections || $.inArray(configuration.subsection, excludedSubsections.toLowerCase().split(',')) === -1)
                );
            },

            getOverride: function (adType, adLocation) {
                var typeOverride = common.getQueryString('adx_' + adType, location.href);
                var typeLocationOverride = common.getQueryString('adx_' + adType + '_' + adLocation.replace('.', '_'), location.href);

                return typeLocationOverride || typeOverride;
            },

            adOverride: function (ad) {
                var override = this.getOverride(ad.type, ad.location);

                if (override) {
                    if (override === 'off') {
                        ad.url = undefined;
                    }
                    else {
                        ad.override = override;
                        ad.pageGroup = override;
                        ad.placement = override;
                        ad.url = environment.adUrlOverride
                            .replace(/\{host\}/g, common.getHost(ad.id))
                            .replace(/\{dpjs\}/g, environment.adDPJS)
                            .replace(/\{id\}/g, common.getMuid())
                            .replace(/\{cid\}/g, override);
                    }
                }
            }
        };
    });
