module OccurrencesHelper
  def to_dms(ord)
    deg= (ord - ord%1).to_i
    min= (ord%1 *60 - (ord%1 *60 %1)).to_i
    sec= ((ord%1 *60 - min)*60).to_i
    return deg.to_s+("%02d"%min)+("%02d"%sec)
  end

  def popular(long, lat)

    e = "E"+to_dms(long.abs)
    s = "S"+to_dms(lat.abs)
    return s+s+e+e
  end
end
