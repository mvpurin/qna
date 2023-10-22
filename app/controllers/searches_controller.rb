class SearchesController < ApplicationController
  skip_authorization_check only: %i[search]

  def search
    @results = object.search(params['query'])
    sort_results
  end

  private

  def sort_results
    @questions = []; @answers = []; @comments = []

    @results.each do |result|
      if result.class == Question
        @questions << result
      elsif result.class == Answer
        @answers << result
      else
        @comments << result
      end
    end
  end

  def object
    params["object_field"].empty? ? @object = "ThinkingSphinx" : @object = params["object_field"]
    @object.constantize
  end
end
