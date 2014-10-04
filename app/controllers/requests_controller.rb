class RequestsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /requests
  # GET /requests.json
  def index
    @requests = Request.all

    render json: @requests
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
    @request = Request.find(params[:id])

    render json: @request
  end

  # POST /requests
  # POST /requests.json
  def create
    groups = [];
    keywords = [];

    params[:groups].each do |group|
      g = Group.find_by_facebook_id(group[:id]) || Group.create({
        facebook_id: group[:id],
        name: group[:name]
      })
      groups << g
    end

    if params[:keywords]
      params[:keywords].each do |keyword|
        k = Keyword.find_by_name(keyword) || Keyword.create(name: keyword)
        keywords << k
      end
    end

    oauth = Koala::Facebook::OAuth.new(ENV["FACEBOOK_APP_ID"], ENV["FACEBOOK_APP_SECRET"])
    long_token = oauth.exchange_access_token_info(params[:user][:authToken])["access_token"]
    user = User.find_by_email(params[:user][:email]) || User.create(email: params[:user][:email])
    user.update_attributes(auth_token: long_token)
    
    r = user.requests.create
    r.groups << groups
    r.keywords << keywords
    r.save

    # FacebookApi.new(r)
    render nothing: true
  end

  # PATCH/PUT /requests/1
  # PATCH/PUT /requests/1.json
  def update
    @request = Request.find(params[:id])

    if @request.update(params[:request])
      head :no_content
    else
      render json: @request.errors, status: :unprocessable_entity
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @request = Request.find(params[:id])
    @request.destroy

    head :no_content
  end
end
