$(function(){
  submit_todo_form_options = { 
          clearForm: true,
          beforeSubmit: function(formData, jqForm, options){
           jqForm.find('.col').css('font-weight','bold').css('background', '#FFFF66').fadeOut('slow');
          },
          success: function(responseText){
            reload_checklist(responseText);
          }
      }
  
  $('#todo_toggle').click(function(){
    new_todo();
    return false;
  })
  
  $('#complete_toggle').livequery('click',function(){
    $('#completed .list').slideToggle('fast', function(){
      $.cookie('complete_div_visible', $(this).is(':visible'), {expires: 7});
    });
    return false;
  })
  
  $('.uncheck_todo').livequery('click',function(){
    $(this).closest('.completed').hide();
    url = $(this).attr('rel')
    $.ajax({url: url, success: function(responseText){
       reload_checklist(responseText);
    },complete: function(request, status){ ajax_complete(request, status)}})
    return false;
  })
    
  $('.wait_todo').livequery('click',function(){
    url = $(this).attr('rel');
    toggle_waiting(this, url)
  })
  
  $('.delete_todo').livequery('click',function(){
    if(confirm('Are you sure you want to delete this todo?')) {
      url = $(this).attr('rel')
      $.ajax({url: url, success: function(responseText){
         reload_checklist(responseText);
      }, complete: function(request, status){ ajax_complete(request, status)}})
    }
    return false;
  })
  
  $('.delete_tag_group').livequery('click',function(){
    if(confirm('Are you sure you want to remove this group?  The items within will become unfiled not removed.')) {
      url = $(this).attr('rel')
      $.ajax({url: url, success: function(responseText){
        get_checklist();
      }})
    }
    return false;
  })  
  
  $('.todo_label').livequery('click',function(){
    edit_todo($(this))
    return false;
  })
  
  $('.tag_filter').livequery('click',function(){
    url = $(this).attr('rel')
    $('#index').hide();
      $.ajax({url: url, success: function(responseText){
         reload_checklist(responseText);
      }, complete: function(request, status){ ajax_complete(request, status)}})      

    return false;
  })
  
  $('#print_button').live('click', function(){
     window.print();      
     $(".slide-options").trigger('click')
     return false;
  })
  
  $('#email_button').live('click', function(){
   url = $(this).attr('rel')
    $.ajax({url: url, success: function(){
       $(".slide-options").trigger('click')
    }})      
    return false;
  })
  
  $('.blink:not(".highlight")').livequery(function(){
    if ($('body').data('blinked_overdue')!=true) {
      $(this).animate( { backgroundColor: '#FFFF99' }, 1000).animate( { backgroundColor: 'white' }, 1000);
      $('body').data('blinked_overdue',true)
    }
  })
  
  if ($.cookie('complete_div_visible')=='false') { $('#completed .list').hide() } else { $('#completed .list').show() }
  
  $('.todo_checkbox').live('click',function(){
    $(this).closest('form').ajaxSubmit(submit_todo_form_options); 
  })
  
  $('.complete_todo_form').livequery('submit', function(){
   $(this).ajaxSubmit(submit_todo_form_options); 
   return false;
  })
    
  $('.due_date').livequery(function(){
    $(this).date_input()
  });
  $(document).bind('date_input.dateSelected',function(objEvent, object, param){
    url = $(object).attr('todo:url')
    clog(param)
    $.put(url, {todo: {due_date: param}}, function(responseText) { 
        reload_checklist(responseText);
      })
  })
  
  
  setup_tooltips();
  bind_keyboard();
  bind_checklist_keyboard();
})

function new_todo(noslide){
   url = $('#todo_toggle').attr('rel')
    $.ajax({url: url, success: function(responseText){
      bind_checklist_keyboard();
      $('#new').html(responseText)
      toggle_todo_form('add');
    }})
    return false;
}

function toggle_todo_form(addedit){
  $('#todo #new').toggle(200, function(){
    if ($('#todo #new').is(':visible')) {
      $('#todo_toggle').text('Hide')
      if (addedit == 'edit') {setup_edit_form()} else {setup_add_form()};
      bind_add_edit_keyboard();
      setup_autocomplete();
    } else {
      $('#todo_toggle').text('+ New Todo')
      bind_checklist_keyboard();
    }
  });
}

function edit_todo(el){
  url = el.attr('rel')
  $.ajax({url: url, success: function(responseText){
      clog('success')
      $('#new').html(responseText)
      $('#todo #new').hide();
      toggle_todo_form('edit');
  }, complete: function(request, status){ ajax_complete(request, status) }
  })
}

function toggle_waiting(el, url){
  $(el).closest('.todo').fadeOut('fast');
  $.ajax({url: url, success: function(responseText){
     reload_checklist(responseText);
     return false
  }, complete: function(request, status){ ajax_complete(request, status) }
  })
}

function showRequest() {
  $('#todo_submit').hide();
  $('.spinner').show();
}

function setup_add_form() {
  $('.new_todo').ajaxForm({ 
       clearForm: true,
       beforeSubmit: showRequest,
       success: function(responseText, status){
        reload_checklist(responseText);
        setup_autocomplete();
        $('#todo_label').removeClass('fieldWithErrors');
       },
       error: function(responseText, statusText, xhr, form){
        setup_autocomplete();
        $('#todo_label').addClass('fieldWithErrors');
       },
       complete: function(request, status){ ajax_complete(request, status)}
   });
}

function setup_edit_form() {
  $('.edit_todo').ajaxForm({ 
       clearForm: true,
       beforeSubmit: showRequest,
       success: function(responseText){ 
         $('#todo #new').slideUp(200); 
         $('#todo_toggle').text('+ New Todo')
         reload_checklist(responseText);
       },
       error: function(responseText, statusText, xhr, form){
        setup_autocomplete();
        $('#todo_label').addClass('fieldWithErrors');
       },
       complete: function(request, status){ ajax_complete(request, status)}
   });
}

function setup_autocomplete() {
  $('.textboxlist').remove();
  
  var t4 = new $.TextboxList('#todo_tag_string', {unique: true, plugins: {autocomplete: {minLength: 1}}, bitsOptions: {editable: {addOnBlur: true}}});
	t4.getContainer().addClass('textboxlist-loading');
  // t4.addEvent('bitAdd',function(bit){
  //  clog(bit.value)
  // })
	  
	$.ajax({url: $('#urls').attr('url:tag_search'), dataType: 'json', success: function(r){
		t4.plugins['autocomplete'].setValues(r);
		t4.getContainer().removeClass('textboxlist-loading');
	}});
	
	$('#todo_submit').show();
  $('.spinner').hide();
	
  $(":text").labelify({ labelledClass: "labelHighlight" });
  $(".textboxlist-bit-editable-input").labelify({ labelledClass: "labelHighlight", text: function(input) { return "+ tag"; } });
	$('#todo_label').focus();
}

function bind_keyboard() {
  $(document).bind('keydown', 'f', function(){ $('body').data('position',0); $('.todo_checkbox:first').focus(); return false; });
  $(document).bind('keydown', 'ctrl+n', function(){ new_todo(); return false; });
  $(document).bind('keydown', 'ctrl+s', function(){ $('#new_todo').submit(); return false; });
  $(document).bind('keydown', 'shift+return', function(){ $('#new').find('form').submit(); return false; });
  $('body:not(#new)').bind('keydown', 'c', function(){ new_todo(); return false; });
}

function bind_add_edit_keyboard() {
  $('input:not(.todo_checkbox)').unbind();
  $('input:not(.todo_checkbox)').bind('keydown', 'ctrl+n', function(){ new_todo();     return false; });
  $('input:not(.todo_checkbox)').bind('keydown', 'ctrl+s', function(){ $('#new_todo').submit();     return false; });
  $('input').bind('keydown','esc', function(){ toggle_todo_form(); return false; })
  $('input').bind('keydown', 'shift+return', function(){ $('#new').find('form').submit(); return false; });
}

function setup_tooltips(){
  $(".note_list").livequery(function(){
        var urlString = $(this).attr('url:showmin')
        $(this).qtip({ 
           content: { url: urlString, method: 'get'}, 
           adjust: { screen: true },
           style: { color: '#ffffff', width: 350, padding: 5, color: 'black', name: 'dark', tip: 'leftTop',border: { 'width': 7, 'radius': 5, 'color': '#000' }}
        });
  });
}
