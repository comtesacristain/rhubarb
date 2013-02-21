# given an array of lower-left and upper-right coordinates
# convert them to an array of polygon coordinates
Array.class_eval do 
  def as_coordinates
    raise "#{self.join(',')} should have 4 numeric values: [minlon, minlat, maxlon, maxlat]" if self.size < 4 or self.size > 4
    v = {:minlon => 0, :maxlon => 2, :minlat => 1, :maxlat => 3}
    ll = [ self[v[:minlon]], self[v[:minlat]] ]
    lr = [ self[v[:maxlon]], self[v[:minlat]] ]
    ur = [ self[v[:maxlon]], self[v[:maxlat]] ]
    ul = [ self[v[:minlon]], self[v[:maxlat]] ]
    [[ll, lr, ur, ul, ll]]
  end


  def to_coordinates(dimension=2)
   if dimension == 2
     i=0
     c=[]
     p=[]
     while i < self.length
       p << self[i]
       if (i+1)%2==0
         c << p
         p=[]
       end
       i +=1
     end
   elsif dimension == 3
     i=0
     c=[]
     p=[]
     while i < self.length
       p << self[i]
       if (i+1)%3==0
         c << p
         p=[]
       end
       i +=1
     end
   end
   return c
  end


#  def stupify (dimension =2)
#    array_max = 900
#    a = self.length /array_max
#    a =
#
#  end
end

