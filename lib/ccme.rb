require "ccme/version"
require "uri"
require "thor"
require 'rugged'
require 'octokit'

class CCMe < Thor
  desc "Status", "Look for circle status"
  def status
    unless last_status
      abort!('unknown', 0)
    end

    puts last_status.state
  end

  desc "Watch", "Notify when status change"
  def watch
    current_status = status
    while(current_status == 'pending')
      current_status = status
      sleep(10.seconds)
    end
    puts current_status
  end

  desc "Github Token", "Set github token"
  def github_token(token=nil)
    if token
      repository.config['github.token'] = token
    else
      puts github_token
    end
  end

  private
  def last_status
    unless defined?(@last_status)
      @last_status = github_client.statuses(github_repo, head.oid).first
    end
    @last_status
  end

  def github_repo
    if origin.url =~ %r{https:\/\/github.com\/(\w+\/\w+)\.git}
      $1
    else
      raise "Unsupported repo url format #{origin.url}" # TODO: support other formats, mainly https
    end
  end

  def origin
    @origin ||= repository.remotes.find { |r| r.name == 'origin' }
  end

  def head
    repository.head.target
  end

  def repository
    @repository ||= Rugged::Repository.new('.') # TODO: allow to be called from a subdirectory
  end

  def github_client
    @github_client ||= Octokit::Client.new(access_token: hub_token)
  end

  def hub_token # TODO: github-token should probably be in a global config
    repository.config['github.token'] || abort!(%{Missing GitHub token.
You can create one here: https://github.com/settings/tokens/new
And add it with the following command: $ ccme github-token YOUR_TOKEN})
  end

  def circle_token
    repository.config['circleci.token'] || abort!(%{Missing CircleCI token.
You can create one here: https://circleci.com/account/api
And add it with the following command: $ circle token YOUR_TOKEN})
  end

  def abort!(message, code=1)
    STDERR.puts(message)
    exit(code)
  end
end
