class Job < ActiveRecord::Base

  def job_url
    "https://www.schoolspring.com/job.cfm?jid=#{self.job_id}" 
  end
end
