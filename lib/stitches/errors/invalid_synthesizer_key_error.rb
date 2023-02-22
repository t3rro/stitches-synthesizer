# Synthesizers need keys to be created however if a synth attempts to process
# an unrecognized key it should error
class InvalidSynthesizerKeyError < StandardError; end
