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

function convert_jsdate_to_tdate(date) {
    // Ex: 2016-10-18T11:00:59Z
    var year = date.getUTCFullYear();
    var month = ("0" + (date.getUTCMonth() + 1)).slice(-2);
    var day = ("0" + date.getUTCDate()).slice(-2);
    var hour = ("0" + date.getUTCHours()).slice(-2);
    var minute = ("0" + date.getUTCMinutes()).slice(-2);
    var seconds = ("0" + date.getUTCSeconds()).slice(-2);

    var tdate = year + month + day + "T" + hour + minute + seconds + "Z";
    return tdate;
}

function add_days_to_date(dateObj, days) {
    var ret = new Date(dateObj);
    ret.setDate(dateObj.getDate() + days);
    return ret;
}

function add_months_to_date(dateObj, months) {
    var currentMonth = dateObj.getMonth();
    dateObj.setMonth(dateObj.getMonth() + months)

    if (dateObj.getMonth() !== ((currentMonth + months) % 12)){
        dateObj.setDate(0);
    }
    return dateObj;
}
