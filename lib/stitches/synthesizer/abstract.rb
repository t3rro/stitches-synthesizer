# frozen_string_literal: true

require_relative %(../errors/invalid_synthesizer_key_error)
require_relative %(../errors/too_many_field_values)
require_relative %(../errors/not_enough_resource_keys)
require_relative %(../primitives/bury)

class AbstractSynthesizer
  include Bury

  attr_reader :translation

  def initialize(name: nil) # rubocop:disable Lint/UnusedMethodArgument
    @translation = {
      ancestors: [],
      template: {},
      context: nil
    }
  end

  def synthesis
    translation[:template]
  end

  def synthesize(content = nil, &block)
    if block_given?
      instance_eval(&block)
    else
      instance_eval(content)
    end
    self
  end

  private

  # check if method is part of keys
  # and is otherwise valid to be used
  def valid_method?(method, keys)
    # if context is nil then you are in resource processing space
    if translation[:context].nil?
      # if you are in resource space the method must be in keys
      keys.include?(method)
    else
      # if we have a context we are not checking for resource
      # signature so method should not be checked
      true
    end
  end

  def validate_method(method, keys)
    err_msg = []
    err_msg << method
    err_msg << %(is invalid for)
    err_msg << self.class
    err_msg << %(and should be one of)
    err_msg << keys.join(%(\n))
    err_msg = err_msg.join(%( ))

    raise InvalidSynthesizerKeyError, err_msg unless valid_method?(method, keys)
  end

  def validate_args(args)
    if translation[:ancestors].empty?
      raise NotEnoughResourceKeys unless args.length.eql?(2)
    elsif !args.length.eql?(1)
      raise TooManyFieldValuesError
    end
  end

  def abstract_method_missing(method, keys, *args)
    keys   = keys.map(&:to_sym)
    method = method.to_sym

    validate_method(method, keys)
    validate_args(args)

    keys.each do |key|
      if key.eql?(translation[:context])
        translation[:ancestors].append(method)
        yield if block_given?
        if args.length == 1
          translation[:template].bury(*translation[:ancestors], args[0])
          translation[:ancestors].pop
        elsif args.empty?
          translation[:ancestors].pop
        else
          msg = %(field: #{method} requires 1 argument, had #{args.length})
          msg += %( )
          msg += %(which were #{args})
          raise TooManyFieldValuesError, msg
        end
      end

      next unless [key].include?(method)

      translation[:ancestors].append(method.to_sym)
      translation[:ancestors].append(*args)
      translation[:context] = method
      yield if block_given?
      translation[:ancestors] = []
      translation[:context] = nil
    end
  end
end
