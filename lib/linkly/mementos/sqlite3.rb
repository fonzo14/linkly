require "sqlite3"
require 'lrucache'

module Linkly
  module Mementos
    class Sqlite3
      def initialize
        create_db

        @lrucache = LRUCache.new(:ttl => 3600)
      end

      def memorize(domain, url, attribute, value)
        unless value.nil? || value.to_s.empty?
          unless exists?(url)
            store(domain, attribute, value)
          end

          value = nil if too_many?(domain, attribute, value)
        end

        value
      end

      private
      def create_db
        @db = SQLite3::Database.new(File.join(ENV['HOME'],".linkly","memento.db"))

        @db.execute <<-SQL
          CREATE TABLE IF NOT EXISTS urls (
            url VARCHAR(2048) NOT NULL PRIMARY KEY,
            created_at DATE NOT NULL DEFAULT CURRENT_DATE
          );
        SQL

        @db.execute <<-SQL
          CREATE INDEX IF NOT EXISTS idx_urls_created_at ON urls (created_at);
        SQL

        @db.execute <<-SQL
          CREATE TABLE IF NOT EXISTS attributes (
            domain VARCHAR(255) NOT NULL,
            attribute VARCHAR(255) NOT NULL,
            created_at DATE NOT NULL DEFAULT CURRENT_DATE,
            value text
          );
        SQL

        @db.execute <<-SQL
          CREATE INDEX IF NOT EXISTS idx_attributes_domains_attribute_created_at ON attributes (domain, attribute, created_at);
        SQL
      end

      def store(domain, attribute, value)
        @db.execute "INSERT INTO attributes (domain, attribute, value) values (?, ?, ?)", [domain, attribute, value]
      end

      def too_many?(domain, attribute, current_value)
        too_many =  false
        count = -1

        @db.execute("select domain, attribute, value from attributes where domain=? and attribute=?", [domain, attribute]).each do |row|
          domain, attribute, value = row

          count += 1 if current_value == value

          if count > 4
            too_many = true
          end
        end

        resultset = @db.execute("select created_at from attributes where domain=? and attribute=? order by created_at desc limit 25,1;", [domain, attribute])
        if row = resultset.first
          @db.execute("DELETE FROM attributes WHERE domain = ? AND attribute = ? AND created_at < ?", [domain, attribute, row[0]])
        end

        too_many
      end

      def exists?(url)
        @lrucache.fetch(url) do
          exists = false

          resultset = @db.execute("select url from urls where url=?", [url])
          if resultset.first
            exists = true
          else
            @db.execute "INSERT INTO urls (url) values (?)", [url]
          end

          if rand(100) < 10
            @db.execute("DELETE FROM urls WHERE created_at < date('now', '-7 days');")
          end

          exists
        end
      end
    end
  end
end