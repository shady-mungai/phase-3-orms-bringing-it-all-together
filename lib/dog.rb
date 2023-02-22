class Dog
    attr_accessor :id,:name,:breed

    # def initialize(attributes)
    #     attributes.each do |key, value|
    #         self.send("#{key}=", value)
    #     end
    # end

    def initialize(name:,breed:,id: nil)
        @id = id
        @name = name
        @breed = breed
    end

    def self.create_table
        drop = <<-SQL
        DROP TABLE IF EXISTS dogs;
        SQL
        DB[:conn].execute(drop)
        

        create = <<-SQL
        CREATE TABLE dogs(
            id INTEGER PRIMARY KEY,
            name TEXT,
            breed TEXT
        )
        SQL
        DB[:conn].execute(create)
    end

    def self.drop_table
        drop = <<-SQL
        DROP TABLE IF EXISTS dogs;
        SQL
        DB[:conn].execute(drop)
    end  
    
    def save
        insert = <<-SQL
        INSERT INTO dogs(name,breed)
        VALUES(?,?)
        SQL

        DB[:conn].execute(insert,self.name, self.breed)

        # self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
        self.id = DB[:conn].last_insert_row_id()

        self
    end

    def self.create(name:,breed:)
        dog = Dog.new(name: name,breed: breed)
        dog.save
        dog
    end

    def self.new_from_db(row)

        Dog.new(id: row[0],name: row[1], breed: row[2])
    end

    def self.all
        sql = <<-SQL
        SELECT * FROM dogs
        SQL

        DB[:conn].execute(sql).map do |row|
            self.new_from_db(row)
        end
        #DB[:conn].execute(sql)
    end

    def self.find_by_name(name)
        find = <<-SQL
        SELECT * FROM dogs
        WHERE name = ?
        LIMIT 1   
        SQL

        DB[:conn].execute(find,name).map do |row|
            self.new_from_db(row)
        end.first
    end

    def self.find(id)
        find = <<-SQL
        SELECT * FROM dogs
        WHERE id = ?
       
        SQL

        DB[:conn].execute(find,id).map do |row|
             self.new_from_db(row)
        end.first
        #DB[:conn].execute(find,id)
            
    end

    




end
