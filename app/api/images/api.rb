# frozen_string_literal: true

module Images
  class API < Grape::API
    format :json

    namespace :search do
      route_param :term do
        get do
          images = JSON.parse(Redis.current.get(:images) || [].to_json, symbolize_names: true)
          images.select do |image|
            %i[author camera tags].any? { |key| image[key].to_s[/#{params[:term]}/i] }
          end
        end
      end
    end
  end
end
