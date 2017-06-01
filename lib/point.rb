class Point
#This class represents a location on a grid (x,y,z)
	NORTH = Point.new(0,1)
	SOUTH = Point.new(0,-1)
	EAST = Point.new(1,0)
	WEST = Point.new(-1,0)
	attr_accessor  :x, :y, :z

	def initialize(*var)
		method_handler = var[0].class.to_s + "_Initialize"
		send(method_handler,var)

	end
	def NilClass_Initialize(var)
		@x = 0
		@y = 0
		@z = 0
	end
	def Array_Initialize(var)
		@x = var[0][0] || 0
		@y = var[0][1] || 0
		@z = var[0][2] || 0
	end
	def Fixnum_Initialize(var)
		@x = var[0] || 0
		@y = var[1] || 0
		@z = var[2] || 0
	end
	def Point_Initialize(var)
		@x = var[0].x
		@y = var[0].y
		@z = var[0].z
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


	def to_s
			"#{@x},#{@y},#{@z}"
	end



end



