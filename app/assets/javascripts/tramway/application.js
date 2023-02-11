//= require jquery
//= require jquery_ujs
//= require jquery3
//= require popper
//= require bootstrap-datepicker-1.8.0
//= require bootstrap-datepicker-1.8.0.ru.min
//= require bootstrap-sprockets
//= require font_awesome5
//= require ckeditor/init
//= require clipboard
//= require_tree .

window.i18n_locale = function(locale) {
  switch (locale) {
    case 'en':
      return({ date_format: 'yyyy-mm-dd', locale: locale });
      break;
    case 'ru':
      return({ date_format: 'dd.mm.yyyy', locale: locale });
      break;
    default:
      return({ date_format: 'yyyy-mm-dd', locale: locale });
      break;
  }
}

$(document).ready(function() {
  if (!(window.current_locale)) {
    console.log('You should set `window.current_locale` before all Javascript code');
  }

  if ($('.date_picker').length != 0) {
    $('.date_picker').datepicker({
      format: window.current_locale.date_format,
      language: window.current_locale.locale
    });
  }

  $('.link').click(function() {
    const href = $(this).data('href');
    if (href) {
      location.href = href;
    } else {
      const anchor = $(this).data('anchor');
      if (!$(anchor).offset() == undefined) {
        $(window).scrollTop($(anchor).offset().top);
      }
    };
  });

  let clipboard = new Clipboard('.clipboard-btn');
  $(function () {
    $('[data-toggle="popover"]').popover()
  })

  const url = new URL(window.location.href);
  const focusElementSelector = url.searchParams.get('focus');
  if (!$(focusElementSelector).offset() == undefined) {
    $(window).scrollTop($(focusElementSelector).offset().top);
  }
});
