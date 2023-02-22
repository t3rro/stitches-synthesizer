# frozen_string_literal: true

require %(stitches/synthesizer/factory)

describe SynthesizerFactory do
  context %(create_synthesizer) do
    it %(should create a resource synthesizer) do
      SynthesizerFactory.create_synthesizer(name: :rando, keys: [:rando]).synthesize do
        rando :nietztche, :thus_spoke_zarathustra do
          superman(%(came from krypton))
          overman(%(came from austria))
        end
      end
    end
  end
end
