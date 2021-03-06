require 'abstract_unit'
require 'action_dispatch/middleware/session/abstract_store'

module ActionDispatch
  class Request
    class SessionTest < ActiveSupport::TestCase
      def test_create_adds_itself_to_env
        env = {}
        s = Session.create(store, env, {})
        assert_equal s, env[Rack::Session::Abstract::ENV_SESSION_KEY]
      end

      def test_to_hash
        env = {}
        s = Session.create(store, env, {})
        s['foo'] = 'bar'
        assert_equal 'bar', s['foo']
        assert_equal({'foo' => 'bar'}, s.to_hash)
      end

      def test_create_merges_old
        env = {}
        s = Session.create(store, env, {})
        s['foo'] = 'bar'

        s1 = Session.create(store, env, {})
        refute_equal s, s1
        assert_equal 'bar', s1['foo']
      end

      def test_find
        env = {}
        assert_nil Session.find(env)

        s = Session.create(store, env, {})
        assert_equal s, Session.find(env)
      end

      private
      def store
        Class.new {
          def load_session(env); [1, {}]; end
          def session_exists?(env); true; end
        }.new
      end
    end
  end
end
