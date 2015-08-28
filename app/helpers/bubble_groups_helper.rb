module BubbleGroupsHelper
  def bubble_group_two_lines_name(name)
    result = name
    case name
      when 'Base 10 How Many'
        result = 'Base 10<br>How Many'
      when 'Base 10 Produce'
        result = 'Base 10<br>Produce'
      when 'Addition and Subtraction Count All'
        result = 'Addition and Subtraction<br>Count All'
      when 'Counting and Cardinality to 20'
        result = 'Counting and<br>Cardinality to 20'
      when 'Number Line Model'
        result = 'Number Line<br>Model'
      when 'Addition and Subtraction Comparison'
        result = 'Addition and Subtraction<br>Comparison'
      when 'Addition and Subtraction Count On'
        result = 'Addition and Subtraction<br>Count On'
    end
    raw result
  end
end
