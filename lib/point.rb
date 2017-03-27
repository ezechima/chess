class Point
#This class represents a location on a grid (x,y,z)

	attr_accessor  :x, :y, :z

	def initialize(x=0,y=0,z=0)
		@x = x
		@y = y
		@z = z

	end

	def +(point)
		point = to_point(point)
		Point.new(@x + point.x, @y + point.y, @z + point.z)

	end
	def *(num)
		
		Point.new(@x * num, @y * num, @z * num)
		
	end

	def move(point)
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
	def to_point(array)
		if array.instance_of?(Point)
			array
		elsif (array.instance_of?(Array) && array[0].instance_of?(Fixnum))
			x,y,z = array
			Point.new(x.to_i,y.to_i,z.to_i)
		end
	end

	def eql? (point)
		return true if (point.instance_of?(Point) && point.x == @x && point.y == @y && point.z ==@z)
		false
		
	end


	def to_s
			"#{@x},#{@y},#{@z}"
	end



end