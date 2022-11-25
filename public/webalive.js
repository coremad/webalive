$( document ).ready(function() {
    const normal_interval = 60000;
    const pending_interval = 1000;
    const max_pending_count = 30;
    var pending_count = 0;
    var intervalID;

    function refresh_table() {
        if (pending_count > 0) {
            $.get('api/new_urls_count').done(function(data) {
                if(--pending_count == 0) $('#err').html("time out")
                else $('#err').html("pending... " + pending_count);
                console.log(pending_count);
                console.log(data);
                if(data == 0) {
                    pending_count = 0;
                    $('#err').html( "ok" );
                }
            }).fail(function() { pending_count == 0; $('#err').html( "error" ); });
        }
        if (pending_count == 0) {
            clearInterval(intervalID);
            intervalID = setInterval(refresh_table, normal_interval);
            $.getJSON( "api/list", function ( data, textStatus, jqXHR ) {
                var content = '<tr class="thead"><td></td><td>URL</td><td>Date</td><td>status</td><td>Headers</td></tr>';
                var c = 1;
                Object.keys(data).reverse().forEach((key) => {
                    var sclass = 'ok';
                    var status = data[key]['status'];
                    if (status < 200 ) sclass = "wtf"
                    else if (status > 300 && status < 400) sclass = 'fok'
                    else if (status > 400 && status < 500) sclass = 'sad'
                    else if (status > 500) sclass = 'bad';
                    content += '<tr class="tline' + c + '">'
                         + '<td><img class="del_url" src="del.png" url="'+data[key]['url']+'" data = "'+data[key]['url_id']+'"></img></td>'
                         + '<td>' + data[key]['url'] + '</td>'
                         + '<td>' +  data[key]['date'].split('.')[0] + '</td>'
                         + '<td class="'+ sclass +'">' + status + '</td>'
                         + '<td>'
                         + '<table class="hlist"><tr>';
                    c ^= 1;
                    if (!data[key]['status']) {content += '<td>Seems unreachable</td>'}
                    else for ( h in data[key]['headers'] )
                        content += '<tr><td class="hname">' + data[key]['headers'][h][0] + '</td><td>' + JSON.parse(data[key]['headers'][h][1]) + '</td></td></tr>';
                    content += '</tr></table></td></tr>';
                });
                $('#here_table').html(content);
                $("#rtime").html(new Date().toLocaleString());
            }).fail(function() { $('#err').html( "error" ) });
        }
    }

    refresh_table();

    $( "#rbutton" ).click(function() {
        refresh_table();
    });

    $("#here_table").on('click','.del_url', function(event) {
            if (confirm("del " + $(this).attr("url"))) {
                res = $.post("api/del",  {
                    id: $(this).attr("data"),
                }).done(function (data) {
                        $('#err').html(data);
                        refresh_table();
                }).fail(function(data){ $('#err').html("wtf")});
            }
            event.preventDefault();
    });

    $( "#addform" ).submit(function( event ) {
        function validURL(str) {
          var pattern = new RegExp('^(https?:\\/\\/)?'+ // protocol
            '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'+ // domain name
            '((\\d{1,3}\\.){3}\\d{1,3}))'+ // OR ip (v4) address
            '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*'+ // port and path
            '(\\?[;&a-z\\d%_.~+=-]*)?'+ // query string
            '(\\#[-a-z\\d_]*)?$','i'); // fragment locator
          return !!pattern.test(str);
        }
        var url = $("#url").val();
        if (url && confirm("add " + url))
            if (validURL(url)) {
                $('#err').html('working...');
                res = $.post("api/add", {
                    url: url,
                }).done(function (data) {
                    $('#err').html(data);
                    if (data == 'pending') {
                        pending_count = max_pending_count;
                        clearInterval(intervalID);
                        intervalID = setInterval(refresh_table, pending_interval);
                    }
                }).fail(function() { $('#err').html( "error" ) });
            } else $('#err').html("URL '" + url + "' is bullshit")
        else $('#err').html("");
        event.preventDefault();
    });
});
