require 'readline'
require 'csv'

class MySqlite
  def initialize
    @tableName      = nil
    @select_attri   = []
    @where_attri    = []
    @order          = :ASC
    @order_column   = nil
    @insert_attri   = {}
    @update_values  = {}
    @requestType    = :none
  end

  def get_table(query)
    query.each do |elem|
      if ['FROM', 'INTO', 'DELETE'].include? elem.upcase
        index = query.index(elem) + 1
        @tableName = query[index]
      end
    end
    self
  end

  def get_select_column(query)
    index_sel = nil
    index_from = nil
    query = query.map(&:upcase)
    query.each do |elem|
      if elem == 'SELECT'
        index_sel = query.index(elem)
      end
      if elem == 'FROM'
        index_from = query.index(elem)
      end
    end
    @select_attri = query[(index_sel + 1)...index_from]
    self
  end

  def run
    p @select_attri
  end

end


request = MySqlite.new
request.get_select_column(["select","all","from","moving"])
request.run
