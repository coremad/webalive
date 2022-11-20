function refresh_table() {
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
                 + '<td>' + data[key]['date'].split('.')[0] + '</td>'
                 + '<td class="'+ sclass +'">' + status + '</td>'
                 + '<td>'
                 + '<table class="hlist"><tr>';
            c ^= 1;
            if (!data[key]['status']) {content += '<td>Seems unreachable</td>'} else
            for ( h in data[key]['headers'] )
                content += '<tr><td class="hname">' + data[key]['headers'][h][0] + '</td><td>' + JSON.parse(data[key]['headers'][h][1]) + '</td></td></tr>';
            content += '</tr></table></td></tr>';
        });
        $('#here_table').html(content);
        $("#rtime").html(new Date().toLocaleString());
    })
}

function validURL(str) {
  var pattern = new RegExp('^(https?:\\/\\/)?'+ // protocol
    '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'+ // domain name
    '((\\d{1,3}\\.){3}\\d{1,3}))'+ // OR ip (v4) address
    '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*'+ // port and path
    '(\\?[;&a-z\\d%_.~+=-]*)?'+ // query string
    '(\\#[-a-z\\d_]*)?$','i'); // fragment locator
  return !!pattern.test(str);
}

function sleep(milliseconds) {
  const date = Date.now();
  let currentDate = null;
  do {
    currentDate = Date.now();
  } while (currentDate - date < milliseconds);
}

$( document ).ready(function() {

    refresh_table();
    const intervalID = setInterval(refresh_table, 30000);
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
                }).fail(function(data){ console.log(data);$('#err').html("wtf " + data)});
            }
            event.preventDefault();
    });

    $( "#addform" ).submit(function( event ) {
        var url = $("#url").val();
        if (validURL(url) && confirm("add " + url)) {
            $('#err').html('working...');
            var rcount = 0;
            $.get('api/url_count').done(function(data){
                rcount = data;
            });
            res = $.post("api/add", {
                url: url,
            }).done(function (data) {
                var nrcount = rcount;
                maxwait = 120;
                if (data == 'ok') do {
                    jQuery.ajaxSetup({async:false});
                    $.get('api/url_count').done(function(data){
                        nrcount = data;
                    });
                    sleep(1000);
                } while (rcount == nrcount && maxwait--);
                $('#err').html(data);
                refresh_table();
            });
        } else $('#err').html("URL '" + url + "' is bullshit");
        event.preventDefault();
    });
});

