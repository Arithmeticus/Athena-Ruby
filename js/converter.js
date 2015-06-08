/*
Developed February 2013 by Joel Kalvesmaki for Dumbarton Oaks, Trustees of
Harvard University
*/

function stroke() {
    var oldtext = $("#oldtext").text();
    // First, look for surrounding code to strip out
    oldtext = oldtext.replace(/<!--[^>]*>/g, "");
    // Now prime the pua variable
    var oldtextpua = oldtext;
    // The Greek midpoint marks characters that have not yet been replaced.
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
            oldtext = oldtext.replace(/(0036΄)([0-9a-fA-F]{4}΄)/g, "$1$2$1");
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
                    var w = $(this).attr("cp").split(";").join("΄") + "΄";
                    // next section for Athena corresponding to ligatures
                    $(this).parent().parent().find("ligatureelement").each(function () {
                        x = x + "&#x" + $(this).find("unicode:first").attr("cp") + ";";
                        xpua = "&#x" + $(this).parent().siblings("pua").attr("cp") + ";";
                    });
                    if (x.length > 1) {
                        var y = $(this).parent().siblings("variant").text();
                        if (Number(y) != 0) {
                            x = "<span class='ar-cv-n" + y + "-lig'>" + x + "</span>"
                        } else {
                            x = "<span class='ar-cv-n0-lig'>" + x + "</span>"
                        };
                    };
                    // next section for Athena that does not correspond to ligatures
                    $(this).parent().parent().children("unicode:first").each(function () {
                        var y = $(this).siblings("variant").text();
                        x = x + "&#x" + $(this).attr("cp") + ";";
                        // add a variation class, if not the standard
                        if (Number(y) != 0) {
                            x = "<span class='ar-cv-n" + y + "'>" + x + "</span>";
                            xpua = "&#x" + $(this).siblings("pua").attr("cp") + ";";
                        } else {
                            xpua = "&#x" + $(this).attr("cp") + ";";
                        };
                    });
                    oldtextpua = oldtextpua.split(w).join(xpua);
                    oldtext = oldtext.split(w).join(x);
                });
            };
            $("#feedback6").text(oldtext);
            $("#feedback7").text(oldtextpua);
            // get rid of unconverted, put underdots and macrons in that order
            oldtext = oldtext.replace(/([0-9]{4})΄/g, "&#x" + "$1" + ";").replace(/(&#x0305;)(&#x0323;)/g, "$2$1");
            oldtextpua = oldtextpua.replace(/([0-9A-Fa-f]{4})΄/g, "&#x" + "$1" + ";").replace(/(&#x0305;)(&#x0323;)/g, "$2$1");
            oldtext = oldtext.replace(/(&#x0305;)(&#x[0-9a-fA-F]{4};)/g, "$2$1|").replace(/(&#x0305;)(<[^>]*>)(&#x[0-9a-fA-F]{4};)(&#x[0-9a-fA-F]{4};)(&#x[0-9a-fA-F]{4};)/g, "$2$3$1$4$1$5$1|").replace(/(&#x0305;)(<[^>]*>)(&#x[0-9a-fA-F]{4};)(&#x[0-9a-fA-F]{4};)/g, "$2$3$1$4$1|").replace(/(&#x0305;)(<[^>]*>)(&#x[0-9a-fA-F]{4};)/g, "$2$3$1|").replace(/\|/g, "");
            oldtextpua = oldtextpua.replace(/(&#x0305;)([^;]*;)/g, "$2$1");
            oldtext = oldtext.replace(/(&#x0323;)(&#x[0-9a-fA-F]{4};)/g, "$2$1|").replace(/(&#x0323;)(<[^>]*>)(&#x[0-9a-fA-F]{4};)/g, "$2$3$1|").replace(/\|/g, "");
            oldtextpua = oldtextpua.replace(/(&#x0323;)(&#x[0-9a-fA-F]{4};)/g, "$2$1");
            $("#convertedtext").html(oldtext);
            $("#convertedtextpua").html(oldtextpua);
            $("#feedback8").text(oldtext);
        },
        error: function () {
            $("#feedback5").html("failure")
        }
    })
}
