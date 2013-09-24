require "sqlite3"

module Linkly
  module Caches
    class Sqlite3
      def initialize
        create_db
      end

      def fetch(url, &blk)
        value = nil
        data = load_from_cache(url)

        if data && data['url'] == url
          value = data['value']
        else
          value = blk.call(url)
          unless value.nil?
            write_to_cache(url, value)
          end
        end

        value
      end

      private
      def create_db
        @db = SQLite3::Database.new(File.join(ENV['HOME'],".linkly","cache.db"))

        @db.execute <<-SQL
          CREATE TABLE IF NOT EXISTS urls (
            url VARCHAR(2048) NOT NULL PRIMARY KEY,
            created_at DATE NOT NULL DEFAULT CURRENT_DATE,
            value text
          );
        SQL

        @db.execute <<-SQL
          CREATE INDEX IF NOT EXISTS idx_urls_created_at ON urls (created_at);
        SQL
      end

      def load_from_cache(url)
        data = nil

        resultset = @db.execute("select value from urls where url=?", [url])
        if row = resultset.first
          data = JSON.parse(row[0])
        end

        if rand(100) < 10
          @db.execute("DELETE FROM urls WHERE created_at < date('now', '-2 days');")
        end

        data
      end

      def write_to_cache(url, value)
        json = JSON.dump({:url => url, :value => value})
        @db.execute "INSERT INTO urls (url, value) values (?, ?)", [url, json]
      end
    end
  end
end