// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require best_in_place
//= require jquery_ujs
//= require turbolinks
//= require nprogress
//= require nprogress-turbolinks
//= require rails-timeago
//= require comments
//= require stacks
//= require tasks
//= require users
//= require bootstrap/bootstrap.min
//= require bootstrap/jquery.scrollTo.min
//= require bootstrap/gritter/js/jquery.gritter.js
//= require bootstrap/gritter-conf.js
//= require jquery.autosize
//
$(document).on("ready page:load", '', function() {
  $('textarea').autosize();
  $(".best_in_place").best_in_place();
  $('.tooltips').tooltip();
  $('.popovers').popover();

  function responsiveView() {
    var wSize = $(window).width();
    if (wSize <= 768) {
      $('#container').addClass('sidebar-close');
      $('#sidebar > ul').hide();
    }

    if (wSize > 768) {
      $('#container').removeClass('sidebar-close');
      $('#sidebar > ul').show();
    }
  }
  $(window).on('load', responsiveView);
  $(window).on('resize', responsiveView);

        // $("#sidebar").niceScroll({styler:"fb",cursorcolor:"#4ECDC4", cursorwidth: '3', cursorborderradius: '10px', background: '#404040', spacebarenabled:false, cursorborder: ''});

        // $("html").niceScroll({styler:"fb",cursorcolor:"#4ECDC4", cursorwidth: '6', cursorborderradius: '10px', background: '#404040', spacebarenabled:false,  cursorborder: '', zindex: '1000'});
});

$(document).on('click', '#sidebar .sub-menu > a', function () {
    var o = ($(this).offset());
    diff = 250 - o.top;
    if(diff>0)
        $("#sidebar").scrollTo("-="+Math.abs(diff),500);
    else
        $("#sidebar").scrollTo("+="+Math.abs(diff),500);
});

$(document).on("click", '.fa-bars', function () {
  if ($('#sidebar > ul').is(":visible") === true) {
    $('#main-content').css({
      'margin-left': '0px'
    });
    $('#sidebar').css({
      'margin-left': '-210px'
    });
    $('#sidebar > ul').hide();
    $("#container").addClass("sidebar-closed");
  } else {
    $('#main-content').css({
      'margin-left': '210px'
    });
    $('#sidebar > ul').show();
    $('#sidebar').css({
      'margin-left': '0'
    });
    $("#container").removeClass("sidebar-closed");
  }
});


$(document).on("click", '.panel .tools .fa-chevron-down', function () {
  var el = jQuery(this).parents(".panel").children(".panel-body");
  if (jQuery(this).hasClass("fa-chevron-down")) {
    jQuery(this).removeClass("fa-chevron-down").addClass("fa-chevron-up");
    el.slideUp(200);
  } else {
    jQuery(this).removeClass("fa-chevron-up").addClass("fa-chevron-down");
    el.slideDown(200);
  }
});

$(document).on("click", '.panel .tools .fa-times', function () {
  $(this).parents(".panel").parent().remove();
});
