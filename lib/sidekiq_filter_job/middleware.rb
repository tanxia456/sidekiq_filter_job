module SidekiqFilterJob
  class Middleware

    def call(*args)
      worker, job, queue = args
      job_class_name = get_job_name(job)
      need_jump_job = sidekiq_reids.smembers(::SidekiqFilterJob::REDIS_LIST_NAME)
      return if need_jump_job.include?(job_class_name)

      yield
    end

    private
    def get_job_name(job)
      job_info = (job['args'] || []).first || {}
      job_info['job_class']
    end

    def sidekiq_reids
      @sidekiq_redis ||= ::Sidekiq.redis(&:itself)
    end
  end
end