class Logical
  def initialize(statement)
    @statement = statement
    @ruby   = ""
  end
  
  def self.to_ruby(statement)
    Logical.new(statement).to_ruby
  end

  def to_ruby
    @statement.gsub('∧','and').gsub('∨','or').gsub('~','!')
  end

  def to_array
    header
  end

  def header
    variables << @statement
  end

  def self.eval_statement(variables,state)
    
  end

  def body
    boolean_table.map do |facts|
      statement = variables.join(",") + "=" + facts.join(',') + ';' + to_ruby
      facts << eval(statement)
    end
  end

  def variables
    @statement.gsub(/and|or/,'').scan(/\w/).uniq
  end

  def boolean_table
    Logical.boolean_table(variables.count)
  end

  def self.boolean_table(variable_count)
    (2**variable_count).times.inject([]) do |table,index|
      table << variable_count.times.map do |position| 
        index[position].zero?
      end
    end
  end
end
