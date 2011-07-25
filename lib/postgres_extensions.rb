module ActiveRecord
  module ConnectionAdapters
    module Quoting
      # Convert dates and times to UTC so that the following two will be equivalent:
      # Event.all(:conditions => ["start_time > ?", Time.zone.now])
      # Event.all(:conditions => ["start_time > ?", Time.now])
      def quoted_date(value)
        value.respond_to?(:utc) ? value.utc.to_s(:db) : value.to_s(:db)
      end
    end


    module SchemaStatements

      # Adds timestamps (created_at and updated_at) WITH TIME ZONE columns to the named table.
      # ===== Examples
      #  add_timestampstz(:suppliers)
      def add_timestampstz(table_name)
        add_column table_name, :created_at, :timestamptz
        add_column table_name, :updated_at, :timestamptz
      end

    end

    class Table
      def timestampstz
        @base.add_timestampstz(@table_name)
      end
    end

  end
end

class ActiveRecord::ConnectionAdapters::PostgreSQLAdapter < ActiveRecord::ConnectionAdapters::AbstractAdapter
  def native_database_types
    {
      :primary_key => "serial primary key".freeze,
      :string      => { :name => "character varying", :limit => 255 },
      :text        => { :name => "text" },
      :integer     => { :name => "integer" },
      :float       => { :name => "float" },
      :decimal     => { :name => "decimal" },
      :datetime    => { :name => "timestamp with time zone" },
      :timestamp   => { :name => "timestamp with time zone" },
      :timestamptz   => { :name => "timestamp with time zone" },
      :time        => { :name => "time" },
      :date        => { :name => "date" },
      :binary      => { :name => "bytea" },
      :boolean     => { :name => "boolean" }
    }
  end

  def quoted_date(value) #:nodoc:
    if value.acts_like?(:time)
      usec = sprintf(".%06d", value.usec) if value.respond_to?(:usec)
      zone = " #{value.zone}" if value.respond_to?(:zone)
      "#{super}#{usec}#{zone}"
    else
      super
    end
  end
  
end
