# Override method serializable_hash in  devise/lib/devise/models/authenticatable.rb
# to do not embed refresh_token field into response body

module Devise
  module Models

    module Authenticatable

      # Redefine serializable_hash in models for more secure defaults.
      # By default, it removes from the serializable model all attributes that
      # are *not* accessible. You can remove this default by using :force_except
      # and passing a new list of attributes you want to exempt. All attributes
      # given to :except will simply add names to exempt to Devise internal list.
      def serializable_hash(options = nil)
        options = options.try(:dup) || {}
        options[:except] = Array(options[:except])

        if options[:force_except]
          options[:except].concat Array(options[:force_except])
        else
          options[:except].concat BLACKLIST_FOR_SERIALIZATION
          options[:except].concat [:refresh_token]
        end

        super(options)
      end
    end
  end
end
