def fixture file
  File.read(Rails.root.join("fixtures", "static", file))
end

def json_fixture file
  JSON.parse fixture(file)
end

def json_vcr_fixture file
  f = YAML.load_file(Rails.root.join("fixtures", "vcr", file))
  JSON.parse f['http_interactions'][0]['response']['body']['string']
end
