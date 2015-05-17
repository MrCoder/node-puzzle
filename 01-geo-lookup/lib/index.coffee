fs = require 'fs'


GEO_FIELD_MIN = 0
GEO_FIELD_MAX = 1
GEO_FIELD_COUNTRY = 2


exports.ip2long = (ip) ->
  ip = ip.split '.', 4
  return +ip[0] * 16777216 + +ip[1] * 65536 + +ip[2] * 256 + +ip[3]


gindex = []
heads = []
min = 0
max = 0
length = 0
exports.load = ->
  data = fs.readFileSync "#{__dirname}/../data/geo.txt", 'utf8'
  data = data.toString().split '\n'

  for line in data when line
    line = line.split '\t'
    # GEO_FIELD_MIN, GEO_FIELD_MAX, GEO_FIELD_COUNTRY
    gindex.push [+line[0], +line[1], line[3]]
  gindex.sort (a, b) -> a[GEO_FIELD_MIN] - b[GEO_FIELD_MIN]
  heads = gindex.map (obj) -> obj[GEO_FIELD_MIN]
  length = heads.length
  min = gindex[0][GEO_FIELD_MIN]
  max = gindex[length - 1][GEO_FIELD_MAX]


normalize = (row) -> country: row[GEO_FIELD_COUNTRY]


floorSearch = (a, low, high, x) ->
  if low > high
    return low

  mid = (low + high) // 2

  if a[mid] > x
    return floorSearch a, low, mid - 1, x
  else if a[mid] < x
    return floorSearch a, mid + 1, high, x
  else
    return mid+1


exports.lookup = (ip) ->

  return -1 unless ip

  find = this.ip2long ip

  if min > find || max < find
    return null

  start = floorSearch heads, 0, length, find
  if gindex[start - 1][GEO_FIELD_MAX] < find
    return null
  return normalize gindex[start - 1]