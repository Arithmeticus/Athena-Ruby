/* this method starts with traditional javascript (to get the hex 
value) then segues into jquery (to lookup the athena ruby database)
TO DO:
    - test Seals 6 patches of Athena on this
    - convert everything to jquery (much more elegant)
*/
if (window.XMLHttpRequest) {
    // code for IE7+, Firefox, Chrome, Opera, Safari
    xmlhttp = new XMLHttpRequest();
    xmlhttp2 = new XMLHttpRequest();
} else {
    // code for IE6, IE5
    xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    xmlhttp2 = new ActiveXObject("Microsoft.XMLHTTP");
}
xmlhttp.open("GET", "strokes.xml", false);
xmlhttp.send();
xmlDoc = xmlhttp.responseXML;

function stroke() {
    // *x* holds the old Athena text
    var x=$("#oldtext").text();
    // *hex* holds *x*, converted into a hexadecimal string
    var hex = new Array;
    $("#convertedtext").html("");
    $("p[id^='feedback']").html("").css({"color":"gray","font-size":"80%"});
    $("#feedback1").html(x);
    for (var i = 0; i < x.length; i++) {
        //convert next two lines to jquery, then get rid of all the initializing code (lines 7-18)
        y = xmlDoc.getElementById(x[i]);
        hex[i] =(y.getElementsByTagName("hex")[0].childNodes[0].nodeValue);
        $("#feedback2").append(hex[i]);
    };
    lookup(hex);
}

function lookup(data) {
    $.ajax({
        type: "GET",
        url: "AR.xml",
        data: "index=10",
        dataType: "xml",
        success: function (xml) {
            $.each(data, function (index, value){
                var z = $(xml).find("athena[cp="+value+"]").parent().siblings("unicode:first").text();
                $('#convertedtext').append(z);
            });
        }
    });
}