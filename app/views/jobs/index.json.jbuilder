json.array!(@jobs) do |job|
  json.extract! job, :id, :date, :title, :employer, :location
  json.url job_url(job, format: :json)
end
