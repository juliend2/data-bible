// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require chosen-jquery
//= require turbolinks
//= require_tree .

// source: http://stackoverflow.com/a/33164856/242404
AbstractChosen.browser_is_supported = function() {
  if (window.navigator.appName === "Microsoft Internet Explorer") {
    return document.documentMode >= 8;
  }
  if (/iP(od|hone)/i.test(window.navigator.userAgent)) {
    return false;
  }
  if (/Android/i.test(window.navigator.userAgent)) {
    if (/Mobile/i.test(window.navigator.userAgent)) {
      return false;
    }
  }
  return true;
};

