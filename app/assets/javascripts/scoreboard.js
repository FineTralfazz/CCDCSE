function check_updates() {
    $.getJSON('/scoreboard/last_check', function(data) {
        if ($('meta[name="last_check"]').attr('content') != data['last_check']) {
            window.location = window.location;
        }
    });
}

$(function() {
    if ($('meta[name="last_check"]').attr('content')) {
        setInterval(check_updates, 1000);
    }
});