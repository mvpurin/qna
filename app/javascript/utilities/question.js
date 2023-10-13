$(document).on('turbo:load', function () {
  $('.questions').on('click', '.edit-question-link', function (e) {
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden');
  });

  $('.question').on('click', '.add-comment-question', function (e) {
    e.preventDefault();
    $(this).hide();
    let questionId = $(this).data('instanceId');
    $('form#add-comment-question-' + questionId).removeClass('hidden');
  })

  $('.questions').on('ajax:success', function (e) {
    let instance = e.detail[0];
    console.log(instance)
    let id = instance.id;
    let rating = instance.likes - instance.dislikes;
    $('#rating-question-' + id).html('Rating: ' + rating);
  });

  $('.subscription').on('ajax:success', function (e) {
    let instance = e.detail[0];
    let link = document.getElementById('subscription')

    if (instance == 'Subscribed!') {
      alert("You will receive email notifications about new answers! If you don't want to, please unsubscribe")
      link.text = 'Unsubscribe!'
    } else if (instance == 'Unsubscribed!') {
      alert('You will not receive notifications!')
      link.text = 'Subscribe to the question!'
    }
  });
});