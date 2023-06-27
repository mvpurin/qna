$(document).on('ready turbo:load', function () {
  $('.add-badge-link').on('click', function (e) {
    e.preventDefault();
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })
});