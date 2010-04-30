/**
 * Slide Box : a jQuery Plug-in
 * Samuel Garneau <samgarneau@gmail.com>
 * http://samuelgarneau.com
 * 
 * Released under no license, just use it where you want and when you want.
 */

(function($){
	
	$.fn.slideBox = function(params){
	
		var content = $(this).html();
		var defaults = {
			width: "100%",
			height: "200",
			position: "bottom"			// Possible values : "top", "bottom"
		}
		
		// extending the fuction
		if(params) $.extend(defaults, params);
		
		var divPanel = $("<div class='slide-panel'>");
		var divContent = $("<div class='slide-panel-content'>");
	  $('body').data('divPanel_visible','false')
	
		$(divContent).html(content);
		$(divPanel).addClass('slide-'+defaults.position);
		$(divPanel).css("width", defaults.width);
		
		// centering the slide panel
		$(divPanel).css("left", (100 - parseInt(defaults.width))/2 + "%");
	
		// if position is top we're adding 
		if(defaults.position == "top")
			$(divPanel).append($(divContent));
		
		// adding buttons
    // $(divPanel).append("<div class='slide-button'></div>");
    // $(divPanel).append("<div style='display: none' id='close-button' class='slide-button'></div>");
		
		if(defaults.position == "bottom")
			$(divPanel).append($(divContent));
		
		$(this).replaceWith($(divPanel));
		
		// Buttons action
		$(".slide-button, .slide-options").click(function(){
			if($('body').data('divPanel_visible') == 'true')
				$(document).trigger('close.slideBox')
			else {
				$(divContent).animate({height: defaults.height+'px'}, 200, function(){
				  $('body').data('divPanel_visible','true');
          showOverlay();
				});
				}
			
			$(".slide-button").toggle();
		});
		
    function showOverlay() {
      $("body").append('<div id="slideBox_overlay" class="slideBox_hide"></div>')
      $('#slideBox_overlay').hide().addClass("slideBox_overlayBG")
        .css("height",(document.height-defaults.height)+'px')
        .click(function() {$(document).trigger('close.slideBox') })
        .fadeIn(200)
      return false
    }
    
    function hideOverlay() {
      $('#slideBox_overlay').fadeOut(200, function(){
        $("#slideBox_overlay").removeClass("slideBox_overlayBG")
        $("#slideBox_overlay").addClass("slideBox_hide") 
        $("#slideBox_overlay").remove()
      })

      return false
    }
    
    /*
     * Bindings
     */

    $(document).bind('close.slideBox', function() {
      clog('close')
      $(divContent).animate({height: "0px"}, 200, function(){
				  $('body').data('divPanel_visible','false');
				  hideOverlay()
				  $(document).trigger('afterClose.slideBox')
				})
    })
	};
	
})(jQuery);