require 'csv'


class MySqliteRequest
    def initialize
        @table_name     = nil
        @select_attri   = []
        @where_attri    = []
        @order_column   = nil
        @insert_attri   = []
        @update_values  = nil
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
        tableA = get_data(@table)
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
        @table_name="on_join_db.csv"
        self
    end

    def order(order, column_name)
        @order        = order
        @order_column = column_name
        self
    end

    def insert(table_name)
        @table_name = table_name
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

    def set(data)
        @update_values=data
        self
    end

    def update(table_name)
        @table_name = table_name
        self.request_type(:update)
        self
    end

    def set (data)
        @update_values = data
        self
    end

    def delete
        self.request_type(:delete)

    def get_data (filname)
        csv_data = CSV.read(filename, headers: true)
        return hash_data = csv_data.map(&:to_h)
    end

    def request_type (type)
        @requestType = type
    end



end


def main ()
    request = MySqliteRequest.new
    request = request.from('nba_player_data.csv')
    request = request.select('name')
    request = request.print_select()
    #request = request.where('birth_state', 'Indiana')
    request.run
end

main()