require 'rails_helper'

RSpec.describe SearchPage, type: :model do
  let(:html) { File.read(fixture_path.join('featured_jobs.html')) }
  let(:sp) { SearchPage.new(html) }

  describe "initialize" do
    it "with a response" do
      expect(SearchPage.new(html)).to_not be_nil
    end
  end

  describe ".job_start" do
    it "should return the beginning of current range" do
      expect(sp.job_start).to eq(121)
    end
  end

  describe ".job_end" do
    it "should return the end of current range" do
      expect(sp.job_end).to eq(140)
    end
  end

  describe ".total_featured_jobs" do
    it "should return total featured jobs" do
      expect(sp.total_featured_jobs).to eq(12810)
    end
  end

  describe ".total_extended_jobs" do
    it "should return total extended jobs" do
      expect(sp.total_extended_jobs).to eq(70474)
    end
  end

  describe ".parsed_job_count" do
    it "should return an array of matches" do
      expect(sp.send(:parsed_job_count)).to be_an(Array)
    end
  end

  describe ".has_more_featured_jobs?" do
    it "should return true if inside the range" do
      expect(sp.has_more_featured_jobs?).to eq(true)
    end

    it "should return false if outside the range" do
      allow(sp).to receive(:total_featured_jobs).and_return(10)
      expect(sp.has_more_featured_jobs?).to eq(false)
    end
  end

  describe ".has_more_extended_jobs?" do
    it "should return true if inside the range" do
      expect(sp.has_more_extended_jobs?).to eq(true)
    end

    it "should return false if outside the range" do
      allow(sp).to receive(:total_extended_jobs).and_return(10)
      expect(sp.has_more_extended_jobs?).to eq(false)
    end
  end

  describe ".job_rows" do
    it "should return an array of job html elements" do
      expect(sp.send(:job_rows)).to be_an(Array)
    end

    it "should have 20 jobs" do
      expect(sp.send(:job_rows).size).to eq(20)
    end
  end

  describe ".parse_jobs" do
    it "should return an array" do
      expect(sp.send(:parse_jobs)).to be_an(Array)
    end

    it "should include job hashes" do
      expect(sp.send(:parse_jobs).first).to be_a(Hash)

      job = sp.send(:parse_jobs).first
      # expect(job[:date]).to eq("Feb 25")
      expect(job[:title]).to eq("Self Contained 7-12 Special Education")
      expect(job[:employer]).to eq("Augusta School District")
      expect(job[:location]).to eq("Augusta, Arkansas")
      expect(job[:job_id]).to eq(2392854)
    end
  end

  describe ".parse_date" do
    it "returns a date object" do
      expect(sp.send(:parse_date, "Feb 25")).to be_a(Date)
    end

    it "returns the current year if from this year" do
      expect(sp.send(:parse_date, "Feb 25").to_s).to eq("2016-02-25")
    end

    it "returns last year if from last year" do
      expect(sp.send(:parse_date, "Jun 25").to_s).to eq("2015-06-25")
    end
  end
end
