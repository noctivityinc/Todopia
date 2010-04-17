$(function(){
  $(document).ready(function(){
    $('.spinner').hide();
    $('a[rel*=facebox]').facebox() 

    $(document).bind('reveal.facebox', function() { 
      $.ajaxSetup({
          'beforeSend': function(xhr) {
              xhr.setRequestHeader("Accept", "text/javascript")
          },
          complete: function(XMLHttpRequest, textStatus) {
              }
      })

      $('#note_body').focus(); 
      
      $('#new_note').ajaxForm({ 
          clearForm: true,
          success: function(rText) {
            $('#facebox').find('#index').fadeOut(100).html(rText).fadeIn(200);
            $('#facebox').find('#note_body').focus();
           }
       });
       
      $('.delete_note').live('click',function(){
        url = $(this).attr('rel')
        $.ajax({
          url: url,
          success: function(responseText) {
            $('#facebox').find('#index').fadeOut(100).html(responseText).fadeIn(200);
          }
        })
        return false;
      })
    }).bind('close.facebox', function(){
      get_checklist();
    })
    
    $(":text").labelify({ labelledClass: "labelHighlight" });
    
    if ($.cookie('warning_message_trigger')!='true') $('#warning_message_trigger').trigger('click');
    $.cookie('warning_message_trigger', 'true', {expires: 365});
  });
})

function get_checklist() {
  $.ajax({url: $('#urls .todo_index').attr('rel'), success: function(todoResponse){
    reload_checklist(todoResponse);
  }})
}

function reload_checklist(responseText) {
  $('#todo').find('#index').html(responseText);
  bind_checklist_keyboard();
  $('a[rel*=facebox]').facebox() 
}

function bind_checklist_keyboard(){
  $('.todo_checkbox').bind('keydown', 'down', function(){ 
    $(this).closest('.todo').next('.todo').find('.todo_checkbox').focus()
  });
  
  $('.todo_checkbox').bind('keydown', 'up', function(){ 
    $(this).closest('.todo').prev('.todo').find('.todo_checkbox').focus()
  });
  
  $('.todo_checkbox').bind('keydown', 'e', function(){ 
    $(this).closest('form').find('.todo_label').click()
  });
  
  $('.todo_checkbox').bind('keydown', 'n', function(){ 
    $(this).closest('form').find('.note_trigger').click()
  });
  
  checklist_sortable()
  console.log($.cookie('complete_div_visible'))
  if ($.cookie('complete_div_visible') == 'true') {$('#completed .list').show()} else {$('#completed .list').hide()}
  $('.todo_checkbox:first').focus();
}

function checklist_sortable() {
  $("#not_complete").sortable({handle: '.handle', 
    placeholder: 'ui-state-highlight',
    update: function() { 
      order = $("#not_complete").sortable('serialize'); 
      url = $("#not_complete").attr('rel');
      url = url+'?'+order
      $.ajax({url:url})
      }
    });
  $('#not_complete').disableSelection();
}