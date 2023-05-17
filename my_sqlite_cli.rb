require 'readline'
require 'csv'
require_relative 'my_sqlite_request.rb'

class MySqlite
  def initialize
    @tableName      = nil
    @select_attri   = []
    @where_attri    = nil
    @where_criteria = nil
    @order_column   = nil
    @insert_attri   = {}
    @update_values  = {}
    @requestType    = :none
  end

  def get_table(query)
    query.each do |element|
      if(element.upcase=="FROM" || element.upcase=="INTO" || element.upcase=="UPDATE")
          @tableName=query[query.find_index(element) + 1]
          break
      end
  end
  end

  def get_select_column(query)
    index_sel = 0
    index_from = 0
    query = query.map(&:upcase)
    query.each do |elem|
      if elem == 'SELECT'
        index_sel = query.index(elem)
      end
      if elem == 'FROM'
        index_from = query.index(elem)
      end
    end
    @select_attri  = query[index_sel + 1...index_from]
    @select_attri = @select_attri.join(',').downcase.split(',')
    self
  end


  def get_where_params (query)
    query.each do |elem|
      if elem.upcase == 'WHERE'
        @where_attri = query[query.index(elem) + 1]
      end
      if elem == '='
        @where_criteria  = query.slice((query.index(elem) + 1), query.length - query.index(elem)).join(' ').slice(1..-2)
      end
    end

    #@where_attri << [column_name, criteria]
    p @where_attri
    p @where_criteria
  end

  def select_exec(query)
    request = MySqliteRequest.new
    request = request.from(@tableName)
    request = request.select(@select_attri)
    if query.map(&:upcase).include? 'WHERE'
      request = request.where(@where_attri, @where_criteria)
    end
    request.run
    self
  end

  def get_query (query)
    get_table(query)
    get_select_column(query)
    get_where_params(query)
    self
  end

  def cli_request(query)
    get_query(query)
      if(query[0].upcase=="SELECT")
          p "select"
          select_exec(query)
      end
      self
  end

  def run
    while query=Readline.readline("my sqlite cli > ", true)
      query = query.split
      if(query.join == "exit")
          exit
      elsif
          cli_request(query)
      end
    end
  end

end


request = MySqlite.new
request.run
