# SidekiqFilterJob

这是一个sidekiq的中间件，主要作用是将已经进入待执行队列中的任务，直接根据任务名称进行删除或者直接跳过的操作。适用的场景，线上的队列中由于某些异常的job导致队列阻塞的场景。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sidekiq_filter_job'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sidekiq_filter_job

## Usage
### 1、集成到sidekiq中,在对应的sidekiq.rb配置文件中
```ruby
Sidekiq.configure_server do |config|
  # 添加 Middleware::Sidekiq::FilterJob 中间件
  config.server_middleware do |chain|
    chain.add Middleware::Sidekiq::FilterJob
  end
end
```
### 2、将需要跳过的任务名称放入 redis中, 可以直接在console中执行
```ruby
# 直接调用add_blank_list的类方法
SidekiqFilterJob::Service.add_blank_list(['job_names'])
```

### 3、其它一些方法
```ruby
# 1、删除队列中的任务
# @param [String] queue_name 队列名称，例如: default
# @param [Array] job_names 对应的任务名称 
SidekiqFilterJob::Service.remove_job(queue_name, job_names)

# 2、查询所有需要跳过的任务名称
SidekiqFilterJob::Service.blank_list

# 3、撤销需要跳过的任务
# @param [Array] job_names 需要跳过的job名称
SidekiqFilterJob::Service.remove_blank_list(['job_names'])
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tanxia456/sidekiq_filter_job.
