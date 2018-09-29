require 'sinatra'
require 'haml'
require 'sqlite3'

class Inventario
	def initialize()
		@db = SQLite3::Database.open("inventario.sqlite")
	end

	def mostrar_lista()
		self.lista_to_hash(@db.execute("SELECT * FROM productos"))
	end

	def registrar(image, product, amount, price)
		@db.execute("INSERT INTO productos(imagen, nombre, cantidad, precio) VALUES('#{image}', '#{product}', '#{amount}','#{price}')")
	end

	def lista_to_hash(arr)
		arr.map do |dato|
			{
				:id => dato[0],
				:imagen => dato[1],
				:nombre => dato[2],
				:cantidad => dato[3],
				:precio => dato[4]
			}
		end
	end
end

db = Inventario.new()

get '/' do 
	@productos = db.mostrar_lista()
	haml :index
end

get '/nuevo' do 
	haml :nuevo
end

post '/nuevo' do 
	if params.has_key?('file') and params.has_key?('product') and params.has_key?('amount') and params.has_key?('price') 
		@filename = params[:file][:filename]
		file = params[:file][:tempfile]
		File.open("./public/img/#{@filename}", 'wb') do |f|
			f.write(file.read)
		end
		@regis = db.registrar(params[:file][:filename], params[:product], params[:amount], params[:price])
	end
	redirect "/"
end
