// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//
//

window.DEXTER = {
  'drops': {
    'new'  : function() {
      var $type = $('#type');
      var toggleDisplay = function() {
        if($type.val()) {
          if($type.val() == 'file') {
            $('.redirect-section').hide();
            $('.upload-section').show();
          }
          else {
            $('.redirect-section').show();
            $('.upload-section').hide();
          }

        }
      };

      toggleDisplay();
      $type.change(toggleDisplay);

      function supportAjaxUploadWithProgress() {
        return supportFileAPI() && supportAjaxUploadProgressEvents() && supportFormData();

        // Is the File API supported?
        function supportFileAPI() {
          var fi = document.createElement('INPUT');
          fi.type = 'file';
          return 'files' in fi;
        };

        // Are progress events supported?
        function supportAjaxUploadProgressEvents() {
          var xhr = new XMLHttpRequest();
          return !! (xhr && ('upload' in xhr) && ('onprogress' in xhr.upload));
        };

        // Is FormData supported?
        function supportFormData() {
          return !! window.FormData;
        }
      }

      if (supportAjaxUploadWithProgress()) {
        initFullFormAjaxUpload();
      }

      function initFullFormAjaxUpload() {
        var form = document.getElementById('form-id');
        form.onsubmit = function() {
          $('#js-upload').val(true);

          // FormData receives the whole form
          var formData = new FormData(form);

          // We send the data where the form wanted
          var action = form.getAttribute('action');

          // Code common to both variants
          sendXHRequest(formData, action);

          // Avoid normal form submission
          return false;
        }
      }

      // Once the FormData instance is ready and we know
      // where to send the data, the code is the same
      // for both variants of this technique
      function sendXHRequest(formData, uri) {
        // Get an XMLHttpRequest instance
        var xhr = new XMLHttpRequest();

        // Set up events
        xhr.upload.addEventListener('progress', onprogressHandler, false);
        xhr.addEventListener('readystatechange', onreadystatechangeHandler, false);

        // Set up request
        xhr.open('POST', uri, true);

        // Fire!
        xhr.send(formData);
      }

      // Handle the progress
      function onprogressHandler(evt) {
        var percent = Math.floor(evt.loaded/evt.total*100);
        $('#progress-bar').attr('style', 'width:' + percent + '%;');
        $('.meter').attr('style', '');
      }

      // Handle the response from the server
      function onreadystatechangeHandler(evt) {
        var status = null;

        try {
          status = evt.target.status;
        }
        catch(e) {
          return;
        }

        if (status == '200' && evt.target.responseText) {
          window.location = $.parseJSON(evt.target.response).url;
        }
        else {
          var parsed = $.parseJSON(evt.target.responseText);
          if( ! parsed) {
            return;
          }
          var errors = parsed.errors;
      
          $('.meter').attr("style", "visibility:hidden");
          $.each(errors, function(key, value) {
            if($('#' + key + "-wrapper.field_with_errors").size() > 0) {
              return;
            }

            $("#" + key + "-wrapper").addClass('field_with_errors').append("<div class=\"error\">" + value + "</div>");
            $('#submit').show();
          });
        }
      }

      $('form').submit(function() {
        $('.field_with_errors').removeClass('field_with_errors')
        $('.error').remove();
        $('#submit').hide();
      });

    }
  }
}
