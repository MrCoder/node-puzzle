Encoder = require '../src/encoder'
Hamming = require '../src/hamming84'
expect = require 'expect.js'

console.log Encoder

describe 'Encoder', ->

  it 'should encode 11011 as 0110011', ->
    encoder = new Encoder
    expect(encoder.encode([false, false, false, true, false, false, true, false])).to.eql [
      true,true,false,true,false,false,true,false,false,true,false,true,false,true,false,true]

#  it 'should convert boolean array to number', ->
#    bits = [true, false, true, true]
#    len = bits.length
#    x = 0
#    for bit in bits
#      if bit
#        x = x | 1
#        console.log x
#      x = x << 1
#      console.log x
#    console.log "result x = #{x}"


  it 'should encode with Hamming84', ->
    encodeResult = []
    encodeResult.encode = Hamming.encode
    encodeResult.encode([0x12], null, () -> {})
    decoded = []
    decoded.decode = Hamming.decode
    decoded.decode(encodeResult[0], null, () -> {})
    buf = new Buffer(2)
    buf.writeUIntBE(0xd255, 0, 2)
    expect(encodeResult[0]).to.eql buf

  it 'should decode 0110011 as 1011', ->
    encoder = new Encoder
    expect(encoder.decode([true,true,false,true,false,false,true,false,false,true,false,true,false,true,false,true]
    ))
      .to.eql [false, false, false, true, false, false, true, false]