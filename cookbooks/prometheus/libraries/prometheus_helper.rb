module Gitlab
  module Prometheus
    def self.kingpin_flags_for(node, service)
      config = ""
      node[service]["flags"].each do |flag_key, flag_value|
        if flag_value == true
          config += "--#{flag_key} "
        elsif flag_value == false
          config += "--no-#{flag_key} "
        else
          config += "--#{flag_key}=\"#{flag_value}\" " unless flag_value.empty?
        end
      end
      config
    end

    def self.flags_for(node, service)
      config = ""
      node[service]["flags"].each do |flag_key, flag_value|
        config += "-#{flag_key}=\"#{flag_value}\" " unless flag_value.empty?
      end
      config
    end

    def hash_to_yaml(hash)
      mutable_hash = JSON.parse(hash.dup.to_json)
      mutable_hash.to_yaml
    end

    def parse_jobs(jobs, inventory_dir)
      jobs.sort.map { |name, job|
        scrape_config = {
          "job_name": name,
        }.merge(job.to_hash)

        # Make sure honor_labels is a bool
        scrape_config["honor_labels"] = job["honor_labels"].to_s == "true" if job["honor_labels"]

        # Convert inventory file to file_sd_configs.
        if job["inventory_file_name"] || job["file_inventory"]
          # Default honor_labels to true since some inventory files override `instance`.
          scrape_config["honor_labels"] = true unless job["honor_labels"]

          file_name = (job["inventory_file_name"] || name) + ".yml"
          scrape_config["file_sd_configs"] = [
            { "files" => [File.join(inventory_dir, file_name)] },
          ]
          scrape_config.delete("inventory_file_name")
          scrape_config.delete("file_inventory")
          scrape_config.delete("role_name")
          scrape_config.delete("chef_search")
          scrape_config.delete("public_hosts")
        end

        # Remove other keys.
        scrape_config.delete("exporter_port")

        scrape_config
      }
    end
  end
end

Chef::Recipe.send(:include, Gitlab::Prometheus)
Chef::Resource.send(:include, Gitlab::Prometheus)
Chef::Provider.send(:include, Gitlab::Prometheus)
