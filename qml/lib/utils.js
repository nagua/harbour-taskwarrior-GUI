.pragma library


function copyItem(data) {
    var ret = {};
    for (var p in data) {
        ret[p] = data[p];
    }
    return ret;
}

function copyViewModel(view) {
    return {lid: view.lid, page: view.page, name: view.name, query: view.query, section: view.section};
}

function convert_tdate_to_jsdate(date) {
    // Ex: 20160901T110008Z
    if( typeof date === "undefined" || date.length < 15)
        return ""

    var year   = date.slice( 0,  4);
    var month  = date.slice( 4,  6);
    var day    = date.slice( 6,  8);
    var hour   = date.slice( 9, 11);
    var minute = date.slice(11, 13);
    var second = date.slice(13, 15);

    var utc_date = year + "-" + month + "-" + day + "T" + hour + ":" + minute + ":" + second + "Z";
    return utc_date;
}
