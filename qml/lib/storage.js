.pragma library
.import QtQuick.LocalStorage 2.0 as Storage

var DB_VERSION = "0.1"


function connectDB() {
    return Storage.LocalStorage.openDatabaseSync("Taskwarrior", "", "Taskwarrior Database", 1024);
}

function createDB(tx) {
    console.log("Creating DB v" + DB_VERSION + " from scratch...")

    // Way to store the different views
    tx.executeSql("CREATE TABLE views(ID INTEGER PRIMARY KEY AUTOINCREMENT, ViewName TEXT, Query TEXT, Section TEXT);");

    // Possibly store settings
    tx.executeSql("CREATE TABLE IF NOT EXISTS settings(ID INTEGER PRIMARY KEY AUTOINCREMENT, Setting TEXT UNIQUE, Value TEXT);");
}

function recreateDB() {
    console.log("Drop all tables from DB");

    var db = connectDB();
    db.transaction(function(tx) {
        tx.executeSql("DROP TABLE IF EXISTS views");
        tx.executeSql("DROP TABLE IF EXISTS settings");
    });

    db.transaction(function(tx) {
        createDB(tx);
    });

    return db;
}

function schemaIsUpToDate() {
    var db = connectDB();

    if(db.version === "") {
        db.changeVersion("", DB_VERSION, createDB);
        return true;
    }
    return db.version === DB_VERSION;
}

function readViews() {
    var db = connectDB();
    var lists = [];
    db.transaction(function(tx) {
        var result = tx.executeSql("SELECT * FROM views;");
        for(var i = 0; i < result.rows.length; ++i) {
            var item = result.rows.item(i);
            var storage_item = {lid: item.ID ,name: item.ViewName, query: item.Query, section: item.Section};
            lists.push(storage_item);
        }
    });
    return lists;
}

function addView(view) {
    var db = connectDB();
    db.transaction(function(tx) {
        var result;
        result = tx.executeSql("INSERT INTO views (ViewName, Query, Section) VALUES (?,?,?);", [view.name, view.query, view.section]);
        result = tx.executeSql("COMMIT;");
        view.lid = +result.insertId;
    })
}

function deleteView(view) {
    var db = connectDB();
    db.transaction(function(tx) {
        tx.executeSql("DELETE FROM views WHERE ID = ?;", view.lid);
        tx.executeSql("COMMIT;");
    });
}


function editView(view) {
    var db = connectDB();
    db.transaction(function(tx) {
        tx.executeSql("UPDATE views Set ViewName=?, Query=?, Section=? WHERE ID = ?;", [view.name, view.query, view.section, view.lid]);
        tx.executeSql("COMMIT;");
    });
}
