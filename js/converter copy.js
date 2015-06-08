/* TO DO:
Developed February 2013 by Joel Kalvesmaki for Dumbarton Oaks, Trustees of 
Harvard University
*/

// defunct Java approach
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
    var oldtext = $("#oldtext").text();
    var oldtextpua = oldtext;
    // I've collated the Greek midpoint to help the later sequence determine which
    // characters have not yet been replaced.
    var oldtext = oldtext.replace(/(.)/g, "$1·");
    $("#convertedtext").html("");
    $("#convertedtextpua").html("");
    $("p[id^='feedback']").html("").css({
        "color": "gray", "font-size": "80%"
    });
    $("#feedback1").html(oldtext);
    // first convert the old text into a string of 4-digit hex numbers using strokes.xml
    $.ajax({
        url: "strokes.xml",
        dataType: "xml",
        success: function (unicode) {
            $("#feedback3").html("1st xml file successfully accessed");
            $(unicode).find("keystroke").each(function () {
                var xdec = $(this).find("dec").text();
                var xchar = String.fromCharCode(Number(xdec));
                var xhex = $(this).find("hex").text();
                //replace midpoint with another placeholder, the Greek numeral sign
                oldtext = oldtext.split(xchar + "·").join(xhex + "΄");
            });
            oldtextpua = oldtext;
            $("#feedback4").html(oldtext);
        },
        error: function () {
            $("#feedback3").html("failure")
        }
    });
    // now go through the AR database, long AR sequences first, and make global replacements
    $.ajax({
        url: "AR.xml",
        dataType: "xml",
        success: function (ar) {
            $("#feedback5").html("2nd xml file successfully accessed");
            for (var i = 3; i > 0; i--) {
                $(ar).find("athena").filter(function () {
                    return $(this).attr("cp").length == 5 * i - 1
                }).each(function () {
                    var x = "";
                    var xpua = "";
                    w = $(this).attr("cp").split(";").join("΄") + "΄";
                    $(this).parent().parent().find("ligatureelement").each(function () {
                        x = x + "&#x" + $(this).find("unicode:first").attr("cp") + ";";
                        xpua = "&#x" + $(this).parent().siblings("pua").attr("cp") + ";";
                    });
                    x = "<span class='ar-cv-n0-lig'>" + x + "</span>";
                    // next line specially for singlets in Athena that represent ligatures
                    $(this).parent().parent().children("unicode:first").each(function () {
                        var y = $(this).siblings("variant").text();
                        x = x + "&#x" + $(this).attr("cp") + ";";
                        // add a variation class, if not the standard
                        if (y != 0) {
                            x = "<span class='ar-cv-n" + y + "'>" + x + "</span>";
                            xpua = "&#x" + $(this).siblings("pua").attr("cp") + ";";
                        } else {
                        xpua = "&#x" + $(this).siblings("unicode:first").attr("cp") + ";";
                        };
                    });
                    oldtextpua = oldtextpua.split(w).join(xpua);
                    oldtext = oldtext.split(w).join(x);
                });
            };
            $("#feedback6").html(oldtextpua);
            $("#convertedtext").html(oldtext);
            $("h2:first").text("Athena Ruby, fully Unicode compliant");
            $("#convertedtextpua").html(oldtextpua);
            $("h3:first").text("Athena Ruby, private use area");
        },
        error: function () {
            $("#feedback5").html("failure")
        }
    })
}

// defunct, but perhaps useful for reference
function stroke1() {
    // *x* holds the old Athena text
    var x = $("#oldtext").text();
    // *hex* will eventually hold *x*, converted into a hexadecimal string
    var hex = new Array;
    // clear, prep the boxes...
    $("#convertedtext").html("");
    $("p[id^='feedback']").html("").css({
        "color": "gray", "font-size": "80%"
    });
    // items below convert x to a hex value, using a JavaScript loop
    $("#feedback1").html(x);
    for (var i = 0; i < x.length; i++) {
        //convert next two lines to jquery, then get rid of all the initializing code (lines 7-18)
        y = xmlDoc.getElementById(x[i]);
        hex[i] =(y.getElementsByTagName("hex")[0].childNodes[0].nodeValue);
        $("#feedback2").append(hex[i]);
    };
}

// defunct, but perhaps useful for reference
function lookup2(datatest) {
    var i = datatest;
    $("#feedback5").html(i);
    $.ajax({
        url: "AR.xml",
        dataType: "xml",
        success: function (inputdata) {
            $("#feedback3").html("entering");
            $(inputdata).find("index:contains('20')").each(function () {
                var j = $(this).parent().find("prodname").text();
                $("#feedback4").append(j);
            });
        }
    });
}

// defunct, but perhaps useful for reference
function lookup(data) {
    $.ajax({
        type: "GET",
        url: "AR.xml",
        dataType: "xml",
        data: "index=10",
        success: function (xml) {
            $.each(data, function (index, value) {
                var z = $(xml).find("athena[cp=" + value + "]").parent().siblings("unicode:first").text();
                $('#convertedtext').append(z);
            });
        },
        error: function () {
            $('#convertedtext').append('error');
        }
    });
}