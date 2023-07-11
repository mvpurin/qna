$(document).on('ready turbo:load', function () {
  $('.questions').off().on('click', '.edit-question-link', function (e) {
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden');
  });

  $('.questions').off().on('ajax:success', function (e) {
    let instance = e.detail[0];
    let id = instance.id;
    let rating = instance.likes - instance.dislikes;
    $('#rating-' + id).html('Rating: ' + rating);
  });
});