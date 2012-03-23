$(function() {
	$('.bubbleInfo').each(function() {
		var distance = 10;
		var time = 250;
		var hideDelay = 200;

		var hideDelayTimer = null;

		var beingShown = false;
		var shown = false;
		var trigger = $('.trigger', this);
		var clicktrigger = $('.clicktrigger', this);
		var hovertrigger = $('.hovertrigger', this);
		var info = $('.popup', this).css('opacity', 0);
		
		function show() {
			if(hideDelayTimer)
				clearTimeout(hideDelayTimer);
			if(beingShown || shown) {
				// don't trigger the animation again
				return;
			} else {
				// reset position of info box
				beingShown = true;

				info.css({
					/*top : -20,*/
					/*left : -33,*/
					display : 'block'
				}).animate({
					top : '+=' + distance + 'px',
					opacity : 1
				}, time, 'swing', function() {
					beingShown = false;
					shown = true;
				});
			}

			return false;
		}
		
		function hide() {
			if(hideDelayTimer)
				clearTimeout(hideDelayTimer);
			hideDelayTimer = setTimeout(function() {
				hideDelayTimer = null;
				info.animate({
					top : '-=' + distance + 'px',
					opacity : 0
				}, time, 'swing', function() {
					shown = false;
					info.css('display', 'none');
				});
			}, hideDelay);
			return false;
		}
		
		function showandhide(time) {
			if (!time) time = 3000;
			if (!shown) {
				show();
				setTimeout(hide,3000);
			}
		}

		$([trigger.get(0), info.get(0)]).focusin(show).focusout(hide);
		//$([clicktrigger.get(0), info.get(0)]).click(showandhide);
	});
	
});
