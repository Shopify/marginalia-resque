require 'marginalia'
require 'marginalia/comment'
require 'resque'
require 'json'

require 'marginalia-resque/version'

module Marginalia::Resque
  mattr_accessor :previous_comment

  def self.update_with_job!(job_klass, params)
    if Array === params && params.size == 1 && Hash === params[0]
      params = params[0]
    end
    Marginalia::Resque.previous_comment = Marginalia::Comment.comment
    Marginalia::Comment.comment = "job:#{job_klass.name},params:#{params.to_json}"
  end

  def self.clear_after_job!
    Marginalia::Comment.comment = Marginalia::Resque.previous_comment
    Marginalia::Resque.previous_comment = nil
  end
end

class Resque::Job
  class << self
    def create_with_marginalia(queue, klass, *args)
      if Resque.inline?
        Marginalia::Resque.update_with_job!(klass, args)
        ret = create_without_marginalia(queue, klass, *args)
        Marginalia::Resque.clear_after_job!
        ret
      else
        create_without_marginalia(queue, klass, *args)
      end
    end
    alias_method_chain :create, :marginalia
  end
end

class Resque::Worker
  def perform_with_marginalia(job)
    Marginalia::Resque.update_with_job!(job.payload_class, job.args)
    perform_without_marginalia(job)
    Marginalia::Resque.clear_after_job!
  end
  alias_method_chain :perform, :marginalia
end