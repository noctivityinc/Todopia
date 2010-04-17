$(function(){
  bind_keyboard();
  bind_checklist_keyboard();
  
  $('#todo_toggle').click(function(){
    new_todo();
    return false;
  })
  
  $('.todo_checkbox').live('click',function(){
    cb = $(this);
    ndx = cb.closest('.todo').index();
    $(this).closest('form').ajaxSubmit({ 
           clearForm: true,
           beforeSubmit: function(){
            cb.closest('form').find('label').css('font-weight','bold').fadeOut('slow');
           },
           success: function(responseText){
             reload_checklist(responseText);
             $('.edit_todo:eq('+ndx+')').find('.todo_checkbox').focus()
           }
       });
  })
  
  $('#complete_toggle').live('click',function(){
    $('#completed .list').slideToggle('fast', function(){
      $.cookie('complete_div_visible', $(this).is(':visible'), {expires: 7});
    });
    return false;
  })
  
  $('.delete_todo').live('click',function(){
    if(confirm('Are you sure you want to delete this todo?')) {
      url = $(this).attr('rel')
      $.ajax({url: url, success: function(responseText){
         reload_checklist(responseText);
      }})
    }
    return false;
  })
  
  $('.todo_label').live('click',function(){
    url = $(this).attr('rel')
    $.ajax({url: url, success: function(responseText){
        $('#new').html(responseText)
        $('#todo #new').hide();
        show_todo_form('edit');
    }})
    return false;
  })
  
  $('.tag_filter').live('click',function(){
    url = $(this).attr('rel')
    $.ajax({url: url, success: function(responseText){
       reload_checklist(responseText);
    }})
    return false;
  })
  
  if ($.cookie('complete_div_visible')==true) { $('#completed .list').show() } else { $('#completed .list').hide() }
})

function new_todo(noslide){
   url = $('#todo_toggle').attr('rel')
    $.ajax({url: url, success: function(responseText){
      bind_checklist_keyboard();
      $('#new').html(responseText)
      show_todo_form('add');
    }})
    return false;
}

function show_todo_form(addedit){
  $('#todo #new').slideToggle(100, function(){
    if ($('#todo #new').is(':visible')) {
      $('#todo_toggle').text('Hide')
      if (addedit == 'edit') {setup_edit_form()} else {setup_add_form()};
      setup_autocomplete();
      bind_add_edit_keyboard();
    } else {
      $('#todo_toggle').text('+ New Todo')
      bind_checklist_keyboard();
    }
  });
}

function showRequest() {
  $('#todo_submit').hide();
  $('.spinner').show();
}

function setup_add_form() {
  $('.new_todo').ajaxForm({ 
       clearForm: true,
       beforeSubmit: showRequest,
       success: function(responseText){
        reload_checklist(responseText);
        setup_autocomplete();
       }
   });
}

function setup_edit_form() {
  $('.edit_todo').ajaxForm({ 
       clearForm: true,
       beforeSubmit: showRequest,
       success: function(responseText){ 
         $('#todo #new').slideUp(100); 
         reload_checklist(responseText);
         $('.todo_checkbox:first').focus(); }
   });
}

function setup_autocomplete() {
  $('.textboxlist').remove();
  
  var t4 = new $.TextboxList('#todo_tag_string', {unique: true, plugins: {autocomplete: {}}});
	t4.getContainer().addClass('textboxlist-loading');
	  
	$.ajax({url: $('#urls .tag_search').attr('rel'), dataType: 'json', success: function(r){
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
  $(document).bind('keydown', 'f', function(){ $('.todo_checkbox:first').focus(); });
  $(document).bind('keydown', 'ctrl+n', function(){ new_todo(); });
  $(document).bind('keydown', 'ctrl+s', function(){ $('#new_todo').submit(); });
}

function bind_add_edit_keyboard() {
  $('input:not(.todo_checkbox)').unbind();
  $('input:not(.todo_checkbox)').bind('keydown', 'ctrl+n', function(){ new_todo(); });
  $('input:not(.todo_checkbox)').bind('keydown', 'ctrl+s', function(){ $('#new_todo').submit(); });
}

