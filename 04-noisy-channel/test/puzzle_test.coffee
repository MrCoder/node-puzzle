Noise = require '../src/noise'
assert = require 'assert'

Transmitter = require '../src/transmitter'
expect = require 'expect.js'
Encoder = require '../src/encoder'

describe 'Noise transmitter', ->
  describe 'transmitter', ->
    it 'should transmit the data', ->
      bits = [false, false, false, true, false, false, true, false]
      encoder = new Encoder
      randomBoolean = -> Math.random() >= 1
      noise = new Noise({randomBoolean})

      transmitter = new Transmitter {encoder, noise}
      expect(transmitter.transmit bits).to.eql bits
#      result = transmitter.transmit bits
#      console.log "$$$ R", result

  describe 'encode/decode', ->
    n = 5

    test = (noiseProbability) ->
      randomBoolean = -> Math.random() >= 1 - noiseProbability

      noise = new Noise({randomBoolean})
      encoder = new Encoder()

      transmitter = new Transmitter {encoder, noise}

      bits = [0...n].map -> Math.random() >= 0.5

      expect(transmitter.transmit bits).to.eql [false, false, false].concat bits

    it 'TRIVIAL: should be able to transmit signal without loss on perfect channel', ->
      for i in [0..100]
        test 0
#
#    it 'YOU WON: should be able to transmit signal without loss on slightly noise channel', ->
#      for i in [0..100]
#        test 0.2
#        console.log "VVVVV passed ..."


#    it 'BONUS: should be able to transmit signal without loss on very noise channel', ->
#      for i in [0..100]
#        test 0.7
