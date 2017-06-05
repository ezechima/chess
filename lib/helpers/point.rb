module ChimaChess
	LOC_REGEXP = /([a-h])([1-8]$)/
	CHESS_FILE_NUMBERS = {"a"=>0,"b"=>1,"c"=>2,"d"=>3,"e"=>4,"f"=>5,"g"=>6,"h"=>7}

	class ChessGameException < Exception
	end


	class Array_Initialize
		def self.create_array (var)
			x = var[0][0] || 0
			y = var[0][1] || 0
			z = var[0][2] || 0
			[x,y,z]
		end
	end
	class Fixnum_Initialize
		def self.create_array (var)
			x = var[0] || 0
			y = var[1] || 0
			z = var[2] || 0
			[x,y,z]
		end
	end

	class Symbol_Initialize
		def self.create_array (var)
			loc = LOC_REGEXP.match(var[0].to_s.downcase)
			if loc.nil?
				raise ChessGameException.new("Invalid Chess Board location")
			else
				file = loc[1]
				rank = loc[2]
				
			end
			[CHESS_FILE_NUMBERS[file],rank.to_i-1,0]
		end
	end
	class String_Initialize
		def self.create_array (var)
			loc = LOC_REGEXP.match(var[0].downcase)
			if loc.nil?
				raise ChessGameException.new("Invalid Chess Board location")
			else
				file = loc[1]
				rank = loc[2]
				
			end
			[CHESS_FILE_NUMBERS[file],rank.to_i-1,0]
		end
	end
	class Point_Initialize
		def self.create_array (var)

				x = var[0].x
				y = var[0].y
				z = var[0].z
				[x,y,z]
		end
	end
	class NilClass_Initialize
		def self.create_array (var)

				x = 0
				y = 0
				z = 0
				[x,y,z]
		end
	end

	class Point
	#This class represents a location on a grid (x,y,z)

		attr_accessor  :x, :y, :z

		def initialize(*var)
			method_handler = "ChimaChess::" + var[0].class.to_s + "_Initialize"
			

			@x,@y,@z = Object.const_get(method_handler).create_array(var)

		end


		def +(point)
			point = to_point(point)
			Point.new(@x + point.x, @y + point.y, @z + point.z)
			
		end

		def *(num)
			
			Point.new(@x * num, @y * num, @z * num)
			
		end

		def move_to!(point)
			point = to_point(point)
			@x = point.x
			@y = point.y
			@z = point.z
			self
		end

		def move_by(point)
			point = to_point(point)
			@x += point.x
			@y += point.y
			@z += point.z
		end
		def to_point(var)
	 			Point.new(var)
			
		end

		def eql? (point)
			return true if (point.instance_of?(Point) && point.x == @x && point.y == @y && point.z ==@z)
			false
			
		end

		def to_chess_notation
			rank = (@y+1).to_s
			file = CHESS_FILE_NUMBERS.key(@x)
			"#{file}#{rank}"
		end



		def to_s
				"#{@x},#{@y},#{@z}"
		end



	end

	NORTH = Point.new(0,1)
	SOUTH = Point.new(0,-1)
	EAST = Point.new(1,0)
	WEST = Point.new(-1,0)


end



