class Deployment
  class Output
    include ApiClient
    attr_accessor :guid, :name, :number

    def initialize(name, number, guid)
      @guid   = guid
      @name   = name
      @number = number
    end

    def create
      params = {
        :files       => { 'stdout' => {:content => "Deployment #{number} pending" } },
        :public      => false,
        :description => "Heaven number #{number} for #{name}"
      }
      @gist = api.create_gist(params)
    end

    def update(stdout, stderr)
      params = {
        'stdout' => { :content => stdout },
        'stderr' => { :content => stderr }
      }
      api.edit_gist(@gist.id, :public => false, :files => params)
    rescue Octokit::UnprocessableEntity
      Rails.logger.info "Unable to update #{@gist.id}, shit's fucked up."
    end

    def url
      "https://gist.github.com/#{@gist.id}"
    end
  end
end
