require 'sqlite3'

if File.exists? "inventario.sqlite"
	File.delete("inventario.sqlite")
end

db = SQLite3::Database.open("inventario.sqlite")

db.execute <<SQL
	CREATE TABLE productos(
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		imagen VARCHAR(200),
		nombre VARCHAR(200),
		cantidad VARCHAR(20),
		precio VARCHAR(20)
		);
SQL


