// Flash functions for RoR flash_renderer plugin
//  (c) Joshua Lippiner 2009
$(document).ready(function() {

    jQuery.fn.showFlash = function() {
        $(this.selector).show('normal').delay(3000).fadeOut(2000);
    }

    $('#flash_messages').showFlash();

    $('#flash').click(function() {
        $('#flash_messages').fadeOut(500);
    })

    jQuery.flash = {
        notice: function(message, parent) {
            parent = parent == null ? '': parent + ' ';
            $(parent + '#flash_messages').html(message).removeClass().addClass('notice').showFlash();
        },
        message: function(message, parent) {
            parent = parent == null ? '': parent + ' ';
            $(parent + '#flash_messages').html(message).removeClass().addClass('message').showFlash();
        },
        warning: function(message, parent) {
            parent = parent == null ? '': parent + ' ';
            $(parent + '#flash_messages').html(message).removeClass().addClass('warning').showFlash();
        },
        error: function(message, parent) {
            parent = parent == null ? '': parent + ' ';
            $(parent + '#flash_messages').html(message).removeClass().addClass('error').showFlash();
        },
        clear: function(parent) {
            parent = parent == null ? '': parent + ' ';
            $(parent + '#flash_messages').hide();
        },
        show: function() {
          $(' #flash').load('/flash');
          $('html, body').animate({
              scrollTop: 0
          });
        }
    }

    $('#flash_messages .error').prepend("<span class='ui-icon ui-icon-alert' style='float:left;margin-right:.3em'></span>")
    $('#flash_messages .warning').prepend("<span class='ui-icon ui-icon-info' style='float:left;margin-right:.3em'></span>")
    $('#flash_messages .notice').prepend("<span class='ui-icon ui-icon-info' style='float:left;margin-right:.3em'></span>")

})

 function flash(data, parent) {
    if (data != null) {
        if (data.type == 'notice') $.flash.notice(data.message, parent);
        if (data.type == 'message') $.flash.message(data.message, parent);
        if (data.type == 'warning') $.flash.warning(data.message, parent);
        if (data.type == 'error') $.flash.error(data.message, parent);
    }
}
