module SidekiqFilterJob
  class Service
    class << self
      #
      # 删除job中的任务
      #
      # @param [String] queue_name 队列名称，例如: default
      # @param [Array] job_names 对应的任务名称
      #
      def remove_job(queue_name = 'default', job_names = [])
        queue = ::Sidekiq::Queue.new(queue_name)
        queue.each do |job|
          job_class_name = job.args.first['job_class']
          job.delete if job_names.include?(job_class_name)
        end
      end

      #
      # 黑名单列表
      #
      # @return [Array] 返回需要跳过的 job名称
      #
      def blank_list
        sidekiq_redis.smembers(::SidekiqFilterJob::REDIS_LIST_NAME)
      end

      #
      # 添加黑名单
      #
      # @param [Array] job_names 需要跳过的job名称
      #
      def add_blank_list(job_names = [])
        sidekiq_redis.sadd(::SidekiqFilterJob::REDIS_LIST_NAME, job_names)
      end

      #
      # 移出黑名单
      #
      # @param [Array] job_names 需要跳过的job名称
      #
      def remove_blank_list(job_names = [])
        sidekiq_redis.srem(::SidekiqFilterJob::REDIS_LIST_NAME, job_names)
      end

      private
      def sidekiq_redis
        @__sidekiq_redis ||= ::Sidekiq.redis(&:itself)
      end
    end
  end
end