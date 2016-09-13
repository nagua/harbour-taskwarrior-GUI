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

