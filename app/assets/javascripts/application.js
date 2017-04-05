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
    $(this).closest('table').find("input:checkbox").prop('checked', checked);
  });

  if($('#books').length > 0) {
    var FJS = FilterJS([], '#books-body', {
      template: '#book-row',
      search: {ele: '#searchbox'},
      criterias:[
        {field: 'read', ele: '#read_status :checkbox'}
      ],
      callbacks: {
        afterFilter: function(result){
          $('#total_books').text(result.length);
        }
      }
    });

    FJS.setStreaming({
      data_url: 'books/data.json',
      stream_after: 1,
      batch_size: 500
    });

    $('#read_status :checkbox').prop('checked', true);
  }
});
