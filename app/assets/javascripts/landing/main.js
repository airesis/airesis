/*-----------------------------------------------------------------------------------
 /*
 /* Main JS
 /*
 -----------------------------------------------------------------------------------*/

(function ($) {

    /*---------------------------------------------------- */
    /* Preloader
     ------------------------------------------------------ */
    $(window).load(function () {
        // will first fade out the loading animation
        $("#status").fadeOut("slow");

        // will fade out the whole DIV that covers the website.
        $("#preloader").delay(500).fadeOut("slow").remove();
        $('.login-form').addClass("animated fadeInDownBig");
        $('.hero-text').addClass("animated fadeInDownBig");
        $('.buttons').addClass("animated fadeInDownBig");
        //$('.buttons .learn-more').addClass("animated fadeInRightBig");
        $('.js #hero .hero-image img').addClass("animated fadeInUpBig");
        $('.js #hero .buttons a.trial').addClass("animated shake");
    });


    /*---------------------------------------------------- */
    /* Mobile Menu
     ------------------------------------------------------ */
    var toggle_button = $("<a>", {
            id: "toggle-btn",
            html: "Menu",
            title: "Menu",
            href: "#"
        }
    );
    var nav_wrap = $('nav#nav-wrap')
    var nav = $("ul#nav");

    /* id JS is enabled, remove the two a.mobile-btns
     and dynamically prepend a.toggle-btn to #nav-wrap */
    nav_wrap.find('a.mobile-btn').remove();
    nav_wrap.prepend(toggle_button);

    toggle_button.on("click", function (e) {
        e.preventDefault();
        nav.slideToggle("fast");
    });

    if (toggle_button.is(':visible')) nav.addClass('mobile');
    $(window).resize(function () {
        if (toggle_button.is(':visible')) nav.addClass('mobile');
        else nav.removeClass('mobile');
    });

    $('ul#nav li a').on("click", function () {
        if (nav.hasClass('mobile')) nav.fadeOut('fast');
    });


    /*----------------------------------------------------*/
    /* FitText Settings
     ------------------------------------------------------ */
    setTimeout(function () {

        $('h1.responsive-headline').fitText(1.2, {minFontSize: '25px', maxFontSize: '50px'});

    }, 100);


    /*----------------------------------------------------*/
    /* Smooth Scrolling
     ------------------------------------------------------ */
    $('.smoothscroll').on('click', function (e) {

        e.preventDefault();

        var target = this.hash,
            $target = $(target);

        $('html, body').stop().animate({
            'scrollTop': $target.offset().top
        }, 800, 'swing', function () {
            window.location.hash = target;
        });

    });


    /*----------------------------------------------------*/
    /* Highlight the current section in the navigation bar
     ------------------------------------------------------*/
    var sections = $("section"),
        navigation_links = $("#nav-wrap a");

    sections.waypoint({

        handler: function (event, direction) {

            var active_section;

            active_section = $(this);
            if (direction === "up") active_section = active_section.prev();

            var active_link = $('#nav-wrap a[href="#' + active_section.attr("id") + '"]');

            navigation_links.parent().removeClass("current");
            active_link.parent().addClass("current");

        },
        offset: '35%'
    });


    /*----------------------------------------------------*/
    /* Waypoints Animations
     ------------------------------------------------------ */
    if (window.innerWidth > 640) {
        $('.js .groups').waypoint(function () {
            $('.js .groups .feature-media').addClass('animated fadeInLeftBig').show();
        }, {offset: 'bottom-in-view'});

        $('.js .permissions').waypoint(function () {
            $('.js .permissions .feature-media').addClass('animated fadeInRightBig').show();
        }, {offset: 'bottom-in-view'});

        $('.js .events').waypoint(function () {
            $('.js .events .feature-media').addClass('animated fadeInLeftBig').show();
        }, {offset: 'bottom-in-view'});

        $('.js .proposals').waypoint(function () {
            $('.js .proposals .feature-media').addClass('animated fadeInRightBig').show();
        }, {offset: 'bottom-in-view'});

        $('.js .documents').waypoint(function () {
            $('.js .documents .feature-media').addClass('animated fadeInLeftBig').show();
        }, {offset: 'bottom-in-view'});


        $('.js .forum').waypoint(function () {
            $('.js .forum .feature-media').addClass('animated fadeInRightBig').show();
        }, {offset: 'bottom-in-view'});

        $('.js .more').waypoint(function () {
            $('.js .more .feature-media').addClass('animated fadeInLeftBig').show();
        }, {offset: 'bottom-in-view'});
    }
    else {
        $('.js .groups .feature-media').show();

        $('.js .permissions .feature-media').show();

        $('.js .events .feature-media').show();

        $('.js .proposals .feature-media').show();

        $('.js .documents .feature-media').show();

        $('.js .forum .feature-media').show();

        $('.js .more .feature-media').show();
    }


    /*----------------------------------------------------*/
    /* Flexslider
     /*----------------------------------------------------*/
    $('.flexslider').flexslider({
        namespace: "flex-",
        controlsContainer: ".flex-container",
        animation: 'slide',
        controlNav: true,
        directionNav: false,
        smoothHeight: true,
        slideshowSpeed: 7000,
        animationSpeed: 600,
        randomize: false
    });
})(jQuery);
