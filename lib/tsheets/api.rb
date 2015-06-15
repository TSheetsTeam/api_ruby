class TSheets::API

  TSheets::Repo.classes.each do |klass|
    acc_name = klass.name.split('::').last.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').tr("-", "_").downcase
    send :attr_reader, acc_name
    @@_repos ||= []
    @@_repos << { :name => acc_name, :class => klass }
  end

  def initialize(config)
    @bridge = TSheets::Bridge.new(config)
    @@_repos.each do |repo|
      instance_variable_set "@#{repo[:name]}", repo[:class].new(@bridge)
    end
  end

end
