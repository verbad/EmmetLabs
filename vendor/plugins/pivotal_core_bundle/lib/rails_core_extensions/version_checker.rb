    module Pivotal
      class VersionChecker
        def self.current_rails_version_matches?(version_requirement)
          version_matches?(Rails::VERSION::STRING, version_requirement)
        end

        def self.version_matches?(version, version_requirement)
          Gem::Version::Requirement.new([version_requirement]).satisfied_by?(Gem::Version.new(version))
        end

        def self.rails_version_is_below_2?
          result = Pivotal::VersionChecker.current_rails_version_matches?('<1.99.0')
          result
        end

        def self.rails_version_is_below_rc2?
          Pivotal::VersionChecker.current_rails_version_matches?('<1.99.1')
        end

        def self.rails_version_is_1991?
          Pivotal::VersionChecker.current_rails_version_matches?('=1.99.1')
        end
      end
    end
