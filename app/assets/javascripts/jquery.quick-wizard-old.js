(function ($) {

    $.fn.quickWizard = function (options, callback) {

        var settings = {
            'prevButton': '<button id="form-wizard-prev" type="button" class="btn backButton">Go back</button>',
            'nextButton': '<button id="form-wizard-next" type="button" class="btn blue forwardButton">Next</button>',
            'activeClass': 'form-wizard-active',
            'element': 'div.step',
            'submit': '[type = "submit"]',
            'root': null,
            'prevArgs': [0],
            'nextArgs': [0],
            'disabledClass': 'ui-button-disabled ui-state-disabled',
            'containerClass': 'form-wizard-container',
            'breadCrumb': true,
            'breadCrumbElement': 'div.legend',
            'breadCrumbListOpen': '<ol class="bread-crumb">',
            'breadCrumbListClose': '</ol><br/>',
            'breadCrumbListElementOpen': '<li><div class="step_title">',
            'breadCrumbListElementClose': '</div></li>',
            'breadCrumbListElementOpenFirst': '<li><div class="first step_title">',
            'breadCrumbListElementOpenLast': '<li><div class="last step_title">',
            'breadCrumbActiveClass': 'bread-crumb-active',
            'breadCrumbCompletedClass': 'bread-crumb-completed',
            'breadCrumbPosition': 'before',
            'clickableBreadCrumbs': false
        };

        if (options) {
            $.extend(settings, options);
        }

        callback = callback || function () {
        };

        function disablePrev(prevObj) {
            if ($(prevObj).is(":button")) {
                $(prevObj).attr('disabled', 'disabled');
            }
            $(prevObj).addClass(settings.disabledClass);
        }

        return this.each(function () {

            var container = $(this);
            var children = container.children(settings.element);
            var activeClassSelector = '.' + settings.activeClass;
            var submitButton = container.find(settings.submit);
            var insertedNextCallback;
            var originalNextCallback;
            var root;
            var breadCrumbList;

            if (settings.root === null) {
                root = children.first();
            } else {
                root = $(settings.root);
            }

            /* Set up container class */
            if (settings.containerClass != "") {
                container.addClass(settings.containerClass);
            }

            /* Set up bread crumb menu */
            if (settings.breadCrumb) {
                breadCrumbList = settings.breadCrumbListOpen

                breadCrumbElements = container.find(settings.breadCrumbElement);
                breadCrumbElements.each(function (index) {
                    if (index == 0) {
                        breadCrumbList += settings.breadCrumbListElementOpenFirst + $(this).html() + settings.breadCrumbListElementClose;
                    }
                    else if (index == (breadCrumbElements.size() - 1)) {
                        breadCrumbList += settings.breadCrumbListElementOpenLast + $(this).html() + settings.breadCrumbListElementClose;
                    }
                    else {
                        breadCrumbList += settings.breadCrumbListElementOpen + $(this).html() + settings.breadCrumbListElementClose;
                    }
                });

                breadCrumbList += settings.breadCrumbListClose;
                if (settings.breadCrumbPosition === 'after') {
                    breadCrumbList = $(breadCrumbList).insertAfter(container);
                } else {
                    breadCrumbList = $(breadCrumbList).insertBefore(container);
                }
                breadCrumbList.children().first().addClass(settings.breadCrumbActiveClass);
            }

            /* Check if the last argument is a callback function */
            if (typeof (settings.nextArgs[settings.nextArgs.length - 1]) == "function") {

                /* If it is store the user provided callback */
                originalNextCallback = settings.nextArgs[settings.nextArgs.length - 1];

                /* then replace it with a wrapper function that calls both the user provided function and ours */
                settings.nextArgs[settings.nextArgs.length - 1] = function () {
                    insertedNextCallback.call();
                    originalNextCallback.call();
                };

            } else {

                /* If there is no callback function append ours */
                settings.nextArgs[settings.nextArgs.length] = function () {
                    insertedNextCallback.call();
                }
            }

            /* Insert the previous and next buttons after the submit button and hide it until we're ready */

            var prev = $(settings.prevButton).insertBefore(submitButton);
            var next = $(settings.nextButton).insertBefore(submitButton);
            submitButton.hide();

            /*mega pezzotto by Andrea Maresta*/
            prev.keypress(function (e) {
                var keyCode = e.keyCode || e.which;
                if (keyCode == 9) {
                    if (e.shiftKey) {
                        $('.form-wizard-container textarea:visible').last().focus()
                    }
                    else {
                        prev.nextAll('.buttonStyle:visible').focus();
                    }
                }
                else if (keyCode == 13) {
                    prev.click();
                }
            });

            /* If the root element is first disable the previous button */
            if (root.hasClass('root')) {
                disablePrev(prev);
            }

            children.hide();
            root.toggleClass(settings.activeClass).show();

            $(next).click(function () {
                var active = container.find(activeClassSelector);

                /* Check to see if the forms are valid before moving on */

                if (validElement()) {
                    var nextSet = active.next(settings.element);
                    var afterNextSet = nextSet.next(settings.element);
                    if (nextSet.length) {
                        $(active).toggleClass(settings.activeClass);
                        $(nextSet).toggleClass(settings.activeClass);

                        /* Get the current element's position and store it */
                        active.data('posiiton', active.css('position'));

                        /* Set our callback function */
                        insertedNextCallback = function () {
                            active.css('position', active.data('posiiton'));
                        };

                        /* Call show and hide with the user provided arguments */
                        active.fadeOut('slow', function () {
                            nextSet.fadeIn('slow', function () {
                            });
                        });

                        /* If bread crumb menu is used make those changes */
                        if (settings.breadCrumb) {
                            var activeCrumb_ = breadCrumbList.find('.' + settings.breadCrumbActiveClass);
                            var nextCrumb_ = activeCrumb_.next();
                            activeCrumb_.removeClass(settings.breadCrumbActiveClass);
                            activeCrumb_.addClass(settings.breadCrumbCompletedClass);
                            nextCrumb_.addClass(settings.breadCrumbActiveClass);
                        }

                        /* If the previous button is a button enable it */
                        if ($(prev).is(":button")) {
                            $(prev).removeAttr('disabled');
                        }
                        /* If it's anything else, remove the disabled class */
                        $(prev).removeClass(settings.disabledClass);
                    }

                    /* If there are no more sections, hide the next button and show the submit button */
                    if (afterNextSet.length <= 0) {
                        $(next).hide();
                        submitButton.show().css('display', 'inline-block');
                    }

                    settings.nextCallback(nextSet);
                }
            });

            $(prev).click(function () {
                var active = container.find(activeClassSelector);
                var prevSet = active.prev(settings.element);
                var beforePrevSet = prevSet.prev(settings.element);
                if (prevSet.length) {
                    $(active).toggleClass(settings.activeClass);
                    $(prevSet).toggleClass(settings.activeClass);
                    prevSet.data('posiiton', prevSet.css('position'));
                    insertedNextCallback = function () {
                        prevSet.css('position', prevSet.data('posiiton'));
                    };

                    active.fadeOut('slow', function () {
                        prevSet.fadeIn('slow', function () {
                        });
                    });

                    if (settings.breadCrumb) {
                        var activeCrumb_ = breadCrumbList.find('.' + settings.breadCrumbActiveClass);
                        var prevCrumb_ = activeCrumb_.prev();
                        activeCrumb_.removeClass(settings.breadCrumbActiveClass);
                        prevCrumb_.addClass(settings.breadCrumbActiveClass);
                    }
                    $(next).show();
                    submitButton.hide();
                }
                if (beforePrevSet.length <= 0) {
                    disablePrev(prev);
                }

                settings.prevCallback(prevSet);
            });
            callback.call(this);
        });

    };
})(jQuery);


function validElement() {
    //If the form is valid then go to next else dont
    var valid = true;
    console.log('valid?');
    // this will cycle through all visible inputs and attempt to validate all of them.
    // if validations fail 'valid' is set to false
    $('[data-validate]:input:visible').each(function () {
        var settings = window.ClientSideValidations.forms[this.form.id];
        if (!$(this).isValid(settings.validators)) {
            valid = false
        }
    });

    //var content_ = $('#proposal_sections_attributes_0_paragraphs_attributes_0_content_tbl');
    //if (content_.is(':visible')) {
    //    var escapedcontent_ = tinyMCE.get('proposal_sections_attributes_0_paragraphs_attributes_0_content').getContent().replace(/<p>&nbsp;<\/p>/g,'').replace(/\n/g,'').replace(/ /g,'');
    //    if (escapedcontent_ == '') {
    //        return false;
    //    }
    //}


    var choise_ = $('[name="proposal[votation][choise]"]:checked').val();
    console.log('choise: ' + choise_);
    if (choise_ == 'new') {
        var end_ = $('#proposal_votation_end').val();
        console.log('end: ' + end_);
        if (end_ == '') {
            alert('Devi impostare la data fine votazione');
            e.preventDefault();
            valid = false;
        }
    }

    // if any of the inputs are invalid we want to disrupt the click event
    return valid;
}
