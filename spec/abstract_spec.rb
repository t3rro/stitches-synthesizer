# frozen_string_literal: true

require_relative %(./spec_helper)
require %(stitches/errors/invalid_synthesizer_key_error)
require %(stitches/errors/too_many_field_values)

describe RandoSynthesizer do
  context %(main) do
    let(:synth) do
      described_class.new
    end

    it %(should compile small declaration and be hash) do
      synth.synthesize do
        rando :nietztche, :thus_spoke_zarathustra do
          superman(%(came from krypton))
          overman(%(came from austria))
        end
      end
      expect(synth.synthesis).to be_kind_of(Hash)
    end

    it %(should raise an argument error with more than one arg per field) do
      expect do
        synth.synthesize do
          rando :socrates, :the_republic do
            things(%(may), %(not), %(be), %(what), %(you), %(think))
          end
        end
      end.to raise_error(TooManyFieldValuesError)
    end

    it %(should have expected keys) do
      synth.synthesize do
        rando :kafka, :metamorphasis do
          change :inevitable
        end
      end
      expect(
        synth.synthesis[:rando][:kafka][:metamorphasis][:change]
      ).to be(:inevitable)
    end
  end
end
