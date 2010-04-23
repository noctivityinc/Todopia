/*
 * 
 * Part of article How to detect screen size and apply a CSS style
 * http://www.ilovecolors.com.ar/detect-screen-size-css-style/
 *
 */

$(document).ready(function() {

  clog(document.width)
	if (document.width>=800)
	{
		clog('Screen size: 1024x768 or larger');
		$("link[media=screen]").attr({href : "/stylesheets/compiled/public.css"});
	}
	else
	{
		clog('Screen size: less than 1024x768, 800x600 maybe?');
		$("link[media=screen]").attr({href : "/stylesheets/compiled/public_narrow.css"});
	}
});

