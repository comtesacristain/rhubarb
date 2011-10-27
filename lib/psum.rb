module Psum


    
  def self.sum(a)
    if a.size > 2
      n=a.size/2
      b=a.pop(n)
      c=a
      return Psum.sum(b) + Psum.sum(c)
    elsif a.size ==1
      return a[0]
    else
      return a[0] + a[1]
    end
  end

end