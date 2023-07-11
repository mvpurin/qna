$(document).on('ready turbo:load', function () {
  $('.questions').off().on('click', '.edit-question-link', function (e) {
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden');
  })

  $('.voting').off().on('ajax:success', function (e) {
    console.log(e);
    let rating = e.detail[0];
    $('.rating').html('Rating: ' + rating);
  })
});