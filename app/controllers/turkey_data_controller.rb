class TurkeyDataController < ApplicationController
  FARMS = {"stefanovicova" => 10,
           "borovce" => 8,
           "podhorany" => 6,
           "horne_saliby" => 6,
           "cabaj" => 14,
           "mala_stefanovicova" => 6
  }
  def new
    farm = chopfirst(request.fullpath.)
    @halls = FARMS[farm];
    render 'new';
  end

  def create
  end

  private

    def chopfirst(text)
      text[1..-1]
    end

end
