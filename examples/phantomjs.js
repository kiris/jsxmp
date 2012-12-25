var page = require('webpage').create();
page.open(phantom.args[0], function (status) {
    var title = page.evaluate(function () {
        document.title;               // =>
        console.log(document.title);  // =>
        return document.title;
    });
    title; // =>
    console.log(title);
    phantom.exit();
});