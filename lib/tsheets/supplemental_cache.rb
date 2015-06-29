class TSheets::SupplementalCache
  attr_accessor :data

  def initialize
    @data = {}
  end

  def store(model_def, model)
    @data[model_def[:type]] ||= {}
    @data[model_def[:type]][model.send "#{model_def[:primary]}"] = model
    model
  end

  def resolve(model_def, container_model)
    return unless @data[model_def[:type]]
    @data[model_def[:type]][container_model.send "#{model_def[:foreign]}"]
  end
end
