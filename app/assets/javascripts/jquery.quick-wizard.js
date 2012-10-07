(function ($) {

    $.fn.quickWizard = function (options, callback) {
        
        var settings = {
            'prevButton': '<button id="form-wizard-prev" type="button" class="buttonStyle littleText">Torna al passo precedente</button>',
            'nextButton': '<button id="form-wizard-next" type="button" class="buttonStyle littleText">Procedi</button>',
            'activeClass': 'form-wizard-active',
            'element': 'div.step',
            'submit': '[type = "submit"]',
            'root': null,
            'prevArgs': [0],
            'nextArgs': [0],
            'disabledClass': 'ui-state-disabled',
            'containerClass' : 'form-wizard-container',
            'breadCrumb': true,
            'breadCrumbElement': 'div.legend',
            'breadCrumbListOpen': '<ol class="bread-crumb">',
            'breadCrumbListClose': '</ol><br/>',
            'breadCrumbListElementOpen': '<li><div>',
            'breadCrumbListElementClose': '</div></li>',
            'breadCrumbListElementOpenFirst': '<li><div class=\'first\'>',
            'breadCrumbListElementOpenLast': '<li><div class=\'last\'>',
            'breadCrumbActiveClass': 'bread-crumb-active',
            'breadCrumbCompletedClass': 'bread-crumb-completed',
            'breadCrumbPosition': 'before'
        };

        if (options) {
            $.extend(settings, options);
        }

        callback = callback || function () { };
        
        function disablePrev(prevObj){
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
            
            if(settings.root === null){                
                root = children.first();
            }else{
                root = $(settings.root);
            }
            
            /* Set up container class */
            if(settings.containerClass != ""){
                container.addClass(settings.containerClass);
            }
            
            /* Set up bread crumb menu */
            if (settings.breadCrumb) {
                breadCrumbList = settings.breadCrumbListOpen

				breadCrumbElements = container.find(settings.breadCrumbElement);
                breadCrumbElements.each(function (index) {
                	if (index == 0) {
                		breadCrumbList += settings.breadCrumbListElementOpenFirst + $(this).text() + settings.breadCrumbListElementClose;
                    }
                    else if (index == (breadCrumbElements.size()-1)) {
                    	breadCrumbList += settings.breadCrumbListElementOpenLast + $(this).text() + settings.breadCrumbListElementClose;
                    }
                    else {
                    	breadCrumbList += settings.breadCrumbListElementOpen + $(this).text() + settings.breadCrumbListElementClose;                    	
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
                settings.nextArgs[settings.nextArgs.length - 1] = function () { insertedNextCallback.call(); originalNextCallback.call(); };

            } else {
                
                /* If there is no callback function append ours */
                settings.nextArgs[settings.nextArgs.length] = function () { insertedNextCallback.call(); }
            }

            /* Insert the previous and next buttons after the submit button and hide it until we're ready */
            
            var prev = $(settings.prevButton).insertBefore(submitButton);
            var next = $(settings.nextButton).insertBefore(submitButton);
            submitButton.hide();
            
            /* If the root element is first disable the previous button */            
            if(root.hasClass('root')){
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
                        insertedNextCallback = function () { active.css('position', active.data('posiiton')); };

                        /* Call show and hide with the user provided arguments */
                        active.fadeOut('slow',function() {
                        	nextSet.fadeIn('slow',function() {
                        	});
                        });
                        
                        /* If bread crumb menu is used make those changes */
                        if (settings.breadCrumb) {
                            breadCrumbList.find('.' + settings.breadCrumbActiveClass).removeClass(settings.breadCrumbActiveClass).next().addClass(settings.breadCrumbActiveClass);
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
                        submitButton.show();
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
                    insertedNextCallback = function () { prevSet.css('position', prevSet.data('posiiton')); };
                    
                     active.fadeOut('slow',function() {
                        	prevSet.fadeIn('slow',function() {
                        	});
                        });
                    
                    if (settings.breadCrumb) {
                        breadCrumbList.find('.' + settings.breadCrumbActiveClass).removeClass(settings.breadCrumbActiveClass).prev().addClass(settings.breadCrumbActiveClass);
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
  // this will cycle through all visible inputs and attempt to validate all of them.
  // if validations fail 'valid' is set to false
  $('[data-validate]:input:visible').each(function() {
    var settings = window[this.form.id];
    if (!$(this).isValid(settings.validators)) {
      valid = false
    }
  });
  
  // if any of the inputs are invalid we want to disrupt the click event
  return valid;
}
