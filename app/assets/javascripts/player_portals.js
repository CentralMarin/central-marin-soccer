// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require jquery
//= require bootstrap-sprockets
//= require jquery.bootstrap.wizard
//= require jquery.validate.min
//= require wizard
//= require jquery.Jcrop.min
//= require namespace
//= require player_portal_modals
//= require player_portal_payments
//= require player_portal_registration
//= require player_portal_events

$("[data-hide]").on("click", function(){
     $(this).closest("." + $(this).attr("data-hide")).hide();
});