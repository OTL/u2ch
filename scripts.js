function checkFontAndAddLoading(font, baseText, loadingText, indicator) {
    if (font.status == FontLoader.Ready) {
        if (indicator) {
            indicator.running = false;
        }
        return baseText;
    } else {
        if (indicator) {
            indicator.running = true;
        }
        return loadingText;
    }
}

function getFavoriteBoardList() {
    var db = LocalStorage.openDatabaseSync("u2ch", "0.2", "hoge", 1000000);
    var list = [];
    db.transaction(
        function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS FavoriteBoard(title TEXT, url TEXT)');
            // Show all added greetings
            var rs = tx.executeSql('SELECT * FROM FavoriteBoard');

            for(var i = 0; i < rs.rows.length; i++) {
                list.push(rs.rows.item(i));
            }
        });
    return list;
}

function addBoardToFavorite(title, url) {
    var db = LocalStorage.openDatabaseSync("u2ch", "0.2", "hoge", 1000000);
    db.transaction(
        function(tx) {
            // Create the database if it doesn't already exist
            tx.executeSql('CREATE TABLE IF NOT EXISTS FavoriteBoard(title TEXT, url TEXT)');
            // Add (another) greeting row
            tx.executeSql('INSERT INTO FavoriteBoard VALUES(?, ?)', [title, url]);
         }
     );
}

function removeBoardFromFavorite(title, url) {
    var db = LocalStorage.openDatabaseSync("u2ch", "0.2", "hoge", 1000000);
    db.transaction(
        function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS FavoriteBoard(title TEXT, url TEXT)');
            // Create the database if it doesn't already exist
            tx.executeSql('DELETE FROM FavoriteBoard WHERE url = ?', [url]);
        });
}
