Hamming = require './hamming84'

module.exports = class Encoder
  encode: (bits) ->
    # Modify this
    bits
    x = 0
    for bit in bits
      if bit
        x = x | 1
      x = x << 1
    x = x >> 1
    len = bits.length

    result = []
    result.encode = Hamming.encode
    result.encode([x], null, () -> {})

    bools = []
    resultInt = result[0].readUIntBE(0, result[0].length)

    y = 0x8000
    for i in [0 ... 16]
      bools.push Boolean(resultInt & y)
      y = y >> 1

#    resultInt = result[1].readUIntBE(0, result[1].length)
#    console.log "result as Int #{resultInt}"
#
#    y = 0x80
#    for i in [0 ... 16]
#      bools.push Boolean(resultInt & y)
#      y = y >> 1

    return bools

  decode: (bits) ->
    # Modify this
    bits

    bits2 = bits

    result = []
    result.decode = Hamming.decode

    x = 0
    for bit in bits2
      if bit
        x = x | 1
      x = x << 1
    x = x >> 1

    buf = new Buffer(2)
    buf.writeUIntBE(x, 0, 2)

    result.decode(buf, null, () -> {})
    bools = []

    resultInt = result[0].readUIntBE(0, result[0].length)

    y = 0x80
    for i in [0 ... 8]
      bools.push Boolean(resultInt & y)
      y = y >> 1
    return bools