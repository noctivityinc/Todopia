$(function(){
  bind_tag_group();
  
  $('.select_tag_group').livequery('click',function(){
    $(this).closest('h2').next('.tag_group').toggle();
    return false;
  });
})  

function bind_tag_group(){
  $(".tag_group_menu_trigger").contextMenu({
      menu: 'tagGroupMenu'
  },
      function(action, el, pos) {
        switch(action)
        {
        case 'ungroup':
          ungroup(el)
          break;
        case 'check_all':
          check_all(el)
          break;o
        case 'delete':
          delete_all(el)
          break;
        case 'rename':
          rename(el);
          break;
        case 'print':
          print_all(el)
          break;          
        }
  })
  
  $(".unfiled_group").contextMenu({
      menu: 'unfiledGroupMenu'
  },
      function(action, el, pos) {
        switch(action)
        {
        case 'check_unfiled':
          check_unfiled(el)
          break;
        case 'delete_unfiled':
          delete_unfiled(el)
          break;
        case 'print':
          print_all(el)
          break;          
        }
  })
}

function ungroup(el){
  if(confirm('Are you sure you want to remove this group?  The items within will become unfiled not removed.')) {
    id = $(el).attr('rel')
    $.ajax({url: '/tag_groups/'+id+'/remove', success: function(){
      get_checklist()
    }})
  }
}

function check_all(el){
  id = $(el).attr('rel')
  $.ajax({url: '/tag_groups/'+id+'/check_all', success: function(){
    get_checklist()
  }})
}

function print_all(el){
  url = $(el).attr('url:filter')
  $('#index').hide();
  $.ajax({url: url, success: function(responseText){
     reload_checklist(responseText);
     $(document).bind('checklist.reloaded',function(){
       window.print();      
       $(document).unbind('checklist.reloaded')
       get_checklist();
     })
  }})      
}

function rename(el){
  var new_name = prompt('Enter group name:',el.attr('tg:tag'))
  if (new_name!='') {
    id = $(el).attr('rel')
    $.ajax({url: '/tag_groups/'+id+'/rename?name='+new_name, success: function(){
      get_checklist()
    }})
  }
}

function delete_all(el){
  if(confirm('Are you sure you want to delete this group and ALL the items within it? Hint - if you just want to remove the GROUPING, pick "Remove Group"')) {
    id = $(el).attr('rel')
    $.ajax({url: '/tag_groups/'+id+'/delete', success: function(responseText){
      get_checklist();
    }})
  }
}

function check_unfiled(el){
  id = $(el).attr('rel')
  $.ajax({url: '/users/'+id+'/tag_groups/check_unfiled', success: function(){
    get_checklist()
  }})
}

function delete_unfiled(el){
  if(confirm('Are you sure you want to delete ALL unfiled todos?')) {
    id = $(el).attr('rel')
    $.ajax({url: '/users/'+id+'/tag_groups/delete_unfiled', success: function(responseText){
      get_checklist();
    }})
  }
}

