module Linkly
  module Caches
    class LocalFile
      def initialize
        create_local_file_cache_directory
      end

      def fetch(url, &blk)
        value = nil
        key = hash(url)
        data = load_from_cache(key)

        if data && data['url'] == url
          value = data['value']
        else
          value = blk.call(url)
          unless value.nil?
            write_to_cache(key, url, value)
          end
        end

        value
      end

      private
      def create_local_file_cache_directory
        FileUtils.mkdir_p(local_file_cache_directory_path) unless File.exists?(local_file_cache_directory_path)
      end

      def local_file_cache_directory_path
        File.join(ENV['HOME'],'.linkly','cache')
      end

      def hash(url)
        Digest::MD5.hexdigest(url.to_s)
      end

      def local_file_path(hash_key)
        File.join(local_file_cache_directory_path, current_month, hash_key)
      end

      def load_from_cache(key)
        data = nil

        if File.exists?(local_file_path(key))
          data = IO.read(local_file_path(key))
          data = JSON.parse(data)
        end

        data
      end

      def write_to_cache(key, url, value)
        json = JSON.dump({:url => url, :value => value})
        File.open(local_file_path(key), "a") { |f| f << json }
      end

      def current_month
        t = Time.now.utc
        m = "#{t.year}#{t.month}"

        om = t - (86400 * 30)
        om = "#{om.year}#{om.month}"

        if om != m && (rand(100) < 100)
          FileUtils.rm_rf(File.join(local_file_cache_directory_path, om), secure: true)
        end

        FileUtils.mkdir_p(File.join(local_file_cache_directory_path, m)) unless File.exists?(File.join(local_file_cache_directory_path, m))

        m
      end
    end
  end
end