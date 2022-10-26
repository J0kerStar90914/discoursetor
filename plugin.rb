# name: discourse-whonix-onion-host-support
# about: load Whonix site on onion if used
# version: 0.1
# authors: Miguel Jacq

::ONION_HOST = "oxr7npylofi23da6uvswkjfsgcbhlnx46srkdkssqghhupmx5cxdlbad.onion"
::CLEAR_HOST = "community.sec4ever.com"

after_initialize do

  # got to patch this class to allow more hostnames
  class ::Middleware::EnforceHostname
    def call(env)
      hostname = env[Rack::Request::HTTP_X_FORWARDED_HOST].presence || env[Rack::HTTP_HOST]

      env[Rack::Request::HTTP_X_FORWARDED_HOST] = nil

      if hostname == ::ONION_HOST
        env[Rack::HTTP_HOST] = ::ONION_HOST
      else
        env[Rack::HTTP_HOST] = ::CLEAR_HOST
      end

      @app.call(env)
    end
  end
end
