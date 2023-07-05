$(document).on('ready turbo:load', function () {
  $('.answers').off().on('click', '.edit-answer-link', function (e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })

  $('form.new-answer').off().on('ajax:success', function (e) {
    let xhr = e.detail[2];
    $('.answers').append(xhr.responseText);
  })

  $('form.new-answer').on('ajax:error', function (e) {
    let xhr = e.detail[2];
    $('.answer-errors').html(xhr.responseText);
  })
});