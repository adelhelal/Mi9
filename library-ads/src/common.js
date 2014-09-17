define(['jquery', 'jquery/cookie', './environment', 'hbs!./templates/wrapper', 'hbs!./templates/wrapperDap', 'hbs!./templates/content', 'hbs!./templates/toggle'],
    function ($, cookie, environment, hbsWrapper, hbsWrapperDap, hbsContent, hbsToggle) {

        var dapCounter = 100;

        return {
            getHost: function (index) {
                var repeater = 6;
                return environment.hosts[Math.floor(index % (environment.hosts.length * repeater) / repeater)];
            },

            generateId: function (bytes) {
                bytes = bytes || 32;
                var strings = [], hexDigits = '0123456789ABCDEF';
                for (var i = 0; i < bytes; i += 1) {
                    strings[i] = hexDigits.substr(Math.floor(Math.random() * 16), 1);
                }
                return strings.join('');
            },

            getMuid: function () {
                //var id = localStorage.getItem('TempMUID');
                var id = $.cookie('TempMUID');
                if (!id) {
                    id = this.generateId();
                    //localStorage.setItem('TempMUID', id);
                    $.cookie('TempMUID', id, { expires: 30, path: '/' });
                }
                return id;
            },

            getQueryString: function (name, string) {
                name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
                var regex = new RegExp("[\\?&]" + name + "=([^&#]*)");
                var value = regex.exec(string.toLowerCase());
                return (!value) ? '' : decodeURIComponent(value[1].replace(/\+/g, ' ')).toLowerCase();
            },

            isTouchDevice: function () {
                return (('ontouchstart' in window) || (navigator.MaxTouchPoints > 0) || (navigator.msMaxTouchPoints > 0));
            },

            responsiveCheck: function (ad) {
                return (!ad.minWidth || ad.minWidth == 0 || window.innerWidth >= ad.minWidth) && (!ad.maxWidth || ad.maxWidth == 0 || window.innerWidth <= ad.maxWidth);
            },

            adVisible: function (ad) {
                return this.responsiveCheck(ad) && !(ad.deviceHidden && this.isTouchDevice()) && this.getQueryString('adx_enabled', location.href) !== 'false' && ad.url;
            },

            getToggle: function (id) {
                var toggle = localStorage.getItem(id);
                return !toggle || toggle === null ? 'show' : toggle;
            },

            toggleAd: function (ad) {

                var toggle = this.getToggle(ad.ninemsnId);

                var $divToggle = $(hbsToggle({ toggle: toggle, type: ad.type, location: ad.location }));

                var $target = $(ad.target);
                if ($target.children().length > 0) {
                    $target.children().first().before($divToggle);
                }
                else {
                    $target.append($divToggle);
                }

                var common = this;
                $divToggle.click(function () {

                    toggle = toggle === 'show' ? 'hide' : 'show';
                    localStorage.setItem(ad.ninemsnId, toggle);
                    if (toggle === 'show') {
                        common.renderAd(ad);
                    }
                    else {
                        common.clearAd(ad, true);
                    }

                    $(this).toggleClass('show hide');
                });
            },

            clearAd: function (ad, hasToggle) {
                var $target = $(ad.target);

                if (hasToggle) {
                    $('#' + ad.ninemsnId).remove();
                }
                else {
                    $target.empty();
                }

                if (ad.hasGutters) {
                    $('#' + window.leftGutterId).remove();
                    $('#' + window.rightGutterId).remove();
                    //window.removeEventListener('resize', 'resizeGutters', false);
                }

                if (ad.hasBackground) {
                    $('body').css('background-image', '');
                    $('body').css('background-color', '');
                }

                $('body').removeClass('ads-' + ad.type + '-' + ad.location.replace('.', '-'));
            },

            renderAd: function (ad) {

                $(ad.target).addClass('advert ' + ad.type + ' ' + ad.type + '-' + ad.location.replace('.', '-'));
                $('body').addClass('ads-' + ad.type + '-' + ad.location.replace('.', '-'));

                if (ad.hasToggle && this.getToggle(ad.ninemsnId) === 'hide') {
                    return;
                }

                //Use dapmsn's renderAd directly, otherwise override the rad.msn url
                if (!ad.override) {
                    $(ad.target).append($(hbsWrapperDap({ ninemsnId: ad.ninemsnId, type: ad.type, location: ad.location.replace('.', '-'), id: ad.id })));
                    dapMgr.renderAd(ad.type + '_' + ad.location.replace('.', '-') + '-' + ad.id, ad.url, 1, 1); //fb, ft, ac);
                }
                else {
                    var dapId = 'dapIfM' + (dapCounter--);
                    $(ad.target).append($(hbsWrapper({ ninemsnId: ad.ninemsnId, type: ad.type, location: ad.location.replace('.', '-'), id: ad.id, dapId: dapId })));
                    var frames = $(ad.target).find('#' + dapId);
                    if (frames.length > 0) {
                        frames[0].contentDocument.write(hbsContent({ dapId: dapId, url: ad.url }));
                    }
                }
            },
        };
    });
