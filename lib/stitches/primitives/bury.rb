module Bury
  class << self
    def add_bury_to_hash
      Hash.send(:define_method, :bury) do |*args|
        # arg 0 is key arg 1 is val
        if args.count < 2
          raise ArgumentError, %(2 or more arguments required)
        elsif args.count == 2
          self[args[0]] = args[1]

        # if we have more args bury the arg recursively
        else
          arg = args.shift
          self[arg] = {} unless self[arg]
          self[arg].bury(*args) unless args.empty?
        end
      end
    end
  end
  add_bury_to_hash
end
