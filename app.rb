require "sinatra/base"
require "sinatra/json"
require "pry"
require 'json'
DB = {}

class Coloson < Sinatra::Base
	set :show_exceptions, false
	error do |e|
		raise e
	end

	def self.reset_database
		DB.each { |k,v| DB[k] = []}	
	end

	get "/numbers/evens" do
			DB["evens"] ||= []
			json DB["evens"]
end


	post "/numbers/evens" do
		new_number = params["number"]
		if new_number == new_number.to_i.to_s
			DB["evens"] ||= []
			DB["evens"].push new_number.to_i
			200
		end
	end

	get "/numbers/odds" do
		if DB.empty?
			status 200
			json []
		else

			status 200
			json DB["odds"]
		end
	end


	post "/numbers/odds" do
		new_number = params["number"]
		if new_number == new_number.to_i.to_s
			DB["odds"] ||= []
			DB["odds"].push new_number.to_i
			200
		else
			status 422


			r = {}
			r["status"] = "error"
			r["error"] = "Invalid number: #{new_number}"

			body(r.to_json)

		end
	end

	delete "/numbers/odds" do
		deleted = params["number"]
		if deleted == deleted.to_i.to_s
			DB["odds"].delete deleted.to_i
			200
		else
			500
		end
	end




	get "/numbers/primes/sum" do
		DB["primes"] ||= []

		status 200
		sum = (DB["primes"]).reduce(0, :+)
		json(status: "ok", sum: sum)
	end


	post "/numbers/primes" do
		new_number = params["number"]
		if new_number == new_number.to_i.to_s
			DB["primes"] ||= []
			DB["primes"].push new_number.to_i
			200

		end
	end

	get "/numbers/mine/product" do
		DB["mine"] ||= []
		product = (DB["mine"]).reduce(1, :*)
		if product  > 100
			status 422
			json(status: "error", error:"Only paid users can multiply numbers that large" )
		else

			status 200
			json(status: "ok", product: product)
		end
	end

	post "/numbers/mine" do
		new_number = params["number"]
		if new_number == new_number.to_i.to_s
			DB["mine"] ||= []
			DB["mine"].push new_number.to_i
			200

		end
	end


end


Coloson.run! if $PROGRAM_NAME == __FILE__
