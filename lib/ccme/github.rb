class Github
  def initialize(token, repo_path = '.')
    @hub_token = token
    @repo_path = repo_path
  end

  def status
    puts 'fetching status'
    status = github_client.statuses(github_repo, head.oid).first.state
    puts status
    status
  end

  def github_client
    @github_client ||= Octokit::Client.new(access_token: @hub_token)
  end

  def github_repo
    if origin.url =~ %r{https:\/\/github.com\/(\w+\/\w+)\.git}
      $1
    else
      raise "Unsupported repo url format #{origin.url}"
    end
  end

  def origin
    @origin ||= repository.remotes.find { |r| r.name == 'origin' }
  end

  def head
    repository.head.target
  end

  def repository
    @repository ||= Rugged::Repository.new(@repo_path)
  end
end
