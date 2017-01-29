def db_config orm
  db_config = YAML.load_file(File.join(File.dirname(__FILE__), "../config.yml"))
  db = db_config["database"][ENV['DB']]
  #db["adapter"] = db["adapter"][ENV['ORM']]
  db
end
