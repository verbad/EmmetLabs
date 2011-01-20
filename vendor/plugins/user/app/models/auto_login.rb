class AutoLogin < Token
  alias_method :user, :tokenable
  alias_method :user=, :tokenable=
end