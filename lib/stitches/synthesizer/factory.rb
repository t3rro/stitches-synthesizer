require_relative %(./abstract)

module SynthesizerFactory
  class << self
    def create_synthesizer(name:, keys:)
      synth = AbstractSynthesizer.new(name: name)
      synth.define_singleton_method(:method_missing) do |method_name, *args, &block|
        abstract_method_missing(
          method_name,
          keys,
          *args,
          &block
        )
      end
      synth
    end
  end
end
