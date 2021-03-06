class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: [:show, :edit_profile, :edit_contact, :update, :destroy, :getInstruments, :addInstrument, :removeInstrument]
  layout :resolve_layout
  
  def show
  end
  
  def edit_profile
  end
  
  def edit_contact
  end
  
  def update
    @profile.assign_attributes(profile_params)
    
    if profile_params[:artists_list]
      artists = profile_params[:artists_list].split(",").map do |artist_name|
        artist_name.strip!
        Artist.where(name: artist_name).first_or_create do |artist|
      	 artist_obj = Spotty.search_artist(artist_name)
      	 artist.spotify_id = artist_obj.id
      	 artist.photo_url = artist_obj.images.first['url']
      	 artist.genres = artist_obj.genres.join(",")
        end
      end
      @profile.artists = artists
    end
    
    if @profile.save
      flash[:notice] = "Profile updated"
    end
    redirect_to profile_edit_profile_path(@profile)
=begin
    else
      render 'edit_profile'
    end
=end
  end

  def getInstruments
    render :json => @profile.instrument_profile.all
  end

  def addInstrument
    if params[:instrument] != nil && @profile.id != nil && params[:proficiency] != nil && params[:owned] != nil
      @instrument_profile = InstrumentProfile.find_by(profile_id: @profile.id, instrument_id: params[:instrument])
      if @instrument_profile == nil
        @instrument_profile = InstrumentProfile.create(:instrument_id => params[:instrument],
                                                        :profile_id => @profile.id, 
                                                        :proficiency => params[:proficiency],
                                                        :owned => params[:owned])
      else
        @instrument_profile.proficiency = params[:proficiency]
        @instrument_profile.owned = params[:owned]
        @instrument_profile.save
      end
    end
    respond_to do |format|
      format.json { render :json => @instrument_profile.instrument }
    end
  end

  def removeInstrument
    if params[:instrument] != nil && @profile.id != nil
      @instrument_profile = InstrumentProfile.find_by(profile_id: @profile.id, instrument_id: params[:instrument])
      if @instrument_profile != nil
        @instrument_profile.destroy
      end
    end
    respond_to do |format|
      format.json  { head :no_content }
    end
  end


  private
  
  def set_profile
    if params[:id] !=  nil
      @profile = Profile.find_by user_id: params[:id]
    else
      @profile = Profile.find_by user_id: current_user.id
    end
    @profile.artists_list = @profile.artists.map(&:name).join(", ")
  end

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :age, :bio, :phone, :location, :artists_list, instrument_ids: [])
  end
  
  def resolve_layout
    case action_name
    when "edit_profile"
      "profiles"
    when "edit_contact"
      "profiles"
    else
      "application"
    end
  end
  
end
