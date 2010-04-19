$(function(){
  complete_todo_form_options = { 
          clearForm: true,
          beforeSubmit: function(formData, jqForm, options){
           jqForm.find('.col').css('font-weight','bold').css('background', '#FFFF66').fadeOut('slow');
          },
          success: function(responseText){
            reload_checklist(responseText);
            // $('.edit_todo:eq('+ndx+')').find('.todo_checkbox').focus()
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
    }})
    return false;
  })
    
  $('.delete_todo').livequery('click',function(){
    if(confirm('Are you sure you want to delete this todo?')) {
      url = $(this).attr('rel')
      $.ajax({url: url, success: function(responseText){
         reload_checklist(responseText);
      }})
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
      }})      

    return false;
  })
  
  if ($.cookie('complete_div_visible')=='false') { $('#completed .list').hide() } else { $('#completed .list').show() }
  
  setup_complete_todo_form();
  setup_tooltips();
  bind_keyboard();
  bind_checklist_keyboard();
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
  $('#todo #new').slideToggle(200, function(){
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
      $('#new').html(responseText)
      $('#todo #new').hide();
      show_todo_form('edit');
  }})
}

function setup_complete_todo_form() {
  $('.todo_checkbox').live('click',function(){
    clog('todo_checkbox');
    clog($(this))
    $(this).closest('form').ajaxSubmit(complete_todo_form_options); 
  })
  
  $('.complete_todo_form').livequery('submit', function(){
    clog('complete submitting...')
   $(this).ajaxSubmit(complete_todo_form_options); 
   return false;
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
         $('#todo #new').slideUp(200); 
         reload_checklist(responseText);
       }
   });
}

function setup_autocomplete() {
  $('.textboxlist').remove();
  
  var t4 = new $.TextboxList('#todo_tag_string', {unique: true, plugins: {autocomplete: {}}, bitsOptions: {editable: {addOnBlur: true}}});
	t4.getContainer().addClass('textboxlist-loading');
  // t4.addEvent('bitAdd',function(bit){
  //  clog(bit.value)
  // })
	  
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
  $(document).bind('keydown', 'f', function(){ $('body').data('position',0); $('.todo_checkbox:first').focus(); });
  $(document).bind('keydown', 'ctrl+n', function(){ new_todo(); });
  $(document).bind('keydown', 'ctrl+s', function(){ $('#new_todo').submit(); });
}

function bind_add_edit_keyboard() {
  $('input:not(.todo_checkbox)').unbind();
  $('input:not(.todo_checkbox)').bind('keydown', 'ctrl+n', function(){ new_todo(); });
  $('input:not(.todo_checkbox)').bind('keydown', 'ctrl+s', function(){ $('#new_todo').submit(); });
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
