$(document).on('ready turbo:load', function () {
  $('form.new-comment').on('ajax:success', function (e) {
    console.log("comment detail: " + e);
    let comment = e.detail[0];
    $('.comments').append(comment.body);
  })
});