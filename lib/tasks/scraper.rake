# curl -X "POST" "https://www.schoolspring.com/search.cfm" \
# 	-H "Content-Type: application/x-www-form-urlencoded" \
# 	--data-urlencode "pageNumber=600" \
# 	--data-urlencode "countrylocation=us"


namespace :scraper do
  desc "Fetch data from SchoolSpring"
  task fetch: :environment do
    puts "Starting scraper"
    fetch_jobs(0)
    puts "Scraper finished."
  end

  desc "Geocode current jobs"
  task geocode: :environment do
    Job.where("latitude IS ? AND longitude IS ?", nil, nil).each do |job|
      geocoded = Geokit::Geocoders::GoogleGeocoder.geocode(job.location)
      next nil unless geocoded.success

      puts "Location found for #{job.location}"
      lat, lon = geocoded.ll.split(',')

      job.latitude = lat
      job.longitude = lon
      job.save
    end
  end
end

def fetch_jobs(page)
  collisions = 0
  puts "Running fetch on page #{page}"
  response = RestClient.post("https://www.schoolspring.com/search.cfm", {pageNumber: page, countrylocation: 'us', state: 6})
  p = SearchPage.new response

  puts "Response received #{p.total_extended_jobs} found (#{p.job_start - p.job_end})"
  p.jobs.each do |job|
    begin
      puts Job.create(job)
    rescue ActiveRecord::RecordNotUnique
      collisions += 1
      puts "Found a duplicate #{job[:job_id]}. #{collisions} collisions."
    end
  end

  fetch_jobs(page + 1) if p.has_more_featured_jobs? #unless collisions == 20
end
