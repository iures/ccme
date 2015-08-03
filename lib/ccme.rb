require 'ccme/version'
require 'uri'
require 'thor'
require 'rugged'
require 'octokit'
require 'ccme/github'
require 'terminal-notifier'

class CCMe < Thor
  desc "Status", "Look for circle status"
  def status(repo_path = ".")
    @repo_path = repo_path
    unless last_status
      abort!('unknown', 0)
    end

    last_status
  end

  desc "Watch REPO_PATH", "Notify when status change for a specific REPO_PATH"
  def watch(repo_path = ".")
    @repo_path = repo_path
    current_status = github_client.status
    while(current_status == 'pending')
      sleep(CC::API_HITS_EVERY)
      current_status = github_client.status
    end

    TerminalNotifier.notify(current_status, :appIcon => "assets/#{current_status}.png")
    current_status
  end

  desc "Github TOKEN", "Set github TOKEN"
  def github_token(token=nil)
    if token
      Rugged::Config.global['github.token']  = token
    else
      puts github_token
    end
  end

  private
  def last_status
    unless defined?(@last_status)
      @last_status = github_client.status
    end
    @last_status
  end

  def github_client
    @github_client ||= Github.new(hub_token, @repo_path)
  end

  def hub_token
    Rugged::Config.global['github.token'] || abort!(%{Missing GitHub token.
You can create one here: https://github.com/settings/tokens/new
And add it with the following command: $ ccme github-token YOUR_TOKEN})
  end

  def circle_token
    Rugged::Config.global['circleci.token'] || abort!(%{Missing CircleCI token.
You can create one here: https://circleci.com/account/api
And add it with the following command: $ circle token YOUR_TOKEN})
  end

  def abort!(message, code=1)
    STDERR.puts(message)
    exit(code)
  end
end
