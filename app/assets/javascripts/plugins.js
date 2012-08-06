
// usage: log('inside coolFunc', this, arguments);
// paulirish.com/2009/log-a-lightweight-wrapper-for-consolelog/
window.log = function(){
  log.history = log.history || [];   // store logs to an array for reference
  log.history.push(arguments);
  if(this.console) {
    arguments.callee = arguments.callee.caller;
    var newarr = [].slice.call(arguments);
    (typeof console.log === 'object' ? log.apply.call(console.log, console, newarr) : console.log.apply(console, newarr));
  }
};

// make it safe to use console.log always
(function(b){function c(){}for(var d="assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,timeStamp,profile,profileEnd,time,timeEnd,trace,warn".split(","),a;a=d.pop();){b[a]=b[a]||c}})((function(){try
{console.log();return window.console;}catch(err){return window.console={};}})());


// place any jQuery/helper plugins in here, instead of separate, slower script files.

//jquery.google_menu
(function ($) {
    $.fn.fixedMenu = function () {
        return this.each(function () {
            var menu = $(this);
            //close dropdown when clicked anywhere else on the document
            $("html").click(function () {
                menu.find('.active').removeClass('active');
            });
            menu.find('ul li > a').bind('click', function (event) {
                event.stopPropagation();
                //check whether the particular link has a dropdown
                if (!$(this).parent().hasClass('single-link') && !$(this).parent().hasClass('current')) {
                    //hiding drop down menu when it is clicked again
                    if ($(this).parent().hasClass('active')) {
                        $(this).parent().removeClass('active');
                    } else {
                        //displaying the drop down menu
                        $(this).parent().parent().find('.active').removeClass('active');
                        $(this).parent().addClass('active');
                    }
                } else {
                    //hiding the drop down menu when some other link is clicked
                    $(this).parent().parent().find('.active').removeClass('active');

                }
            })
        });
    }
})(jQuery);

//$('document').ready(function(){
//    $('.menu').fixedMenu();
//});

