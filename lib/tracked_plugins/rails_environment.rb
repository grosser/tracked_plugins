# always complains when reinstalling, even though there is not externals!
class RailsEnvironment
  def externals_with_svn_check=(items)
    self.externals_without_svn_check=(items) if use_externals?
  end
  alias_method_chain :externals=, :svn_check
end