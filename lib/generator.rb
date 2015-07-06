module TSheets
  require 'tsheets/helpers'

  class Generator
    def self.clean
      `rm -f lib/tsheets/{models,repos}/*.rb`
    end

    def self.run! config
      new.run! config
    end

    def run! config
      generate_models! config['objects']
      generate_repos! config['endpoints']
    end

    def write_dynamic! path, contents
      FileUtils.touch "lib/tsheets/#{path}"
      File.write "lib/tsheets/#{path}", contents
    end

    def generate_models! models_config
      models_config.each do |name, config|
        generate_model! name, config
      end
    end

    def generate_model! name, config
      write_dynamic! "models/#{name}.rb", code_for_model(name, config)
    end

    def generate_repos! endpoints_config
      endpoints_config.each do |name, config|
        generate_repo! name, config
      end
    end

    def generate_repo! name, config
      write_dynamic! "repos/#{name}.rb", code_for_repo(name, config)
    end

    def code_for_repo name, config
      template = <<-EOF
  class TSheets::Repos::<%= class_name %> < TSheets::Repository
    url "<%= config['url'] %>"
    model TSheets::Models::<%= model_class %>
    actions <%= actions %><% filters.each do |field_name, field_config| %>
    filter :<%= field_name %>, <%= field_config %><% end %>
  end
      EOF
      class_name = TSheets::Helpers.to_class_name name
      model_class = TSheets::Helpers.to_class_name config['object']
      actions = config['actions'].map { |a| ":#{a}" }.join(', ')
      filters = {}
      filters = config['filters'].map do |fname, fconfig|
        { fname => ( fconfig[/\[\]/].nil? ? ":#{fconfig}" : "[ :#{fconfig.gsub(/\[\]/, '')} ]" ) }
      end.inject({}, &:merge) if config['filters']
      ERB.new(template).result binding
    end

    def code_for_model name, config
      template = <<-EOF
  class TSheets::Models::<%= class_name %> < TSheets::Model<% fields.each do |field_name, field_config| %>
    field :<%= field_name %>, <%= field_config %><% end %>
  end
      EOF
      fields = {}
      fields = config.map do |fname, fconfig|
        { fname => ( !fconfig.is_a?(Array) ? ":#{fconfig}" : "[ :#{fconfig.first} ]" ) }
      end.inject({}, &:merge) if config
      class_name = TSheets::Helpers.to_class_name name
      ERB.new(template).result binding
    end

  end
end
