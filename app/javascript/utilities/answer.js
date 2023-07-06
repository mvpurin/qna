$(document).on('ready turbo:load', function () {
  $('.answers').off().on('click', '.edit-answer-link', function (e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })

  $('form.new-answer').off().on('ajax:success', function (e) {
    let answer = e.detail[0];
    $('.answers').append('<p>' + answer.title + '\n' + answer.body + '</p>');
  })

  $('form.new-answer').on('ajax:error', function (e) {
    let errorsMessage = document.getElementsByClassName('answer-errors');

    if (errorsMessage) {
      errorsMessage.html('');
    };

    let errors = e.detail[0];

    $.each(errors, function (index, value) {
      $('.answer-errors').append('<p>' + value + '</p >')
    })
  })
});