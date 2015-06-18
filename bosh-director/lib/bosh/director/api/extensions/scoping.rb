module Bosh::Director
  module Api
    module Extensions
      module Scoping
        module Helpers
          def current_user
            @user
          end
        end

        def self.registered(app)
          app.set default_scope: :write
          app.helpers(Helpers)
        end

        def scope(allowed_scope)
          condition do
            if allowed_scope == :default
              scope = settings.default_scope
            elsif allowed_scope.kind_of?(ParamsScope)
              scope = allowed_scope.scope(params, settings.default_scope)
            else
              scope = allowed_scope
            end

            auth_provided = %w(HTTP_AUTHORIZATION X-HTTP_AUTHORIZATION X_HTTP_AUTHORIZATION).detect do |key|
              request.env.has_key?(key)
            end

            if auth_provided
              begin
                @user = identity_provider.corroborate_user(request.env, scope)
              rescue AuthenticationError
              end
            end

            if requires_authentication? && @user.nil?
              response['WWW-Authenticate'] = 'Basic realm="BOSH Director"'
              throw(:halt, [401, "Not authorized\n"])
            end
          end
        end

        def route(verb, path, options = {}, &block)
          options[:scope] ||= :default
          super(verb, path, options, &block)
        end

        class ParamsScope
          def initialize(name, scope)
            @name = name.to_s
            @scope = scope
          end

          def scope(params, default_scope)
            scope_name = params.fetch(@name, :default).to_sym
            @scope.fetch(scope_name, default_scope)
          end
        end
      end
    end
  end
end
