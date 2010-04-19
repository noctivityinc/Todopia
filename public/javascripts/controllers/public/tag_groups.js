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
          break;
        case 'delete':
          delete_all(el)
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

function delete_all(el){
  if(confirm('Are you sure you want to delete this group and ALL the items within it? Hint - if you just want to remove the GROUPING, pick "Remove Group"')) {
    id = $(el).attr('rel')
    $.ajax({url: '/tag_groups/'+id+'/delete', success: function(responseText){
      get_checklist();
    }})
  }
}
