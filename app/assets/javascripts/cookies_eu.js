$(document).ready(function () {
    $('.cookies-eu-ok').click(function (e) {
        e.preventDefault();
        Cookie.set('cookie_eu_consented', 'true', {path: '/', expires: 365});
        $('.cookies-eu').remove();
    });
});
