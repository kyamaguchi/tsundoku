// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require tether
//= require bootstrap
//= require jquery_ujs
//= require turbolinks
//= require filter
//= require_tree .

$(document).on('turbolinks:load', function() {
  $('.datepicker').datepicker({dateFormat: 'yy-mm-dd'});
  $(".select_all").on('change', function() {
    var checked = $(this).prop("checked");
    $(this).closest('table').find("tr:visible input:checkbox").prop('checked', checked);
  });

  if($('#books').length > 0) {
    var FJS = FilterJS([], '#books-body', {
      template: '#book-row',
      search: {ele: '#searchbox', fields: ['title', 'raw_author'], start_length: 1},
      criterias:[
        {field: 'author_id', ele: '#author', all: 'all'},
        {field: 'read', ele: '#read_status :checkbox'},
        {field: 'tag', ele: '#tag :checkbox'},
      ],
      callbacks: {
        afterFilter: function(result){
          $('#current_books_count').text(result.length);
        }
      }
    });

    FJS.setStreaming({
      data_url: 'books/data.json',
      stream_after: 1,
      batch_size: 500
    });

    $('#tag_list .form-check').each(function(){
      FJS.addCriteria({field: $(this).attr('id'), ele: '#' + $(this).attr('id') + ' :checkbox'});
    });

    $('#read_status :checkbox').prop('checked', true);
    $('#tag :checkbox').prop('checked', true);
    $('#tag_list :checkbox').prop('checked', true);

    FJS.addCallback('afterAddRecords', function(){
      var total_books_count = $('#total_books_count').data('count');

      var percent = 0;
      if(total_books_count > 0) {
        percent = parseInt(this.recordsCount*100/total_books_count);
      } else {
        percent = 100;
      }

      $('#stream_progress').text(percent + '%').attr('style', 'width: '+ percent +'%;');

      if (percent == 100){
        $('#stream_progress').parent().fadeOut(1000);
      }
    });
  }
});
