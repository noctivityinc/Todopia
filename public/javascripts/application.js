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
          beforeSubmit: function(){
           console.log('new note'); 
          },
          success: function(rText) {
            console.log(rText)
            $('#facebox').find('#index').fadeOut(100).html(rText).fadeIn(200);
            get_checklist();
           }
       });
       
      $('.delete_note').live('click',function(){
        url = $(this).attr('rel')
        $.ajax({
          url: url,
          success: function(responseText) {
            $('#facebox').find('#index').fadeOut(100).html(responseText).fadeIn(200);
            get_checklist();
          }
        })
        return false;
      })
    })
    
    $(":text").labelify({ labelledClass: "labelHighlight" });
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
  
  checklist_sortable()
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