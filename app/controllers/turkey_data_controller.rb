class TurkeyDataController < ApplicationController
  FARMS = {"stefanovicova" => 10,
           "borovce" => 8,
           "podhorany" => 6,
           "horne_saliby" => 6,
           "cabaj" => 14,
           "mala_stefanovicova" => 6,
           "test" => 2
  }
  def new
    get_halls_number(request.fullpath)

    render 'new';
  end

  def create
    prev_url = params[:farm]
    get_halls_number(params[:farm])
    turkey_death_data = params[:death]
    turkey_hatch_data = params[:hatch]


    turkey_death_data.each_with_index do |(key, value), index|
      break if index == @halls
      puts(key)
      puts(value)
    end

    turkey_hatch_data.each_with_index do |(key, value), index|
      break if index == @halls
      puts(key)
      puts(value)
    end

    redirect_to(prev_url)
  end

  private

    def chopfirst(text)
      text[1..-1]
    end

    def get_halls_number(raw_string_farm)
      farm = chopfirst(raw_string_farm)
      @halls = FARMS[farm]
    end

end
