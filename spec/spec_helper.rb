require %(stitches/synthesizer/abstract)

class RandoSynthesizer < AbstractSynthesizer
  def method_missing(method_name, *args, &block)
    abstract_method_missing(
      method_name,
      %i[rando],
      *args,
      &block
    )
  end
end
