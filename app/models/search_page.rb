class SearchPage

  def initialize(res)
    @response = res
    @html = Nokogiri::HTML(res)
  end

  def jobs
    @jobs ||= parse_jobs
  end

  def has_more_featured_jobs?
    job_end <= total_featured_jobs
  end

  def has_more_extended_jobs?
    job_end <= total_extended_jobs
  end

  def job_start
    @job_start ||= parsed_job_count[0].to_i
  end

  def job_end
    @job_end ||= parsed_job_count[1].to_i
  end

  def total_featured_jobs
    @total_featured_jobs ||= parsed_job_count[2].to_i
  end

  def total_extended_jobs
    @total_extended_jobs ||= parsed_job_count[3].to_i
  end

  private

  def job_count_string
    @html.css('.job-count').text
  end

  def job_rows
    @html.css('.job-count + table tr').select do |j|
      j.at_css('.cellData') != nil
    end
  end

  def parsed_job_count
    job_count_string.scan(/\d+/)
  end

  def parse_jobs
    job_rows.map do |row|
      parse_job(row)
    end
  end

  def parse_job(row)
    cols = row.css('td')
    job = {
      date: parse_date(cols[0].text),
      title: cols[1].text.strip,
      employer: cols[2].text.strip,
      location: cols[3].text.strip,
      job_id: cols[1].css('a').first['href'].match(/\d+/)[0].to_i
    }
    # job[:latitude], job[:longitude] = parse_location(job[:location])

    return job
  end

  def parse_date(date)
    parsed_date = Date.parse(date)
    if parsed_date.future?
      return parsed_date.prev_year
    end

    parsed_date
  rescue
    return nil
  end
end
