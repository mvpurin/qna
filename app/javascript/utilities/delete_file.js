$(document).on('ready turbo:load', function () {
  $('.files').on('click', '.delete-file-link', function () {
    var fileId = $(this).data('fileId');
    document.getElementById('file-' + fileId).remove();
  })
});