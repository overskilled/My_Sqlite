require 'csv'


class MySqliteRequest

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

    def from (table_name)
        @tableName = table_name
        self
    end

    def select (column_name)

        if column_name.kind_of?(Array)
            @select_attri += column_name.map do |item|
              item.to_s
            end
        else
            @select_attri << column_name.to_s
        end
        self.request_type(:select)
        self
        #puts @select_attri
    end

    def where(column_name, criteria)
        @where_attri << [column_name, criteria]
        self
    end

    def join(column_on_db_a, filename_db_b, column_on_db_b)
        File.open('on_join_db.csv', 'w') {|file| file.truncate(0)}
        tableA = get_data(@tableName)
        tableB = get_data(filename_db_b)
        tableA.each do |elemA|
            tableB.each do |elemB|
                if elemA[column_on_db_a] == elemB[column_on_db_b]
                elemA.merge!(elemB)
                end
            end
        end
        File.open("on_join_db.csv", "a") do |f|
            headers = hash_data[0].keys.join(",")
            values = hash_data.map(&:values).map { |v| v.join(",") }
            f.puts(headers)
            f.puts(values)
        end
        @tableName="on_join_db.csv"
        self
    end

    def order(order, column_name)
        @order        = order
        @order_column = column_name
        self
    end

    def insert(table_name)
        @tableName = table_name
        self.request_type(:insert)
        self
    end

    def values(data)
        if @requestType == :insert
            @insert_attri = data
        else
            abort("Something went wrong during request")
        end
        self
    end



    def update(table_name)
        @tableName = table_name
        self.request_type(:update)
        self
    end

    def set (data)
        @update_values = data
        self
    end

    def delete
        self.request_type(:delete)
    end

    def get_data (filname)
        csv_data = CSV.read(filename, headers: true)
        return hash_data = csv_data.map(&:to_h)
    end

    def request_type (type)
        @requestType = type
    end

    def select_exec
        @select_result = []
        CSV.parse(File.read(@tableName), headers: true).each do |elem|
            if @where_attri.empty?
                if @select_attri == ['*'] || @select_attri == ["all"]
                    @select_result << elem.to_hash
                else
                    @select_result << elem.to_hash.slice(*@select_attri)
                end
            else
                @where_attri.each do |attri|
                    if elem[attri[0]] == attri[1]
                       if @select_attri == ['*'] || @select_attri == ["all"]
                            @select_result << elem.to_hash
                       else
                            @select_result << elem.to_hash.slice(*@select_attri)
                       end
                    end
                end
            end
        end
        @select_result
    end

    def insert_exec
        File.open(@tableName, "a") {
            |f| f.puts @insert_attri.values.join(',')
        }

    end


    def run
        if @requestType == :select
            select_exec
        elsif @requestType == :insert
            insert_exec
        end
    end

end


def main ()
  request = MySqliteRequest.new
  request = request.insert('nba_player_data.csv')
  request = request.values({"name" => "Lebron"})
  #request = request.where('name', 'Matt Zunic')
  p request.run
  #p test = test.from('nba_player_data.csv').select('name').where('birth_state', 'Indiana').run
  #request.run
end

main()
