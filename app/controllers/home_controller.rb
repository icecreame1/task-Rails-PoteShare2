class HomeController < ApplicationController
  def index
    @suggest_area = {"img_tokyo" => "東京", "img_osaka" => "大阪", "img_kyoto" => "京都", "img_sapporo" => "札幌"}
  end
end
