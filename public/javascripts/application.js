var tmr;

$(function(){
  setup_ajax();
  $('.spinner').hide();
  $('body').data('position',0)
  $('a[rel*=facebox]').facebox() 
  
  complete_todo_form_options = { 
         clearForm: true,
         beforeSubmit: function(formData, jqForm, options){
          jqForm.find('.col').css('font-weight','bold').css('background', '#FFFF66').fadeOut('slow');
         },
         success: function(responseText){
           reload_checklist(responseText);
           $('.edit_todo:eq('+ndx+')').find('.todo_checkbox').focus()
         }
     }
  
  $(document).bind('reveal.facebox', function() { 
    setup_ajax();

    $('#note_body').focus(); 
    
    $('#new_note').ajaxForm({ 
        clearForm: true,
        success: function(rText) {
          $('#facebox').find('#index').fadeOut(200).html(rText).fadeIn(200);
          $('#facebox').find('#note_body').focus();
         }
     });
     
    $('.delete_note').live('click',function(){
      url = $(this).attr('rel')
      $.ajax({
        url: url,
        success: function(responseText) {
          $('#facebox').find('#index').fadeOut(200).html(responseText).fadeIn(200);
        }
      })
      return false;
    })
  }).bind('afterClose.facebox', function(){
    get_checklist();
  })
  
  $(":text").labelify({ labelledClass: "labelHighlight" });
  
  if ($.cookie('warning_message_trigger')!='true') $('#warning_message_trigger').trigger('click');
  $.cookie('warning_message_trigger', 'true', {expires: 365});
  
  $('a[rel=toggle]').live('click',function(){
    $($(this).attr('href')).toggle();
    select_current_checkbox();
  }).each(function(el){
    $($(this).attr('href')).hide();
  })
})

function setup_ajax(){
  $(document).ajaxSend(function(event, request, settings) {
      if ( settings.type == 'post' ) {
          settings.data = (settings.data ? settings.data + "&" : "")
                  + "authenticity_token=" + encodeURIComponent( AUTH_TOKEN );
          request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
      }
  });
  
  $.ajaxSetup({
      'beforeSend': function(xhr) {
          xhr.setRequestHeader("Accept", "text/javascript")
          $('.spinner').fadeIn(200);
      },
      dataType: 'html',
      complete: function(XMLHttpRequest, textStatus) {
          $('.spinner').hide();
          }
  })
  
  // When I say html I really mean script for rails
  $.ajaxSettings.accepts.html = $.ajaxSettings.accepts.script;
}

function get_checklist() {
  $.ajax({url: $('#urls').attr('url:todo_reload'), 
      success: function(todoResponse) { reload_checklist(todoResponse); }
    })
}   

function reload_checklist(responseText) {
  $('#todo').find('#index').html(responseText).fadeIn(200, function(){
    setup_ajax();
    setup_complete_todo_form();
    bind_tag_group();
    bind_checklist_keyboard();
    $('a[rel*=facebox]').facebox() 
    bind_timers();
    $(document).trigger('checklist.reloaded')
  });
}

function bind_checklist_keyboard(){
  $('.todo_checkbox').unbind();
  
  $('.todo').bind('keydown', 'j', function(){ 
    var position = $('body').data('position') + 1
    position = (position > $('.todo').length-1) ? $('.todo').length-1 : position
    reposition_todo(position);
  });
  
  $('.todo').bind('keydown', 'k', function(){ 
    var position = $('body').data('position') - 1
    position = (position < 0) ? 0 : position
    reposition_todo(position);
  });
  
  $('.todo_checkbox').bind('keydown', 'e', function(){ 
    edit_todo($(this).closest('.todo').find('.todo_label'))
    return false;
  });
  
  $('.todo_checkbox').bind('keydown', 'n', function(){ 
    $(this).closest('.todo').find('.note_trigger').click()
    return false;    
  });
  
  
  $('.todo').bind('keydown', 'w', function(){
    url = $(this).find('.wait_todo').attr('rel');
    toggle_waiting(url)
  });

  $('.todo_checkbox').bind('keydown', '#', function(){ 
    $(this).closest('.todo').find('.delete_todo').click()
    return false;    
  });
    
  $('.todo_checkbox').bind('keydown', 'd', function(){ 
    $(this).closest('.todo').find('.delete_todo').click()
    return false;    
  });
  
  checklist_sortable()
  if ($.cookie('complete_div_visible') == 'true') {$('#completed .list').show()} else {$('#completed .list').hide()}
 
  select_current_checkbox();
}

function reposition_todo(position) {
  $('.todo').find('.col_select').removeClass('selected')
  $('.todo:eq('+position+')').find('.col_select').addClass('selected')
  $('.todo:eq('+position+')').find('.todo_checkbox').focus()
  $('body').data('position',position)
  return false;
}

function select_current_checkbox(){
  var position = $('body').data('position');
  reposition_todo(position)
}

function checklist_sortable() {
  $(".tag_group").sortable({handle: '.handle', 
    connectWith: '.tag_group', 
    placeholder: 'ui-state-highlight',
    stop: function(event, ui) { 
      old_tag_group = $(this).attr('tg:tag')
      new_tag_group = ui.item.closest('.tag_group').attr('tg:tag')
      
      if(old_tag_group!=new_tag_group) {
        var ui_item = $(ui.item.children()[0])
        todo_id = ui_item.attr('todo:id')
        move_url = $('#urls').attr('url:move_todo')
        $.post(move_url, {move_from: old_tag_group, move_to: new_tag_group, id: todo_id}, function(todoResponse) { 
          $(document).bind('checklist.reloaded', function(){
              ui_item.find('.todo_checkbox').focus();
              $(document).unbind('checklist.reloaded') 
            })
          reload_checklist(todoResponse); 
          })
       } else {
         reorder_url = $('#urls').attr('url:reorder_todos')
         $.post(reorder_url, $(this).sortable('serialize'), function(todoResponse) { 
           $(document).bind('checklist.reloaded', function(){
               ui_item.find('.todo_checkbox').focus();
               $(document).unbind('checklist.reloaded') 
             })
           reload_checklist(todoResponse); 
           })
      }
      }
    });
  $('#not_complete').disableSelection();
}

function bind_timers(){
  if (window.fluid==undefined) {
    // don't use timers if using fluid.  weird issues
    $('body, input, textarea').bind('keydown', set_checklist_refresh)
    $(document).bind('click', set_checklist_refresh)
    set_checklist_refresh()
  }
}

function set_checklist_refresh (){
  clearInterval(tmr)
  tmr = setInterval ( "get_checklist()", 600000);
}

function clog(message, type) {
  try
    {
    console.log(message)
    }
  catch(err)
    {}
}
